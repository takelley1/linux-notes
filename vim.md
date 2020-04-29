
## VIM

**see also:** [daniel messler on vim](https://danielmiessler.com/study/vim/)

### split-window editing

`:sp` or `:split file`  =  open another file in a split window.    
`:vsplit file`          =  vertical split.    

`CTRL-w k`              =  switch to upper window.    
`CTRL-w j`              =  switch to lower window.    
`CTRL-w CTRL-w`         =  switch to another window (cycle.  )  

`CTFL-w =`              =  make all windows equal size.    
`10 CTRL-w+`            =  increase window size by 10 lines.    
`:resize`               =  make window full size.    

`:hide`                 =  close current window.    
`:only`                 =  keep only this window open.    

---
### general

`:help`        = get help.    
`:help usr_01` = show user manual.    

`v`       = enter visual mode.    
`CTRL-v`  = enter visual block mode.    

`u`       = undo.    
`CTRL-r`  = redo.     
`CTRL-n`  = keyword completion.    

`qx`      = record macro bound to `x.  `  
`q`       = stop recording macro.    
`100@x`   = play macro bound to `x` 100 times.    

`u`           = convert selection to lowercase (visual mode.  )  
`U` (*upper*) = convert selection to uppercase (visual mode.  )  

`.`           = repeat last action.    

---  
### indenting 

`:set shiftwidth=1` = set indents to 1 space wide.    

press `v` and highlight lines of text using the standard navigation keys  
type `>` or `<` to indent right or left  

-to indent more, type `2>` or `3>`  
-to change your indenting/tabbing to use spaces and not tabs, type `:set et`)  
-to set auto-indenting, type `:set ai`)  
-to set the tab-size, type `:set ts=2` (or whatever number you want.  )  
-also, for tabbing-size, set shiftwidth (`>`) by typing `:set sw=2.  `)  

---
### navigation

`4k`   = jump up 4 lines.    
`9j`   = jump down 9 lines (*the letter j points downwards.  *)  
`100h` = jump left 100 chars.    
`50l`  = jump right 50 chars.    

`b` (*back*) = jump backward 1 word.    
`B`          = jump backward 1.   WORD*  
`w` (*word*) = jump forward 1 word.    
`W`          = jump forward 1.   WORD  
`e` (*end*)  = jump forward 1 word to end of word.    
`E`          = jump forward 1 WORD to end of word.    

`$`          = jump to end of line                       (*regex for end of string.  *)  
`0`          = jump to beginning of line.    
`^`          = jump to first non-whitespace char of line (*regex for start of string.  *)  

`CTRL-u`        = jump up 1/2 page.    
`CTRL-d`        = jump down 1/2 page.    
`H` (*high*)    = jump to top of screen.    
`M` (*middle*)  = jump to middle of screen.    
`L` (*low*)     = jump to bottom of screen.    

`gg`            = jump to first line.    
`G` (*Go!*)     = jump to last line.    
`33G`           = jump to line 33.  

`fx` (*find*)   = jump forward to closest `x.  `  
`Fx`            = jump back to closest `x.  `

`)`   = jump forward 1 sentence.    
`(`   = jump back 1 sentence.    
`}`   = jump forward 1 paragraph.    
`{`   = jump back 1 paragraph.  

\*= WORDs use more liberal rules to determine where a words starts and.    
    where it ends (ex: "http://www.vimcheatsheet.com" is 7 words but 1 WORD)

---
### cut / copy / paste 

to enter visual mode so you can highlight stuff and cut selected text: `v`  
Use navigation keys to highlight and press `d` to cut selection

`x`             = cut character at cursor.    
`X`             = cut character before cursor.  

`diw` or `daw`  = cut word at cursor.    
`dis`           = cut sentence.  

`D`             = cut to end of line.    
`d^`            = cut to beginning of line.    
`J` (*join*)    = remove line breaks.  

`dd`            = cut line.    
`dis` or `das`  = cut sentence.  

`y` (*yank*)    = copy selection.    
`yiw`           = copy word.    
`yy` or `Y`     = copy line.  

`"*y`           = copy into PRIMARY register.    
`"+y`           = copy into CLIPBOARD register.    

> NOTE: the PRIMARY and CLIPBOARD registers are managed by X11 (not Vim), so data copied into these
        registers can be used elsewhere in the X11 session <sup>[1]</sup> 

`“xy`         = copy selection to register `x.  `  
`“xp`         = paste from register `x.  `

`P` (*paste*) = paste before cursor.    
`p`           = paste after cursor.  

---
### inserting text (actions that switch to insert mode) 

`i` (*insert*) = insert before cursor.    
`a` (*after*)  = insert after cursor.  

`I`            = insert at beginning of line.    
`A`            = insert at end of line.  

`ciw`          = cut word and insert.    
`cf[x]`        = cut to first instance of [x] on the current line and insert.    

`C` (*change*) = cut to end of line and insert.    
`cc` or `S`    = cut entire line and insert.  

`c`            = cut selection and insert.  

`o` (*open*)   = add line below and insert.    
`O`            = add line above and insert.  

`CTRL-c` (*close*) = exit insert mode.  

---
### misc typed commands

`:noh`                = turn off match highlighting (after string search.  )
`:sort`               = sort text.  
`:retab`              = replace tabs with spaces in file.  

`:%s/xxx/yyy/g`       = replace `xxx` with `yyy` in entire file.  
`:g/^x/d`             = delete all lines beginning with `x.  `

`:q` (*quit*)         = exit file.    
`:q!`                 = force exit file.    
`:w` (*write*)        = save file.    
`:wq` or `:x` or `ZZ` = save and quit.    

#### find and replace

1. search for word using `/word` in normal mode  
1. use `ciw` to change first match of `word` and exit insert mode  
1. use `n` to jump to next match of `word`  
1. use `.` to repeat last action  
1. continue to use `n` and `.` to replace matches  

[1]: https://vi.stackexchange.com/questions/84/how-can-i-copy-text-to-the-system-clipboard-from-vim
