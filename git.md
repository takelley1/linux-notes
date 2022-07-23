## [Git](https://git-scm.com/docs)

**See also:**
  - [The Git book](https://git-scm.com/book/en/v2)
  - [Git cheat sheet](https://education.github.com/git-cheat-sheet-education.pdf)

### Tips

- `git fetch --all && git reset --hard origin/master` = Force pull -- force local tree to match remote tree
<br><br>
- `git grep "mystring" $(git rev-list --all) | cut -d: -f2-4 | sort -u` = [Search entire repo history for string *mystring*.](https://stackoverflow.com/a/2929502)
  - `git grep "mystring" $(git rev-list --all -- lib/util) -- lib/util` = Search only under the *lib/util* path
<br><br>
- `git push origin --delete feature-123` = Delete the *feature-123* branch remotely.
- `git submodule update` = [Update submodules to remove from unstaged changes in parent repo](https://stackoverflow.com/a/6006919)
- `git commit --amend -m 'Commit message'` = [Amend most recent commit message](https://linuxize.com/post/change-git-commit-message/)
                                             (requires `git push --force` if commit already pushed).
<br><br>
- `git add -A` = Stage all modified files, including deleted files.
- `git add -A ./*` = Stage all modified files, including deleted files, beneath the current path.
- `git add -u` = Stage all modified files.

---
### [Submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules)

- `git submodule update --init --recursive` = Clone submodules in already-present repo.
- `git clone --recurse-submodules` = Include submodules in repo clone.
<br><br>
- `git submodule add ssh://git@server.example.com:7999/ansible-zabbix-agent.git roles/ansible-zabbix-agent` = Add submodue to repo.

Submodule configuration in *.gitmodules* to track the *develop* branch:
```gitconfig
[submodule "roles/ansible-zabbix-server"]
  path = roles/ansible-zabbix-server
  url = ssh://git@server.example.com:7999/ansible-zabbix-server.git
  branch = develop
```

---
### [Tags](https://git-scm.com/book/en/v2/Git-Basics-Tagging)

*Tag specific commits to release your software.*

- `git tag v0.1`           = Tag the current commit as version 0.1.
- `git push origin --tags` = Push tags.

---
### Setup

*Configuring user information used across all local repositories.*

- `git config --global user.name “<FIRSTNAME LASTNAME>”` = Set a name that is identifiable for credit when review
                                                           version history.
- `git config --global user.email “<VALID-EMAIL>”`       = Set an email address that will be associated with each
                                                           history marker.
- `git config --global color.ui auto`                    = Set automatic command line coloring for git for easy
                                                           reviewing.

---
### Init

- `git init`        = Initialize an existing directory as a git repository.
- `git clone <URL>` = Retrieve an entire repository from a hosted location via url.

---
### Staging

- `git checkout <COMMIT HASH> -- ./file1 ../file2` = Revert file1 and file2 to the specified commit.
- `git checkout -- <FILE>`                         = Undo changes made to an unstaged file.
<br><br>
- `git reset <FILE>`          = Unstage a file while retaining the changes in working directory.
<br><br>
- `git diff`                  = Diff of what is changed but not staged.
- `git diff --staged`         = Diff of what is staged but not yet commited.
- `git commit -m '<MESSAGE>'` = Commit your staged content as a new commit snapshot.

---
### Branches

- **See also:**
  - [GitHub branching best-practices](https://nvie.com/posts/a-successful-git-branching-model/)
<br><br>
- `git branch`                 = List your branches, a `*` will appear next to the currently active branch.
- `git branch <BRANCH-NAME>`   = Create a new branch at the current commit.
- `git merge <BRANCH-NAME>`    = Merge the specified branch into the current one.

---
### History

- `git log branchB..branchA`   = Show the commits on branchA that are not on branchB.
- `git log --follow <FILE>`    = Show the commits that changed file, even across renames.
<br><br>
- `git diff branchB...branchA` = Show the diff of what is in branchA that is not in branchB.
- `git show <COMMIT-HASH>`     = Show any object in git in human-readable format.
- `git checkout <COMMIT-HASH>` = Checkout the repository at the specified commit.

---
### Tracking path changes

*Versioning file removes and path changes.*

- `git rm <FILE>`                    = Delete the file from project and stage the removal for commit.
- `git mv <CURRENT-PATH> <NEW-PATH>` = Change an existing file path and stage the move.
- `git log --stat -M`                = Show all commit logs with indication of any paths that moved.

---
### Ignoring patterns

*Preventing unintentional staging or commiting of files.*

.gitignore:
```
logs/
*.notes
pattern*/
```
*Save a file with desired paterns as .gitignore with either direct string matches or wildcard globs.*

`git config --global core.excludesfile <FILE>` = System wide ignore patern for all local repositories.

---
### Remotes

- `git remote -v`                = Show remote repo info.
- `git remote add <ALIAS> <URL>` = Add a git url as an alias.
- `git fetch <ALIAS>`            = Fetch down all the branches from that git remote.
- `git merge <ALIAS>/<BRANCH>`   = Merge a remote branch into your current branch to bring it up to date.
<br><br>
- `git push <ALIAS> <BRANCH>`    = Transmit local branch commits to the remote repository branch.

---
### Rewriting history

- `git rebase <BRANCH>`       = Apply any commits of current branch ahead of specified one.
- `git reset --hard <COMMIT>` = Clear staging area, rewrite working tree from specified commit.

---
### Stashing

*Temporarily store modified, tracked files in order to change branches.*

- `git stash`      = Save modified and staged changes.
- `git stash list` = List stack-order of stashed file changes.
- `git stash pop`  = Write working from top of stash stack.
- `git stash drop` = Discard the changes from top of stash stack.
