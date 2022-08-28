#!/bin/bash

# print help
if [[ ! $1 ]]; then
    echo "-n, --name        your name"
    echo "-u, --username    your username"
    echo "-p, --password    password for your user and ssh key"
    echo "-e, --email       your work email"
    echo "--yay             setup yay"
    echo "--gnome           setup gnome"
    echo "--ydisk           setup yandex disk"
    echo "--gh-ssh          setup github ssh key"
    exit
fi

# parse arguments
POSITIONAL=()
while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    -n|--name)
      NAME="$2"
      shift
      shift
      ;;
    -u|--username)
      USERNAME="$2"
      shift
      shift
      ;;
    -p|--password)
      PASSWORD="$2"
      shift
      shift
      ;;
    -e|--email)
      EMAIL="$2"
      shift
      shift
      ;;
    --yay)
      YAY="YES"
      shift
      ;;
    --gnome)
      GNOME="YES"
      shift
      ;;
    --ydisk)
      YDISK="YES"
      shift
      ;;
    --gh-ssh)
      GH_SSH="YES"
      shift
      ;;
    *)
      POSITIONAL+=("$1")
      shift
      ;;
  esac
done

# restore positional parameters
set -- "${POSITIONAL[@]}"

if [[ ! $NAME ]]; then echo "set name through -n|--name option"; fi
if [[ ! $USERNAME ]]; then echo "set username through -u|--user option"; fi
if [[ ! $PASSWORD ]]; then echo "set password through -p|--password option"; fi
if [[ ! $EMAIL ]]; then echo "set email through -e|--email option"; fi
if [[ ! $NAME || ! $USERNAME || ! $PASSWORD || ! $EMAIL ]]; then exit; fi

# interval between sections
INTERVAL=5

# install primary packages
echo "INSTALL PACKAGES"
sleep $INTERVAL

pacman -S $(cat packages/archlinux/pacman-primary)
if [[ $? -ne 0 ]]; then
    echo "packages is not installed"
    echo "run script as root"
    exit
fi

# install gnome
if [[ $GNOME ]]; then
    echo "INSTALL GNOME"
    sleep $INTERVAL

    pacman -S $(cat packages/archlinux/gnome)
fi

# setup locale
echo "SETUP LOCALE"
sleep $INTERVAL

vim /etc/locale.gen
locale-gen
localectl set-locale LANG=en_US.UTF-8

# setup sudo
echo "SETUP SUDO"
sleep $INTERVAL

visudo

# setup user
echo "SETUP USER"
sleep $INTERVAL

useradd -m -G wheel "$USER"
echo -e "$PASSWORD\n$PASSWORD" | passwd "$USER"
su "$USER"
if [[ $? -ne 0 ]]; then
    echo "user is not setted"
    echo "run script as root"
    exit
fi

ur="sudo -u $USERNAME"
chown -R "$USERNAME" .
chgrp -R "$USERNAME" .
HOME="/home/$USERNAME"

# sync configuration
echo "SYNC CONFIGURATION"
sleep $INTERVAL

$ur ./sync.py -f

# change shell to zsh
echo "CHANGE SHELL"
sleep $INTERVAL

echo -e "$PASSWORD\n/usr/bin/zsh" | $ur chsh

# setup git
echo "SETUP GIT"
sleep $INTERVAL

git config --global user.name "Vladislav Tkachenko"
git config --global user.email "$EMAIL"

# load gnome settings
if [[ $GNOME ]]; then
    echo "LOAD GNOME SETTINGS"
    sleep $INTERVAL

    cat .gnome-settings | $ur dconf load /
fi

# install packer
echo "INSTALL PACKER"
sleep $INTERVAL

$ur git clone https://github.com/wbthomason/packer.nvim \
    ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# create neovim backup dir
echo "NEOVIM BACKUP DIR"
sleep $INTERVAL

$ur mkdir -p ~/.local/share/nvim/backup

# install oh-my-zsh
echo "INSTALL OH-MY-ZSH"
sleep $INTERVAL

curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh | $ur bash

# install nvm
# TODO find last nvm version from github
echo "INSTALL NVM"
sleep $INTERVAL

$ur mkdir ~/.config/nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | $ur bash
$ur nvm install --lst

# setup yay
if [[ $YAY ]]; then
    echo "SETUP YAY"
    sleep $INTERVAL

    cd /tmp
    pushd .
    $ur git clone https://aur.archlinux.org/yay.git
    cd yay
    pushd .
    $ur makepkg -si
    popd
    popd
    $ur yay -S $(cat packages/archlinux/yay-primary)
fi

# setup yandex disk
if [[ $YDISK ]]; then
    echo "SETUP YANDEX DISK"
    sleep $INTERVAL

    $ur echo -e "\n/home/$USER/ydisk\n" | $ur yandex-disk setup
fi

# setup github ssh key
if [[ $GH_SSH ]]; then
    echo "SETUP GUTHUB SSH KEY"
    sleep $INTERVAL

    echo -e "/home/$USER/.ssh/github\n$PASSWORD\n$PASSWORD" | ssh-keygen -t ed25519 -C "$EMAIL"
    xclip -selection clipboard "/home/$USER/.ssh/github.pub"
    yandex-browser-beta https://github.com/settings/keys
fi

# setup time
$ur timedatectl set-timezone Europe/Moscow
