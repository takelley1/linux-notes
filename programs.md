## TMUX & SCREEN

| action                                    | tmux                                           | screen                |
|-------------------------------------------|------------------------------------------------|-----------------------|
| start a new session                       | `tmux`<br>`tmux new`                           | `screen`              | 
| re-attach the detached session            | `tmux attach`                                  | `screen -r`           |
| re-attach a specific detached session     | `tmux attach -t [number]`<br>`tmux a -t [number]`|`screen -r [number]` |
| detach from currently attached session    | `^b` `d`<br>`^b` `:detach`                     | `^a` `d`              |
| rename window                             | `^b` `,`<br>`^b` `:rename-window [new-name]`   | `^a` `A` `[new-name]` |
| list windows                              | `^b` `w`                                       | `^a` `w`              |
| go to window #                            | `^b` `#`                                       | `^a` `#`              |
| go to last active window                  | `^b` `l`                                       | `^a` `l`              |
| go to next window                         | `^b` `n`                                       | `^a` `n`              |
| go to previous window                     | `^b` `p`                                       | `^a` `p`              |
| see keybindings                           | `^b` `?`                                       | `^a` `?`              |
| list sessions                             | `^b` `s`<br>`tmux ls`<br>`tmux list-sessions`  | `screen -ls`          |
| kill the current pane                     | `^b` `x`                                       | `^a` `k`              |
| kill the current window                   | `^b` `&`                                       | `^a` `k`<br>`^a` `^k` |
| detatch from terminal                     | `^b` `^d`                                      | `^a` `^d`             |
| create another window                     | `^b` `c`                                       | `^a` `c`              |
| switch to another pane                    | `^b` `o`                                       | `^a` `Tab`            |
| split pane horizontally                   | `^b` `"`                 | `^a` `S`<br>then `^a` `Tab`<br>and `^a` `c` |
| split pane vertically                     | `^b` `%`                 | `^a` `\|`<br>then `^a` `Tab`<br>and `^a` `c`|
| kill all other panes but the current one  | `^b` `!`                                       |                       |
| swap location of panes                    | `^b` `^o`                                      |                       |
| resize pane downwards by 15 units         | `^b` `:resize -D 15`                           |                       |
| rearrange pane layouts   	            | `^b` `space`                                   |                       |
| move split pane to a separate window      | `^b` `:break-pane`                             | `^a` `X`              |
| make window a split pane with another window | `^b` `:join-pane -t [window-number]`        |                       |
| show numeric values of panes              | `^b` `q`                                       |                       |
| enable scroll / view scrollback           | `^b` `[`<br>(`q` to exit)                  | `^a` `[`<br>(`q` to exit) |

### screen

> note: precede all screen keybindings with CTRL + A

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


## ANSIBLE 

- `ansible-playbook /path/to/playbook -kK –f 100` = run playbook

run ad-hoc command as root on target box
- `ansible 192.168.1.1 -a "yum update" -u akelley -k –b –-become-user root –K –-become-method su -f 10`
  - `-a` run ad-hoc command
  - `-u` use this user to access the machine
  - `-k` ask for user's password instead of using ssh key
  - `-b` use become to elevate privileges
  - `--become-user root` become the user root when elevating
  - `-K` ask for escalation password
  - `--become-method su` use su instead of sudo when elevating
  - `-f 100` = run 100 separate worker threads

`ansible-playbook --syntax-check ./playbook.yml` = check syntax  
`ansible-link ./playbook.yml` = check best-practices


## OPENSCAP  

- run scap scan
  ```
  oscap xccdf eval \
  --fetch-remote-resources \
  --profile xccdf_mil.disa.stig_profile_MAC-3_Sensitive \
  --results /scap_nfs/scap_$(hostname)_$(date +%Y-%m-%d_%H:%M).xml \
  --report /scap_nfs/scap_$(hostname)_$(date +%Y-%m-%d_%H:%M).html \
  /shares/U_Red_Hat_Enterprise_Linux_7_V2R2_STIG_SCAP_1-2_Benchmark.xml
  ```
  - `--fetch-remote-resources` = download any new definition updates
  - `--profile` = which profile within the STIG checklist to use
  - `--results` = filepath to place XML results
  - `--report` = filepath to place HTML-formatted results
  - `/shares/U_Red_Hat_Enterprise_Linux_7_V2R2_STIG_SCAP_1-2_Benchmark.xml` = filepath of the STIG checklist file


## LESS 

`SPACE` next page  
`b` previous page  
`>` last line  
`<` first line  
`/` forward search  
`?` backward search  
`n` next search match  
`N` previous search match  
`q` quit
