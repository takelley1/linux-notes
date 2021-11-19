
## REGEX

- **See also:**
  - `man 7 regex`
  - [Regex101](https://www.regex101.com/)
  - [Regex tester](https://www.regextester.com/)
  - [RexEgg](http://www.rexegg.com)

### Examples

- `^[^#]*foobar.*` = Match lines containing *foobar*, exclude commented lines
- Match most non-English characters:
  ```
  [^()[\]*+$?¿\/\-. \\~!@#$%^&*=_{}|;:․‥…·¨`‛''"‟’´‘’“”′‵″‶‴‷⁗„,<>—‒―¯–℃℉°№¹²³µ£¥¢©®℗™§¶ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789]
  ```
- Match all *duckduckgo* subdomains except *safe* and *help*:
  ```
  (?<!(safe|help))\.duckduckgo\.com
  ```

### Patterns

- `.`       = Any character.
- `[abc…]`  = Anything within brackets (*a*, *b*, or *c*).
- `[0-9]`   = Range within brackets (digits *0* through *9*, inclusive).
- `[^123…]` = Anything NOT within brackets.
- `\`       = Escape next character.
- `(   )`   = Pattern grouping (`([0-9]{1,3}\.){5}` = 5 instances of 1-3 of any digit, followed by a period.).
  - `(?:   )` = Non-capturing group. Use this when backreferences to a group aren't needed.
- `\1`      = Backreference to group #1.
<br><br>
- `(?!foo)`  = Negative lookahead, matches any subsequent string that is NOT *foo* (similar to `[^ ]`, except for a string rather than a range).
  - `grep -P '/documents/github-repos/(?!my-repos)'` = Matches all directories under *github-repos* EXCEPT *my-repos*.

### Quantifiers

- `^`     = Match pattern at start.
- `$`     = Match pattern at end.
- `a|b`   = Alternation of patterns (*a* or *b*).
- `*`     = Zero or more of pattern.
  - `*?`  = Zer or more of pattern (lazy).
- `+`     = One or more of pattern.
- `?`     = Zero or one of pattern.
- Bounds: basic regex uses `\{ \}`, extended regex uses `{ }`
  - `{1,5}` = One to five of pattern.
  - `{3,}`  = At least three of pattern.
  - `{,2}`  = At most three of pattern.
  - `{1}`   = Exactly one of pattern.

| Character classes | Similar to      | GNU synonym | *Only valid within brackets e.g [[:xyz:]]*        |
|-------------------|-----------------|-------------|---------------------------------------------------|
| `[:upper:]`       | `[A-Z]`         |             | Uppercase alphabetic characters                   |
| `[:lower:]`       | `[a-z]`         |             | Lowercase alphabetic characters                   |
| `[:digit:]`       | `[0-9]`         |             | Numeric characters                                |
| `[:alpha:]`       | `[A-Za-z]`      |             | Alphabetic characters                             |
| `[:alnum:]`       | `[A-Za-z0-9]`   | `\w`        | Alphanumeric characters                           |
| `[:blank:]`       | `[ \t]`         |             | Space and tab characters ONLY                     |
| `[:space:]`       | `[ \t\n\r\f\v]` | `\s`        | Whitespace characters (space, tab, formfeed, etc.)|
| `[:cntrl:]`       |                 |             | Control characters                                |
| `[:graph:]`       | `[^ [:cntrl:]]` |             | Graphical characters (non-control characters)     |
| `[:print:]`       | `[[:graph:] ]`  |             | Graphical characters and space                    |
| `[:punct:]`       |      |       | Punctuation characters (non-letter, digit, control char, or space) |

| GNU-style character classes |           |
|------|----------------------------------|
| `\s` | Whitespace characters            |
| `\S` | Non-whitespace characters        |
| `\w` | letters, digits, underscores     |
| `\W` | Non-letters, digits, underscores |
| `\f` | Form-feed                        |
| `\r` | Carriage return                  |
| `\n` | Newline                          |
| `\t` | Tab                              |


---
## GLOBBING

- `*`      = Zero or more of any character.
- `?`      = Exactly one of any character.
- `[xyz]`  = Any characters within set or within range.
- `[!xyz]` = Negation of xyz (any characters NOT in the set of *xyz*).
