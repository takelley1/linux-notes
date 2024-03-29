## [Awk/Gawk/Mawk](https://www.gnu.org/software/gawk/manual/gawk.html)

- **See also**:
  - [AWK one-liners explained](https://catonmat.net/awk-one-liners-explained-part-one)
  - [AWK cheat sheet](https://catonmat.net/ftp/awk.cheat.sheet.pdf)

### Examples

Parse the output of `git status` for use in bash $PS1 prompt.
```bash
git status --short -b 2>/dev/null |
awk -F'[][]' \
    '{
    # Operate on 1st line only.
    if(NR==1)
        {
        # Replace ahead/behind with arrows.
        sub(/ahead/,"▲")
        sub(/behind/,"▼")

        # Remove comma and spaces.
        gsub(/(\s|,)/,"")

        # Store 2nd field in a variable.
        ahead_behind_count=$2
        }
    # If theres more than 1 line, then the repo has unstaged changes.
    if(NR>1)
        changed="(+)"
    }
    # Use END so we only print once and not once for each record.
    # Use printf instead of print so fields are not separated by spaces.
    END {printf "%s%s",ahead_behind_count,changed}
    '
```

Comment out all lines in which the first non-whitespace string is "alias".
```bash
awk
  '{
    if ($0 ~ /^[[:space:]]*alias/)
      print "#",$0
    else
      print $0
  }' \
  file.sh
```

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

- `git status 2>/dev/null | awk '{if(NR==2) {gsub(/[^0-9]/,""); print $0}}'` = Print the number of commits to push/pull from the current repo.
- `yum history | awk -F"|" '($2~"<ansible>" && $4~"U"){print $0}'` = Print lines that contain *\<ansible\>* in column 2 and *U* in column 4
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

### Operators

- `~` = Regex matching operator (`awk '$1 ~ /J/'` = Print field *1* if it contains a *J*.).
- `!~` = Negation regex matching operator. (`awk '$1 !~ /J/'` = Print field *1* if it doesn't contain a *J*.).
