# Sourced on all invocations of the shell unless the -f option is set.
# Should contain commands to set the command search path and other important
# environment variables.
# Should not contain commands that produce output or assume that there is a TTY.

# Ensure path arrays do not contain duplicates.
typeset -gU path

