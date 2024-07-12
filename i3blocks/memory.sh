#!/bin/sh

CONTENT=$(free -h --si | grep --color=never "Mem" | awk 'OFS="/" {print $3,$2}')

echo "Memory: $CONTENT"
