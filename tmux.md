## TMUX

| action                               | tmux (preceed all hotkeys with `CTRL-b`) | screen (`CTRL-a`)   |
|--------------------------------------|------------------------------------------|---------------------|
| help                                 | `?`                                      | `?`                 |
| create new session                   | `tmux`<br>`tmux new`                     | `screen`            |
| list sessions                        | `s`<br>`tmux ls`<br>`tmux list-sessions` | `screen -ls`        |
| re-attach to session                 | `tmux attach`                            | `screen -r`         |
| re-attach to session x               | `tmux attach -t [x]`<br>`tmux a -t [x]`  |`screen -r [x]`      |
| detach from session                  | `d` or `:detach`                         | `d`                 |
|--------------------------------------|------------------------------------------|---------------------|
| create new window                    | `c`                                      | `c`                 |
| list windows                         | `w`                                      | `w`                 |
| rename window                        | `:rename-window [new-name]`              | `A` `[new-name]`    |
| go to window #                       | `#`                                      | `#`                 |
| go to last active window             | `l`                                      | `l`                 |
| go to next window                    | `n`                                      | `n`                 |
| go to previous window                | `p`                                      | `p`                 |
|                                      |                                          |                     |
| kill current pane                    | `x`                                      | `k`                 |
| kill current window                  | `&`                                      | `k`<br>`^a` `^k`    |
| kill all other panes but current one | `!`                                      |                     |
| split window horizontally            | `"`                                      | `S`-`Tab`-`c`       |
| split window vertically              | `%`                                      | `\|`-`Tab`-`c`      |
| switch panes                         | `o`                                      | `Tab`               |
| swap location of panes               | `^o`                                     |                     |
| cycle through pane layouts   	       |`space`                                   |                     |
| resize pane downwards by 15 units    | `:resize -D 15`                          |                     |
| move pane to another window          | `:break-pane`                            | `X`                 |
| join pane to another window          | `:join-pane -t [window-number]`          |                     |
| show numeric values of panes         | `q`                                      |                     |
| enable scroll / view scrollback      | `PAGEUP`<br>(`q` to exit)                | `[`<br>(`q` to exit)|

### screen

> note: precede all screen keybindings with `CTRL-A`

`c` create new window and switch to it

`SPACE` or `n` switch to next window  
`BACKSPACE` or `p` switch to previous window  
`ESC` enter 'scrollback' mode (use up/down arrow keys)
(within scrollback mode) `SPACE` begin/end copy selection

`]` paste selection

`|` split window vertically (pipe)  
`S` split window horizontally (capital S)

`k` kill current window  
`\` kill all windows  
`X` collapse split window (capital X)  
`d` detach from session

`r` toggle line-wrap  
`A` name current window (capital A)

(at bash prompt) `screen -ls` = list open screen sessions  
(at bash prompt) `screen -r [id#]` = reconnect to screen session with same pid number
