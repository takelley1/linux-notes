
## SHELL INITIALIZATION <sup>[6]</sup>

`~/.profile` is the place to put stuff that applies to your whole session, such as programs that you want to start when you log in, and environment variable definitions. `/etc/profile` and scripts in `/etc/profile.d/` apply to all user sessions.<br>

`~/.bashrc` is the place to put stuff that applies only to bash itself, such as alias and function definitions, shell options, and prompt settings (you could also put key bindings there, but for bash they normally go into `~/.inputrc`).<br>

`~/.bash_profile` can be used instead of `~/.profile`, but it is read by bash only, not by any other shell (this is mostly a concern if you want your initialization files to work on multiple machines and your login shell isn't bash on all of them.) This is a logical place to include `~/.bashrc` if the shell is interactive.<br>


---
## SHELL TYPES <sup>[7]</sup>

- #### Interactive login shell
  - Logging in remotely via, for example, ssh.
  - Dropping to a tty on your local machine (Ctrl-Alt-F1) and login there.
  - `~/.bash_profile` is sourced when starting this shell type.
  - `~/.profile` is sourced if `~/.bash_profile` doesn't exist.

- #### Interactive non-login shell
  - Opening a new terminal window.
  - `~/.bashrc` is sourced when starting this shell type.

- #### Non-interactive non-login shell
  - Running a script.

- #### Non-interactive login shell
  - This is extremely rare, and you're unlikey to encounter it.

---
## BASH

`while true; do <COMMAND>; sleep 1s; done` = Loop command indefinitely.<br>

`sudo !!` = Execute last command with sudo privileges.<br>

`1>` or `>`    = Stdout.<br>
`2>`           = Stderr.<br>
`2>&1` or `&>` = Stdout and stderr.<br>

`cat /file.log 2>&1 | grep -i error` = Pass both stdout and stderr to grep through pipe, by default pipe only passes stdout.<br>
`stat /home/file.txt`                = Show last modified date, creation date, and other metadata about given file.<br>
`history` = Print past commands to stdout, grep and use ![line_number] to repeat command without retyping.<br>

### Sourcing vs executing <sup>[5]</sup>

`bash script.sh` or `source script.sh`?
- **Sourcing** a script runs in the current shell process, preserving all environment variables of the current shell.
- **Executing** a script runs in a new shell, which will load only the default environment variables.

### Escape characters

`'single quotes'`

- When in doubt, put the whole string in single quotes <sup>[1]</sup>
  - **Single quotes preserve the literal value of every character enclosed within the quotes.** <sup>[3]</sup>
  - A single quote *cannot* occur between single quotes, even when escaped by a backslash. <sup>[3]</sup>

`"double quotes"`

- Double quotes preserve literal value of every character except the dollar sign, backtick, and backslash. <sup>[3]</sup>
- Characters that need to be escaped: `"`, `$`, `\`, ` ` <sup>[2]</sup>

### Hotkeys

`CTRL-r` = Search command history.<br>

`CTRL-l` = Clear screen.<br>

`CTRL-c` = Send `SIGINT` to foreground process.<br>
`CTRL-SHIFT-j` or `CTRL-j` = Get shell prompt back.<br>
`CTRL-z` = Suspend foreground process.<br>
`CTRL-d` = Exit current shell.<br>

`ALT-k` (in vi mode) = Recall previous command.<br>
`ALT-j` (in vi mode) = Recall next command.<br>
`ALT-f` = Jump forward one word  (when editing a command).<br>
`ALT-b` = Jump backward one word (when editing a command).<br>

### If-statement conditional tests <sup>[4]</sup>

**See also:** [bash beginners guide](http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_07_01.html)

#### File-based conditions <sup>[8]</sup>

| Syntax          | Meaning                                                       |
|-----------------|---------------------------------------------------------------|
| -a or -e FILE   | FILE exists.                                                  |
| -d FILE         | FILE exists and is a directory.                               |
| -f FILE         | FILE exists and is a regular file.                            |
| -L FILE         | FILE exists and is a symbolic link.                           |
| -k FILE         | FILE exists and its sticky bit is set.                        |
| -r FILE         | FILE exists and is readable.                                  |
| -w FILE         | FILE exists and is writable.                                  |
| -x FILE         | FILE exists and is executable.                                |
| -s FILE         | FILE exists and has a size greater than zero.                 |
| -O FILE         | FILE exists and is owned by the effective user ID.            |
| -G FILE         | FILE exists and is owned by the effective group ID.           |
| -N FILE         | FILE exists and has been modified since it was last read.     |
| FILE1 -nt FILE2 | FILE1 is newer than FILE2, or FILE1 exists and FILE2 doesn't. |
| FILE1 -ot FILE2 | FILE1 is older than FILE2, or FILE2 exists and FILE1 doesn't. |
| -o OPTIONNAME   | Shell option "OPTIONNAME" is enabled.                         |

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

`printenv`                     = Get values of all environment variables.<br>
`export HOME=/home/newhomedir` = Set value of environment variable.<br>

`DISPLAY` = Name of X window display.<br>
`EDITOR`  = Default text editor.<br>
`HOME`    = Path of current user's home directory.<br>
`LOGNAME` = Current user's login name.<br>
`MAIL`    = Path of current user's mailbox.<br>
`OLDPWD`  = The shell's previous working directory.<br>
`PATH`    = Where the shell looks for command binaries, paths separated by a colon.<br>
`PWD`     = The shell's current working directory.<br>
`SHELL`   = Path of the shell's binary.<br>
`TERM`    = Type of terminal being used.<br>
`USER`    = Current username.<br>


---
## CONSOLE / TTY

`dpkg-reconfigure console-setup`    = Change console font size (Debian-based distros).<br>
`/etc/default/console-setup`        = Change console font size.<br>


[1]: https://stackoverflow.com/questions/15783701/which-characters-need-to-be-escaped-when-using-bash#20053121
[2]: https://www.shellscript.sh/escape.html
[3]: http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_03_03.html
[4]: http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_07_01.html
[5]: https://superuser.com/questions/176783/what-is-the-difference-between-executing-a-bash-script-vs-sourcing-it/176788#176788
[6]: https://medium.com/@abhinavkorpal/bash-profile-vs-bashrc-c52534a787d3
[7]: https://askubuntu.com/questions/879364/differentiate-interactive-login-and-non-interactive-non-login-shell
[8]: https://linuxacademy.com/blog/linux/conditions-in-bash-scripting-if-statements/
