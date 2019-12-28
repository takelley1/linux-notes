
## VIM

#### split-window editing

`:sp` or `:split file`  =  open another file in a split window  
`:vsplit file`          =  vertical split

`CTRL-w k`              =  move cursor up a window  
`CTRL-w j`              =  move cursor down a window  
`CTRL-w CTRL-w`         =  move cursor to another window (cycle)

`CTFL-w =`              =  make all equal size  
`10 CTRL-w+`            =  increase window size by 10 lines

`:hide`                 =  close current window  
`:only`                 =  keep only this window open

---
#### general

`v`       = enter visual mode  
`CTRL-v`  = enter visual block mode

`u`       = undo  
`CTRL-r`  = redo

`CTRL-n`  = keyword completion

`qx`      = record macro bound to `x`  
`q`       = stop recording macro  
`100@x`   = play macro bound to `x` 100 times

`u`           = convert to lowercase (visual mode)  
`U` (*upper*) = convert to uppercase (visual mode)

`.`           = repeat last action

---  
#### indenting 

`:set shiftwidth=1` = set indents to 1 space wide

press `v` and highlight lines of text using the standard navigation keys  
type `>` or `<` to indent right or left

(to indent more, type `2>` or `3>`)  
(to change your indenting/tabbing to use spaces and not tabs, type `:set et`)  
(to set auto-indenting, type `:set ai`)  
(to set the tab-size, type `:set ts=2` (or whatever number you want)  
(also, for tabbing-size, set shiftwidth (`>`) by typing `:set sw=2`)

---
#### navigation

`4k`   = go up 4 lines  
`9j`   = go down 9 lines
`100h` = go left 100 chars  
`50l`  = go right 50chars

`b` (*back*) = go left 1 word  
`w` (*word*) = go right 1 word

`$` (*regex for end of string*) = jump to end of line  
`0`                             = jump to beginning of line

`)`   = jump forward 1 sentence  
`(`   = jump back 1 sentence
`}`   = jump forward 1 paragraph  
`{`   = jump back 1 paragraph

`CTRL-u`        = jump up 1 page  
`CTRL-d`        = jump down 1 page

`H` (*high*)    = jump to top of screen  
`L` (*low*)     = jump to bottom of screen  
`M` (*middle*)  = jump to middle of screen

`gg`            = jump to first line  
`G` (*Go!*)     = jump to last line

`fx` (*find*)   = jump forward to closest `x`  
`Fx`            = jump back to closest `x`

---
#### cut / copy / paste 

to enter visual mode so you can highlight stuff and cut selected text: `v`  
Use navigation keys to highlight and press `d` to cut selection

`x`             = cut character at cursor  
`X`             = cut character before cursor

`diw` or `daw`  = cut word at cursor  
`dis`           = cut sentence

`D`             = cut to end of line  
`d^`            = cut to beginning of line

`dd`            = cut line  
`dis` or `das`  = cut sentence

`y` (*yank*)    = copy selection  
`yiw`           = copy word  
`yy` or `Y`     = copy line

`"*y`           = copy into PRIMARY register *mnemonic: Star is Select (for copy-on-select)*  
`"+y`           = copy into CLIPBOARD register *mnemonic: CTRL PLUS C (for the common keybind)*

> note: the PRIMARY and CLIPBOARD registers are managed by X11 (not Vim), so data copied into these
        registers can be used elsewhere in the X11 session [1]

`“xy`         = copy selection to register `x`  
`“xp`         = paste from register `x`

`P` (*paste*) = paste before cursor  
`p`           = paste after cursor

---
#### inserting text (actions that switch to insert mode) 

`i` (*insert*) = insert before cursor  
`a` (*after*)  = insert after cursor

`I`            = insert at beginning of line  
`A`            = insert at end of line

`ciw`          = cut word and insert

`C` (*change*) = cut to end of line and insert  
`cc` or `S`    = cut entire line and insert

`c`            = cut selection and insert

`o` (*open*)   = add line below and insert  
`O`            = add line above and insert

`CTRL-c` (*close*) = exit insert mode

---
#### misc typed commands

`:q` (*quit*)   = exit file  
`:q!` (*quit!*) = force exit file

`:w` (*write*)  = save file
 
`:wq` or `:x` or hotkey `ZZ` = save and quit

`:noh`                       = turn off highlighting (after string search)

`:%s/xxx/yyy/g`              = replace `xxx` with `yyy` in entire file

`:g/^x/d`                    = delete all lines beginning with `x`

[1] https://vi.stackexchange.com/questions/84/how-can-i-copy-text-to-the-system-clipboard-from-vim

