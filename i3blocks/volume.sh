#!/bin/sh
echo "Volume: $(pactl list sinks | grep --color=never "Volume: f" | awk '{print $5}')"
