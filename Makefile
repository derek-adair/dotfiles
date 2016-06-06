all: UPDATE INSTALL

INSTALL: TMUX VIMRC ZSHRC

TMUX:
	cp .tmux.conf ~/;
VIMRC:
	cp .vimrc ~/;
ZSHRC:
	cp .zshrc ~/;

UPDATE:
	git remote update && git pull origin master;
