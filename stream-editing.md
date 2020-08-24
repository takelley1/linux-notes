## AWK

- See also:
  - [AWK one-liners explained](https://catonmat.net/awk-one-liners-explained-part-one)
  - [GAWK manual](https://www.gnu.org/software/gawk/manual/)
  - [AWK cheat sheet](https://catonmat.net/ftp/awk.cheat.sheet.pdf)

### Examples

- `awk '{print $3, $2}'` = Print the 3rd and 2nd fields of input.
- `awk '/foo/ {gsub(/abc/,""); gsub(/[0-9]/,""); print $1}'` = Print 1st field of lines that contain *foo*, remove *abc* and all numbers from output.
- `awk '/[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/' {print $3}` = Print 3rd field of lines that contain IP-address-like strings in input.
<br><br>
- `awk -F':' '/:[1-4][0-9]{3}/ {print $6}' /etc/passwd` = Print the home directories of all interactive users.
- `awk -F':' '! /\/sbin\/nologin/ {print $1}' /etc/passwd` = Print users who don't use */sbin/nologin* as their shell.
<br><br>
- `awk '{if(NR>2) print $0}'` = Print all but the first two lines.

### Regex

- `^` = Match string at start.
- `$` = Match string at end.
- `a|b` = Alternation (`a` OR `b`).
- `*` = Zero or more of previous.
- `+` = One or more of previous.
- `?` = Zero or one of previous.
- `{1,5}` = One to five of previous.
- `{3,}` = At least three of previous.
- `[abc...]` = Anything within [ ]
- `[^abc...]` = Anything NOT within [ ]

| Backslash syntax |                      |
|------|----------------------------------|
| `\s` | Whitespace characters            |
| `\S` | NON whitespace characters        |
| `\w` | letters, digits, underscores     |
| `\W` | NON letters, digits, underscores |
| `\f` | Form-feed                        |
| `\r` | Carriage return                  |
| `\n` | Newline                          |
| `\t` | Tab                              |

| Character classes | *Only valid within brackets e.g [[:xyz:]]* |
|-------------------|-----------------------------------------|
| `[:alnum:]` | Alphanumeric characters                       |
| `[:alpha:]` | Alphabetic characters                         |
| `[:blank:]` | Space or tab characters                       |
| `[:cntrl:]` | Control characters                            |
| `[:digit:]` | Numeric characters                            |
| `[:lower:]` | Lowercase alphabetic characters               |
| `[:print:]` | Printable characters (non-control characters) |
| `[:punct:]` | Punctuation characters (non-letter, digit, control char, or space) |
| `[:space:]` | Space characters (space, tab, formfeed, etc.) |
| `[:upper:]` | Uppercase alphabetic characters               |


---
## SED

`sed -<PARAMETER> '<RESTRICTION> <FLAG1>/<PATTERN1>/<PATTERN2>/<FLAG2>' <FILE1> <FILE2>…`

### Examples

- `sed '1s/^/spam/ file.txt` = Insert "spam" at the first line of file.txt.
  - `1` = Restrict operations to the first line of the input.
  - `s` = Replace mode.
  - `^` = (First string) Replace the start of the first line with the second string.
  - `spam` = (Second string) This string will replace the start of the first line in file.txt.
<br><br>
- `sed 's/spam/eggs/3' file.txt` = Replace the third occurrence of "spam" with "eggs" in file.txt.
<br><br>
- `sed '2,3/^str*ng/d' file.txt` = Delete all strings matching expression.
  - `2,3` = Limit command to the second and third lines of the file.
<br><br>
- `echo "all is fair" | sed 'i\in love and war'` = Returns "all is fair in love and war". Inserts input before match.
- `echo "in love and war" | sed 'a\all is fair'` = Returns "all is fair in love and war". Inserts input after match.
<br><br>
- `sed -n '2p'` = Print second line of input.
<br><br>
- `sed 's/string1/string2/w file.txt'` = Write modified data to file.txt.
<br><br>
- `sed 's/abc/xyz/I'` = Match "abc" or "ABC", replace with "xyz".
- `sed -e 's/a/A' -e 's/b/B'`

### Flags

- `s` (*substitute*)  = Perform a string substitution.
- `i` (*insert*)      = Insert input above match.
- `a` (*after*)       = Insert input after match.
- `g` (*global*)      = Perform operation throughout the entirety of the file.
- `p` (*print*)       = Force-print match to stdout. Usually used with `-n` to only print match.
- `w` (*write*)       = Write to the provided file.
- `I` (*insensitive*) = Make regex case-insensitive.

### Parameters

- `-e` (*expression*) = Combine multiple invocations into a single command.
- `-r` (*regex*)      = Use extended regular expressions, allowing the use of characters like `+`.
- `-n` (*nullify*)    = Suppress printing modified input to stdout.
- `-i` (*in-place*)   = Don't print result to stdout, just go ahead and immediately edit file.

### Patterns

- `&` = Current regex match (ex: `echo "123 abc" | sed 's/[0-9]*/& &/'` = `123 123 abc`).

### Restrictions

- the opposite of `g`, perform operations only on the listed lines of file.
- `sed '3,5d` = Delete lines 3 through 5.

### Other commands and examples

- `tr ‘a-z’ ‘A-Z’` (*translate*)    = Find first parameter (`‘a-z’`) and replace matches with second parameter (`‘A-Z’`).
<br><br>
- `cat file.txt | awk {'print $12}` = Print the 12th column, space delimited, of every line in file.txt.
<br><br>
- `sort -rk 2`                      = Reverse (`r`) sort results by the second column (`k`) of output.
<br><br>
- `ifconfig ens32 | grep "inet" | grep –v "inet6" | tr –s " " ":" | cut –f 3 –d ":"` = Filter out only the ipv4 address of the ens32 interface.
  - `ifconfig ens32`  = Print the full ens32 interface.
  - `grep "inet"`     = Grep for lines with 'inet'.
  - `grep –v 'inet6'` = Filter out lines with `inet6`.
  - `tr –s " " ":"`   = Translate all spaces into colons to provide a common delimiter.
  - `cut –f 3 –d ":"` = Filter out the third field using cut and specifying the colon delimiter.


---
## WILDCARDS

### globbing

- `*`      = Zero or more of any character.
- `?`      = Exactly one of any character.
- `[xyz]`  = Any characters within set or within range of xyz (ex: `[0-9]`, `[H-K]`, `[aeiou]`, `[a-z]`).
- `[!xyz]` = Negation of xyz (any characters NOT in the set of xyz).

---
## GREP

### Examples

- `grep -h -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' /var/log/maillog* | sort -u` = Extract IPs.
  - `-h` = Don't print filenames (used only when grep is searching through multiple files).
  - `-o` = Print only the matching part of the line, instead of the whole line.
  - `sort -u` = Remove duplicates.
<br><br>
- `grep -nir ‘ex*le’ ./f*.txt` = Search for string ‘ex*le’ (with globbing) in all `.txt` files starting with `f` in or beneath the current directory.
  - `-i` = Ignore case.
  - `-n` = Display line number of match.
<br><br>
- `grep -l ‘^alice’ /etc/*` = Show only the filenames containing matches (`-l`) instead of the matches themselves.
<br><br>
- `grep -wv ‘[a-d]’ /*.txt` = Grep for words (`-w`) that DON’T contain the letters 'a' through 'd' (`-v`).
<br><br>
- `grep -C 5 '192\.168'` = Show five lines of context (`-C 5`) surrounding matched results, escape (`\`) the `.` in string to search for it literally and not interpret it as part of a globbing expression.

### Options

- `r` = Recurse through subdirectories.
- `i` = Ignore case.
- `v` = Show everything NOT in match (negation).
- `n` = Show the line number of matches.
- `l` = Show filenames of matches only.
- `w` = Match complete words rather than just letters.
<br><br>
- `C 5` (*context*) = Show 5 lines after and before match.
- `A 2` (*after*)   = Show 2 lines after match.
- `B 1` (*before*)  = Show 1 line before match.

### Regex (Invoked with `-E` option or by using `egrep`)

- `^`        = Match string at start.
- `$`        = Match string at end.
- `|`        = Logical OR.
- `*`        = Zero or more of previous.
- `+`        = One or more of previous.
- `{1,3}`    = Match the previous 1-3 times.
- `[0-9]`    = Any digit.
- `[A-Za-z]` = Any letter.
- `.`        = Any character.
- `\`        = Escape next character.
