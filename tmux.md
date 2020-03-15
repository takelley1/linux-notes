
## TMUX

| action                            | hotkey (preceed with `CTRL-b`)           |
|-----------------------------------|------------------------------------------|
| help                              | `?`                                      |
| create new session                | `tmux`<br>`tmux new`                     |
| list sessions                     | `s` or `tmux ls`                         |
| re-attach to session              | `tmux attach`                            |
| re-attach to session x            | `tmux attach -t [x]`<br>`tmux a -t [x]`  |
| detach from session               | `d` or `:detach`                         |
| fix dotted lines in windows       | `D` (detatch from nested session)        |
|-----------------------------------|------------------------------------------|
| create new window                 | `c`                                      |
| list windows                      | `w`                                      |
| rename window                     | `,`                                      |
| rename session                    | `$`                                      |
| go to window #                    | `#`                                      |
| go to last active window          | `l`                                      |
| go to next window                 | `n`                                      |
| go to previous window             | `p`                                      |
| pass COMMAND to nested session    | `CTRL-b`-`CTRL-b` COMMAND                |
|-----------------------------------|------------------------------------------|
| kill current pane                 | `x`                                      |
| kill current window               | `&`                                      |
| kill all other panes              | `!`                                      |
|-----------------------------------|------------------------------------------|
| split window horizontally         | `"`                                      |
| split window vertically           | `%`                                      |
| switch panes                      | `o`                                      |
| swap location of panes            | `^o`                                     |
| cycle through pane layouts        | `space`                                  |
| resize pane downwards by 5 units  | `:resize -D 5`<br>`ALT-DownArrow`        |
| swap windows 3 and 1              | `swap-window -s 3 -t 1`                  |
|-----------------------------------|------------------------------------------|
| move pane to another window       | `:break-pane`                            |
| join pane to another window       | `:join-pane -t [window-number]`          |
| show numeric values of panes      | `q`                                      |
| enable scroll / view scrollback   | `PAGEUP` (`q` to exit)                   |

#### tmux copy and paste

1. `CTRL-b [` = enter scrollback mode  
1. `SPACE`    = enter text selection mode  
1. `ENTER`    = copy selected text to clipboard  
1. `CTRL-b ]` = paste text from clipboard  

