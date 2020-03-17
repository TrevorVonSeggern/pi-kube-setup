#!/bin/bash

# get some variables for later
echo "This is a setup script for your pi cluster."
echo "I'm going to prompt you for some input for this specific pi"

echo "What static ip address should this pi have? (192.168.0.100)"
read STATICIPADDRESS

echo "Username?"
read MYUSER

sudo adduser $MYUSER
sudo usermod -aG sudo $MYUSER
su - $MYUSER

# do stuff that prompts user first so that the install is less painful
if [ ! -d /home/$MYUSER/.ssh ]; then
  sudo -u $MYUSER mkdir /home/$MYUSER/.ssh
  ssh-keygen -t rsa
fi

# get the static ip
sudo echo "

interface eth0
static ip_address=$STATICIPADDRESS/24
static routers=192.168.0.1
static domain_name_servers=192.168.0.1"  >> /etc/dhcpcd.conf


# need to 
sudo apt get update
sudo apt get upgrade
sudo apt get dist-upgrade

# install a bunch of easy packages
sudo apt install -y tmux vim zsh git ufw

sudo ufw allow ssh
sudo ufw enable

if [ ! -d /home/$MYUSER/git ]; then
  sudo -u $MYUSER mkdir /home/$MYUSER/git
  sudo -u $MYUSER git clone https://github.com/trevorvonseggern/dotfiles ~/git/dotfiles
  sudo -u $MYUSER git clone https://github.com/trevorvonseggern/vim ~/git/vim
  # todo: run the install script for each of these repos.
fi


# ssh
sudo systemctl enable ssh
sudo systemctl start ssh


# docker
sudo curl -sSL get.docker.com | sh && \ sudo usermod $MYUSER -aG docker
# docker doesn't like swap file
sudo dphys-swapfile swapoff && \ sudo dphys-swapfile uninstall && \ sudo update-rc.d dphys-swapfile remove

# add an if statement here
echo "cgroup_enable=cpuset cgroup_enable=memory" > /boot/cmdline



# kubernetes
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \ echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list && \ sudo apt-get update -q && \ sudo apt-get install -qy kubeadm




# oh my zsh
sudo -u $MYUSER sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
