## AWK

- See also:
  - [AWK one-liners explained](https://catonmat.net/awk-one-liners-explained-part-one)
  - [GAWK manual](https://www.gnu.org/software/gawk/manual/)
  - [AWK cheat sheet](https://catonmat.net/ftp/awk.cheat.sheet.pdf)

### Examples

- `awk '{print $3, $2} file.txt'` = Print the 3rd and 2nd fields of file.txt.
- `awk '/foo/ {gsub(/abc/,""); gsub(/[0-9]/,""); print $1}'` = Print 1st field of lines that contain "foo", remove "abc" and all numbers from output.
- `awk '/[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/' {print $3}` = Print 3rd field of lines that contain IP-address-like strings in input.
- `awk -F':' '/:[1-4][0-9]{3}/ {print $6}' /etc/passwd` = Print the home directories of all interactive users.
- `awk -F':' '! /\/sbin\/nologin/ {print $1}' /etc/passwd` = Print users who don't use /sbin/nologin as their shell.

### Regex

`^` = Match string at start.    (ex. `rpm –qa | grep -E ^a`)<br>
`$` = Match string at end.      (ex. `rpm –qa | grep -E 64$`)<br>
`a|b` = Alternation (`a` OR `b`).               (ex. `grep -E ‘i|a’ file`)<br>
`*` = Zero or more of previous. (ex. `grep -E ‘a*’ file`)<br>
`+` = One or more of previous.<br>
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
       
> NOTE: Enclose character classes in two sets of square brackets when using awk, [[:like_this:]].


---
## SED

`sed -[PARAMETER] '[RESTRICTION] [FLAG1]/[PATTERN1]/[PATTERN2]/[FLAG2]' [FILE1] [FILE2]...`

### Examples

`sed '1s/^/spam/ file.txt` = Insert "spam" at the first line of file.txt.<br>
                       `1` = Restrict operations to the first line of the input.<br>
                       `s` = Replace mode.<br>
                       `^` = (First string) Replace the start of the first line with the second string.<br>
                    `spam` = (Second string) This string will replace the start of the first line in file.txt.<br>

`sed 's/spam/eggs/3' file.txt` = Replace the third occurrence of "spam" with "eggs" in file.txt.<br>

`sed '2,3/^str*ng/d' file.txt` = Delete all strings matching expression.<br>
                         `2,3` = Limit command to the second and third lines of the file.<br>

`echo "all is fair" | sed 'i\in love and war'` = Returns "all is fair in love and war". Inserts input before match.<br>
`echo "in love and war" | sed 'a\all is fair'` = Returns "all is fair in love and war". Inserts input after match.<br>

`sed -n '2p'` = Print second line of input.<br>

`sed 's/string1/string2/w file.txt'` = Write modified data to file.txt.<br>

`sed 's/abc/xyz/I'` = Match "abc" or "ABC", replace with "xyz".<br>
`sed -e 's/a/A' -e 's/b/B'`<br>

### Flags

`s` (*substitute*)  = Perform a string substitution.<br>
`i` (*insert*)      = Insert input above match.<br>
`a` (*after*)       = Insert input after match.<br>
`g` (*global*)      = Perform operation throughout the entirety of the file.<br>
`p` (*print*)       = Force-print match to stdout. Usually used with `-n` to only print match.<br>
`w` (*write*)       = Write to the provided file.<br>
`I` (*insensitive*) = Make regex case-insensitive.<br>

### Parameters

`-e` (*expression*) = Combine multiple invocations into a single command.<br>
`-r` (*regex*)      = Use extended regular expressions, allowing the use of characters like `+`.<br>
`-n` (*nullify*)    = Suppress printing modified input to stdout.<br>
`-i` (*in-place*)   = Don't print result to stdout, just go ahead and immediately edit file.<br>

### Patterns

`&` = Current regex match (ex: `echo "123 abc" | sed 's/[0-9]*/& &/'` = `123 123 abc`).<br>

### Restrictions

- the opposite of `g`, perform operations only on the listed lines of file.<br>
`sed '3,5d` = Delete lines 3 through 5.<br>

### Other commands and examples

`tr ‘a-z’ ‘A-Z’` (*translate*)    = Find first parameter (`‘a-z’`) and replace matches with second parameter (`‘A-Z’`).<br>

`cat file.txt | awk {'print $12}` = Print the 12th column, space delimited, of every line in file.txt.<br>

`sort -rk 2`                      = Reverse (`r`) sort results by the second column (`k`) of output.<br>

`ifconfig ens32 | grep "inet" | grep –v "inet6" | tr –s " " ":" | cut –f 3 –d ":"` = Filter out only the ipv4 address of the ens32 interface.<br>
                                                                 `ifconfig ens32`  = Print the full ens32 interface.<br>
                                                                 `grep "inet"`     = Grep for lines with 'inet'.<br>
                                                                 `grep –v 'inet6'` = Filter out lines with `inet6`.<br>
                                                                 `tr –s " " ":"`   = Translate all spaces into colons to provide a common delimiter.<br>
                                                                 `cut –f 3 –d ":"` = Filter out the third field using cut and specifying the colon delimiter.<br>


---
## WILDCARDS

### globbing

`*`      = Zero or more of any character.<br>
`?`      = Exactly one of any character.<br>
`[xyz]`  = Any characters within set or within range of xyz (ex: `[0-9]`, `[H-K]`, `[aeiou]`, `[a-z]`).<br>
`[!xyz]` = Negation of xyz (any characters NOT in the set of xyz).<br>



---
## GREP

### Examples

`grep -h -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' /var/log/maillog* | sort -u` = Extract IPs.<br>
                                                                                     `-h` = Don't print filenames (used only when grep is searching through multiple files).<br>
                                                                                     `-o` = Print only the matching part of the line, instead of the whole line.<br>
                                                                                `sort -u` = Remove duplicates.<br>

`grep -nir ‘ex*le’ ./f*.txt` = Search for string ‘ex*le’ (with globbing) in all `.txt` files starting with `f` in or beneath the current directory.<br>
                        `-i` = Ignore case.<br>
                        `-n` = Display line number of match.<br>

`grep -l ‘^alice’ /etc/*` = Show only the filenames containing matches (`-l`) instead of the matches themselves.<br>

`grep -wv ‘[a-d]’ /*.txt` = Grep for words (`-w`) that DON’T contain the letters 'a' through 'd' (`-v`).<br>

`grep -C 5 '192\.168'` = Show five lines of context (`-C 5`) surrounding matched results, escape (`\`) the `.` in string to search for it literally and not interpret it as part of a globbing expression.<br>

### Options

`r` = Recurse through subdirectories.<br>
`i` = Ignore case.<br>
`v` = Show everything NOT in match (negation).<br>
`n` = Show the line number of matches.<br>
`l` = Show filenames of matches only.<br>
`w` = Match complete words rather than just letters.<br>

`C 5` (*context*) = Show 5 lines after and before match.<br>
`A 2` (*after*)   = Show 2 lines after match.<br>
`B 1` (*before*)  = Show 1 line before match.<br>

### Regex (Invoked with `-E` option or by using `egrep`)

`^`        = Match string at start.
`$`        = Match string at end.
`|`        = Logical OR.              (ex. `grep -E ‘i|a’ file`)<br>
`*`        = Zero or more of previous. (ex. `grep -E ‘a*’ file`)<br>
`+`        = One or more of previous.<br>
`{1,3}`    = Match the previous 1-3 times.<br>
`[0-9]`    = Any digit.<br>
`[A-Za-z]` = Any letter.<br>
`.`        = Any character.<br>
`\`        = Escape next character.<br>
