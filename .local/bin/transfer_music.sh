#!/usr/bin/env bash
set -euo pipefail

# Source the common transfer library
source "$(dirname "$0")/transfer_lib.sh"

# Check for single instance and create PID file
check_single_instance

# Books-specific configuration
REMOTE=legomaniac77@seedhost
REMOTE_HOME=/home3/legomaniac77/downloads
DEST=/home/hamacher/Music/Import
CERT=/home/hamacher/.ssh/seedbox
LOG_FILE=/home/hamacher/tmp/transfer_music.log

# Initialize transfer with default bandwidth limit (2048 KB/s)
init_transfer

#############
# Qbittorrent
#############
transfer_items "qbittorrent" "$REMOTE_HOME/ready_for_transfer/lidarr" "$DEST/qbittorrent" "false" "l" "txt"

########
# Nzbget
########
transfer_items "nzbget" "$REMOTE_HOME/completed/Music" "$DEST/nzbget" "true" "d" "txt"

# Clean up and finalize
cleanup_transfer
