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


## GIT
[https://education.github.com/git-cheat-sheet-education.pdf]

#### setup
configuring user information used across all local repositories  
`git config --global user.name “[firstname lastname]”` = set a name that is identifiable for credit when review version history  
`git config --global user.email “[valid-email]”` = set an email address that will be associated with each history marker  
`git config --global color.ui auto` = set automatic command line coloring for git for easy reviewing

---
#### init
configuring user information, initializing and cloning repositories  
`git init` = initialize an existing directory as a git repository  
`git clone [url]` = retrieve an entire repository from a hosted location via url

---
#### stage & snapshot
working with snapshots and the git staging area  
`git status` = show modified files in working directory, staged for your next commit  
`git add [file]` = add a file as it looks now to your next commit (stage)  
`git reset [file]` = unstage a file while retaining the changes in working directory  
`git diff` = diff of what is changed but not staged  
`git diff --staged` = diff of what is staged but not yet commited  
`git commit -m “[descriptive message]”` = commit your staged content as a new commit snapshot

---
#### branch & merge
isolating work in branches, changing context, and integrating changes  
`git branch` = list your branches. a `*` will appear next to the currently active branch  
`git branch [branch-name]` = create a new branch at the current commit  
`git checkout` = switch to another branch and check it out into your working directory  
`git merge [branch]` = merge the specified branch’s history into the current one  
`git log` = show all commits in the current branch’s history

---
#### inspect & compare
examining logs, diffs and object information  
`git log` = show the commit history for the currently active branch  
`git log branchB..branchA` =show the commits on branchA that are not on branchB  
`git log --follow [file]` =show the commits that changed file, even across renames  
`git diff branchB...branchA` =show the diff of what is in branchA that is not in branchB  
`git show [SHA]` = show any object in git in human-readable format

---
#### tracking path changes
versioning file removes and path changes  
`git rm [file]` = delete the file from project and stage the removal for commit  
`git mv [existing-path] [new-path]` = change an existing file path and stage the move  
`git log --stat -M` = show all commit logs with indication of any paths that moved

---
#### ignoring patterns
preventing unintentional staging or commiting of files
```
logs/
*.notes
pattern*/
```
save a file with desired paterns as .gitignore with either direct string matches or wildcard globs  
`git config --global core.excludesfile [file]` = system wide ignore patern for all local repositories

---
#### share & update
retrieving updates from another repository and updating local repos  
`git remote add [alias] [url]` = add a git url as an alias  
`git fetch [alias]` = fetch down all the branches from that git remote  
`git merge [alias]/[branch]` = merge a remote branch into your current branch to bring it up to date  
`git push [alias] [branch]` = transmit local branch commits to the remote repository branch  
`git pull` = fetch and merge any commits from the tracking remote branch


#### rewrite history
rewriting branches, updating commits and clearing history  
`git rebase [branch]` = apply any commits of current branch ahead of specified one  
`git reset --hard [commit]` = clear staging area, rewrite working tree from specified commit

---
#### temporary commits
temporarily store modified, tracked files in order to change branches  
`git stash` = save modified and staged changes  
`git stash list` = list stack-order of stashed file changes  
`git stash pop` = write working from top of stash stack  
`git stash drop` = discard the changes from top of stash stack

---
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


## TMUX & SCREEN

|  action                                   | tmux                                           | screen                |
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
| rearrange pane layouts   	                | `^b` `space`                                   |                       |
| move split pane to a separate window      | `^b` `:break-pane`                             | `^a` `X`              |
| make window a split pane with another window | `^b` `:join-pane -t [window-number]`        |                       |
| show numeric values of panes              | `^b` `q`                                       |                       |
| enable scroll / view scrollback           | `^b` `[`<br>(`q` to exit)                  | `^a` `[`<br>(`q` to exit) |

### screen

> note: precede all screen keybindings with CTRL + A and all tmux keybindings with CTRL + B

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


## VIM

#### general

`v` enter visual mode  
`CTRL-v` enter visual block mode

`u` undo  
`CTRL-r` redo

`CTRL-n` keyword completion  
`qx` record macro bound to `x`  
`q` stop recording macro  
`@x` play macro bound to `x`

`u` convert to lowercase (visual mode)  
`U` (*upper*) convert to uppercase (visual mode)

`.` repeat last action

---  
#### indenting 

press `v` and then arrow keys (or `h`,`j`,`k`,`l`,`w`,`$`) to highlight lines of text  
type `>` or `<` to indent right or left

(to indent more, type `2>` or `3>`)  
(to change your indenting/tabbing to use spaces and not tabs, type `:set et`)  
(to set auto-indenting, type `:set ai`)  
(to set the tab-size, type `:set ts=2` (or whatever number you want)  
(also, for tabbing-size, set shiftwidth (`>`) by typing `:set sw=2`)

---
#### navigation

`#k` go up `#` lines  
`#j` go down `#` lines

`#h` go left `#` chars  
`#l` go right `#` chars

`b` (*back*) go left 1 word  
`w` (*word*) go right 1 word

`$` (*$ is regex for end of string*) jump to end of line  
`0` jump to beginning of line

`)` jump forward 1 sentence  
`(` jump back 1 sentence

`}` jump forward 1 paragraph  
`{` jump back 1 paragraph

`CTRL-u` (*up*) jump up 1 page  
`CTRL-d` (*down*) jump down 1 page

`H` (*high*) jump to top of screen  
`L` (*low*) jump to bottom of screen  
`M` (*middle*) jump to middle of screen

`gg` jump to first line  
`G` (*Go!*) jump to last line

`fx` (*find*) jump forward to closest `x`  
`Fx` jump back to closest `x`

---
#### cut / copy / paste 

to enter visual mode so you can highlight stuff and cut selected text: `v`  
Use `h`,`j`,`k`,`l`,`w`,`b`,`$` keys to highlight and press `d` to cut selection

`x` (*x looks like scissors*) cut character at cursor  
`X` cut character before cursor

`diw` or `daw` cut word at cursor  
`dis` cut sentence

`D` cut to end of line  
`d^` cut to beginning of line (note `^` is regex for matching beginning of string)

`dd` cut line  
`dis` or `das` (*`d`elete `a` `s`entence*) cut sentence

`y` (*yank*) copy selection  
`yiw` copy word  
`yy` or `Y` copy line

`“xy` copy selection to reg `x`  
`“xp` paste from reg `x`

`P` (*paste*) paste before cursor  
`p` paste after cursor

---
#### inserting text (actions that switch to insert mode) 

`i` (*insert*) insert before cursor  
`a` (*after*) insert after cursor

`I` insert at beginning of line  
`A` insert at end of line

`ciw` cut word and insert

`C` (*change*) cut to end of line and insert  
`cc` or `S` cut entire line and insert

`c` cut selection and insert

`o` (*open*) add line below and insert text  
`O` add line above and insert text

`CTRL-c` (*close*) exit insert mode

---
#### typed commands

`:q` (*quit*) exit file  
`:q!` (*quit!*) force exit file

`:w` (*write*) save file
 
`:wq` or `:x` or hotkey `ZZ` save and quit

`:noh` turn off highlighting (after a  string search)

`:%s/xxx/yyy/g` replace `xxx` with `yyy` in entire file

`:g/^x/d` delete all lines beginning with `x`
