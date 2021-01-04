#!/bin/bash
HOMEBREW_NO_AUTO_UPDATE=1

# linuxbrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

# brew
brew install git bash-completion powerline-go tmux make vim
git config --global user.email "0deltast@gmail.com"
git config --global user.name "0Delta"

# kubernetes
brew install kubectl stern kubectx k9s helm helmfile

# pipenv
brew install pipenv
# echo "set PIPENV_VENV_IN_PROJECT true" >> ~/.config/fish/fish.config
# echo "eval (pipenv --completion)" >> ~/.config/fish/fish.config
pipenv --completion

# google-cloud-sdk
brew install python@3.8
brew link python@3.8
curl -o /tmp/google-cloud-sdk.tar.gz https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-312.0.0-linux-x86_64.tar.gz
tar -C /tmp /tmp/google-cloud-sdk.tar.gz
rm -rf /tmp/google-cloud-sdk.tar.gz
/tmp/google-cloud-sdk/install.sh -q --command-completion false --path-update false
rm -rf /tmp/google-cloud-sdk

# fisher
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish

# fisher add
fish -c "
fisher install fisherman/z
fisher install 0delta/fish-async-prompt@v3
"

# golang
STABLE_GO=$(curl -L https://golang.org/dl -o- -s | grep -oP go[1-9.]+linux-amd64.tar.gz | head -n 1)
curl -L -o /tmp/gopkg.tar.gz https://golang.org/dl/${STABLE_GO}
mkdir -p ~/.go
tar -C ~/.go -xzf /tmp/gopkg.tar.gz
rm /tmp/gopkg.tar.gz

$(cd $(dirname $0); pwd)/link.sh
