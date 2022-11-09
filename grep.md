## [Grep](https://www.gnu.org/software/grep/manual/grep.html)

### Examples

- `grep -Eho '([0-9]{1,3}\.){1,3}[0-9]{1,3}' /var/log/maillog* | sort -u` = Extract IPs.
  - `-E` = Use regex.
  - `-h` = Don't print filenames (used only when grep is searching through multiple files).
  - `-o` = Print only the matching part of the line, instead of the whole line.
  - `sort -u` = Remove duplicates.
<br><br>
- `grep -nir 'ex*le' ./f*.txt` = Search for *ex\*le* (with globbing) in all *.txt* files starting with *f* in or beneath
  the current directory.
  - `-n` = Display line number of match.
  - `-i` = Ignore case.
<br><br>
- `grep -Pn "[^\x00-\x7F]" file.txt` = Show all non-ASCII characters in file.txt.
- `grep -l '^alice' /etc/*` = Show only the filenames containing matches (*-l*) instead of the matches themselves.
- `grep -wv '[a-d]' /*.txt` = Grep for words (*-w*) that DON'T contain the letters *a* through *d* (*-v*).
- `grep -C 5 '192\.168'` = Show five lines of context (*-C 5*) surrounding matched results.

### Options

- `-r` = Recurse through subdirectories.
- `-i` = Ignore case.
- `-v` = Show everything NOT in match (negation).
- `-n` = Show the line number of matches.
- `-l` = Show filenames of matches only.
- `-w` = Match complete words rather than just letters.
<br><br>
- `-C 5` (*context*) = Show 5 lines after and before match.
- `-A 2` (*after*)   = Show 2 lines after match.
- `-B 1` (*before*)  = Show 1 line before match.
