# Sourced in interactive shells.
# Should contain commands to set up aliases, functions, options, key bindings,
# etc.

#
# Configure basic tools.
#
export EDITOR='vim'
export VISUAL='vim'

# Zsh is sometimes too smart for its own good - child shells will pick up the
# editor setting and "helpfully" switch to vi key bindings.
bindkey -e

export PAGER='less'
export LESS='-F -M -R -X -z-4'

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
function vim_indicator() {
  if [ -n "$VIMRUNTIME" ]; then
    echo "[VIM] "
  fi
}

# <return code indicator> [login@host] (YY-MM-DD HH:MM:SS) [current directory]
# prompt character (# for root, % for lesser beings)
PROMPT="%(?.%F{green}✔.%F{red}%?) %{%F{yellow}%}[%n@%M] (%D %*) $(vim_indicator)[%4c]%{%F{default}%}
%(!.%{%F{red}%}.%{%F{cyan}%})%#%{%F{default}%} "
