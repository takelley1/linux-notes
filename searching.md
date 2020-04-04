
## `find` COMMAND

### examples

print all files with non-ascii characters in the name <sup>[1]</sup> 
```bash
find . -print0 | \
perl -n0e 'chomp; print $_, "\n" if /[[:^ascii:][:cntrl:]]/'
```

remove all files with non-ascii characters in the name <sup>[1]</sup> 
```bash
find . -print0 | \
perl -MFile::Path=remove_tree -n0e 'chomp; remove_tree($_, {verbose=>1}) if /[[:^ascii:][:cntrl:]]/'
```

perform `ls –l` command on found files  
`find -name "file[0-9].txt" -exec ls -l {} \;` or  
`find -name "file[0-9].txt" | xargs ls -l` or  
`find -name "file[0-9].txt" -ls`  

`-exec [COMMAND] {} \;` = perform [COMMAND] on every returned result  
                   `{}` = the current result  
                   `\;` = terminator  

`find ./ -type f | wc –l` = print number of files beneath current path  
                `-type f` = search for files only, not directories  
                  `wc –l` = count the number of lines in the ouput  

`find -03 -L . -type f -name "*.jpg"` =  
                                `-03` = optimize file search order based on likelihood of finding a match  
                                 `-L` = follow symbolic links  
                                  `.` = search in or below the current directory  
                            `-type f` = look for regular files only  
                              `-name` = search based on file name  
                            `"*.jpg"` = use wildcard to search for all files with .jpg extension  

`find ~ -user alice -mtime 7 -iname “.log” -delete` = delete log files owned by alice within a certain date range
                                      `-user alice` = files owned by user alice  
                                                `~` = search in or beneath the specified user's home directory  
                                         `-mtime 7` = look for files modified 7 days ago  
                                            `-iname`= match by file name (case insensitive)  
                                          `-delete` = delete matched files  

### options 

`-type f` = match is of type `f` (`f`=file, `d`=dir, `l`=link, `p`=pipe, `b`=block, `c`=character)  
`-iname`  = match by file name, ignoring case  
`-regex`  = match by file name using regex

`-uid 1000`    = match is owned by UID 1000 (`-gid N` for file's group's GID)  
`-user alice`  = match is owned by user alice  
`-group wheel` = match is owned by group wheel 

`-mmin -19`       = match was last modified less than 19 minutes ago  
`-mmin +5`        = match was last modified more than 5 minutes ago  
`-mtime 3`        = same as 'mmin' but in days, not minutes (match modified 3 days ago)  
`-newer file.txt` = match is newer than file.txt

`-size +5G` = match is more than 5 gigabytes (`c`=bytes, `w`=two-byte words, `k`=kilobytes), (`-`=less than, `+`=more than)  
`-perm 755` = match has octal permissions 755

`-delete` = delete matches  
`-L`      = follow symbolic links

---
## `locate` COMMAND

### examples

`locate -ice *.txt` = search for all .txt files on the system  
    `-i` (*ignore*) = ignore case of match  
    `-c` (*count*)  = list number of matches  
    `-e` (*exist*)  = verify file’s existence before producing result since database may be old  

> NOTE: locate is much faster than find, but locate searches a tabulated database instead of actively scrubbing your disk for a match.
        This means the data locate uses may be a few hours old  

[1]: https://stackoverflow.com/questions/19146240/find-and-delete-files-with-non-ascii-names

