#!/bin/sh

use_color=false
# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs="$(<${COLORS})"
[[ -z ${match_lhs}    ]] \
    && type -P dircolors >/dev/null \
    && match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color} ; then

    PS_RED="\[\033[0;31m\]"
    PS_YELLOW="\[\033[0;33m\]"

    if [[ ${EUID} == 0 ]] ; then
        PS1="${PS_RED}\h${PS_YELLOW} [\A] \W \$\[\033[00m\] "
    else
        PS1="${PS_YELLOW}\u@\h [\A] \w \$\[\033[00m\] "
    fi
else
    if [[ ${EUID} == 0 ]] ; then
        # show root@ when we don't have colors
        PS1='\u@\h [\A] \W \$ '
    else
        PS1='\u@\h [\A] \w \$ '
    fi
fi

unset use_color safe_term match_lhs
