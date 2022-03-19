#!/usr/bin/env bash

# colors
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'
MAIN=${BLUE}

echo -e ${MAIN}"==> Setting global variables"${NC}
ROOT_UID=0
REPO="$HOME/repo/debian"

# clone repo to the correct location
if [[ ! -d $REPO ]]; then
    mkdir -p $HOME/repo
    git clone https://github.com/dudekmichal/debian.git $REPO
fi;

# check if script is executed by non-root user
echo -e ${MAIN}"==> Checking if not root"${NC}
if [[ "$UID" == "$ROOT_UID" ]]; then
  echo "Please run this script as a user"
  exit 126
fi

create_directories()
{
  echo -e ${MAIN}"==> Creating directories"${NC}
  mkdir -p $HOME/tmp
  mkdir -p $HOME/mnt
  mkdir -p $HOME/documents
  mkdir -p $HOME/music
  mkdir -p $HOME/movies
  mkdir -p $HOME/download
  mkdir -p $HOME/repo
  mkdir -p $HOME/pictures
}

clone_repositories()
{
  echo -e ${MAIN}"==> Cloning repositories"${NC}
}

config_apt()
{
  sudo sh -c "cat sources.list > /etc/apt/sources.list"
  sudo vi /etc/apt/sources.list

  sudo apt update -y
  sudo apt upgrade -y
}

install_packages()
{
  echo -e ${MAIN}"==> Installing packages"${NC}
  sudo apt install xserver-xorg xinit feh alsa-utils electrum xbacklight \
  gcalcli vim-nox cmake curl exuberant-ctags lua5.2 xfonts-terminus \
  console-setup python3 python gcc cmake zsh acpi nethack-console mpv git \
  htop newsbeuter scrot youtube-dl rtorrent zathura mc ranger w3m w3m-img \
  i3lock i3 i3status rofi suckless-tools xterm irssi lxrandr help2man \
  dtrx p7zip unrar-free unzip ssh gmtp redshift fonts-font-awesome \
  breeze-icon-theme links apg moc mutt build-essential libncurses5-dev \
  libssl-dev man-db mpd ncmpcpp mpc net-tools
}

install_cli_packages()
{
  echo -e ${MAIN}"==> Installing packages"${NC}
  sudo apt install vim-nox xfonts-terminus console-setup \
  python3 python gcc cmake zsh acpi nethack-console python-autopep8 \
  git htop newsbeuter rtorrent mc ranger w3m w3m-img irssi dtrx \
  ssh links apg mutt build-essential \
  libncurses5-dev libssl-dev man-db mpd ncmpcpp mpc -y
}

install_lenovo_g580_drivers()
{
  echo -e ${MAIN}"==> Installing drivers for Lenovo G580"${NC}
  sudo apt install firmware-brcm80211 firmware-iwlwifi
}

clone_dotfiles()
{
  if [[ ! -d $HOME/repo/dotfiles ]]; then
    git clone https://github.com/dudekmichal/dotfiles.git $HOME/repo/dotfiles
  fi;

  cp -R $HOME/repo/dotfiles/.* $HOME/
  rm -rf $HOME/repo/dotfiles
}

config_other()
{
  echo -e ${MAIN}"==> Setting other packages"${NC}
  chsh -s /bin/zsh $USER
  xrdb -merge $HOME/.Xresources

  sudo mkdir -p /var/games/nethack

  # git clone https://github.com/haikarainen/light $HOME/tmp/light
  # cd $HOME/tmp/light
  # make && sudo make install
  # cd $HOME && rm -rf $HOME/tmp/light

  # sudo mv ~/.mpd/mpd.conf /etc/mpd.conf
  # sudo systemctl enable mpd
  # sudo systemctl start mpd
}

other_settings()
{
  echo -e ${MAIN}"==> Disabling beep"${NC}
  sudo rmmod pcspkr
  sudo sh -c "echo 'blacklist pcspkr' >> /etc/modprobe.d/blacklist"

  echo -e ${MAIN}"==> Disabling capslock"${NC}
  setxkbmap -option caps:escape &

  echo -e ${MAIN}"==> Setting console font"${NC}
  sudo dpkg-reconfigure console-setup

  echo -e ${MAIN}"==> Setting grub"${NC}
  sudo vi /etc/default/grub
  sudo update-grub
}


main()
{
  create_directories
  clone_repositories
  config_apt
  install_packages
  # install_cli_packages
  # install_lenovo_g580_drivers
  clone_dotfiles
  config_other
  other_settings
}

main
