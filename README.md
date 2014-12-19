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

*... to be continued*
