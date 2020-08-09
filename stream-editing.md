
## STREAM EDITING

### `awk` command

`awk '{print $3}' file.txt` = Print the 3rd column of file.txt.

---
### `sed` command

`sed -[PARAMETER] '[RESTRICTION] [FLAG1]/[PATTERN1]/[PATTERN2]/[FLAG2]' [FILE1] [FILE2]...`

#### Sed examples

`sed '1s/^/spam/ file.txt` = Insert "spam" at the first line of file.txt.
                       `1` = Restrict operations to the first line of the input.
                       `s` = Replace mode.
                       `^` = (First string) Replace the start of the first line with the second string.
                    `spam` = (Second string) This string will replace the start of the first line in file.txt.

`sed 's/spam/eggs/3' file.txt` = Replace the third occurrence of "spam" with "eggs" in file.txt.

`sed '2,3/^str*ng/d' file.txt` = Delete all strings matching expression.
                         `2,3` = Limit command to the second and third lines of the file.

`echo "all is fair" | sed 'i\in love and war'` = Returns "all is fair in love and war". Inserts input before match.
`echo "in love and war" | sed 'a\all is fair'` = Returns "all is fair in love and war". Inserts input after match.

`sed -n '2p'` = Print second line of input.

`sed 's/string1/string2/w file.txt'` = Write modified data to file.txt.

`sed 's/abc/xyz/I'` = Match "abc" or "ABC", replace with "xyz".
`sed -e 's/a/A' -e 's/b/B'`

#### sed flags

`s` (*substitute*)  = Perform a string substitution.
`i` (*insert*)      = Insert input above match.
`a` (*after*)       = Insert input after match.
`g` (*global*)      = Perform operation throughout the entirety of the file.
`p` (*print*)       = Force-print match to stdout. Usually used with `-n` to only print match.
`w` (*write*)       = Write to the provided file.
`I` (*insensitive*) = Make regex case-insensitive.

#### Sed Parameters

`-e` (*expression*) = Combine multiple invocations into a single command.
`-r` (*regex*)      = Use extended regular expressions, allowing the use of characters like `+`.
`-n` (*nullify*)    = Suppress printing modified input to stdout.
`-i` (*in-place*)   = Don't print result to stdout, just go ahead and immediately edit file.

#### Sed patterns

`&` = Current regex match (ex: `echo "123 abc" | sed 's/[0-9]*/& &/'` = `123 123 abc`).

#### Sed restrictions

- the opposite of `g`, perform operations only on the listed lines of file.
`sed '3,5d` = Delete lines 3 through 5.

### Other commands and examples

`tr ‘a-z’ ‘A-Z’` (*translate*)    = Find first parameter (`‘a-z’`) and replace matches with second parameter (`‘A-Z’`).

`cat file.txt | awk {'print $12}` = Print the 12th column, space delimited, of every line in file.txt.

`sort -rk 2`                      = Reverse (`r`) sort results by the second column (`k`) of output.

`ifconfig ens32 | grep "inet" | grep –v "inet6" | tr –s " " ":" | cut –f 3 –d ":"` = Filter out only the ipv4 address of the ens32 interface.
                                                                 `ifconfig ens32`  = Print the full ens32 interface.
                                                                 `grep "inet"`     = Grep for lines with 'inet'.
                                                                 `grep –v 'inet6'` = Filter out lines with `inet6`.
                                                                 `tr –s " " ":"`   = Translate all spaces into colons to provide a common delimiter.
                                                                 `cut –f 3 –d ":"` = Filter out the third field using cut and specifying the colon delimiter.


---
## WILDCARDS

### globbing

`*`      = Zero or more of any character.
`?`      = Exactly one of any character.
`[xyz]`  = Any characters within set or within range of xyz (ex: `[0-9]`, `[H-K]`, `[aeiou]`, `[a-z]`).
`[!xyz]` = Negation of xyz (any characters NOT in the set of xyz).

### Generic regex

`^` = Match string at start.    (ex. `rpm –qa | grep -E ^a`)
`$` = Match string at end.      (ex. `rpm –qa | grep -E 64$`)
`|` = Logical OR.               (ex. `grep -E ‘i|a’ file`)
`*` = Zero or more of previous. (ex. `grep -E ‘a*’ file`)
`+` = One or more of previous.

---
## `grep` command

### Grep examples

`grep -h -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' /var/log/maillog* | sort -u` = Extract IPs.
                                                                                     `-h` = Don't print filenames (used only when grep is searching through multiple files).
                                                                                     `-o` = Print only the matching part of the line, instead of the whole line.
                                                                                `sort -u` = Remove duplicates.

`grep -nir ‘ex*le’ ./f*.txt` = Search for string ‘ex*le’ (with globbing) in all `.txt` files starting with `f` in or beneath the current directory.
                        `-i` = Ignore case.
                        `-n` = Display line number of match.

`grep -l ‘^alice’ /etc/*` = Show only the filenames containing matches (`-l`) instead of the matches themselves.

`grep -wv ‘[a-d]’ /*.txt` = Grep for words (`-w`) that DON’T contain the letters 'a' through 'd' (`-v`).

`grep -C 5 '192\.168'` = Show five lines of context (`-C 5`) surrounding matched results, escape (`\`) the `.` in string to search for it literally and not interpret it as part of a globbing expression.

### Grep options

`r` = Recurse through subdirectories.
`i` = Ignore case.
`v` = Show everything NOT in match (negation).
`n` = Show the line number of matches.
`l` = Show filenames of matches only.
`w` = Match complete words rather than just letters.

`C 5` (*context*) = Show 5 lines after and before match.
`A 2` (*after*)   = Show 2 lines after match.
`B 1` (*before*)  = Show 1 line before match.

### Grep regex (Invoked with `-E` option or by using `egrep`)

`^`        = Match string at start.
`$`        = Match string at end.
`|`        = Logical OR.              (ex. `grep -E ‘i|a’ file`)
`*`        = Zero or more of previous. (ex. `grep -E ‘a*’ file`)
`+`        = One or more of previous.
`{1,3}`    = Match the previous 1-3 times.
`[0-9]`    = Any digit.
`[A-Za-z]` = Any letter.
`.`        = Any character.
`\`        = Escape next character.
