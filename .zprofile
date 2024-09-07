# Similar to .zlogin, except sourced before .zshrc.  In general, favor .zlogin
# over this file unless you have a reason not to.

# On OSX, explicitly source .bashrc so that OS X bash is guaranteed to include all definitions
#if [ "Darwin" = "$(uname -s)" ]; then
#  [ -s "$HOME/.bashrc" ] && . "$HOME/.bashrc"
#fi
