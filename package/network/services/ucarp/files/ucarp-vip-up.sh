#!/bin/sh

CONF=/etc/ucarp.conf
UCARP_HOOKS_DIR="/etc/ucarp.d"

# Load configuration
. "$CONF"

/sbin/ip addr add $2/$VMASK dev $1

# Optional ARP announcements
for ping_ip in $PINGIP; do
    /usr/bin/arping -c 2 -I $1 -s $2 $ping_ip
done

# Export variables for scripts
export UCARP_IF=$IF
export UCARP_VMASK=$VMASK

# Call up hooks after vip is up
for script in "$UCARP_HOOKS_DIR"/*; do
    if [ -x "$script" ]; then
        logger -t "ucarp" "vip-up: $script up $*"
        "$script" up "$@"
    fi
done

exit 0

