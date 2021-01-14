
## SHELL

- **See also**
  - [Google style guide](https://google.github.io/styleguide/shellguide.html)
  - [GNU coreutils decoded](https://www.maizure.org/projects/decoded-gnu-coreutils/index.html)

## SHELL INITIALIZATION <sup>[6]</sup>

- `~/.profile` = The place to put stuff that applies to your whole session, such as programs that you want to start when
   you log in, and environment variable definitions. */etc/profile* and scripts in */etc/profile.d/* apply to all user sessions.

- `~/.bashrc` = The place to put stuff that applies only to bash itself, such as alias and function definitions, shell
  options, and prompt settings (you could also put key bindings there, but for bash they normally go into *~/.inputrc*).

- `~/.bash_profile` = Can be used instead of *~/.profile*, but it is read by bash only, not by any other shell. This is mostly
  a concern if you want your initialization files to work on multiple machines and your login shell isn't bash on all of them.
  This is a logical place to include *~/.bashrc* if the shell is interactive.


---
## SHELL TYPES <sup>[7]</sup>

- Interactive login shell
  - Logging in remotely via, for example, ssh.
  - Dropping to a tty on your local machine (Ctrl-Alt-F1) and login there.
  - `~/.bash_profile` is sourced when starting this shell type.
  - `~/.profile` is sourced if `~/.bash_profile` doesn't exist.
<br><br>
- Interactive non-login shell
  - Opening a new terminal window.
  - `~/.bashrc` is sourced when starting this shell type.
<br><br>
- Non-interactive non-login shell
  - Running a script.
<br><br>
- Non-interactive login shell
  - This is extremely rare, and you're unlikey to encounter it.


---
## BASH

### String manipulation

Remove prefix:
```bash
${parameter#word}  # Shortest matching pattern
${parameter##word} # Longest matching pattern
```

Remove suffix:
```bash
${parameter%word}  # Shortest matching pattern
${parameter%%word} # Longest matching pattern

file="archive.tar.gz"
name="${file%.*}"  # name = "archive.tar"
name="${file%%.*}" # name = "archive"
```

Extract substring:
```bash
${parameter:offset}
${parameter:offset:length}

file="2020-08-15_00:17:02_screenshot.png"
year="${file:0:4}"  # year = 2020
month="${file:5:2}" # month = 08
day="${file:8:2}"   # day = 15
```

Pattern substitution:
```bash
${parameter/pattern/string}

name="Bob Johnson"
replacement="${name/Johnson/Peterson}" # replacement = "Bob Peterson"
```

### printf

- `printf "%03d\n" 5` = `005` = Print with leading zeros.
  - `%` = Marks the start of the formatting string.
  - `0` = Pad with zeros.
  - `3` = Make output 3-places long.
  - `d` = Convert input to a signed decimal.

- `printf "%04.1f\n" 2.5` = `02.5` = Print decimal with leading zeros.

### stdout/stderr

```
1> or >    = Stdout.
2>         = Stderr.
2>&1 or &> = Stdout and stderr.
```

- `cat /file.log 2>&1 | grep -i error` = Pass both stdout and stderr to grep through pipe, by default pipe only passes stdout.

### Misc

- `sudo !!` = Execute last command with sudo privileges.
- `history` = Print past commands to stdout, grep and use ![line_number] to repeat command without retyping.
- `watch <COMMAND>` = Loop command indefinitely.

### Sourcing vs executing <sup>[5]</sup>

- `bash script.sh` or `source script.sh`?
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

- `CTRL-r` = Search command history.
<br><br>
- `CTRL-l` = Clear screen.
<br><br>
- `CTRL-c` = Send `SIGINT` to foreground process.
- `CTRL-SHIFT-j` or `CTRL-j` = Get shell prompt back.
- `CTRL-z` = Suspend foreground process.
- `CTRL-d` = Exit current shell.
<br><br>
- `ALT-k` (in vi mode) = Recall previous command.
- `ALT-j` (in vi mode) = Recall next command.
- `ALT-f` = Jump forward one word  (when editing a command).
- `ALT-b` = Jump backward one word (when editing a command).

### If-statement conditional tests <sup>[4]</sup>

- **See also:**
  - [Bash beginners guide](http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_07_01.html)

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

| Syntax             | Meaning                          |
|--------------------|----------------------------------|
| -z STRING          | STRING is empty.                 |
| -n STRING          | STRING is NOT empty.             |
| STRING1 == STRING2 | STRING1 is equal to STRING2.     |
| STRING1 != STRING2 | STRING1 is NOT equal to STRING2. |

#### Number-based conditions <sup>[8]</sup>

| Syntax             | Meaning                                |
|--------------------|----------------------------------------|
| NUM1 -eq NUM2      | NUM1 is equal to NUM2.                 |
| NUM1 -ne NUM2      | NUM1 is NOT equal to NUM2.             |
| NUM1 -gt NUM2      | NUM1 is greater than NUM2.             |
| NUM1 -ge NUM2      | NUM1 is greater than or equal to NUM2. |
| NUM1 -lt NUM2      | NUM1 is less than NUM2.                |
| NUM1 -le NUM2      | NUM1 is less than or equal to NUM2.    |


---
## ENVIRONMENT VARIABLES

- `printenv`                     = Get values of all environment variables.
- `export HOME=/home/newhomedir` = Set value of environment variable.
<br><br>
- `DISPLAY` = Name of X window display.
- `EDITOR`  = Default text editor.
- `HOME`    = Path of current user's home directory.
- `LOGNAME` = Current user's login name.
- `MAIL`    = Path of current user's mailbox.
- `OLDPWD`  = The shell's previous working directory.
- `PATH`    = Where the shell looks for command binaries, paths separated by a colon.
- `PWD`     = The shell's current working directory.
- `SHELL`   = Path of the shell's binary.
- `TERM`    = Type of terminal being used.
- `USER`    = Current username.


---
## CONSOLE / TTY

- `dpkg-reconfigure console-setup`    = Change console font size (Debian-based distros).
- `/etc/default/console-setup`        = Change console font size.


[1]: https://stackoverflow.com/questions/15783701/which-characters-need-to-be-escaped-when-using-bash#20053121
[2]: https://www.shellscript.sh/escape.html
[3]: http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_03_03.html
[4]: http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_07_01.html
[5]: https://superuser.com/questions/176783/what-is-the-difference-between-executing-a-bash-script-vs-sourcing-it/176788#176788
[6]: https://medium.com/@abhinavkorpal/bash-profile-vs-bashrc-c52534a787d3
[7]: https://askubuntu.com/questions/879364/differentiate-interactive-login-and-non-interactive-non-login-shell
[8]: https://linuxacademy.com/blog/linux/conditions-in-bash-scripting-if-statements/
