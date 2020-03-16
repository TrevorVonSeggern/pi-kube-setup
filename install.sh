#!/bin/bash

# get some variables for later
echo "This is a setup script for your pi cluster."
echo "I'm going to prompt you for some input for this specific pi"

echo "What static ip address should this pi have? (192.168.0.100)"
read STATICIPADDRESS

echo "Username?"
read MYUSER

echo "Password?"
read MYPASSWORD


sudo apt get update
sudo apt get upgrade
sudo apt get dist-upgrade

# things to install: ssh, tmux, vim, git, my dotfile config, zsh, oh my zsh, docker, kubectl... anything else?...

# install a bunch of easy packages
sudo apt install -y tmux vim zsh git

if [ ! -d directory ]; then
  mkdir ~/git
  git clone https://github.com/trevorvonseggern/dotfiles ~/git/dotfiles
  git clone https://github.com/trevorvonseggern/vim ~/git/vim
  # todo: run the install script for each of these repos.
fi


# oh my zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# ssh
sudo systemctl enable ssh
sudo systemctl start ssh


# docker
curl -sSL get.docker.com | sh && \ sudo usermod pi -aG docker
# docker doesn't like swap file
sudo dphys-swapfile swapoff && \ sudo dphys-swapfile uninstall && \ sudo update-rc.d dphys-swapfile remove

# add an if statement here
echo "cgroup_enable=cpuset cgroup_enable=memory" > /boot/cmdline



# kubernetes
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \ echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list && \ sudo apt-get update -q && \ sudo apt-get install -qy kubeadm
