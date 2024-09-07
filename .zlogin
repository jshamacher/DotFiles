# Sourced in login shells.
# As a general rule, this should not change the shell environment at all.
# Instead, it should be used to set the terminal type, run external commands
# like fortune, etc.

# I always liked fortune.
if type fortune > /dev/null; then
    fortune
fi
