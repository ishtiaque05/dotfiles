# Powerlevel10k overrides
typeset -g POWERLEVEL9K_DIR_SHORTENED_LENGTH=2
typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=0
typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_last
typeset -g POWERLEVEL9K_DIR_BACKGROUND=0

# DIR_BACKGROUND gives the directory segment its own background, so its borders
# with the os-icon and vcs segments become "different background" boundaries.
# The base config leaves LEFT_SEGMENT_SEPARATOR empty, which butts those
# segments (and their icons) right up against each other. Add a single space so
# every left-segment boundary has a gap.
typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=' '
