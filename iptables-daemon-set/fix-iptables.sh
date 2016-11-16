#!/bin/sh

# Can be overridden via env vars.
DEST_SUBNET=${DEST_SUBNET:-10.123.0.0/16}
IPTABLES=${IPTABLES:-/sbin/iptables}
SLEEP_INTERVAL=${SLEEP_INTERVAL:-1}

COMMENT="fix-iptables: MASQ for VPN"

echo `date` "Starting fix-iptables"

while true; do
  if iptables -L -t nat | grep -q "${COMMENT}"; then
    echo `date` "iptables ok"
  else
    ${IPTABLES} \
      -t nat \
      -A POSTROUTING \
      -d "${DEST_SUBNET}" \
      -m comment --comment "${COMMENT}" \
      -m addrtype ! --dst-type LOCAL \
      -j MASQUERADE
    if [ "$?" -eq 0 ]; then
      echo `date` "added masq to ${DEST_SUBNET}"
    else
      echo `date` "error adding iptables rule"
    fi
  fi

  sleep "${SLEEP_INTERVAL}"
done
