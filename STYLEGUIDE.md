## SECTION HEADERS AT THE BEGINNING OF FILES LOOK LIKE THIS


---
## SECTION HEADERS ARE IN ALL CAPS AND HAVE TWO BLANK SPACES BETWEEN THEM AND THE END OF THE PREVIOUS SECTION


---
## `commands in section headers are within backticks` SECTION HEADER

### Subsection headers are in sentence case and have one blank space between them and the end of the previous section

`command --param 1 --param 2` (*mneumonic*) = Command descriptions are full sentences. <sup>[References look like this]</sup>
                                `--param 1` = Parameter descriptions are aligned with the end of the command.
                                `--param 2` = Parameter 2 description (*long mneumonic*). <sup>[1]</sup>

`command <VARIABLES_IN_COMMANDS_LOOK_LIKE_THIS>`

`command [VARIABLE1] [VARIABLE2]` = Commands that require explanatory variables store the variable names in
                                    square brackets, all-caps.

> NOTE: Note subsections wrap at 120 characters and are full sentences. This is a very long line and is an example of
        note wrapping.

Explanation header:
```
Long explanation text within code blocks are also usually wrapped at 120 characters. This is a very long line and is
wrapped at 120 characters.
```

---
### Subsection header with dividing lines have two blank lines before them <sup>[2]</sup>

| Table header   | Another table header    | Table headers are in sentence case               |
|----------------|-------------------------|--------------------------------------------------|
| Gigabyte (GB)  | 10<sup>9</sup> bytes    | <= One space between column borders and text =>  |
|                                          | Table fields are in sentence case                |

![image name](/image/path.webp) [Image references don't use superscripts]
![another image name](/image/path2.webp) <sup>[2]</sup>

#### Minor subsection headers are also in sentence case and have one blank line above them

```bash
Very long commands like this are wrapped at 120 characters within code blocks.   \ # Comments describing command lines within blocks go here and usually ignore the 120 line limit.
  --Parameters can go on separate lines like this to make things easier to read. \ # All comments are one space away from the last character of the command and aligned like this.
  --Parameters are indented by two spaces compared to the command.               \ # Here's another comment line.
```

**See also:** [link name](https://www.link-address.example.com)

1. step 1
   ```bash
   example command
   ```
1. step 2
   ```yaml
   yaml_example_line1:
   yaml_example_line2:
   ```
   1. step 2a
   ```bash
   vim /path/to/text/file
   ```
   ```
   text file content line 1
   text file content line 2
   ```
   1. step 2b
1. step 3

[1]: https://www.source-1.com
[2]: https://www.source-2.com
[3]: https://www.source-3.com
