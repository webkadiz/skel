#!/bin/bash

# print help
if [[ ! $1 ]]; then
    echo "-n, --name - your name"
    echo "-u, --username - your username"
    echo "-p, --passoword - password for your user"
    echo "-e, --email - your work email"
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
    *)
      POSITIONAL+=("$1")
      shift
      ;;
  esac
done

set -- "${POSITIONAL[@]}" # restore positional parameters

if [[ ! $NAME ]]; then echo "set name through -n|--name option"; fi
if [[ ! $USERNAME ]]; then echo "set username through -u|--user option"; fi
if [[ ! $PASSWORD ]]; then echo "set password through -p|--password option"; fi
if [[ ! $EMAIL ]]; then echo "set email through -e|--email option"; fi
if [[ ! $NAME || ! $USERNAME || ! $PASSWORD || ! $EMAIL ]]; then exit; fi

# install primary packages
pacman -S $(cat packages/archlinux/pacman-primary)
if [[ $? -ne 0 ]]; then
    echo "packages is not installed"
    echo "run script as root"
    exit
fi

# setup sudo
visudo

# setup user
useradd -m -G wheel "$USER"
echo -e "$PASSWORD\n$PASSWORD" | passwd "$USER"
su "$USER"
if [[ $? -ne 0 ]]; then
    echo "user is not setted"
    echo "run script as root"
    exit
fi

# sync configuration
./sync.py -f

# change shell to zsh
echo -e "$PASSWORD\n/usr/bin/zsh" | chsh

# setup git
git config --global user.name "Vladislav Tkachenko"
git config --global user.email "$EMAIL"

# load gnome settings
if [[ $GNOME ]]; then
    cat .gnome-settings | dconf load /
fi

# install packer
git clone https://github.com/wbthomason/packer.nvim \
    ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# create backup dir
mkdir -p ~/.local/share/nvim/backup

# install oh-my-zsh
curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash

# install nvm
# TODO find last nvm version from github
mkdir ~/.config/nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
nvm install --lst

# setup yay
if [[ $YAY ]]; then
    cd /tmp
    pushd .
    git clone https://aur.archlinux.org/yay.git
    cd yay
    pushd .
    makepkg -si
    popd
    popd
    yay -S $(cat packages/archlinux/yay-primary)
fi

# setup yandex disk
if [[ $YDISK ]]; then
    echo -e "\n/home/$USER/ydisk\n" | yandex-disk setup
fi
