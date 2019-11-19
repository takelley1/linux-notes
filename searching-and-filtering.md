## STREAM EDITING

### `awk` command

---
### `sed` command
- command syntax: `sed -[parameter] '[restriction] [flag1]/[pattern1]/[pattern2]/[flag2]'`

#### flags

`s` (*substitute*) perform a string substitution (ex: `sed 's/happy/sad/'` = replace 'happy' with 'sad') \
`i` (*insert*) insert input above match (ex: `echo "all is fair" | sed 'i\in love and war'`) \
`a` (*after*) insert input after match (ex: `echo "in love and war" | sed 'a\all is fair'`) \
`g` (*global*) perform operation throughout the entirety of the file \
`p` (*print*) force-print match to stdout. Usually used with `-n` to only print match (ex: `sed -n '2p'` = print 2nd line of input) \
`w` (*write*) write to the provided file (ex: `sed 's/string1/string2/w file.txt'` = write modified data to file.txt) \
`I` (*insensitive*) make regex case-insensitive (ex: `sed 's/abc/xyz/I'` = match abc or ABC)

#### parameters

`-e` (*expression*) combine multiple invocations into a single command (ex: `sed -e 's/a/A' -e 's/b/B'`) \
`-r` (*regex*) use extended regular expressions, allowing the use of characters like `+` \
`-n` (*nullify*) suppress printing modified input to stdout \
`-i` (*in-place*) don't print result to stdout, just go ahead and immediately edit file

#### patterns

`&` equal to the current regex match (ex: `echo "123 abc" | sed 's/[0-9]*/& &/'` = `123 123 abc`)

#### restrictions

- the opposite of `g`, perform operations only on the listed lines of file
`sed '3,5d` = delete lines 3 through 5

#### examples

`sed 's/string1/string2/3' file.txt` = replace the third occurrence of string1 with string2 in file.txt

`sed '2,3/^str*ng/d' file.txt` = delete all strings matching expression \
`2,3` limit command to the second and third lines of the file \

### other commands and examples

`tr ‘a-z’ ‘A-Z’` = (`tr`anslate) find first parameter (`‘a-z’`) and replace matches with second parameter (`‘A-Z’`) 

`cat file.txt | awk {'print $12}` = print the 12th column, space delimited, of every line in file.txt 

`sort -rk 2` = reverse (`-r`) sort results by the second (`2`) column (`-k`) of output 

`ifconfig ens32 | grep "inet" | grep –v "inet6" | tr –s " " ":" | cut –f 3 –d ":"` = \
  -filter out only the ipv4 address of the ens32 interface \
  -first print the full ens32 interface (`ifconfig ens32`) \
  -then grep for lines with 'inet' (`grep "inet"`) \
  -then filter out lines with `inet6` with (`grep –v 'inet6'`) \
  -then translate all spaces into colons (`tr –s " " ":"`) to provide a common delimiter \
  -then filter out the third field using cut and specifying the colon delimiter (`cut –f 3 –d ":"`)

---
## WILDCARDS

### globbing

`*` zero or more of any character \
`?` exactly one of any character \
`[xyz]` (set) any characters within set or within range of xyz, ex: `[0-9]`, `[H-K]`, `[aeiou]`, `[a-z]` \
`[!xyz]` or `[^xyz]` negation of xyz, any characters NOT in xyz

### generic regex

`^` match string at start (ex. `rpm –qa | grep -E ^a`) \
`$` match string at end (ex. `rpm –qa | grep -E 64$`) \
`|` logical OR (ex. `grep -E ‘i|a’ file`) \
`*` zero or more of previous (ex. `grep -E ‘a*’ file`) \
`+` one or more of previous

---
## `grep` command

### `grep` options

`r` recursive \
`i` ignore case \
`v` show everything NOT in match (negation) \
`n` show line number \
`l` show filenames of matches only \
`w` match complete words

`C #` (*context*) show `#` lines after and before match \
`A #` (*after*) show `#` lines after match \
`B #` (*before*) show `#` lines before match

### `grep` regex (invoked with `-E` option)

`^` match string at start \
`$` match string at end \
`|` logical OR (ex. `grep -E ‘i|a’ file`) \
`*` zero or more of previous (`grep -E ‘a*’ file`) \
`+` one or more of previous \
`{1,3}` match the previous 1-3 times \
`[0-9]` any digit \
`[A-Za-z]` any letter \
`.` any character \
`\` escape next character

### `grep` examples

`grep -h -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' /var/log/maillog* | sort -u` = extract IPs \
`-h` don't print filenames (used only when grep is searching through multiple files) \
`-o` print only the matching part of the line, instead of the whole line \
`sort -u` remove duplicates \
`-u` (*unique*) only match unique lines

