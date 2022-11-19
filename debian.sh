#!/usr/bin/env bash

echo -e ${MAIN}"==> Setting global variables"${NC}
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'
MAIN=${BLUE}
ROOT_UID=0


verify_user()
{
  # check if script is executed by non-root user
  echo -e ${MAIN}"==> Checking if not root"${NC}
  if [[ "${UID}" == "${ROOT_UID}" ]]; then
    echo "Please run this script as a user"
    exit 126
  fi
}

create_directories()
{
  echo -e ${MAIN}"==> Creating directories"${NC}

  mkdir $HOME/doc
  mkdir $HOME/tmp
  mkdir $HOME/src
  mkdir $HOME/img
  mkdir $HOME/msc
}

clone_repositories()
{
  echo -e ${MAIN}"==> Cloning repositories"${NC}
  git clone git@github.com:dudekmichal/debian.git $HOME/src/debian
  git clone git@github.com:dudekmichal/dotfiles.git $HOME/src/dotfiles
}

config_apt()
{
  echo -e ${MAIN}"==> Configuration of sources.list"${NC}
  sudo sh -c "cat config/sources.list > /etc/apt/sources.list"
  sudo vi /etc/apt/sources.list

  sudo apt update
  sudo apt upgrade
}

install_packages()
{
  echo -e ${MAIN}"==> Installing packages"${NC}
  sudo apt install \
  console-setup \
  xserver-xorg \
  nethack-qt \
  youtube-dl \
  # redshift \
  xinit \
  scrot \
  unzip \
  hexchat
  htop \
  feh \
  vim \
  ssh
}

install_gnome()
{
  sudo apt install \
  gnome-tweak-tool \
  fonts-powerline \
  gnome-boxes \
  gnome
}

install_tweak_packages()
{
  sudo apt install \
  fonts-font-awesome \
  faenza-icon-theme \
  fonts-inconsolata
}

install_drivers()
{
  # asus ac51 driver
  # sudo apt install firmware-misc-nonfree

  # rtx 2070
  # sudo apt install nvidia-driver

  # thinkpad x1 carbon wifi
  sudo apt install firmware-iwlwifi
}

install_dev_tools()
{
  sudo apt install \
  build-essential \
  exuberant-ctags \
  libncurses-dev \
  virt-manager \
  libssl-dev \
  libelf-dev \
  libssl-dev \
  devscripts \
  python3 \
  bison \
  cmake \
  flex \
  curl \
  gcc \
  vim \
  git
}

setup_dotfiles()
{
  rsync -ah --exclude ".git*" $HOME/src/dotfiles/.* $HOME/
}

config_other()
{
  echo -e ${MAIN}"==> Setting other packages"${NC}
  chsh -s /usr/bin/zsh $USER
  xrdb -merge $HOME/.Xresources
}

other_settings()
{
  echo -e ${MAIN}"==> Setting console font"${NC}
  sudo dpkg-reconfigure console-setup

  echo -e ${MAIN}"==> Setting grub"${NC}
  sudo vi /etc/default/grub
  sudo update-grub
}

config_zsh()
{
  sudo apt install vim zsh fonts-powerline -y
  chsh -s /usr/bin/zsh
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.config/powerlevel10k
  # echo "[[ ! -f ~/src/dotfiles/.aliasrc ]] || source ~/.aliasrc" >>~/.zshrc
  # echo "source ~/.config/powerlevel10k/powerlevel10k.zsh-theme" >>~/.zshrc
}

main()
{
  verify_user
  create_directories
  clone_repositories
  config_apt
  install_packages
  # install_gnome
  install_tweak_packages
  install_drivers
  install_dev_tools
  setup_dotfiles
  config_zsh
  config_other
  other_settings
}

main
