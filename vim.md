
## VIM

**See also:**
  - [Learn vimscript the hard way](https://learnvimscriptthehardway.stevelosh.com/)
  - [Daniel Messler on vim](https://danielmiessler.com/study/vim/)

[Insert comments in bulk](https://stackoverflow.com/questions/1676632/whats-a-quick-way-to-comment-uncomment-lines-in-vim/15588798#15588798):
- Method 1
  1. Enter visual block mode.
  1. Select range.
  1. `SHIFT-i` to enter insert mode.
  1. Type a comment symbol.
  1. Exit insert mode.
- Method 2
  1. Enter visual block mode.
  1. Select range.
  1. Enter command mode with `:`.
  1. Enter `norm i#` to insert comment symbols.

### Split-window editing

- `:sp` or `:split file`  =  Open another file in a split window.
- `:vsplit file`          =  Vertical split.
<br><br>
- `CTRL-w k`              =  Switch to upper window.
- `CTRL-w j`              =  Switch to lower window.
- `CTRL-w CTRL-w`         =  Switch to another window (cycle).
<br><br>
- `CTFL-w =`              =  Make all windows equal size.
- `10 CTRL-w+`            =  Increase window size by 10 lines.
- `:resize`               =  Make window full size.
<br><br>
- `:hide`                 =  Close current window.
- `:only`                 =  Keep only this window open.

---
### General

- `:help`        = Get help.
- `:help usr_01` = Show user manual.
<br><br>
- `v`       = Enter visual mode.
- `CTRL-v`  = Enter visual block mode.
<br><br>
- `u`       = Undo.
- `CTRL-r`  = Redo.
- `CTRL-n`  = Keyword completion.
<br><br>
- `qx`      = Record macro bound to *x*.
- `q`       = Stop recording macro.
- `100@x`   = Play macro bound to *x* 100 times.
<br><br>
- `u`           = Convert selection to lowercase (visual mode).
- `U` (*upper*) = Convert selection to uppercase (visual mode).
<br><br>
- `.`           = Repeat last action.

---
### Indenting

- `:set shiftwidth=1` = Set indents to 1 space wide.
<br><br>
- Press `v` and highlight lines of text using the standard navigation keys.
- Type `>` or `<` to indent right or left.
<br><br>
- To indent more, type `2>` or `3>`.
- To change your indenting/tabbing to use spaces and not tabs, type `:set et`).
- To set auto-indenting, type `:set ai`).
- To set the tab-size, type `:set ts=2` (or whatever number you want).
- Also, for tabbing-size, set shiftwidth (`>`) by typing `:set sw=2`).

---
### Navigation

- `4k`   = Jump up 4 lines (*k for climb/klimb*).
- `9j`   = Jump down 9 lines (*the letter j points downwards*).
- `100h` = Jump left 100 chars.
- `50l`  = Jump right 50 chars.
<br><br>
- `b` (*back*) = Jump backward 1 word.
- `B`          = Jump backward 1 WORD*.
- `w` (*word*) = Jump forward 1 word.
- `W`          = Jump forward 1 WORD.
- `e` (*end*)  = Jump forward 1 word to end of word.
- `E`          = Jump forward 1 WORD to end of word.
<br><br>
- `$`          = Jump to end of line (*regex for end of string*).
- `0`          = Jump to beginning of line.
- `^`          = Jump to first non-whitespace char of line (*regex for start of string*).
<br><br>
- `CTRL-u`        = Jump up 1/2 page.
- `CTRL-d`        = Jump down 1/2 page.
- `H` (*high*)    = Jump to top of screen.
- `M` (*middle*)  = Jump to middle of screen.
- `L` (*low*)     = Jump to bottom of screen.
<br><br>
- `gg`            = Jump to first line.
- `G` (*Go!*)     = Jump to last line.
- `33G`           = Jump to line 33.
<br><br>
- `fx` (*find*)   = Jump forward to closest *x*.
- `Fx`            = Jump back to closest *x*.
<br><br>
- `)`   = Jump forward 1 sentence.
- `(`   = Jump back 1 sentence.
- `}`   = Jump forward 1 paragraph.
- `{`   = Jump back 1 paragraph.
<br><br>
- \*WORDs use more liberal rules to determine where a words starts and where it ends (ex: "http://www.vimcheatsheet.com"
  is 7 words but 1 WORD)

---
### Cut / Copy / Paste

- To enter visual mode so you can highlight stuff and cut selected text: `v`
- Use navigation keys to highlight and press `d` to cut selection.
<br><br>
- `x`             = Cut character at cursor.
- `X`             = Cut character before cursor.
<br><br>
- `diw` or `daw`  = Cut word at cursor.
- `dis`           = Cut sentence.
<br><br>
- `D`             = Cut to end of line.
- `d^`            = Cut to beginning of line.
- `J` (*join*)    = Remove line breaks.
<br><br>
- `dd`            = Cut line.
- `dis` or `das`  = Cut sentence.
<br><br>
- `y` (*yank*)    = Copy selection.
- `yiw`           = Copy word.
- `yy` or `Y`     = Copy line.
<br><br>
- `"*y`           = Copy into PRIMARY register.
- `"+y`           = Copy into CLIPBOARD register.

> NOTE: The PRIMARY and CLIPBOARD registers are managed by X11 (not Vim), so data copied into these registers can be
> used elsewhere in the X11 session <sup>[1]</sup>

- `“xy`         = Copy selection to register *x*.
- `“xp`         = Paste from register *x*.
<br><br>
- `P` (*paste*) = Paste before cursor.
- `p`           = Paste after cursor.

---
### Inserting text (Actions that switch to insert mode)

- `i` (*insert*) = Insert before cursor.
- `a` (*after*)  = Insert after cursor.
<br><br>
- `I`            = Insert at beginning of line.
- `A`            = Insert at end of line.
<br><br>
- `ciw`          = Cut word and insert.
- `cfx`          = Cut to first instance of *x* on the current line and insert.
<br><br>
- `C` (*change*) = Cut to end of line and insert.
- `cc` or `S`    = Cut entire line and insert.
<br><br>
- `c`            = Cut selection and insert.
<br><br>
- `o` (*open*)   = Add line below and insert.
- `O`            = Add line above and insert.
<br><br>
- `CTRL-c` (*close*) = Exit insert mode.

---
### Misc typed commands

- `:noh`                = Turn off match highlighting (after string search).
- `:sort`               = Sort text.
- `:retab`              = Replace tabs with spaces in file.
<br><br>
- `:%s/xxx/yyy/g`       = Replace *xxx* with *yyy* in entire file.
- `:g/^x/d`             = Delete all lines beginning with *x*.
<br><br>
- `:q` (*quit*)         = Exit file.
- `:q!`                 = Force exit file.
- `:w` (*write*)        = Save file.
- `:wq` or `:x` or `ZZ` = Save and quit.

#### Find and replace

1. Search for word using `/word` in normal mode.
1. Use `ciw` to change first match of `word` and exit insert mode.
1. Use `n` to jump to next match of `word`.
1. Use `.` to repeat last action.
1. Continue to use `n` and `.` to replace matches.

[1]: https://vi.stackexchange.com/questions/84/how-can-i-copy-text-to-the-system-clipboard-from-vim
