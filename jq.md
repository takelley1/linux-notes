
## [JQ](https://stedolan.github.io/jq/manual/)

- **See also**:
  - [jq cheat sheet](https://lzone.de/cheat-sheet/jq)

### Examples

- `i3-msg -t get_workspaces | jq '.[] | select(.focused == true) | .id'` = Print the *id* field if the *focused* field
                                                                           equals *true*.
- `i3-msg -t get_outputs | jq '.[] | .name,.active'` = Print both the *name* and *active* fields.
- `i3-msg -t get_outputs | jq '.[] | {name,active}'` = Print both the *name* and *active* fields as dictionaries.
