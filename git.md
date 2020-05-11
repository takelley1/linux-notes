
## GIT <sup>[1]</sup>

**see also:** [github fundamentals](https://git-scm.com/docs)

`git add -A` = Stage all modified files, including deleted files.    
`git add -A ./*` = Stage all modified files, including deleted files, beneath the current path.    
`git add -u` = Stage all modified files.    

---
### tags

**further reading:** [git basics - tagging](https://git-scm.com/book/en/v2/Git-Basics-Tagging)

*tag specific commits to release your software*  
`git tag v0.1`           = Tag the current commit as version 0.1.  
`git push origin --tags` = Push tags.    

---
### setup

*configuring user information used across all local repositories*   
`git config --global user.name “[firstname lastname]”` = Set a name that is identifiable for credit when review version history.    
`git config --global user.email “[valid-email]”`       = Set an email address that will be associated with each history marker.    
`git config --global color.ui auto`                    = Set automatic command line coloring for git for easy reviewing.  

---
### init

*configuring user information, initializing and cloning repositories*  
`git init`        = Initialize an existing directory as a git repository.    
`git clone [url]` = Retrieve an entire repository from a hosted location via url.  

---
### staging

*reverting changes*  
`git checkout [commit hash] -- ./file1 ../file2` = Revert file1 and file2 to the specified commit.    
`git checkout -- [file]`                         = Undo changes made to an unstaged file.  

*working with snapshots and the staging area*  
`git status`                = Show modified files in working directory, staged for your next commit.    
`git add [file]`            = Add a file as it looks now to your next commit (stage).  
`git reset [file]`          = Unstage a file while retaining the changes in working directory.    

`git diff`                  = Diff of what is changed but not staged.    
`git diff --staged`         = Diff of what is staged but not yet commited.    
`git commit -m '[message]'` = Commit your staged content as a new commit snapshot.  

---
### branches

**further reading:** [github branching best-practices](https://nvie.com/posts/a-successful-git-branching-model/)

*isolating work in branches, changing context, and integrating changes*  
`git branch`                 = List your branches, a `*` will appear next to the currently active branch.    
`git branch [branch-name]`   = Create a new branch at the current commit.    
`git checkout [branch-name]` = Switch to another branch and check it out into your working directory.    
`git merge [branch-name]`    = Merge the specified branch into the current one.    

---
### history

*examining logs, diffs and object information*  
`git log`                    = Show the commit history for the active branch.    
`git log branchB..branchA`   = Show the commits on branchA that are not on branchB.  
`git log --follow [file]`    = Show the commits that changed file, even across renames.    

`git diff branchB...branchA` = Show the diff of what is in branchA that is not in branchB.  
`git show [commit-hash]`     = Show any object in git in human-readable format.    
`git checkout [commit-hash]` = Checkout the repository at the specified commit.  

---
### tracking path changes

*versioning file removes and path changes*  
`git rm [file]`                    = Delete the file from project and stage the removal for commit.    
`git mv [current-path] [new-path]` = Change an existing file path and stage the move.    
`git log --stat -M`                = Show all commit logs with indication of any paths that moved.  

---
### ignoring patterns

*preventing unintentional staging or commiting of files*  
.gitignore:
```
logs/
*.notes
pattern*/
```
*save a file with desired paterns as .gitignore with either direct string matches or wildcard globs*  
`git config --global core.excludesfile [file]` = System wide ignore patern for all local repositories.  

---
### remotes

*retrieving updates from another repository and updating local repos*  
`git remote -v`                = Show remote repo info.    
`git remote add [alias] [url]` = Add a git url as an alias.    
`git fetch [alias]`            = Fetch down all the branches from that git remote.    
`git merge [alias]/[branch]`   = Merge a remote branch into your current branch to bring it up to date.    

`git push [alias] [branch]`    = Transmit local branch commits to the remote repository branch.    
`git pull`                     = Fetch and merge any commits from the tracking remote branch.  

---
### rewriting history

*rewriting branches, updating commits and clearing history*  
`git rebase [branch]`       = Apply any commits of current branch ahead of specified one.    
`git reset --hard [commit]` = Clear staging area, rewrite working tree from specified commit.  

---
### stashing

*temporarily store modified, tracked files in order to change branches*  
`git stash`      = Save modified and staged changes.    
`git stash list` = List stack-order of stashed file changes.    
`git stash pop`  = Write working from top of stash stack.    
`git stash drop` = Discard the changes from top of stash stack.  

[1]: https://education.github.com/git-cheat-sheet-education.pdf

