#!/usr/bin/env bash

# Transfer Library - Common functions for media transfer scripts
# This library provides reusable functions for transferring media from remote seedboxes

# Default configuration - can be overridden by calling scripts
REMOTE="${REMOTE:-}"
REMOTE_HOME="${REMOTE_HOME:-}"
CERT="${CERT:-}"
LOG_FILE="${LOG_FILE:-/tmp/transfer.log}"
#SSH="${SSH:-ssh -T -n}"
SSH="${SSH:-ssh -T}"

# Bandwidth limiting setup
setup_bandwidth_limit() {
    local bwlimit="${1:-2048}"  # Default 2048 KB/s

    HOUR=$((10#$(date +%H)))
    DOW=$(date +%u)   # 1=Mon .. 7=Sun
    BWLIMIT=()        # empty by default

    # Weekdays 08:00–18:00 local time -> throttle to specified KB/s
    if [[ $DOW -le 5 && $HOUR -ge 8 && $HOUR -lt 18 ]]; then
        BWLIMIT=(--bwlimit="$bwlimit")
    fi
}

# Logging function for consistency
log() {
    echo "$*" >> "$LOG_FILE"
}

# Initialize transfer session
init_transfer() {
    local bwlimit="${1:-2048}"

    # Set up SSH with cert if provided
    if [[ -n "$CERT" ]]; then
        #SSH="ssh -T -n -i $CERT"
        SSH="ssh -T -i $CERT"
    fi

    # Remember the desired daytime throttle (KB/s) for dynamic recalculation
    DEFAULT_BWLIMIT_KBPS="$bwlimit"

    setup_bandwidth_limit "$bwlimit"
    log "---------- $(date)"
}

# Function to transfer items from a source
transfer_items() {
    local source_type="$1"
    local remote_path="$2"
    local local_dest="$3"
    local use_remove_source="$4"
    local find_type="${5:-f}"  # Default to files, can be 'l' for symlinks or 'd' for directories
    local exclude_extensions="$6"  # Optional: space-separated list of extensions to exclude (e.g., "lnk arj zipx")

    log "Transferring $source_type"

    # Create destination directory if it doesn't exist
    mkdir -p "$local_dest"

    # Build exclude options from the extension list
    local exclude_opts=()
    if [[ -n "$exclude_extensions" ]]; then
        IFS=' ' read -ra ext_array <<< "$exclude_extensions"
        for ext in "${ext_array[@]}"; do
            exclude_opts+=(--exclude="*.$ext")
        done
    fi

    # Use a temporary file to avoid multiple SSH connections
    local temp_file
    temp_file=$(mktemp)

    # Get the list of items to transfer
    $SSH "$REMOTE" "find \"$remote_path\" -mindepth 1 -maxdepth 1 -type $find_type -print0" > "$temp_file"

    # Track last applied bwlimit string so we only log when it changes
    local __prev_bw_str=""

    while IFS= read -r -d '' ITEM<&3; do
        log "> Transferring |$ITEM|"

        # Recompute bandwidth limit dynamically each item in case we crossed time windows
        # Uses DEFAULT_BWLIMIT_KBPS from init_transfer as the throttle value during work hours
        setup_bandwidth_limit "${DEFAULT_BWLIMIT_KBPS:-2048}"
        local __bw_str
        __bw_str="${BWLIMIT[*]}"
        if [[ "$__bw_str" != "$__prev_bw_str" ]]; then
            if [[ -n "$__bw_str" ]]; then
                log "Bandwidth limit active: $__bw_str"
            else
                log "Bandwidth limit disabled"
            fi
            __prev_bw_str="$__bw_str"
        fi

        if [[ "$use_remove_source" == "true" ]]; then
            rsync "${BWLIMIT[@]}" "${exclude_opts[@]}" -a --partial --remove-source-files -e "$SSH" $REMOTE:"$ITEM" "$local_dest/" #</dev/null
            # Clean up empty directories if needed.  Doing 'rm -rf' is a bit dangerous,
            # but we can't simply use 'rmdir' because of the exclusions above - we often
            # end up leaving files behind after transferring the video (eg).
            #$SSH "$REMOTE" "rm -rf \"$ITEM\" 2>/dev/null || true" #< /dev/null
            $SSH "$REMOTE" "rm -rf \"$ITEM\" || true"
        else
            rsync "${BWLIMIT[@]}" "${exclude_opts[@]}" -a --partial -L -e "$SSH" $REMOTE:"$ITEM" "$local_dest/" #</dev/null
            #$SSH "$REMOTE" "rm \"$ITEM\" 2>/dev/null || true" #< /dev/null
            $SSH "$REMOTE" "rm \"$ITEM\" || true"
        fi
    done 3< "$temp_file"

    rm "$temp_file"
}

# Clean up function
cleanup_transfer() {
    log "Done at $(date)"
}

# Alternative flock-based approach (uncomment to use instead of PID file)
check_single_instance() {
    local lock_file="/tmp/$(basename "$0" .sh).lock"
    exec 200>"$lock_file"
    if ! flock -n 200; then
        log "Another instance is already running. Exiting."
        exit 1
    fi
}
