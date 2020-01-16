
## TMUX

| action                            | tmux (preceed all hotkeys with `CTRL-b`) | screen (`CTRL-a`) |
|-----------------------------------|------------------------------------------|-------------------|
| help                              | `?`                                      | `?`               |
| create new session                | `tmux`<br>`tmux new`                     | `screen`          |
| list sessions                     | `s` or `tmux ls`                         | `screen -ls`      |
| re-attach to session              | `tmux attach`                            | `screen -r`       |
| re-attach to session x            | `tmux attach -t [x]`<br>`tmux a -t [x]`  |`screen -r [x]`    |
| detach from session               | `d` or `:detach`                         | `d`               |
|-----------------------------------|------------------------------------------|-------------------|
| create new window                 | `c`                                      | `c`               |
| list windows                      | `w`                                      | `w`               |
| rename window                     | `:rename-window [new-name]`              | `A` `[new-name]`  |
| go to window #                    | `#`                                      | `#`               |
| go to last active window          | `l`                                      | `l`               |
| go to next window                 | `n`                                      | `n`               |
| go to previous window             | `p`                                      | `p`               |
| pass COMMAND to nested session    | `CTRL-b`-`CTRL-b` COMMAND                |                   |
|-----------------------------------|------------------------------------------|-------------------|
| kill current pane                 | `x`                                      | `k`               |
| kill current window               | `&`                                      | `k`-`^k`          |
| kill all other panes              | `!`                                      |                   |
|-----------------------------------|------------------------------------------|-------------------|
| split window horizontally         | `"`                                      | `S`-`Tab`-`c`     |
| split window vertically           | `%`                                      | `\|`-`Tab`-`c`    |
| switch panes                      | `o`                                      | `Tab`             |
| swap location of panes            | `^o`                                     |                   |
| cycle through pane layouts        | `space`                                  |                   |
| resize pane downwards by 15 units | `:resize -D 15`                          |                   |
| swap windows 3 and 1              | `swap-window -s 3 -t 1`                  |                   |
|-----------------------------------|------------------------------------------|-------------------|
| move pane to another window       | `:break-pane`                            | `X`               |
| join pane to another window       | `:join-pane -t [window-number]`          |                   |
| show numeric values of panes      | `q`                                      |                   |
| enable scroll / view scrollback   | `PAGEUP` (`q` to exit)                   | `[` (`q` to exit) |

### screen

> note: precede all screen keybindings with `CTRL-A`

`r` = toggle line-wrap  
`A` = name current window (capital A)

(at bash prompt) `screen -ls`      = list open screen sessions  
(at bash prompt) `screen -r [id#]` = reconnect to screen session with same pid number

