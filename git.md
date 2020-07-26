
## GIT <sup>[1]</sup>

**See also:** [github fundamentals](https://git-scm.com/docs)

`git add -A` = Stage all modified files, including deleted files.<br>
`git add -A ./*` = Stage all modified files, including deleted files, beneath the current path.<br>
`git add -u` = Stage all modified files.<br>

---
### Tags

**See also:** [git basics - tagging](https://git-scm.com/book/en/v2/Git-Basics-Tagging)

*Tag specific commits to release your software.*<br>
`git tag v0.1`           = Tag the current commit as version 0.1.<br>
`git push origin --tags` = Push tags.<br>

---
### Setup

*Configuring user information used across all local repositories.*<br>
`git config --global user.name “<FIRSTNAME LASTNAME>”` = Set a name that is identifiable for credit when review version history.<br>
`git config --global user.email “<VALID-EMAIL>”`       = Set an email address that will be associated with each history marker.<br>
`git config --global color.ui auto`                    = Set automatic command line coloring for git for easy reviewing.<br>

---
### Init

*Configuring user information, initializing and cloning repositories.*<br>
`git init`        = Initialize an existing directory as a git repository.<br>
`git clone <URL>` = Retrieve an entire repository from a hosted location via url.<br>

---
### Staging

*Reverting changes.*<br>
`git checkout <COMMIT HASH> -- ./file1 ../file2` = Revert file1 and file2 to the specified commit.<br>
`git checkout -- <FILE>`                         = Undo changes made to an unstaged file.<br>

*Working with snapshots and the staging area.*<br>
`git status`                = Show modified files in working directory, staged for your next commit.<br>
`git add <FILE>`            = Add a file as it looks now to your next commit (stage).<br>
`git reset <FILE>`          = Unstage a file while retaining the changes in working directory.<br>

`git diff`                  = Diff of what is changed but not staged.<br>
`git diff --staged`         = Diff of what is staged but not yet commited.<br>
`git commit -m '<MESSAGE>'` = Commit your staged content as a new commit snapshot.<br>

---
### Branches

**See also:** [github branching best-practices](https://nvie.com/posts/a-successful-git-branching-model/)

*Isolating work in branches, changing context, and integrating changes.*<br>
`git branch`                 = List your branches, a `*` will appear next to the currently active branch.<br>
`git branch <BRANCH-NAME>`   = Create a new branch at the current commit.<br>
`git checkout <BRANCH-NAME>` = Switch to another branch and check it out into your working directory.<br>
`git merge <BRANCH-NAME>`    = Merge the specified branch into the current one.<br>

---
### History

*Examining logs, diffs and object information.*<br>
`git log`                    = Show the commit history for the active branch.<br>
`git log branchB..branchA`   = Show the commits on branchA that are not on branchB.<br>
`git log --follow <FILE>`    = Show the commits that changed file, even across renames.<br>

`git diff branchB...branchA` = Show the diff of what is in branchA that is not in branchB.<br>
`git show <COMMIT-HASH>`     = Show any object in git in human-readable format.<br>
`git checkout <COMMIT-HASH>` = Checkout the repository at the specified commit.<br>

---
### Tracking path changes

*Versioning file removes and path changes.*<br>
`git rm <FILE>`                    = Delete the file from project and stage the removal for commit.<br>
`git mv <CURRENT-PATH> <NEW-PATH>` = Change an existing file path and stage the move.<br>
`git log --stat -M`                = Show all commit logs with indication of any paths that moved.<br>

---
### Ignoring patterns

*Preventing unintentional staging or commiting of files.*<br>
.gitignore:
```
logs/
*.notes
pattern*/
```
*Save a file with desired paterns as .gitignore with either direct string matches or wildcard globs.*<br>
`git config --global core.excludesfile <FILE>` = System wide ignore patern for all local repositories.<br>

---
### Remotes

*Retrieving updates from another repository and updating local repos.*<br>
`git remote -v`                = Show remote repo info.<br>
`git remote add <ALIAS> <URL>` = Add a git url as an alias.<br>
`git fetch <ALIAS>`            = Fetch down all the branches from that git remote.<br>
`git merge <ALIAS>/<BRANCH>`   = Merge a remote branch into your current branch to bring it up to date.<br>

`git push <ALIAS> <BRANCH>`    = Transmit local branch commits to the remote repository branch.<br>
`git pull`                     = Fetch and merge any commits from the tracking remote branch.<br>

---
### Rewriting history

*Rewriting branches, updating commits and clearing history.*<br>
`git rebase <BRANCH>`       = Apply any commits of current branch ahead of specified one.<br>
`git reset --hard <COMMIT>` = Clear staging area, rewrite working tree from specified commit.<br>

---
### Stashing

*Temporarily store modified, tracked files in order to change branches.*<br>
`git stash`      = Save modified and staged changes.<br>
`git stash list` = List stack-order of stashed file changes.<br>
`git stash pop`  = Write working from top of stash stack.<br>
`git stash drop` = Discard the changes from top of stash stack.<br>

[1]: https://education.github.com/git-cheat-sheet-education.pdf
