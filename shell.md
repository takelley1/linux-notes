
## SHELL INITIALIZATION <sup>[1], [2]</sup> 

- **interactive login shell**
  - logging in remotely via, for example, ssh
  - drop to a tty on your local machine (Ctrl-Alt-F1) and login there
  - `~/.bash_profile` is sourced when starting this shell type
  - `~/.profile` is sourced if `~/.bash_profile` doesn't exist

- **interactive non-login shell**
  - opening a new terminal window
  - `~/.bashrc` is sourced when starting this shell type

- **non-interactive non-login shell**
  - runing a script.

- **non-interactive login shell**
  - this is extremely rare, and you're unlikey to encounter it

`~/.profile` is the place to put stuff that applies to your whole session, such as programs that you want to start when you log in, and environment variable definitions.  

`~/.bashrc` is the place to put stuff that applies only to bash itself, such as alias and function definitions, shell options, and prompt settings (you could also put key bindings there, but for bash they normally go into `~/.inputrc`.)  

`~/.bash_profile` can be used instead of `~/.profile`, but it is read by bash only, not by any other shell (this is mostly a concern if you want your initialization files to work on multiple machines and your login shell isn't bash on all of them.) This is a logical place to include `~/.bashrc` if the shell is interactive.  


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

---
### sourcing vs executing <sup>[5]</sup> 

`bash script.sh` or `source script.sh`?
- **Sourcing** a script runs in the current shell process, preserving all environment variables of the current shell
- **Executing** a script runs in a new shell, which will load only the default environment variables 

---
### escape characters

`'single quotes'`
- when in doubt, put the whole string in single quotes <sup>[1]</sup> 
  - **single quotes preserve the literal value of every character enclosed within the quotes** <sup>[3]</sup> 
  - a single quote *cannot* occur between single quotes, even when escaped by a backslash <sup>[3]</sup> 

`"double quotes"`
- double quotes preserve literal value of every character except the dollar sign, backtick, and backslash <sup>[3]</sup> 
- characters that need to be escaped: `"`, `$`, `\`, `[space]` <sup>[2]</sup> 

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
### if statement conditional tests <sup>[4]</sup> 

**see also:** [bash beginners guide](http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_07_01.html)

#### File-based conditions <sup>[8]</sup> 

| syntax          | meaning                                                                    |
|-----------------|----------------------------------------------------------------------------|
| -a or -e FILE   | FILE exists.                                                               |
| -d FILE         | FILE exists and is a directory.                                            |
| -f FILE         | FILE exists and is a regular file.                                         |
| -L FILE         | FILE exists and is a symbolic link.                                        |
| -k FILE         | FILE exists and its sticky bit is set.                                     |
| -r FILE         | FILE exists and is readable.                                               |
| -w FILE         | FILE exists and is writable.                                               |
| -x FILE         | FILE exists and is executable.                                             |
| -s FILE         | FILE exists and has a size greater than zero.                              |
| -O FILE         | FILE exists and is owned by the effective user ID.                         |
| -G FILE         | FILE exists and is owned by the effective group ID.                        |
| -N FILE         | FILE exists and has been modified since it was last read.                  |
| FILE1 -nt FILE2 | FILE1 was changed sooner than FILE2, or if FILE1 exists and FILE2 doesn't. |
| FILE1 -ot FILE2 | FILE1 is older than FILE2, or if FILE2 exists and FILE1 doesn't.           |
| -o OPTIONNAME   | Shell option "OPTIONNAME" is enabled.                                      |

#### String-based conditions <sup>[8]</sup> 

| syntax             | meaning                          |
|--------------------|----------------------------------|
| -z STRING          | STRING is empty.                 |
| -n STRING          | STRING is NOT empty.             |
| STRING1 == STRING2 | STRING1 is equal to STRING2.     | 
| STRING1 != STRING2 | STRING1 is NOT equal to STRING2. |

#### Number-based conditions <sup>[8]</sup> 

| syntax             | meaning                                |
|--------------------|----------------------------------------|
| NUM1 -eq NUM2      | NUM1 is equal to NUM2.                 |
| NUM1 -ne NUM2      | NUM1 is NOT equal to NUM2.             |
| NUM1 -gt NUM2      | NUM1 is greater than NUM2.             | 
| NUM1 -ge NUM2      | NUM1 is greater than or equal to NUM2. |
| NUM1 -lt NUM2      | NUM1 is less than NUM2.                | 
| NUM1 -le NUM2      | NUM1 is less than or equal to NUM2.    |


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
## CONSOLE / TTY

`dpkg-reconfigure console-setup`    = change console font size (debian-based distros)  
`/etc/default/console-setup`        = change console font size  

---
`who` or `w`  = view users currently logged in  
`write alice` = compose a message to the user alice (assuming she's logged in), use `CTRL-D` to send your message <sup>[9]</sup>   

[1]: https://stackoverflow.com/questions/15783701/which-characters-need-to-be-escaped-when-using-bash#20053121  
[2]: https://www.shellscript.sh/escape.html  
[3]: http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_03_03.html  
[4]: http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_07_01.html  
[5]: https://superuser.com/questions/176783/what-is-the-difference-between-executing-a-bash-script-vs-sourcing-it/176788#176788   
[6]: https://medium.com/@abhinavkorpal/bash-profile-vs-bashrc-c52534a787d3   
[7]: https://askubuntu.com/questions/879364/differentiate-interactive-login-and-non-interactive-non-login-shell  
[8]: https://linuxacademy.com/blog/linux/conditions-in-bash-scripting-if-statements/
[9]: https://www.tecmint.com/send-a-message-to-logged-users-in-linux-terminal/  
