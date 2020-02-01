
## STREAM EDITING

### `awk` command

`awk {'print $3'} file.txt` = print the 3rd column of file.txt 

---
### `sed` command
syntax: `sed -[parameter] '[restriction] [flag1]/[pattern1]/[pattern2]/[flag2]'`

#### examples

`sed '1s/^/string/ file.txt`         = insert string at first line of file.txt

`sed 's/string1/string2/3' file.txt` = replace the third occurrence of string1 with string2 in file.txt

`sed '2,3/^str*ng/d' file.txt`       = delete all strings matching expression  
                         `2,3`       = limit command to the second and third lines of the file  

#### flags

`s` (*substitute*)  = perform a string substitution                                           (ex: `sed 's/happy/sad/'` = replace 'happy' with 'sad')  
`i` (*insert*)      = insert input above match                                                (ex: `echo "all is fair" | sed 'i\in love and war'`)  
`a` (*after*)       = insert input after match                                                (ex: `echo "in love and war" | sed 'a\all is fair'`)  
`g` (*global*)      = perform operation throughout the entirety of the file  
`p` (*print*)       = force-print match to stdout. Usually used with `-n` to only print match (ex: `sed -n '2p'` = print 2nd line of input)  
`w` (*write*)       = write to the provided file                                              (ex: `sed 's/string1/string2/w file.txt'` = write modified data to file.txt)  
`I` (*insensitive*) = make regex case-insensitive                                             (ex: `sed 's/abc/xyz/I'` = match abc or ABC)

#### parameters

`-e` (*expression*) = combine multiple invocations into a single command                      (ex: `sed -e 's/a/A' -e 's/b/B'`)  
`-r` (*regex*)      = use extended regular expressions, allowing the use of characters like `+`  
`-n` (*nullify*)    = suppress printing modified input to stdout  
`-i` (*in-place*)   = don't print result to stdout, just go ahead and immediately edit file

#### patterns

`&` = current regex match (ex: `echo "123 abc" | sed 's/[0-9]*/& &/'` = `123 123 abc`)

#### restrictions

- the opposite of `g`, perform operations only on the listed lines of file
`sed '3,5d` = delete lines 3 through 5

### other commands and examples

`tr ‘a-z’ ‘A-Z’` (*translate*)    = find first parameter (`‘a-z’`) and replace matches with second parameter (`‘A-Z’`) 

`cat file.txt | awk {'print $12}` = print the 12th column, space delimited, of every line in file.txt 

`sort -rk 2`                      = reverse (`r`) sort results by the second column (`k`) of output 

`ifconfig ens32 | grep "inet" | grep –v "inet6" | tr –s " " ":" | cut –f 3 –d ":"` = filter out only the ipv4 address of the ens32 interface  
  `ifconfig ens32`  = first print the full ens32 interface  
  `grep "inet"`     = then grep for lines with 'inet'   
  `grep –v 'inet6'` = then filter out lines with `inet6` with   
  `tr –s " " ":"`   = then translate all spaces into colons  to provide a common delimiter  
  `cut –f 3 –d ":"` = then filter out the third field using cut and specifying the colon delimiter 

---
## WILDCARDS

### globbing

`*`      = zero or more of any character  
`?`      = exactly one of any character  
`[xyz]`  = any characters within set or within range of xyz (ex: `[0-9]`, `[H-K]`, `[aeiou]`, `[a-z]`)  
`[!xyz]` = negation of xyz (any characters NOT in the set of xyz)

### generic regex

`^` = match string at start    (ex. `rpm –qa | grep -E ^a`)  
`$` = match string at end      (ex. `rpm –qa | grep -E 64$`)  
`|` = logical OR               (ex. `grep -E ‘i|a’ file`)  
`*` = zero or more of previous (ex. `grep -E ‘a*’ file`)  
`+` = one or more of previous

---
## `grep` command

### options

`r` = recursive  
`i` = ignore case  
`v` = show everything NOT in match (negation)  
`n` = show line number  
`l` = show filenames of matches only  
`w` = match complete words

`C 5` (*context*) = show 5 lines after and before match  
`A 2` (*after*)   = show 2 lines after match  
`B 1` (*before*)  = show 1 line before match

### regex (invoked with `-E` option)

`^`        = match string at start  
`$`        = match string at end  
`|`        = logical OR               (ex. `grep -E ‘i|a’ file`)  
`*`        = zero or more of previous (ex. `grep -E ‘a*’ file`)  
`+`        = one or more of previous  
`{1,3}`    = match the previous 1-3 times  
`[0-9]`    = any digit  
`[A-Za-z]` = any letter  
`.`        = any character  
`\`        = escape next character

### examples

`grep -h -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' /var/log/maillog* | sort -u` = extract IPs  
  `-h`            = don't print filenames (used only when grep is searching through multiple files)  
  `-o`            = print only the matching part of the line, instead of the whole line  
  `sort -u`       = remove duplicates  
  `-u` (*unique*) = only match unique lines

`grep -nir ‘ex*le’ ./f*.txt` = search for string ‘ex*le’ with globbing  
search in all `.txt` files starting with `f` in or beneath (`-r`) the current directory (`./`)  
  `-i` = ignore case  
  `-n` = display line number of match

`grep -l ‘^alice’ /etc/*` = show only the filenames containing matches (`-l`) instead of the matches themselves

`grep -wv ‘[a-d]’ /*.txt` = grep for words (`-w`) that DON’T contain the letters 'a' through 'd' (`-v`)

`grep -C 5 '192.168'` = show five lines of context (`-C 5`) surrounding matched results, escape (`\`) the `.` in string to search for it literally and not interpret it as part of a globbing expression

