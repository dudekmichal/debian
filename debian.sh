#!/usr/bin/env bash

echo -e ${MAIN}"==> Setting global variables"${NC}
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'
MAIN=${BLUE}
ROOT_UID=0
REPO="$HOME/src/debian"

# clone repo to the correct location
if [[ ! -d $REPO ]]; then
  mkdir -p $HOME/src
  git clone https://github.com/dudekmichal/debian.git $REPO
fi;

# check if script is executed by non-root user
echo -e ${MAIN}"==> Checking if not root"${NC}
if [[ "${UID}" == "${ROOT_UID}" ]]; then
  echo "Please run this script as a user"
  exit 126
fi

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
  redshift \
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
  libssl-dev \
  libelf-dev \
  libssl-dev \
  cmake curl \
  python3 \
  python \
  bison \
  flex \
  gcc \
  vim \
  git
}

clone_dotfiles()
{
  if [[ ! -d $HOME/src/dotfiles ]]; then
    git clone https://github.com/dudekmichal/dotfiles.git $HOME/src/dotfiles
  fi;

  # cp -R $HOME/src/dotfiles/.* $HOME/
  # rm -rf $HOME/src/dotfiles
}

config_other()
{
  echo -e ${MAIN}"==> Setting other packages"${NC}
  chsh -s /usr/bin/zsh $USER
  xrdb -merge $HOME/.Xresources

  # systemctl --user enable mpd
  # systemctl --user start mpd
  # sudo systemctl enable NetworkManager.service
  # sudo systemctl start NetworkManager.service
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
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/src/powerlevel10k
  echo "[[ ! -f ~/src/dotfiles/.aliasrc ]] || source ~/.aliasrc" >>~/.zshrc
  echo "source ~/src/powerlevel10k/powerlevel10k.zsh-theme" >>~/.zshrc
}

main()
{
  create_directories
  clone_repositories
  config_apt
  install_packages
  # install_gnome
  install_tweak_packages
  install_drivers
  install_dev_tools
  clone_dotfiles
  config_zsh
  config_other
  other_settings
}

main
