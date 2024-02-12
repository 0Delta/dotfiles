#!/bin/bash
HOMEBREW_NO_AUTO_UPDATE=1

# setup
git submodule init
git submodule update

# linuxbrew
CI=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

# brew
brew install -q git bash-completion tmux make vim fzf npm
rm ~/.gitconfig
brew postinstall -q gcc

# kubernetes
brew install -q kubectl stern kubectx k9s helm helmfile

# pipenv
brew install -q pipenv
# echo "set PIPENV_VENV_IN_PROJECT true" >> ~/.config/fish/fish.config
# echo "eval (pipenv --completion)" >> ~/.config/fish/fish.config
# eval "$(pipenv --completion)"

# google-cloud-sdk
brew install -q python@3
brew link python@3 --overwrite
# curl -o /tmp/google-cloud-sdk.tar.gz https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-312.0.0-linux-x86_64.tar.gz
# tar -C /tmp -xzf /tmp/google-cloud-sdk.tar.gz
# rm -rf /tmp/google-cloud-sdk.tar.gz
# /tmp/google-cloud-sdk/install.sh -q --command-completion false --path-update false
# rm -rf /tmp/google-cloud-sdk
curl https://sdk.cloud.google.com > /tmp/install.sh
bash /tmp/install.sh --disable-prompts
rm /tmp/install.sh

# fish
brew install -q fish powerline-go

# fisher
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish

# fisher add
fish -c "
fisher install fisherman/z
fisher install mordax7/fish-fzf-todoist
fisher install patrickf1/fzf.fish
fisher install acomagu/fish-async-prompt
"

# golang
STABLE_GO=$(curl -L https://go.dev/dl -o- -s | grep -oP go[0-9.]+linux-amd64.tar.gz | head -n 1)
curl -L -o /tmp/gopkg.tar.gz https://golang.org/dl/${STABLE_GO}
mkdir -p ~/.go
tar -C ~/ -xzf /tmp/gopkg.tar.gz
rm -rf ~/.go
mv ~/go ~/.go
rm /tmp/gopkg.tar.gz
mkdir -p ~/.local/bin
ln -s ~/.go/bin/* ~/.local/bin

# gpg
sudo apt install -y socat scdaemon

# network setting
# need wsl restart
sudo touch /etc/resolv.conf
cat <<EOF | sudo tee /etc/wsl.conf
[boot]
systemd=true
[network]
generateResolvConf = false
EOF
awk '!a[$0]++' /etc/wsl.conf | sudo tee /etc/wsl.conf

sudo rm /etc/resolv.conf
sudo touch /etc/resolv.conf
cat <<EOF | sudo tee -a /etc/resolv.conf
nameserver 1.1.1.1
nameserver 8.8.8.8
EOF
awk '!a[$0]++' /etc/resolv.conf | sudo tee /etc/resolv.conf

$(cd $(dirname $0); pwd)/link.sh
