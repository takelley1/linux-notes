
## CONSOLE

`dpkg-reconfigure console-setup`    = change console font size (debian-based distros)  
[edit `/etc/default/console-setup`] = change console font size

---
## BASH

`while true; do [COMMAND]; sleep 10; done` = loop command indefinitely

`[COMMAND] &`              = run command in background  
`[COMMAND1] && [COMMAND2]` = run command2 only if command1 is successful  
`[COMMAND1] || [COMMAND2]` = run command2 only if command1 is NOT successful  
`[COMMAND1] ; [COMMAND2]`  = run command2 immediately after command1, even if command1 is not successful (ex: `cd /home ; ls`)

`sudo !!` = execute last command with `sudo` privileges

`1>` or `>`    = stdout  
`2>`           = stderr  
`2>&1` or `&>` = stdout and stderr

`cat /file.log 2>&1 | grep -i error` = pass both stdout and stderr to grep through pipe, by default pipe only passes stdout  
`stat /home/file.txt`                = show last modified date, creation date, and other metadata about given file

### if statement conditional tests

see also: http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_07_01.html

| syntax [4]          | meaning                                                                            |
|---------------------|------------------------------------------------------------------------------------|
| [ -a FILE ]         | True if FILE exists.                                                               |
| [ -b FILE ]         | True if FILE exists and is a block-special file.                                   |
| [ -c FILE ]         | True if FILE exists and is a character-special file.                               |
| [ -d FILE ]         | True if FILE exists and is a directory.                                            |
| [ -e FILE ]         | True if FILE exists.                                                               |
| [ -f FILE ]         | True if FILE exists and is a regular file.                                         |
| [ -g FILE ]         | True if FILE exists and its SGID bit is set.                                       |
| [ -h FILE ]         | True if FILE exists and is a symbolic link.                                        |
| [ -k FILE ]         | True if FILE exists and its sticky bit is set.                                     |
| [ -p FILE ]         | True if FILE exists and is a named pipe (FIFO).                                    |
| [ -r FILE ]         | True if FILE exists and is readable.                                               |
| [ -s FILE ]         | True if FILE exists and has a size greater than zero.                              |
| [ -t FD ]           | True if file descriptor FD is open and refers to a terminal.                       |
| [ -u FILE ]         | True if FILE exists and its SUID (set user ID) bit is set.                         |
| [ -w FILE ]         | True if FILE exists and is writable.                                               |
| [ -x FILE ]         | True if FILE exists and is executable.                                             |
| [ -O FILE ]         | True if FILE exists and is owned by the effective user ID.                         |
| [ -G FILE ]         | True if FILE exists and is owned by the effective group ID.                        |
| [ -L FILE ]         | True if FILE exists and is a symbolic link.                                        |
| [ -N FILE ]         | True if FILE exists and has been modified since it was last read.                  |
| [ -S FILE ]         | True if FILE exists and is a socket.                                               |
| [ FILE1 -nt FILE2 ] | True if FILE1 was changed sooner than FILE2, or if FILE1 exists and FILE2 doesn't. |
| [ FILE1 -ot FILE2 ] | True if FILE1 is older than FILE2, or if FILE2 exists and FILE1 doesn't.           |
| [ FILE1 -ef FILE2 ] | True if FILE1 and FILE2 refer to the same device and inode numbers.                |
| [ -o OPTIONNAME ]   | True if shell option "OPTIONNAME" is enabled.                                      |

---
### escape characters

`'single quotes'`
- when in doubt, put the whole string in single quotes [1]
  - **single quotes preserve the literal value of every character enclosed within the quotes** [3]
  - a single quote *cannot* occur between single quotes, even when escaped by a backslash [3]

`"double quotes"`
- double quotes preserve literal value of every character except the dollar sign, backtick, and backslash [3]
- characters that need to be escaped: `"`, `$`, `\`, `[space]` [2]

---
### hotkeys

`CTRL-SHIFT-j` or `CTRL-j` = get shell prompt back

`CTRL-r` = search command history  
`history` = print past commands to stdout, grep and use ![line_number] to repeat command without retyping

`CTRL-l` = clear screen

`CTRL-c` = send `SIGINT` to foreground process  
`CTRL-z` = suspend foreground process

`CTRL-d` = exit current shell

`ALT-f` = jump forward one word  (when editing a command)  
`ALT-b` = jump backward one word (when editing a command)

---
## ENVIRONMENT VARIABLES

`echo $VARIABLE-NAME`          = get value of VARIABLE-NAME  
`printenv`                     = get values of all environment variables  
`export HOME=/home/newhomedir` = set value of environment variable (note lack of `$`)
 
`DISPLAY` = name of X window display  
`EDITOR`  = default text editor  
`HOME`    = path of current user's home directory  
`LOGNAME` = current user's login name  
`MAIL`    = path of current user's mailbox  
`OLDPWD`  = the shell's previous working directory  
`PATH`    = where the shell looks for command binaries, paths separated by a colon  
`PWD`     = the shell's current working directory  
`SHELL`   = path of the shell's binary  
`TERM`    = type of terminal being used  
`USER`    = current username

---
#### sources

[1] https://stackoverflow.com/questions/15783701/which-characters-need-to-be-escaped-when-using-bash#20053121  
[2] https://www.shellscript.sh/escape.html  
[3] http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_03_03.html
[4] http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_07_01.html

