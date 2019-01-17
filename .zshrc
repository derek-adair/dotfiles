# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="powerlevel9k/powerlevel9k"

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

export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin"
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


##############################################################
######################### dereks stuff #######################
##############################################################

export DEV_DIR=~/
# Load node virtual manager
source ~/.nvm/nvm.sh


############################# bash stuff ############################
# destroy all the cache
function clear_pyc(){ find . -name "*.pyc" -exec rm -rf {} \;}
# list dirs after i change
function cd(){
    builtin cd "$@" && ls
}
function untar(){tar -xvzf $@}

############################# Git ############################
alias ca='git add . && git commit -am'
alias gch='git cherry-pick'
alias kill_branch='git branch -D'

########################### Docker  ############################
## GENERAL ##
alias comp='docker-compose'
alias comp_prod='docker-compose -f docker-compose.prod.yml'
source_docker(){
    eval $(docker-machine env $1);
    echo "Docker Host :" $DOCKER_HOST;
}
kick_docker(){
    restart_machine;
    source_default;
}
restart_machine(){
    docker-machine kill $1;
    docker-machine start $1;
}
source_default(){source_docker default;}
dopen(){ /usr/bin/open -a "/Applications/Google Chrome.app" "http://$(docker-machine ip):$1";}

## CONTAINERS ##
toss(){docker run -it --rm $@}
hijack(){docker exec -it $1 bash}
snatch(){docker exec -it $@}
#Start a container 
attach_c(){toss $1 /bin/bash}
# run a manage.py command for django
manage_c() { comp run --rm web python manage.py $@;}
# Used to chown any files i generate with docker
gime() { sudo chown -R $USER:$USER $@;}


alias stop_containers='docker stop $(docker ps -q)'
# kill all containers
alias kill_em_all='docker kill $(docker ps -q)'
# remove all non running containers
alias remove_containers='docker rm `docker ps -aq`'
# Nuke all containers from orbit
alias nuke_containers='docker rm -f $(docker ps -a -q)'
# Essentially resets all container runtimes and leaves nothing
#  - deletes all containers and volumes
alias burn_it_all='docker rm -f $(docker ps -aq) && docker volume rm $(docker volume ls -q)'

## IMAGES ##
# Build a template

d_build() { docker build -t="$1" . }
# Removes all images and containers that are not running
alias remove_images='docker rmi `docker images -q`'
#Kill all images and containers that are not running
alias tactical_nuke='remove_containers && remove_images'
alias nuke_volumes='docker volume rm $(docker volume ls -q)'
alias nuke_from_orbit='nuke_containers && docker rmi -f `docker images -q` && docker volume rm `docker volume ls -q`'
alias clean_images='docker rmi $(docker images | grep "^<none>" | awk "{print $3}")'

#Django Docker things
function bootstrap_django(){docker run -it --rm --user "$(id -u):$(id -g)" -v "$PWD":/usr/src/app -w /usr/src/app django django-admin.py startproject $1}

########################### Python ############################

## Python Virtualenvs ##

export PY_VIRTUALENV_DIR="${DEV_DIR}tools/virtualenv"
usePy() { source $PY_VIRTUALENV_DIR/$1/bin/activate;}
alias listPy='ls $PY_VIRTUALENV_DIR'
newPyEnv() { source $PY_VIRTUALENV_DIR/bootstrap/bin/activate; pip freeze > ~/requirements.txt; virtualenv $PY_VIRTUALENV_DIR/$1; source $PY_VIRTUALENV_DIR/$1/bin/activate; pip install -r ~/requirements.txt; rm requirements.txt;}

http() {python -m SimpleHTTPServer $1}

## Load up the python 3 virtualenv by default
usePy python3
alias python=python3
alias pip=pip3

########################### tmux ##########################
alias tm='tmux'
tmat() { tm a -t $1;}
tmswap() {tm switch -t $1;}

# Auto Start
if [[ -z "$TMUX" ]] then
  tmux_session='#OMZ'

  if ! tmux has-session -t "$tmux_session" 2> /dev/null; then
    # Disable the destruction of unattached sessions globally.
    tmux set-option -g destroy-unattached off &> /dev/null

    # Create a new session.
    tmux new-session -d -s "$tmux_session"

    # Disable the destruction of the new, unattached session.
    tmux set-option -t "$tmux_session" destroy-unattached off &> /dev/null

    # Enable the destruction of unattached sessions globally to prevent
    # an abundance of open, detached sessions.
    tmux set-option -g destroy-unattached on &> /dev/null
  fi

  exec tmux new-session -t "$tmux_session"
fi
