#!/bin/bash
export PATH=${PATH}:${HOME}/.local/bin

# enable cgroupv2
sudo loginctl enable-linger $USER
export XDG_RUNTIME_DIR=/run/user/$(id -u)
sudo mkdir -p /etc/systemd/system/user@.service.d
if [ ! -e /etc/systemd/system/user@.service.d/delegate.conf ]; then
  cat <<EOF | sudo tee /etc/systemd/system/user@.service.d/delegate.conf
[Service]
Delegate=cpu cpuset io memory pids
EOF
  sudo systemctl daemon-reload
fi
echo cgroup2 /sys/fs/cgroup cgroup2 rw,nosuid,nodev,noexec,relatime,nsdelegate 0 0 | sudo tee /etc/fstab
awk '!a[$0]++' /etc/fstab | sudo tee /etc/fstab

# install containerd
# https://docs.docker.com/engine/install/ubuntu/
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y containerd.io uidmap crun dbus-user-session
sudo systemctl --user enable --now dbus

# install nerdctl
mkdir -p ~/.local/src && cd ~/.local/src
curl -LO https://github.com/containerd/nerdctl/releases/download/v1.3.1/nerdctl-full-1.3.1-linux-amd64.tar.gz
tar xzfz nerdctl-full-1.3.1-linux-amd64.tar.gz -C ~/.local/

source ~/.bashrc

sudo apt-get -y install containernetworking-plugins

sudo sed -i -e 's/^disabled_plugins = ["cri"]/# disabled_plugins = ["cri"]/g'
sudo tee -a /etc/containerd/config.toml << EOF
[plugins."io.containerd.grpc.v1.cri".containerd]
#  default_runtime_name = "runc"
   default_runtime_name = "crun"

[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.crun]
  runtime_type = "io.containerd.runc.v2"
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.crun.options]
  BinaryName = "/usr/bin/crun"
  SystemdCgroup = true
EOF

sudo systemctl restart containerd

~/.local/bin/containerd-rootless-setuptool.sh install
~/.local/bin/containerd-rootless-setuptool.sh install-buildkit
CONTAINERD_NAMESPACE=default containerd-rootless-setuptool.sh install-buildkit-containerd