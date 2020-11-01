#!/bin/bash

# linuxbrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >> ~/.profile
eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

# brew
brew install git bash-completion powerline-go tmux make vim
git config --global user.email "0deltast@gmail.com"
git config --global user.name "0Delta"

# kubernetes
brew install kubectl stern kubectx k9s helm helmfile

# pipenv
brew install pipenv
echo "set PIPENV_VENV_IN_PROJECT true" >> ~/.config/fish/fish.config
echo "eval (pipenv --completion)" >> ~/.config/fish/fish.config

# google-cloud-sdk
curl -o /tmp/google-cloud-sdk.tar.gz https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-312.0.0-linux-x86_64.tar.gz
tar -xvf  /tmp/google-cloud-sdk.tar.gz
/tmp/google-cloud-sdk/install.sh
rm -rf /tmp/google-cloud-sdk

# fisher
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish

# fisher add
fish -c "
fisher add fisherman/z
fisher add 0delta/fish-async-prompt@v3
"

$(cd $(dirname $0); pwd)/link.sh
