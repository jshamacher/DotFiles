# Sourced in interactive shells.
# Should contain commands to set up aliases, functions, options, key bindings,
# etc.

#
# Configure basic tools.
#

# Zsh is sometimes too smart for its own good - child shells will pick up the
# editor setting and "helpfully" switch to vi key bindings.
bindkey -e

export PAGER='less'
export LESS='-F -M -R -X -z-4'

export RIPGREP_CONFIG_PATH=~/.config/ripgreprc

# You'd think 256 colors would "just work" nowadays.
alias tmux='tmux -2'

# Try to protect me from myself.
alias rm='rm -I'

# Not sure why this isn't the default.
# Note that GREP_OPTIONS, which would have applied for all three commands, has been deprecated.
# Presumably because it's too simple and useful for the GNU people.
alias egrep='egrep --color=always'
alias fgrep='fgrep --color=always'
alias grep='grep --color=always'

# This is a cool trick - by default xargs is unaware of aliases, so (eg) doing a find and piping the
# output into 'xargs fgrep' would bypass the color setting above.  But xargs explicitly checks for
# this alias, and if it finds it then it will also honor aliases in commands it runs.
alias xargs='xargs '

alias vi='nvim'

# I don't think I have ever intentionally used flow control.
stty -ixon

#
# History.
# For the most part, this exactly matches the zprezto settings - they got these right.
#
HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"   # The path to the history file.
HISTSIZE=10000                  # The maximum number of events to save in the internal history.
SAVEHIST=10000                  # The maximum number of events to save in the history file.

setopt BANG_HIST                # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY         # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY       # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY            # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST   # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS         # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS     # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS        # Do not display a previously found event.
setopt HIST_IGNORE_SPACE        # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS        # Do not write a duplicate event to the history file.
setopt HIST_VERIFY              # Do not execute immediately upon history expansion.
setopt HIST_BEEP                # Beep when accessing non-existent history.

#
# mise
#
eval "$(/usr/bin/mise activate zsh)"

#
# Tmux.
#
if [ -r "$HOME/.bin/tmuxinator.zsh" ]; then
    source "$HOME/.bin/tmuxinator.zsh"
fi

#
# Completion.
#
setopt AUTO_PARAM_SLASH         # If completed parameter is a directory, add a trailing slash.
autoload -Uz compinit
compinit

#
# General shell options.
#
setopt CSH_NULL_GLOB            # Ignore patterns with no matches, unless all patterns have no
                                # matches.

unsetopt CORRECT_ALL            # Do not try to correct my typos.

WORDCHARS='*?_-.[]~&;!#$%^(){}<>'   # The default includes = and /.  By excluding those, control-w
                                    # works in a more intuitive fashion.

#
# Prompt.
# See http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
#
#TODO: As an alternative, simply display the shell level?
#function vim_indicator() {
#  if [ -n "$VIMRUNTIME" ]; then
#    echo "[VIM] "
#  fi
#}

# <return code indicator> [login@host] (YY-MM-DD HH:MM:SS) [current directory]
# [git branch, with * when the worktree is dirty]
# prompt character (# for root, % for lesser beings)
autoload -Uz add-zsh-hook
setopt PROMPT_SUBST

function _prompt_escape() {
    # A literal percent in a path or branch name must not become a prompt escape.
    REPLY=${1//\%/%%}
}

function _prompt_path() {
    local display prefix='' base='' leaf
    local -a components
    local -i first index count

    if [[ $PWD == $HOME ]]; then
        display='~'
    elif [[ $PWD == $HOME/* ]]; then
        display="~/${PWD#$HOME/}"
    else
        display=$PWD
    fi

    if [[ $display == /* ]]; then
        prefix='/'
        display=${display#/}
    fi

    components=("${(@s:/:)display}")
    count=${#components}

    # Keep the leaf plus at most two parents. Mark omitted parents with an ellipsis.
    first=1
    if (( count > 3 )); then
        first=$((count - 2))
        prefix+='…/'
    fi

    leaf=${components[-1]:-/}
    for (( index = first; index < count; index++ )); do
        base+="${components[index]}/"
    done

    _prompt_escape "$prefix$base"
    base=$REPLY
    _prompt_escape "$leaf"
    leaf=$REPLY
    prompt_path="%F{yellow}${base}%F{cyan}${leaf}%f"
}

function _prompt_git() {
    local git_output header branch dirty=''
    local -a lines

    git_output=$(GIT_OPTIONAL_LOCKS=0 command git status --porcelain=v1 --branch 2>/dev/null) || {
        prompt_git=''
        return
    }

    lines=("${(@f)git_output}")
    header=${lines[1]#\#\# }

    if [[ $header == 'No commits yet on '* ]]; then
        branch=${header#No commits yet on }
    elif [[ $header == 'Initial commit on '* ]]; then
        branch=${header#Initial commit on }
    elif [[ $header == 'HEAD (no branch)'* ]]; then
        branch=$(command git rev-parse --short HEAD 2>/dev/null)
        branch="detached:${branch:-unknown}"
    else
        branch=${header%%...*}
        branch=${branch%% *}
    fi

    (( ${#lines} > 1 )) && dirty='*'
    _prompt_escape "$branch"
    branch=$REPLY
    prompt_git=" %F{green}{${branch}%F{yellow}${dirty}%F{green}}%f"
}

function _prompt_update() {
    local exit_status=$?

    if (( exit_status == 0 )); then
        prompt_result='%F{green}✔%f'
    else
        prompt_result="%F{red}${exit_status}%f"
    fi

    _prompt_path
    _prompt_git
}

add-zsh-hook precmd _prompt_update

PROMPT='${prompt_result} %F{yellow}[%n@%M] (%D %*) [${prompt_path}%F{yellow}]${prompt_git}%f
%(!.%F{red}.%F{cyan})%#%f '
