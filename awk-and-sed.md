
## [AWK](https://www.gnu.org/software/gawk/manual/gawk.html)

- **See also**:
  - [AWK one-liners explained](https://catonmat.net/awk-one-liners-explained-part-one)
  - [AWK cheat sheet](https://catonmat.net/ftp/awk.cheat.sheet.pdf)

### Examples

Print all interactive users from */etc/passwd*:
```bash
awk -F: \
  '
  # Look for lines that do NOT contain the following:
    # "nologin"
    # First non-whitespace character is a "#" (^\s*#)
    # Last non-whitespace character is a ":" (:\s*$)
  # If the user UID is 0 (i.e. root) or over 1000, print the username.
  !/nologin|^\s*#|:\s*$/ && ($3==0||$3>1000) \
  {print $1}' \
  /etc/passwd

awk -F: '!/nologin|^\s*#|:$/ && ($3==0||$3>1000){print $1}' /etc/passwd
```

List pacman packages by size:
```bash
pacman -Qi | \
  awk -F: \
    '/^Name/ {name=$2}
     /^Installed/ {gsub(/ /,"");size=$2; print size,name}' \
  | sort -h`

pacman -Qi | awk -F: '/^Name/ {name=$2} /^Installed/ {gsub(/ /,"");size=$2; print size,name}' | sort -h`
```

Get weather:
```bash
curl -s wttr.in | \
  awk \
    '{if(NR==3) weather1=$4}
     {if(NR==3) weather2=$5}
     /\.\./ {if(NR==4) print weather1, weather2, "("$5, $6")"}'
```

Reformat a log file:
```bash
gawk -F$'\t' \
'{
# Convert Unix epoch to a human-readable timestamp.
# This function is available only in GNU awk.
time=strftime("%m-%d-%Y %H:%M:%S", $1)
source=$3
url=$6
http_method=$7
http_code=$8
access=$16
group=$19

# Use the printf function so the field alignment can be adjusted.
printf ("%s | %s %s | %-7s %-3s | %s | %s\n", time, group, source, http_method, http_code, access, url)
}' access.log
```

- `awk 'NF>0 {blank=0} NF==0 {blank++} blank < 2'`           = Remove consecutive blank lines, emulates `cat -s`.
<br><br>
- `awk '/foo/ {gsub(/abc/,""); gsub(/[0-9]/,""); print $1}'` = Print 1st field of lines that contain *foo*, remove *abc* and all numbers from output.
- `awk '/([0-9]{1,3}\.){1,3}[0-9]{1,3}/ {print $3}'`         = Print 3rd field of lines that contain IP-address-like strings in input.
- `ip -4 -br a | awk '!/127\.0\.0/ {gsub(/\/[0-9]{1,2}/,""); print $3}'` = Print the primary IP address, without the subnet mask.
<br><br>
- `awk -F: '/:[1-4][0-9]{3}/ {print $6}' /etc/passwd`     = Print the home directories of all interactive users.
- `awk -F: '!/\/sbin\/nologin/ {print $1}' /etc/passwd`   = Print users who don't use */sbin/nologin* as their shell.
<br><br>
- `awk 'NR>2'`          = Print all but the first two lines.
- `awk 'NR==1'`         = Print the first line, emulates `head -1`.
- `awk 'NF>0'`          = Remove blank lines quickly (i.e. print lines with at least one field).
- `awk 'END{print}'`    = Print the last line, emaultes `tail -1` (*{print}* is the same as *{print $0}*).
- `awk 'END{print NR}'` = Print the number of lines, emaultes `wc -l`.
- `awk 'length($0)>80'` = Print lines longer than 80 characters.

### Variables

- **See also:**
  - [Shell variables in an awk script](https://stackoverflow.com/questions/19075671/how-do-i-use-shell-variables-in-an-awk-script)
<br><br>
- `FS`  = Input field separator regular expression, a \<SPACE\> by default.
- `NF`  = The number of fields in the current record.
- `NR`  = The ordinal number of the current record from the start of input.
- `OFS` = The print statement output field separator, \<SPACE\> by default.
- `ORS` = The print statement output record separator, a \<NEWLINE\> by default.
<br><br>
- Pass shell variable to awk:
```
myvar="Hello world!"
awk -v myvar="${myvar}" 'BEGIN {print myvar}'`
```

### Regex
*(See `man 7 regex` for more info.)*

#### Operators

- `~` = Regex matching operator (`awk '$1 ~ /J/'` = Print field *1* if it contains a *J*.).
- `!~` = Negation regex matching operator. (`awk '$1 !~ /J/'` = Print field *1* if it doesn't contain a *J*.).

#### Patterns
- `.`       = Any character.
- `[abc…]`  = Anything within brackets (called a *bracket expression*).
- `[^123…]` = Anything NOT within brackets.
- `\`       = Escape next character.
- `(   )`   = Pattern grouping (groups multiple *pieces* into a single *atom*).
- `([0-9]{1,3}\.){5}` = 5 instances of ( 1-3 of any digit, followed by a period ).

#### Quantifiers
- `^`     = Match pattern at start.
- `$`     = Match pattern at end.
- `a|b`   = Alternation of patterns (*a* or *b*).
- `*`     = Zero or more of pattern.
- `+`     = One or more of pattern.
- `?`     = Zero or one of pattern.
- Bounds: basic regex requires `\{ \}`, extended regex uses `{ }`
  - `{1,5}` = One to five of pattern.
  - `{3,}`  = At least three of pattern.
  - `{,2}`  = At most three of pattern.

| Character classes | Similar to      | GNU synonym | *Only valid within brackets e.g [[:xyz:]]*        |
|-------------------|-----------------|-------------|---------------------------------------------------|
| `[:upper:]`       | `[A-Z]`         |             | Uppercase alphabetic characters                   |
| `[:lower:]`       | `[a-z]`         |             | Lowercase alphabetic characters                   |
| `[:digit:]`       | `[0-9]`         |             | Numeric characters                                |
| `[:alpha:]`       | `[A-Za-z]`      |             | Alphabetic characters                             |
| `[:alnum:]`       | `[A-Za-z0-9]`   | `\w`        | Alphanumeric characters                           |
| `[:blank:]`       | `[ \t]`         |             | Space and tab characters ONLY                     |
| `[:space:]`       | `[ \t\n\r\f\v]` | `\s`        | Whitespace characters (space, tab, formfeed, etc.)|
| `[:cntrl:]`       |                 |             | Control characters                                |
| `[:graph:]`       | `[^ [:cntrl:]]` |             | Graphical characters (non-control characters)     |
| `[:print:]`       | `[[:graph:] ]`  |             | Graphical characters and space                    |
| `[:punct:]`       |      |       | Punctuation characters (non-letter, digit, control char, or space) |

| GNU-style character classes |           |
|------|----------------------------------|
| `\s` | Whitespace characters            |
| `\S` | Non-whitespace characters        |
| `\w` | letters, digits, underscores     |
| `\W` | Non-letters, digits, underscores |
| `\f` | Form-feed                        |
| `\r` | Carriage return                  |
| `\n` | Newline                          |
| `\t` | Tab                              |


---
## [SED](https://www.gnu.org/software/sed/manual/sed.html)

- **See also**:
  - [Sed introduction](https://www.grymoire.com/Unix/Sed.html)

sed `-<PARAMETER> '<RESTRICTION> <FLAG1>/<PATTERN1>/<PATTERN2>/<FLAG2>' <FILE1> <FILE2>…`

### Examples

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


---
## WILDCARDS

### globbing

- `*`      = Zero or more of any character.
- `?`      = Exactly one of any character.
- `[xyz]`  = Any characters within set or within range.
- `[!xyz]` = Negation of xyz (any characters NOT in the set of *xyz*).

---
## [GREP](https://www.gnu.org/software/grep/manual/grep.html)

### Examples

- `egrep -h -o '([0-9]{1,3}\.){1,3}[0-9]{1,3}' /var/log/maillog* | sort -u` = Extract IPs.
  - `-h` = Don't print filenames (used only when grep is searching through multiple files).
  - `-o` = Print only the matching part of the line, instead of the whole line.
  - `sort -u` = Remove duplicates.
<br><br>
- `grep -nir 'ex*le' ./f*.txt` = Search for *ex\*le* (with globbing) in all *.txt* files starting with *f* in or beneath
  the current directory.
  - `-n` = Display line number of match.
  - `-i` = Ignore case.
<br><br>
- `grep -l '^alice' /etc/*` = Show only the filenames containing matches (*-l*) instead of the matches themselves.
- `grep -wv '[a-d]' /*.txt` = Grep for words (*-w*) that DON’T contain the letters *a* through *d* (*-v*).
- `grep -C 5 '192\.168'` = Show five lines of context (*-C 5*) surrounding matched results.

### Options

- `-r` = Recurse through subdirectories.
- `-i` = Ignore case.
- `-v` = Show everything NOT in match (negation).
- `-n` = Show the line number of matches.
- `-l` = Show filenames of matches only.
- `-w` = Match complete words rather than just letters.
<br><br>
- `-C 5` (*context*) = Show 5 lines after and before match.
- `-A 2` (*after*)   = Show 2 lines after match.
- `-B 1` (*before*)  = Show 1 line before match.
