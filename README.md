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

*... to be continued*
