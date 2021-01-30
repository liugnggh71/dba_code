grep ^alias alias.sh | cut -d= -f1 | cut -d: -f 2 | sed 's/alias/unalias/'
