
## VIM

**See also:** [daniel messler on vim](https://danielmiessler.com/study/vim/)

### Split-window editing

`:sp` or `:split file`  =  Open another file in a split window.<br>
`:vsplit file`          =  Vertical split.<br>

`CTRL-w k`              =  Switch to upper window.<br>
`CTRL-w j`              =  Switch to lower window.<br>
`CTRL-w CTRL-w`         =  Switch to another window (cycle).<br>

`CTFL-w =`              =  Make all windows equal size.<br>
`10 CTRL-w+`            =  Increase window size by 10 lines.<br>
`:resize`               =  Make window full size.<br>

`:hide`                 =  Close current window.<br>
`:only`                 =  Keep only this window open.<br>

---
### General

`:help`        = Get help.<br>
`:help usr_01` = Show user manual.<br>

`v`       = Enter visual mode.<br>
`CTRL-v`  = Enter visual block mode.<br>

`u`       = Undo.<br>
`CTRL-r`  = Redo.<br>
`CTRL-n`  = Keyword completion.<br>

`qx`      = Record macro bound to `x`.<br>
`q`       = Stop recording macro.<br>
`100@x`   = Play macro bound to `x` 100 times.<br>

`u`           = Convert selection to lowercase (visual mode).<br>
`U` (*upper*) = Convert selection to uppercase (visual mode).<br>

`.`           = Repeat last action.<br>

---  
### Indenting 

`:set shiftwidth=1` = Set indents to 1 space wide.<br>

press `v` and highlight lines of text using the standard navigation keys  
type `>` or `<` to indent right or left  

-to indent more, type `2>` or `3>`  
-to change your indenting/tabbing to use spaces and not tabs, type `:set et`)  
-to set auto-indenting, type `:set ai`)  
-to set the tab-size, type `:set ts=2` (or whatever number you want).<br>
-also, for tabbing-size, set shiftwidth (`>`) by typing `:set sw=2`).<br>

---
### Navigation

`4k`   = Jump up 4 lines.<br>
`9j`   = Jump down 9 lines (*the letter j points downwards*).<br>
`100h` = Jump left 100 chars.<br>
`50l`  = Jump right 50 chars.<br>

`b` (*back*) = Jump backward 1 word.<br>
`B`          = Jump backward 1 WORD*.<br>
`w` (*word*) = Jump forward 1 word.<br>
`W`          = Jump forward 1 WORD.<br>
`e` (*end*)  = Jump forward 1 word to end of word.<br>
`E`          = Jump forward 1 WORD to end of word.<br>

`$`          = Jump to end of line (*regex for end of string*).<br>
`0`          = Jump to beginning of line.<br>
`^`          = Jump to first non-whitespace char of line (*regex for start of string*).<br>

`CTRL-u`        = Jump up 1/2 page.<br>
`CTRL-d`        = Jump down 1/2 page.<br>
`H` (*high*)    = Jump to top of screen.<br>
`M` (*middle*)  = Jump to middle of screen.<br>
`L` (*low*)     = Jump to bottom of screen.<br>

`gg`            = Jump to first line.<br>
`G` (*Go!*)     = Jump to last line.<br>
`33G`           = Jump to line 33.<br>

`fx` (*find*)   = Jump forward to closest `x`.<br>
`Fx`            = Jump back to closest `x`.<br>

`)`   = Jump forward 1 sentence.<br>
`(`   = Jump back 1 sentence.<br>
`}`   = Jump forward 1 paragraph.<br>
`{`   = Jump back 1 paragraph.<br>

\*= WORDs use more liberal rules to determine where a words starts and.<br>
    where it ends (ex: "http://www.vimcheatsheet.com" is 7 words but 1 WORD)

---
### Cut / Copy / Paste 

To enter visual mode so you can highlight stuff and cut selected text: `v`  
Use navigation keys to highlight and press `d` to cut selection.

`x`             = Cut character at cursor.<br>
`X`             = Cut character before cursor.<br>

`diw` or `daw`  = Cut word at cursor.<br>
`dis`           = Cut sentence.<br>

`D`             = Cut to end of line.<br>
`d^`            = Cut to beginning of line.<br>
`J` (*join*)    = Remove line breaks.<br>

`dd`            = Cut line.<br>
`dis` or `das`  = Cut sentence.<br>

`y` (*yank*)    = Copy selection.<br>
`yiw`           = Copy word.<br>
`yy` or `Y`     = Copy line.<br>

`"*y`           = Copy into PRIMARY register.<br>
`"+y`           = Copy into CLIPBOARD register.<br>

> NOTE: The PRIMARY and CLIPBOARD registers are managed by X11 (not Vim), so data copied into these
        registers can be used elsewhere in the X11 session <sup>[1]</sup> 

`“xy`         = Copy selection to register `x`.<br>
`“xp`         = Paste from register `x`.<br>

`P` (*paste*) = Paste before cursor.<br>
`p`           = Paste after cursor.<br>

---
### Inserting text (Actions that switch to insert mode) 

`i` (*insert*) = Insert before cursor.<br>
`a` (*after*)  = Insert after cursor.<br>

`I`            = Insert at beginning of line.<br>
`A`            = Insert at end of line.<br>

`ciw`          = Cut word and insert.<br>
`cf[x]`        = Cut to first instance of [x] on the current line and insert.<br>

`C` (*change*) = Cut to end of line and insert.<br>
`cc` or `S`    = Cut entire line and insert.<br>

`c`            = Cut selection and insert.<br>

`o` (*open*)   = Add line below and insert.<br>
`O`            = Add line above and insert.<br>

`CTRL-c` (*close*) = Exit insert mode.<br>

---
### Misc typed commands

`:noh`                = Turn off match highlighting (after string search).<br>
`:sort`               = Sort text.<br>
`:retab`              = Replace tabs with spaces in file.<br>

`:%s/xxx/yyy/g`       = Replace `xxx` with `yyy` in entire file.<br>
`:g/^x/d`             = Delete all lines beginning with `x`.<br>

`:q` (*quit*)         = Exit file.<br>
`:q!`                 = Force exit file.<br>
`:w` (*write*)        = Save file.<br>
`:wq` or `:x` or `ZZ` = Save and quit.<br>

#### Find and replace

1. Search for word using `/word` in normal mode.<br>
1. Use `ciw` to change first match of `word` and exit insert mode.<br>
1. Use `n` to jump to next match of `word`.<br>
1. Use `.` to repeat last action.<br>
1. Continue to use `n` and `.` to replace matches.<br>

[1]: https://vi.stackexchange.com/questions/84/how-can-i-copy-text-to-the-system-clipboard-from-vim
