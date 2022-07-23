## SECTION HEADERS AT THE BEGINNING OF FILES LOOK LIKE THIS


---
## SECTION HEADERS ARE IN ALL CAPS AND HAVE TWO BLANK SPACES BETWEEN THEM AND THE END OF THE PREVIOUS SECTION

- **See also:**
  - [See also links are in sentence case](https://www.link-address.example.com)


---
## `commands in section headers are within backticks` SECTION HEADER

### Subsection headers are in sentence case and have one blank space between them and the end of the previous section

- `command --param 1 --param 2` (*mneumonic*) = Command descriptions are full sentences. <sup>[References look like this]</sup>
  - `--param 1` = Parameter descriptions are children of the primary command's bullet point.
  - `--param 2` = Parameter 2 description (*longer mneumonics can be within command descriptions*). <sup>[1]</sup>
<br><br>
- `command` = Similar commands are grouped together, with a `<br><br>` between groups to create whitespace.
- `command <VARIABLES_IN_COMMANDS_LOOK_LIKE_THIS>` = Command descriptions that have commands, paths, or other code in them
                                                     *put the text in italics, like this*. Long Command descriptions wrap
                                                     at around 120 characters. Wrapped lines are indented to be aligned
                                                     with the previous lines.

> NOTE: Note subsections wrap at 120 characters and are full sentences. This is a very long line and is an example of
        note wrapping.

Explanation:
```
Long explanation text within code blocks are also usually wrapped at 120 characters.
```

Command description:
```bash
Very long commands like this are wrapped at 120 characters within code blocks.   \ # Comments describing command lines within blocks go here and usually ignore the 120 line limit.
  --Parameters can go on separate lines like this to make things easier to read. \ # All comments are one space away from the last character of the command and aligned like this.
  --Parameters are indented by two spaces compared to the command.               \ # Here's another comment line.
```
```
Code blocks containing commands are usually only used for commands that frequently occur in sequence or produce
relevant output.
```

---
### Subsection headers with dividing lines have one blank line before them <sup>[2]</sup>

| Table header   | Another table header    | Table headers are in sentence case              |
|----------------|-------------------------|-------------------------------------------------|
| Gigabyte (GB)  | 10<sup>9</sup> bytes    | <= One space between column borders and text => |
|                |                         | Table fields are in sentence case               |

![image name](/image/path.webp)
![another image name](/image/path2.webp) <sup>[2]</sup>

#### Minor subsection headers are also in sentence case and have one blank line above them

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
