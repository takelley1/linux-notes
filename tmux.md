## [Tmux](https://github.com/tmux/tmux/wiki)

| Action                           | Default binding (Preceed with `CTRL-b`)  |
|----------------------------------|------------------------------------------|
| Show current bindings            | `?`                                      |
| Create new session               | `tmux``tmux new`                         |
| List sessions                    | `s` or `tmux ls`                         |
| Re-attach to session             | `tmux attach`                            |
| Re-attach to session x           | `tmux attach -t [x]``tmux a -t [x]`      |
| Detach from session              | `d` or `:detach`                         |
| Fix dotted lines in windows      | `D` (detatch from nested session)        |
|----------------------------------|------------------------------------------|
| Create new window                | `c`                                      |
| List windows                     | `w` (use `j` and `k` to navigate)        |
| Rename window                    | `,`                                      |
| Rename session                   | `$`                                      |
| Go to window #                   | `#`                                      |
| Go to last active window         | `l`                                      |
| Go to next window                | `n`                                      |
| Go to previous window            | `p`                                      |
| Pass COMMAND to nested session   | `CTRL-b,CTRL-b` COMMAND                  |
|----------------------------------|------------------------------------------|
| Kill current pane                | `x`                                      |
| Kill current window              | `&`                                      |
| Kill all other panes             | `!`                                      |
|----------------------------------|------------------------------------------|
| Split window horizontally        | `"`                                      |
| Split window vertically          | `%`                                      |
| Switch pane focus                | `o`                                      |
| Rotate pane locations            | `^o`                                     |
| Cycle through pane layouts       | `space`                                  |
| Resize pane downwards by 5 units | `:resize -D 5``ALT-DownArrow`            |
| Swap windows 3 and 1             | `swap-window -s 3 -t 1`                  |
|----------------------------------|------------------------------------------|
| Move pane to another window      | `:break-pane`                            |
| Join pane to another window      | `:join-pane -t [window-number]`          |
| Show numeric values of panes     | `q` (type pane's number to switch to it) |
| Enter scrollback mode            | `[` or `PAGEUP` (`q` to exit)            |

### Copy and paste

1. `CTRL-b [` = Enter scrollback mode.
2. `SPACE`    = Enter text selection mode.
3. `ENTER`    = Copy selected text to clipboard.
4. `CTRL-b ]` = Paste text from clipboard.

-. `CTRL-b =` = List paste buffers (clipboard history).
