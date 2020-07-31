#Macbook ~/.bashrc
# --- Custom prompt: username@hostname in currentDir \n $

prompt_git() {
	local s='';
	local branchName='';

	# Check if the current directory is in a Git repository.
	if [ $(git rev-parse --is-inside-work-tree &>/dev/null; echo "${?}") == '0' ]; then

		# check if the current directory is in .git before running git checks
		if [ "$(git rev-parse --is-inside-git-dir 2> /dev/null)" == 'false' ]; then

			# Ensure the index is up to date.
			git update-index --really-refresh -q &>/dev/null;

			# Check for uncommitted changes in the index.
			if ! $(git diff --quiet --ignore-submodules --cached); then
				s+='+';
			fi;

			# Check for unstaged changes.
			if ! $(git diff-files --quiet --ignore-submodules --); then
				s+='!';
			fi;

			# Check for untracked files.
			if [ -n "$(git ls-files --others --exclude-standard)" ]; then
				s+='?';
			fi;

			# Check for stashed files.
			if $(git rev-parse --verify refs/stash &>/dev/null); then
				s+='$';
			fi;

		fi;

		# Get the short symbolic ref.
		# If HEAD isn’t a symbolic ref, get the short SHA for the latest commit
		# Otherwise, just give up.
		branchName="$(git symbolic-ref --quiet --short HEAD 2> /dev/null || \
			git rev-parse --short HEAD 2> /dev/null || \
			echo '(unknown)')";

		[ -n "${s}" ] && s=" [${s}]";

		echo -e "${1}${branchName}${2}${s}";
	else
		return;
	fi;
}

#Prompt variables
orange=$(tput setaf 166);
blue=$(tput setaf 033);
yellow=$(tput setaf 228);
violet=$(tput setaf 61);
white=$(tput setaf 15);
bold=$(tput bold);
reset=$(tput sgr0);

#Username = \u, Hostname = \h, Working directory = \W, Path = \w 
PS1="\[${bold}\]\[${orange}\]\u";
PS1+="\[${white}\]@\[${blue}\]\h\[${white}\] in";
PS1+="\[${yellow}\] \W";
PS1+="\$(prompt_git \"\[${white}\] on \[${violet}\]\" \"\[${blue}\]\")"; # Git repository details
PS1+="\n"
PS1+="\[${white}\]$ \[${reset}\]";
export PS1;


# --- Aliases

# Easier navigation: .., ..., ...., ..... and ~
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ~="cd ~" # `cd` is probably faster to type though

# Shortcuts
alias dropbox="cd ~/Documents/Dropbox"
alias dl="cd ~/Downloads"
alias dt="cd ~/Desktop"
alias p="cd ~/Projects"
alias ch='history | grep "git commit"'
alias hg='history | grep'
alias g="git"

# List all files colorized in long format
alias l="ls -lF -G"

# List all files colorized in long format, including dot files
alias la="ls -laF -G"

# List only directories
alias lsd="ls -lF -G | grep --color=never '^d'"

# Always use color output for `ls`
alias ls="command ls -G"

# Always enable colored `grep` output
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Change default python to version 3 instead of 2 
alias python='python3'