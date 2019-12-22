## CONSOLE

`dpkg-reconfigure console-setup` = change console font size (debian-based distros) \
[edit `/etc/default/console-setup`] = change console font size


## BASH

`while true; do [COMMAND] ; sleep 10; done` = loop command indefinitely

`[COMMAND] &` = run command in background \
`[COMMAND1] && [COMMAND2]` = run command2 only if command1 is successful \
`[COMMAND1] || [COMMAND2]` = run command2 only if command1 is NOT successful \
`[COMMAND1] ; [COMMAND2]` = run command2 immediately after command1, even if command1 is not successful (ex: `cd /home ; ls`)

`sudo !!` = execute last command with `sudo` privileges

`1>` or `>` = stdout \
`2>` = stderr \
`2>&1` or `&>` = stdout and stderr

`cat /file.log 2>&1 | grep -i error` = pass both stdout and stderr to grep through pipe, by default pipe only passes stdout \
`stat /home/file.txt` = show last modified date, creation date, and other metadata about given file

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

`CTRL-r` = search command history \
`CTRL-l` = clear screen

`CTRL-c` = send `SIGINT` to foreground process \
`CTRL-z` = suspend foreground process

`CTRL-d` = exit current shell

`ALT-f` = jump forward one word (when editing a command) \
`ALT-b` = jump backward one word (when editing a command)

---
## ENVIRONMENT VARIABLES

`echo $VARIABLE-NAME` = get value of VARIABLE-NAME \
`printenv` = get values of all environment variables \
`export HOME=/home/newhomedir` = set value of environment variable (note lack of `$`)
 
`DISPLAY` = name of X window display \
`EDITOR` = default text editor \
`HOME` = path of current user's home directory \
`LOGNAME` = current user's login name \
`MAIL` = path of current user's mailbox \
`OLDPWD` = the shell's previous working directory \
`PATH` = where the shell looks for command binaries, paths separated by a colon \
`PWD` = the shell's current working directory \
`SHELL` = path of the shell's binary \
`TERM` = type of terminal being used \
`USER` = current username

[1] https://stackoverflow.com/questions/15783701/which-characters-need-to-be-escaped-when-using-bash#20053121 \
[2] https://www.shellscript.sh/escape.html \
[3] http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_03_03.html