
## SHELL

- **See also**
  - [Google style guide](https://google.github.io/styleguide/shellguide.html)
  - [GNU coreutils decoded](https://www.maizure.org/projects/decoded-gnu-coreutils/index.html)
  - [How to do things safely in Bash](https://github.com/anordal/shellharden/blob/master/how_to_do_things_safely_in_bash.md)
  - [Bash pitfalls](https://mywiki.wooledge.org/BashPitfalls)

## [SHELL INITIALIZATION](https://medium.com/@abhinavkorpal/bash-profile-vs-bashrc-c52534a787d3)

- `~/.profile` = The place to put stuff that applies to your whole session, such as programs that you want to start when
   you log in, and environment variable definitions. */etc/profile* and scripts in */etc/profile.d/* apply to all user sessions.

- `~/.bashrc` = The place to put stuff that applies only to bash itself, such as alias and function definitions, shell
  options, and prompt settings (you could also put key bindings there, but for bash they normally go into *~/.inputrc*).

- `~/.bash_profile` = Can be used instead of *~/.profile*, but it is read by bash only, not by any other shell. This is mostly
  a concern if you want your initialization files to work on multiple machines and your login shell isn't bash on all of them.
  This is a logical place to include *~/.bashrc* if the shell is interactive.


---
## [SHELL TYPES](https://askubuntu.com/questions/879364/differentiate-interactive-login-and-non-interactive-non-login-shell)

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
  - [Bash guide](http://mywiki.wooledge.org/BashGuide)
  - [Bash GNU manual](https://www.gnu.org/software/bash/manual/)

### Have a script replace copies of itself
```bash
number_of_instances="$(pgrep -f "${0//*\//}" | wc -l)"
# For some reason this only works if we check if the number of processes is over
#   2 instead of over 1.
if [[ ${number_of_instances} -gt 2 ]]; then
# Kill all processes with the same name as the script, except the
#   highest-numbered PID, which is likely the current instance of the script.
    pgrep -f "${0//*\//}" | sort -n -r | tail -n +2 | xargs kill -s 9
fi
```

### Read user input

- See line ~3008 in `bash(1)` man page for more info on `read`.
```bash
myfunc() {
    read -r -p 'Are you a human? [y/n]: ' human_response
    if [[ "${human_response}" =~ [yY] ]]; then
        echo "Good"
    elif [[ "${human_response}" =~ [nN] ]]; then
        echo "You must be a robot then"
    else
        echo "Enter y or n"
        myfunc
    fi
}

# Alternate method
while :; do
    read -r -p 'Enter URL from which to download proxy certificate: ' proxy_cert_url
    if [[ "${proxy_cert_url}" =~ ^(http|ftp)s?:\/\/.+\. ]]; then
        proxy_dir="/usr/local/share/ca-certificates/proxy_${proxy_ip_and_port}"
        # User-added certs must be kept in their own directory.
        [[ ! -d "${proxy_dir}" ]] && sudo mkdir "${proxy_dir}"
        sudo wget -v "${proxy_cert_url}" --output-document="${proxy_dir}/proxy_${proxy_ip_and_port}_cert.crt"
        sudo update-ca-certificates
        break
    else
        echo 'Must use a format of ^(http|ftp)s?:\/\/.+\. (e.g. http://myserver.domain/certp.pem)'
    fi
done
```

### Case statement

```bash
myfunc() {
    read -r -p 'Are you a human [y/n]: ' response
    case "${response}" in
    [yY])
        echo "Okay, you're a human."
        return
        ;;

    [nN])
        echo "Okay, you must be a robot."
        return
        ;;

    *)
        echo "Enter 'y' or 'n'."
        myfunc
        ;;
    esac
}
```

### String manipulation

Remove prefix:
```bash
${parameter#word}  # Shortest matching pattern
${parameter##word} # Longest matching pattern

num="     19"
num="${num##* }" # num = "19"
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

path=/path/to/script.sh
replacement="${path//*\//}" # replacement = "script.sh"
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

- `cat /file.log 2>&1 | grep -i error` = Pass both stdout and stderr to grep through pipe,
                                         by default pipe only passes stdout.

### Misc

- `sudo !!` = Execute last command with sudo privileges.
- `history` = Print past commands to stdout, grep and use ![line_number] to repeat command without retyping.
- `watch <COMMAND>` = Loop command indefinitely.
- `"$(realpath "${0}")"` = Get full path of the current script.

### [Sourcing vs executing](https://superuser.com/questions/176783/what-is-the-difference-between-executing-a-bash-script-vs-sourcing-it/176788#176788)

- `bash script.sh` or `source script.sh`?
- **Sourcing** a script runs in the current shell process, preserving all environment variables of the current shell.
- **Executing** a script runs in a new shell, which will load only the default environment variables.

### Escape characters

- **See also:**
  - [Bash beginner's guide](http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_03_03.html)

`'single quotes'`

- [When in doubt, put the whole string in single quotes.](https://stackoverflow.com/questions/15783701/which-characters-need-to-be-escaped-when-using-bash#20053121)
  - **Single quotes preserve the literal value of every character enclosed within the quotes.**
  - A single quote *cannot* occur between single quotes, even when escaped by a backslash.

`"double quotes"`

- [Double quotes preserve literal value of every character except the dollar sign, backtick, and backslash.](https://www.shellscript.sh/escape.html)
- Characters that need to be escaped: `"`, `$`, `\`, ` `

### Hotkeys

- `CTRL-r` = Search command history. Hit `CTRL-r` multiple times to cycle through search results.
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

### [If-statement conditional tests](https://linuxacademy.com/blog/linux/conditions-in-bash-scripting-if-statements/)
- **See also:**
  - [Bash beginners guide](http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_07_01.html)

#### File-based conditions

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

#### String-based conditions

| Syntax             | Meaning                          |
|--------------------|----------------------------------|
| -z STRING          | STRING is empty.                 |
| -n STRING          | STRING is NOT empty.             |
| STRING1 == STRING2 | STRING1 is equal to STRING2.     |
| STRING1 != STRING2 | STRING1 is NOT equal to STRING2. |

#### Number-based conditions

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
