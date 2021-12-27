
## [JQ](https://stedolan.github.io/jq/manual/)

- **See also**:
  - [jq cheat sheet](https://lzone.de/cheat-sheet/jq)

### Examples

- `jq -r '.[][][] | select(.field[2] == 4 and .field[1] == 43) | .field[4]'` = If *field[2]* equals *4* and *field[1]* equals
                                                                               *43*, then print *field[4]*. Don't include
                                                                               formatting quotes (`-r`).
- `i3-msg -t get_workspaces | jq '.[] | select(.focused == true) | .id'` = Print the *id* field if the *focused* field
                                                                           equals *true*.
- `i3-msg -t get_outputs | jq '.[] | .name,.active'` = Print both the *name* and *active* fields.
- `i3-msg -t get_outputs | jq '.[] | {name,active}'` = Print both the *name* and *active* fields as dictionaries.
