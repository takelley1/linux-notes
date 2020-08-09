
## VIM

**See also:** [daniel messler on vim](https://danielmiessler.com/study/vim/)

### Split-window editing

`:sp` or `:split file`  =  Open another file in a split window.
`:vsplit file`          =  Vertical split.

`CTRL-w k`              =  Switch to upper window.
`CTRL-w j`              =  Switch to lower window.
`CTRL-w CTRL-w`         =  Switch to another window (cycle).

`CTFL-w =`              =  Make all windows equal size.
`10 CTRL-w+`            =  Increase window size by 10 lines.
`:resize`               =  Make window full size.

`:hide`                 =  Close current window.
`:only`                 =  Keep only this window open.

---
### General

`:help`        = Get help.
`:help usr_01` = Show user manual.

`v`       = Enter visual mode.
`CTRL-v`  = Enter visual block mode.

`u`       = Undo.
`CTRL-r`  = Redo.
`CTRL-n`  = Keyword completion.

`qx`      = Record macro bound to `x`.
`q`       = Stop recording macro.
`100@x`   = Play macro bound to `x` 100 times.

`u`           = Convert selection to lowercase (visual mode).
`U` (*upper*) = Convert selection to uppercase (visual mode).

`.`           = Repeat last action.

---  
### Indenting 

`:set shiftwidth=1` = Set indents to 1 space wide.

press `v` and highlight lines of text using the standard navigation keys  
type `>` or `<` to indent right or left  

-to indent more, type `2>` or `3>`  
-to change your indenting/tabbing to use spaces and not tabs, type `:set et`)  
-to set auto-indenting, type `:set ai`)  
-to set the tab-size, type `:set ts=2` (or whatever number you want).
-also, for tabbing-size, set shiftwidth (`>`) by typing `:set sw=2`).

---
### Navigation

`4k`   = Jump up 4 lines.
`9j`   = Jump down 9 lines (*the letter j points downwards*).
`100h` = Jump left 100 chars.
`50l`  = Jump right 50 chars.

`b` (*back*) = Jump backward 1 word.
`B`          = Jump backward 1 WORD*.
`w` (*word*) = Jump forward 1 word.
`W`          = Jump forward 1 WORD.
`e` (*end*)  = Jump forward 1 word to end of word.
`E`          = Jump forward 1 WORD to end of word.

`$`          = Jump to end of line (*regex for end of string*).
`0`          = Jump to beginning of line.
`^`          = Jump to first non-whitespace char of line (*regex for start of string*).

`CTRL-u`        = Jump up 1/2 page.
`CTRL-d`        = Jump down 1/2 page.
`H` (*high*)    = Jump to top of screen.
`M` (*middle*)  = Jump to middle of screen.
`L` (*low*)     = Jump to bottom of screen.

`gg`            = Jump to first line.
`G` (*Go!*)     = Jump to last line.
`33G`           = Jump to line 33.

`fx` (*find*)   = Jump forward to closest `x`.
`Fx`            = Jump back to closest `x`.

`)`   = Jump forward 1 sentence.
`(`   = Jump back 1 sentence.
`}`   = Jump forward 1 paragraph.
`{`   = Jump back 1 paragraph.

\*= WORDs use more liberal rules to determine where a words starts and.
    where it ends (ex: "http://www.vimcheatsheet.com" is 7 words but 1 WORD)

---
### Cut / Copy / Paste 

To enter visual mode so you can highlight stuff and cut selected text: `v`  
Use navigation keys to highlight and press `d` to cut selection.

`x`             = Cut character at cursor.
`X`             = Cut character before cursor.

`diw` or `daw`  = Cut word at cursor.
`dis`           = Cut sentence.

`D`             = Cut to end of line.
`d^`            = Cut to beginning of line.
`J` (*join*)    = Remove line breaks.

`dd`            = Cut line.
`dis` or `das`  = Cut sentence.

`y` (*yank*)    = Copy selection.
`yiw`           = Copy word.
`yy` or `Y`     = Copy line.

`"*y`           = Copy into PRIMARY register.
`"+y`           = Copy into CLIPBOARD register.

> NOTE: The PRIMARY and CLIPBOARD registers are managed by X11 (not Vim), so data copied into these
        registers can be used elsewhere in the X11 session <sup>[1]</sup> 

`“xy`         = Copy selection to register `x`.
`“xp`         = Paste from register `x`.

`P` (*paste*) = Paste before cursor.
`p`           = Paste after cursor.

---
### Inserting text (Actions that switch to insert mode) 

`i` (*insert*) = Insert before cursor.
`a` (*after*)  = Insert after cursor.

`I`            = Insert at beginning of line.
`A`            = Insert at end of line.

`ciw`          = Cut word and insert.
`cf[x]`        = Cut to first instance of [x] on the current line and insert.

`C` (*change*) = Cut to end of line and insert.
`cc` or `S`    = Cut entire line and insert.

`c`            = Cut selection and insert.

`o` (*open*)   = Add line below and insert.
`O`            = Add line above and insert.

`CTRL-c` (*close*) = Exit insert mode.

---
### Misc typed commands

`:noh`                = Turn off match highlighting (after string search).
`:sort`               = Sort text.
`:retab`              = Replace tabs with spaces in file.

`:%s/xxx/yyy/g`       = Replace `xxx` with `yyy` in entire file.
`:g/^x/d`             = Delete all lines beginning with `x`.

`:q` (*quit*)         = Exit file.
`:q!`                 = Force exit file.
`:w` (*write*)        = Save file.
`:wq` or `:x` or `ZZ` = Save and quit.

#### Find and replace

1. Search for word using `/word` in normal mode.
1. Use `ciw` to change first match of `word` and exit insert mode.
1. Use `n` to jump to next match of `word`.
1. Use `.` to repeat last action.
1. Continue to use `n` and `.` to replace matches.

[1]: https://vi.stackexchange.com/questions/84/how-can-i-copy-text-to-the-system-clipboard-from-vim
