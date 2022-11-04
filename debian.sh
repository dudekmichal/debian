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
if [[ "${UID}" == "${ROOT_UID}" ]]; then
  echo "Please run this script as a user"
  exit 126
fi

create_directories()
{
  echo -e ${MAIN}"==> Creating directories"${NC}
  mkdir -p $HOME/documents
  mkdir -p $HOME/download
  mkdir -p $HOME/movies
  mkdir -p $HOME/music
  mkdir -p $HOME/repo
  mkdir -p $HOME/tmp
  mkdir -p $HOME/mnt
  mkdir -p $HOME/pictures/screenshots
  mkdir -p $HOME/.mpd/playlists
  mkdir -p $HOME/.mpd/lyrics
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
  breeze-icon-theme links apg moc mutt \
  libssl-dev man-db mpd ncmpcpp mpc net-tools acpi network-manager \
  pulseaudio
}

install_cli_packages()
{
  echo -e ${MAIN}"==> Installing packages"${NC}
  sudo apt install vim-nox xfonts-terminus console-setup \
  python3 python gcc cmake zsh acpi nethack-console python-autopep8 \
  git htop newsbeuter rtorrent mc ranger w3m w3m-img irssi dtrx \
  ssh links apg mutt man-db mpd ncmpcpp mpc -y
}

install_gnome()
{
  sudo apt install gnome gnome-boxes
}

install_tweak_packages()
{
  sudo apt install faenza-icon-theme gnome-tweak-tool
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

  # systemctl --user enable mpd
  # systemctl --user start mpd
  # sudo systemctl enable NetworkManager.service
  # sudo systemctl start NetworkManager.service
}

other_settings()
{
  # echo -e ${MAIN}"==> Disabling beep"${NC}
  # sudo rmmod pcspkr
  # sudo sh -c "echo 'blacklist pcspkr' >> /etc/modprobe.d/blacklist"
  # sudo sh -c "cat config/inputrc > /etc/inputrc"

  echo -e ${MAIN}"==> Disabling capslock"${NC}
  setxkbmap -option caps:escape &

  echo -e ${MAIN}"==> Setting console font"${NC}
  sudo dpkg-reconfigure console-setup

  echo -e ${MAIN}"==> Setting grub"${NC}
  sudo vi /etc/default/grub
  sudo update-grub
}

install_drivers()
{
  # asus_ac51_driver
  sudo apt install firmware-misc-nonfree

  # RTX 2070
  sudo apt install nvidia-driver
}

install_dev_tools()
{
  sudo apt install build-essential libncurses-dev bison flex libssl-dev libelf-dev gcc vim git gnome-boxes
}

main()
{
  create_directories
  clone_repositories
  config_apt
  # install_packages
  install_dev_tools
  install_drivers
  install_gnome
  install_tweak_packages
  # install_cli_packages
  clone_dotfiles
  config_other
  other_settings
}

main