`grep -nir ‘ex*le’ ./f*.txt` = search for string ‘ex*le’ with globbing \
search in all `.txt` files starting with `f` in or beneath (`-r`) the current directory (`./`) \
`-i` ignore case \
`-n` display line number of match

`grep -l ‘^alice’ /etc/*` = show only the filenames containing matches (`-l`) instead of the matches themselves

`grep -wv ‘[a-d]’ /*.txt` = grep for words (`-w`) that DON’T contain the letters 'a' through 'd' (`-v`)

`grep -C 5 '192\.168'` = show five lines of context (`-C 5`) surrounding matched results, escape (`\`) the `.` in string to search for it literally and not interpret it as part of a globbing expression

---
## `find` command

#### options 

`-type f` match is of type `f` (`f`=file, `d`=dir, `l`=link, `p`=pipe, `b`=block, `c`=character) \
`-iname` match by file name, ignoring case \
`-regex` match by file name using regex

`-uid 1000` = match is owned by UID 1000 (`-gid N` for file's group's GID) \
`-user alice` = match is owned by user alice \
`-group wheel` = match is owned by group wheel 

`-mmin -19` match was last modified less than 19 minutes ago \
`-mmin +5` match was last modified more than 5 minutes ago \
`-mtime 3` same as `mmin` but in days, not minutes (match modified 3 days ago) \
`-newer file.txt` match is newer than file.txt

`-size +5G` match is more than 5 gigabytes (`c`=bytes, `w`=two-byte words, `k`=kilobytes), (`-`=less than, `+`=more than) \
`-perm 755` match has octal permissions 755

`-delete` delete matches \
`-L` follow symbolic links

#### examples

ex. `find -name "file[0-9].txt" -exec ls -l {} \;` = perform `ls –l` command on files that are found with find 

or

ex. `find -name "file[0-9].txt" | xargs ls -l` = converts stdout of find into input arguments for the piped command using `xargs`

`find ./ -type f | wc –l` = \
  -print number of files beneath current path \
  -search for files only, not directories (`-type f`) \
  -count the number of lines in the ouput (`wc –l`)

`find -03 -L . -type f -name *.jpg` = \
  -optimize file search order based on likelihood of finding a match (`-03`) \
  -follow symbolic links (`-L`) \
  -search in or below the current directory (`.`) \
  -look for files (`-type f`) \
  -search based on file name (`-name`) \
  -use wildcard to search for all files with .jpg extension (`*.jpg`)

`find ~ -user alice -mtime 7 -iname “.log” -delete` = \
  -files owned by user alice (`-user`) \
  -search in or beneath the specified user's home directory (`~`) \
  -filter by file's modified time, in # of days ago (`-mtime`) \
  -ignore case (`-i`) \
  -match by file name (`-name`) \
  -delete after locating files (`-delete`)

`locate -ice *.txt` = search for all .txt files, ignore case (`-i`), show number of matches (`-c` for “count”), and verify file’s existence before producing result since database may be old (`-e`) 

> Note: locate is much faster than find, but locate searches a tabulated database instead of actively scrubbing your disk for a match. This means the data locate uses may be a few hours old 

---
## LOGS

`logger test123` = send a test log to `/var/log/mesages` \
`tail -f file.txt` = view text file in as it updates in realtime (`-f` for follow) \
`ls -ltrh` = list files sorted by last modified time, include filesize (`-h`) \
`journalctl -xe` = show system log files with explanatory (`-x`) text included (systemd only) \
`strace` = trace system call


`/etc/logrotate.d/` = log rotation scripts 
```
{ 
    rotate 7 

    Size 100M 

    daily 

    missingok 
    notifempty 
    delaycompress 
    compress 
    postrotate 
    reload rsyslog >/dev/null 2>&1 || true 
    endscript 
}
```
rotate the `/var/log/syslog` file daily and keep 7 copies of the rotated file, limit size to 100M 

#### log locations
`/var/log/messages` or `/var/log/syslog` generic system activity logs \
`/var/log/secure` or `/var/log/auth` authentication logs \
`/var/log/kernel` logs from the kernel \
`/var/log/cron` record of cron jobs \
`/var/log/maillog` log of all mail messages \
`/var/log/faillog` failed logon attempts \
`/var/log/boot.log` dump location of `init.d` \
`/var/log/dmesg` kernel ring buffer logs for hardware drivers \
`/var/log/httpd` apache server logs

---  
## MISC

`man -k string` search man pages for given string 

`history` = print past commands to stdout, grep and use ![line_number] to repeat command without retyping; [or] use CTRL+R to search history 
