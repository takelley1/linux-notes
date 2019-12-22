## VIM

#### split-window editing

`:split filename`  =  split window and load another file
`ctrl-w k`         =  move cursor up a window
`ctrl-w j`         =  move cursor down a window
`ctrl-w ctrl-w`    =  move cursor to another window (cycle)
`ctrl-w =`         =  make all equal size
`10 ctrl-w+`       =  increase window size by 10 lines
`:vsplit file`     =  vertical split
`:hide`            =  close current window
`:only`            =  keep only this window open

---
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
#### misc typed commands

`:q` (*quit*) exit file  
`:q!` (*quit!*) force exit file

`:w` (*write*) save file
 
`:wq` or `:x` or hotkey `ZZ` save and quit

`:noh` turn off highlighting (after a  string search)

`:%s/xxx/yyy/g` replace `xxx` with `yyy` in entire file

`:g/^x/d` delete all lines beginning with `x`
