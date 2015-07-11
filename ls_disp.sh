#! /bin/sh

# List available monitors.

allmons=$(xrandr | grep -e "^.* connected" | cut -d " "  --field "1")
for mon in $allmons; do
    echo "$mon"
done

