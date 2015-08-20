# git-auto-push
A script for auto pushing files generated from tools

### Tools needed ###
 * sudo apt-get install inotify-tools
 * ssh - without it you will need to enter your password every time
	 * [GitHub](https://help.github.com/articles/generating-ssh-keys/)
	 * [BitBucket](https://confluence.atlassian.com/bitbucket/getting-started-with-bitbucket/set-up-version-control/set-up-git/set-up-ssh-for-git)

### Usage ###
```bash
-w "/abs/path/to/file-to-watch" -s "/abs/path/to/repo" -d "/relative-path/in/repo" -m "Git commit message + date: `date +%D` `date +%R`" -t 3600
```
