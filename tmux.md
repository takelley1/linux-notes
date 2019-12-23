## TMUX

| action                                    | tmux (preceed all hotkeys with `CTRL-b`) | screen (`CTRL-a`)   |
|-------------------------------------------|------------------------------------------|---------------------|
| start a new session                       | `tmux`<br>`tmux new`                     | `screen`            | 
| re-attach to detached session             | `tmux attach`                            | `screen -r`         |
| re-attach to detached session x           | `tmux attach -t [x]`<br>`tmux a -t [x]`  |`screen -r [x]`      |
| detach from currently attached session    | `d`<br>`^b` `:detach`                    | `d`                 |
| rename window                             | `:rename-window [new-name]`              | `A` `[new-name]`    |
| list windows                              | `w`                                      | `w`                 |
| go to window #                            | `#`                                      | `#`                 |
| go to last active window                  | `l`                                      | `l`                 |
| go to next window                         | `n`                                      | `n`                 |
| go to previous window                     | `p`                                      | `p`                 |
| see keybindings                           | `?`                                      | `?`                 |
| list sessions                             | `s`<br>`tmux ls`<br>`tmux list-sessions` | `screen -ls`        |
| kill the current pane                     | `x`                                      | `k`                 |
| kill the current window                   | `&`                                      | `k`<br>`^a` `^k`    |
| detatch from terminal                     | `^d`                                     | `^d`                |
| create another window                     | `c`                                      | `c`                 |
| switch to another pane                    | `o`                                      | `Tab`               |
| split pane horizontally                   | `"`                                      | `S`-`Tab`-`c`       |
| split pane vertically                     | `%`                                      | `\|`-`Tab`-`c`      |
| kill all other panes but the current one  | `!`                                      |                     |
| swap location of panes                    | `^o`                                     |                     |
| resize pane downwards by 15 units         | `:resize -D 15`                          |                     |
| rearrange pane layouts   	                |`space`                                   |                     |
| move split pane to a separate window      | `:break-pane`                            | `X`                 |
| make window a split pane with another window | `:join-pane -t [window-number]`       |                     |
| show numeric values of panes              | `q`                                      |                     |
| enable scroll / view scrollback           | `PAGEUP`<br>(`q` to exit)                | `[`<br>(`q` to exit)|

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
