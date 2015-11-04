contrib
=======

Repository hosting inspirationnal wmutils snippets.

### tile.sh
Arrange your windows in a tiled pattern consisting of one master area, and a
stacking area. Uses `$GAP` and `$MASTER` from environment.

    usage: tile.sh

### fullscreen.sh
Set a window in fullscreen mode, removing borders from it and putting it in
front of all other windows. There can only be one window in fullscreen at a
time. Uses `$FSFILE` from environment.

    usage: fullscreen.sh <wid>

### focus.sh
Focus either a specific window, or the next/previous window in the stack. Then
set borders accordingly. Uses `$BW`, `$ACTIVE` and `$INACTIVE` from environment.

    usage: focus.sh <next|prev|wid>

### focus\_watcher.sh
Focus a new window (using focus.sh) upon its creation.

Depends on `wew(1)` (opt repo)  and `focus.sh` (contrib repo)

    usage: focus_watcher.sh

### rainbow.sh
Make the current window border cycle all the rainbow colors. Uses `$FREQ` from
environment.

    usage: rainbow.sh

### closest.sh
Focus the closest window in a specific direction.

    usage: closest.sh <direction>

### switch\_grid.sh
A simpler version of OS X Mission Control feature, or GNOME Shell's Overview
feature.

Depends on `wew(1)` (opt repo)  and `focus.sh` (contrib repo)

    usage: switch_grid.sh

### deletelock.sh
Set a custom xprop variable which can be used to test if a window is able to
be deleted or not when using killw in a custom script with `wew(1)`.

Depends on xorg-xprop

    usage: deletelock.sh <lock|unlock|toggle|status> <wid>

### groups.sh
Adds group-like capabilities, sorta like those you find in CWM and such WMs.

    usage: groups.sh [-hCU] [-c wid] [-s wid group] [-tmMu group]
           -h shows this help
           -c cleans WID from group files (and makes it visible)
           -C runs cleanup routine
           -s sets WID's group
           -t toggle group visibility state
           -m maps (shows) group
           -M maps group and unmaps all other groups
           -u unmaps (hides) group
           -U unmaps all the groups


*... to be continued*
