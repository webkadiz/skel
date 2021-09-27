#!/bin/bash

# parse arguments
POSITIONAL=()
while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    -u|--USER)
      USER="$2"
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

if [[ ! $PASSWORD ]]; then echo "set password through -p|--password option"; fi
if [[ ! $EMAIL ]]; then echo "set email through -e|--email option"; fi
if [[ ! $USER ]]; then echo "set user through -u|--user option"; fi
if [[ ! $PASSWORD || ! $EMAIL || ! $USER ]]; then exit; fi

# change shell to zsh
chsh < <(echo -e "$PASSWORD\n/usr/bin/zsh")

# sync configuration
./sync.py -f

# install primary packages
sudo pacman -S $(cat packages/archlinux/pacman-primary)

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
    yandex-disk setup < <(echo -e "\n/home/$USER/ydisk\n")
fi
