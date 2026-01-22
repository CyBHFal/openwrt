#!/bin/sh

CONF=/etc/ucarp.conf
UCARP_HOOKS_DIR="/etc/ucarp.d"

# Load configuration
. "$CONF"

# Export variables for scripts
export UCARP_IF=$IF
export UCARP_VMASK=$VMASK

# Call down hooks before vip is removed
for script in "$UCARP_HOOKS_DIR"/*; do
    if [ -x "$script" ]; then
        logger -t "ucarp" "vip-down: $script down $*"
        "$script" down "$@"
    fi
done

/sbin/ip addr del $2/$VMASK dev $1

exit 0
