include .env

.PHONY: setup-tmux
setup-tmux:
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
	cp .tmux.conf ~/.tmux.conf

.PHONY: setup-nvim
setup-nvim: setup-node setup-python setup-dotnet
	@echo "Instaling nvim"
	wget https://github.com/neovim/neovim/releases/download/v0.7.0/nvim-linux64.deb
	sudo apt install ./nvim-linux64.deb
	rm ./nvim-linux64.deb
	@echo "Installing packer.nvim"
	git clone --depth 1 \
		https://github.com/wbthomason/packer.nvim \
		~/.local/share/nvim/site/pack/packer/start/packer.nvim

.PHONY: setup-shell
setup-ghell:
	@echo "Te be implemented"

.PHONY: setup-git
setup-git:
	git config --global \
		user.email "$(GIT_GLOBAL_CONFIG_EMAIL)"
	git config --global \
		user.name "$(GIT_GLOBAL_CONFIG_USERNAME)"

.PHONY: setup-gpg
setup-gpg:
	@echo "Te be implemented"

.PHONY: setup-dotnet
setup-dotnet:
	@echo "Installing dotnet-sdk-6.0"
	sudo apt-get install -y dotnet-sdk-6.0

.PHONY: setup-node
setup-node:
	@echo "Installing nodejs"
	sudo apt-get install -y nodejs

.PHONY: setup-python
setup-python:
	@echo "Installing python2"
	sudo apt-get install -y python2
	@echo "Installing python3"
	sudo apt-get install -y python3

.PHONY: setup-go
setup-go:
	@echo "To be implemented"

.PHONY: setup-rust
setup-rust:
	@echo "To be implemented"
