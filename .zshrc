# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

export PATH="/opt/local/bin:/opt/local/sbin:/opt/local/bin:/opt/local/sbin:/Users/derekadair/dev/_utilities:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/opt/X11/bin"
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

##############################################################
######################### dereks stuff #######################
##############################################################


# Path Stuff
export PATH="/home/derek/Dev/.tools/atlas/packer:$PATH"
export PATH="/home/derek/Dev/.tools/atlas/terraform:$PATH"

############################# zsh mods ############################
#attempt at mimicing pbcopy/pbpaste (suspected bug with working via SSH)
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'
# destroy all the cache
function clear_pyc(){ find . -name "*.pyc" -exec rm -rf {} \;}
# list dirs after i change
function cd(){

    builtin cd "$@" && ls
    }

# Load node virtual manager
source ~/.nvm/nvm.sh


# change to dev dir on ssh
cd ~/Dev

# xvfb-run shortcut
alias fbr="xvfb-run"
############################# Git ############################
alias ca='git add . && git commit -am'
alias gch='git cherry-pick'
alias kill_branch='git branch -D'

########################### packer  ############################
export PACKER_CACHE_DIR=/var/cache/packer/packer_cache/
########################### Docker  ############################
## GENERAL ##
alias comp='docker-compose'
gime() { sudo chown -R derek:derek $@;}

## CONTAINERS ##
toss(){docker run -it --rm $@}
snatch(){docker exec -it $1 /bin/bash}
#Start a container 
attach_c(){toss $1 /bin/bash}
# run a manage.py command for django
manage_c() { comp run --rm web python manage.py $@;}
# Used to chown any files i generate with docker

# kill all containers
alias k9containers='docker kill $(docker ps -q)'
alias remove_containers='docker rm `docker ps -aq`'
alias nuke_containers='docker rm -f $(docker ps -a -q)'

## IMAGES ##
# Build a template

d_build() { docker build -t="$1" . }
# Removes all images and containers that are not running
alias remove_images='docker rmi `docker images -q`'
#Kill all images and containers that are not running
alias tactical_nuke='remove_images && docker rmi -f `docker images -q`'
alias nuke_from_orbot='nuke_containers && docker rmi -f `docker images -q`'

#Django Docker things
function bootstrap_django(){docker run -it --rm --user "$(id -u):$(id -g)" -v "$PWD":/usr/src/app -w /usr/src/app django django-admin.py startproject $1}

########################### Python ############################

## Python Virtualenvs ##
PY_VIRTUALENV_DIR='/home/derek/Dev/.tools/virtualenv/python'
usePy() { source $PY_VIRTUALENV_DIR/$1/bin/activate;}
alias listPy='ls $PY_VIRTUALENV_DIR'
newPyEnv() { source $PY_VIRTUALENV_DIR/bootstrap/bin/activate; pip freeze > ~/requirements.txt; virtualenv $PY_VIRTUALENV_DIR/$1; source $PY_VIRTUALENV_DIR/$1/bin/activate; pip install -r ~/requirements.txt; rm requirements.txt;}

sserver() {python -m SimpleHTTPServer $1}

########################### ENV VARS ##########################
export ATLAS_TOKEN=4Z7hg-_zLiW4_8P1WyhnsoXKhMfJiy_o8h6FCjNr6ZPVm_j3aTTDw4quVYMwvFJJyCz

########################### tmux ##########################
alias tm='tmux'
tmat() { tm a -t $1;}

kick_tmux() { tm new-session -A -s main; }
########################### EC2 ##########################
export EC2_HOME=/usr/local/ec2/ec2-api-tools-1.7.3.0
export PATH=$PATH:$EC2_HOME/bin 
export AWS_ACCESS_KEY=AKIAIJPAGUUMWEDVCNOA
export AWS_SECRET_KEY=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
