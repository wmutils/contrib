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

## Multihead support

### current_disp.sh
Gives the current display when given coordinates or a window id.

    usage: current_disp.sh [-c x y] [wid]

### ls_disp.sh
Lists all available displays.

    usage: ls_disp.sh

### geo_disp.sh
Gives the geometry of the given display.

    usage: geo_disp.sh <display>

### fullscreen_disp.sh
Full screens a window. Each display may have one fullscreen window. 

    usage: fullscreen_disp.sh <display> <wid>

*... to be continued*
