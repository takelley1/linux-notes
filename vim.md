
## VIM

**See also:**
  - [Learn Vimscript the hard way](https://learnvimscriptthehardway.stevelosh.com/)
  - [Daniel Messler on vim](https://danielmiessler.com/study/vim)
  - [Vimdiff cheat sheet](https://gist.github.com/mattratleph/4026987)

### Tips

- `:%s/xxx/yyy/g`       = [Replace *xxx* with *yyy* in entire file.](https://vim.fandom.com/wiki/Search_and_replace)
- `:'<,'>s/xxx/yyy/g`   = Replace *xxx* with *yyy* within the selection.
- `:g/^x/d`             = [Delete all lines beginning with *x* (remove */d* to show lines it will delete).](https://vim.fandom.com/wiki/Delete_all_lines_containing_a_pattern)
<br><br>
- `:put =execute('highlight')` = Place the output of *highlight* in the current buffer, making searching easier.
- `@@` = Repeat last macro.
- `nvim -S /path/to/session.vim` = Start with session file.
- `gq` = Format selection.
<br><br>
- `m[a-z]` = Create mark bound to letter. Marks allow you to quickly jump to specific lines.
- `'[a-z]` = Jump to bound mark.
<br><br>
- `zC` or `zM` = Close all folds.
- `zA`         = Open all folds.
- `za`         = Toggle current fold.
<br><br>
- `:!sed '/$^/d'` = Delete blank lines from selection.
- [Use `;` to repeat a single-line search made with `f` or `t`.](https://github.com/iggredible/Learn-Vim/blob/master/ch05_moving_in_file.md#current-line-navigation)
- `:tabm 1`  = [Move current tab to position 1.](https://stackoverflow.com/questions/7961581/is-there-a-vim-command-to-relocate-a-tab)
- `g+CTRL-g` = [Show word count of selection.](https://vim.fandom.com/wiki/Word_count)
<br><br>
- [Insert comments in bulk:](https://stackoverflow.com/questions/1676632/whats-a-quick-way-to-comment-uncomment-lines-in-vim/15588798#15588798)
  1. Enter visual block mode.
  2. Select range.
  3. `SHIFT-i` to enter insert mode.
  4. Type a comment symbol.
  5. Exit insert mode.

---
### Typed commands

- `:nohl`               = Turn off match highlighting (after string search).
- `:sort`               = Sort text.
- `:retab`              = Replace tabs with spaces in file.
<br><br>
- `:q` (*quit*)         = Exit file.
- `:q!`                 = Force exit file.
- `:w` (*write*)        = Save file.
- `:wq` or `:x` or `ZZ` = Save and quit.
- `:qa!`                = Close and quit everything.

#### Find and replace

1. Search for word using `/word` in normal mode.
2. Use `ciw` to change first match of `word` and exit insert mode.
3. Use `n` to jump to next match of `word`.
4. Use `.` to repeat last action.
5. Continue to use `n` and `.` to replace matches.

---
### General

- `qx`      = Record macro bound to *x*.
- `q`       = Stop recording macro.
- `100@x`   = Play macro bound to *x* 100 times.
<br><br>
- `u`           = Convert selection to lowercase (visual mode).
- `U` (*upper*) = Convert selection to uppercase (visual mode).
<br><br>
- `.`           = Repeat last action.

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

> The PRIMARY and CLIPBOARD registers are managed by X11 (not vim), so data copied into these registers can be
> [used elsewhere in the X11 session](https://vi.stackexchange.com/questions/84/how-can-i-copy-text-to-the-system-clipboard-from-vim)

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

