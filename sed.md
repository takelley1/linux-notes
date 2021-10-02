
## [SED](https://www.gnu.org/software/sed/manual/sed.html)

- **See also**:
  - [Sed introduction](https://www.grymoire.com/Unix/Sed.html)

sed `-<PARAMETER> '<RESTRICTION> <FLAG1>/<PATTERN1>/<PATTERN2>/<FLAG2>' <FILE1> <FILE2>…`

### Examples

Recursive find and replace:
```bash
shopt -s globstar && sed -E -i 's/foo/bar/g' ./**/*.yml

# Use this to test matching.
shopt -s globstar && sed -E -n 's/foo/p' ./**/*.yml
```

Sed example using comments:
```bash
sed \
  --regexp-extended \
  "
  # Remove boilerplate
  s|<p>Necessary cookies.*</p>||g
  s|<p>Any cookies that may.*</p>||g

  # Remove inline links
  s/<(a|span)[^>]*>//g

  # Remove other HTML formatting elements.
  s!<(\/a|\/span|\/b|\/br|\/sup|p|b|br)\s*\/*>!!g

  # Convert HTML escape sequences.
  s|&#821[6|7];|'|g
  s|&#822[0|1];|\"|g
  s|&#8211;| - |g
  s|&#8212;| -- |g
  s|&amp;|\&|g
  s|<sup>|^|g
  s|</p>|\n|g

  # Remove leading spaces.
  s|^\s*||g
  "
```

- `sed -n '!spam!,!eggs!p'` = Print all lines between *spam* and *eggs*, inclusive.
- `sed -En '/([a-z]+) \1/p'` = Print instances of duplicated words.
- `sed '1 s/^/spam/ file.txt` = Insert *spam* at the first line of file.txt.
  - `1` = Restrict operations to the first line of the input.
  - `s` = Substitute mode.
  - `^` = (First string) Replace the start of the first line with the second string.
  - `spam` = (Second string) This string will replace the start of the first line in file.txt.
- `sed 's|spam|eggs|3' file.txt` = Replace the third occurrence of *spam* with *eggs* in file.txt.
<br><br>
- `sed -n 2p`     = Print second line of input.
- `sed 10q`       = Print first ten lines of input, emulates `head`.
- `sed '5,10d'`   = Delete lines 5 through 10.
- `sed 's|.||2g'`  = Remove all periods, skipping the first match on each line.
<br><br>
- `sed '$d'`      = Delete the last line.
- `sed '/^$/d'`   = Delete all blank lines.
- `sed '/./,$!d'` = Delete all leadig blank lines at top of file.

#### Restrictions and Ranges

- `sed '/^#/ s/[0-9]+//'` = Delete the first number on all lines starting with *#*.
  - `'/^#/ `              = Restriction: Operate only on lines matching expression.
- `sed '2,3 s/[0-9]+//'`    = Same thing, but only on lines 2 and 3.
- `sed '2,$ s/[0-9]+//'`    = Same thing, but between lines 2 and the end of the file.
- `sed '/start/,/stop/ s/#.*//'` = Remove comments between the lines *start* and *stop*, inclusive.

### Flags

- Before patterns (`sed '<FLAG>/pattern1/pattern2/'`)
  - `s` (*substitute*)  = Perform a string substitution.
  - `i` (*insert*)      = Insert input above match.
  - `a` (*append*)      = Insert input below match.

- After patterns (`sed '/pattern1/pattern2/<FLAG>'`)
  - `<NUMBER>`          = Only operate on \<NUMBER\>th match.
  - `<NUMBER>g`         = Operate on all matches from the \<NUMBER\>th match onwards (GNU sed only).
  - `g` (*global*)      = Match pattern multiple times on the same line, if possible.
  - `p` (*print*)       = Force-print match to stdout. Usually used with `-n` to only print matching lines.
  - `q` (*quit*)        = Stop processing input.
  - `w` (*write*)       = Write to the provided file.
  - `I` (*insensitive*) = Make regex case-insensitive.

### Parameters

- `-e` (*expression*) = Combine multiple invocations into a single command.
- `-r` (*regex*)      = Use extended regular expressions, allowing the use of characters like `+`.
- `-n` (*nullify*)    = Suppress printing modified input to stdout.
- `-i` (*in-place*)   = Don't print result to stdout, just go ahead and immediately edit file.

### Patterns

- `&` = Current regex match (ex: `echo "123 abc ABC" | sed 's/abc/& def/'` = `123 abc def ABC`).
- `$` = The end of the file.

### Other commands and examples

- `tr ‘a-z’ ‘A-Z’` (*translate*) = Find first parameter (`‘a-z’`) and replace matches with second parameter (`‘A-Z’`).
<br><br>
- `sort -rk 2`                   = Reverse (`r`) sort results by the second column (`k`) of output.
<br><br>
Filter out only the host's primary IPv4 address:
```bash
# Good:
ip -4 -br a | awk '!/127\.0\.0/ {gsub(/\/[0-9]{1,2}/,""); print $3}'
# Bad:
ifconfig ens32 | grep "inet" | grep –v "inet6" | tr –s " " ":" | cut –f 3 –d ":"
```
