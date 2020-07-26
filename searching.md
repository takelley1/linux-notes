
## `find` COMMAND

### Examples

Print all files with non-ascii characters in the name: <sup>[1]</sup>
```bash
find . -print0 | \
perl -n0e 'chomp; print $_, "\n" if /[[:^ascii:][:cntrl:]]/'
```

Remove all files with non-ASCII characters in the name: <sup>[1]</sup>
```bash
find . -print0 | \
perl -MFile::Path=remove_tree -n0e \
'chomp; remove_tree($_, {verbose=>1}) if /[[:^ascii:][:cntrl:]]/'.<br>
```

Perform `ls –l` on found files:
```bash
find -name "file[0-9].txt" -ls               # Best method.
find -name "file[0-9].txt" -exec ls -l {} \; # Also fine.
find -name "file[0-9].txt" | xargs ls -l     # Not recommended.
```

`-exec <COMMAND> {} \;` = Run <COMMAND> on every returned result.<br>
                 `{}` = A "variable" that acts as a placeholder for the current result.<br>
                 `\;` = Required terminator for `exec` commands.<br>

`find ./ -type f | wc –l` = Print number of files beneath current path.<br>
                `-type f` = Search for files only, not directories.<br>
                  `wc –l` = Count the number of lines in the ouput.<br>

`find -03 -L . -type f -name "*.jpg"` =  <br>
                               `-03` = Optimize file search order based on likelihood of finding a match.<br>
                                `-L` = Follow symbolic links.<br>
                                 `.` = Search in or below the current directory.<br>
                           `-type f` = Look for regular files only.<br>
                             `-name` = Search based on file name.<br>
                           `"*.jpg"` = Use wildcard to search for all files with .jpg extension.<br>

`find ~ -user alice -mtime 7 -iname “.log” -delete` = Delete log files owned by alice within a certain date range.<br>
                                      `-user alice` = Files owned by user alice.<br>
                                                `~` = Search in or beneath the specified user's home directory.<br>
                                         `-mtime 7` = Look for files modified 7 days ago.<br>
                                            `-iname`= Match by file name (case insensitive).<br>
                                          `-delete` = Delete matched files.<br>

### Options

`-type f` = Match is of type `f` (`f`=file, `d`=dir, `l`=link, `p`=pipe, `b`=block, `c`=character).<br>
`-iname`  = Match by file name, ignoring case.<br>
`-regex`  = Match by file name using regex.<br>

`-uid 1000`    = Match is owned by UID 1000 (`-gid N` for file's group's GID).<br>
`-user alice`  = Match is owned by user alice.<br>
`-group wheel` = Match is owned by group wheel.<br>

`-mmin -19`       = Match was last modified less than 19 minutes ago.<br>
`-mmin +5`        = Match was last modified more than 5 minutes ago.<br>
`-mtime 3`        = Same as 'mmin' but in days, not minutes (match modified 3 days ago).<br>
`-newer file.txt` = Match is newer than file.txt.<br>

`-size +5G` = Match is more than 5 gigabytes (`c`=bytes, `w`=two-byte words, `k`=kilobytes), (`-`=less than, `+`=more than).<br>
`-perm 755` = Match has octal permissions 755.<br>

`-delete` = Delete matches.<br>
`-L`      = Follow symbolic links.<br>

---
## `locate` command

### Examples

`locate -ice *.txt` = Search for all .txt files on the system.<br>
    `-i` (*ignore*) = Ignore case of match.<br>
    `-c` (*count*)  = List number of matches.<br>
    `-e` (*exist*)  = Verify file’s existence before producing result since database may be old.<br>

> NOTE: locate is much faster than find, but locate searches a tabulated database instead of actively scrubbing your disk for a match.
        This means the data locate uses may be a few hours old

[1]: https://stackoverflow.com/questions/19146240/find-and-delete-files-with-non-ascii-names
