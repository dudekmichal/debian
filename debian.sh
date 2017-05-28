#!/usr/bin/env bash

echo "==> Setting global variables"
ROOT_UID=0
REPO="$HOME/repo/debian"
CONF="$REPO/config"

# check if executed as a user
echo "==> Checking if not root"
if [[ "$UID" == "$ROOT_UID" ]]; then
  whiptail --title "Arch config" --msgbox \
  "Please run this script as a user" 20 70
  exit 126
fi

# create directories
create_directories()
{
  echo "==> Creating directories"
  mkdir $HOME/tmp
  mkdir $HOME/mnt
  mkdir $HOME/documents
  mkdir $HOME/music
  mkdir $HOME/movies
  mkdir $HOME/downloads
  mkdir -p $HOME/repo
  mkdir -p $HOME/pictures/screenshots
}

clone_repositories()
{
  echo "==> Cloning repositories"
  # git clone git@gitlab.com:qeni/documents.git $HOME/repo/
  # git clone git@gitlab.com:qeni/sem_6.git $HOME/repo/
  # git clone git@gitlab.com:qeni/room-raspberry.git $HOME/repo/
}

config_apt()
{
  sudo sh -c "cat $CONF/sources.list > /etc/apt/sources.list"

  sudo apt update -y
  sudo apt upgrade -y
}

install_packages()
{
  echo "==> Installing packages"
  sudo apt xserver-xorg xinit \
  dmenu feh alsa-utils \
  vim cmake curl exuberant-ctags lua5.2 xfonts-terminus console-setup \
  python python2 gcc cmake zsh acpi nethack-console python-autopep8 \
  leafpad mpv chromium git htop newsbeuter scrot youtube-dl rtorrent \
  texmaker texlive zathura \
  i3lock i3 i3status suckless-tools xterm xbacklight irssi lxrandr \
  p7zip unrar-free unzip ssh gmtp redshift fonts-font-awesome -y
}

clone_dotfiles()
{
  cd $HOME
  git clone git@gitlab.com:qeni/dotfiles.git $HOME/.dotfiles
  mv -f $HOME/.dotfiles $HOME/
}

config_other()
{
  echo "==> Setting other packages"
  chsh -s /bin/zsh $USER
  xrdb -merge $HOME/.Xresources

  sudo mkdir -p /var/games/nethack
  sudo cp $CONF/record /var/games/nethack/record
}

copy_scripts()
{
  echo "==> Copying scripts"
  sudo cp $REPO/scripts/m /usr/local/bin/
  sudo cp $REPO/scripts/um /usr/local/bin/
  sudo cp $REPO/scripts/live-usb /usr/local/bin/
  sudo cp $REPO/scripts/take-screenshot /usr/local/bin/
  sudo cp $REPO/scripts/take-screenshot-s /usr/local/bin/
  sudo chmod +x /usr/local/bin/m
  sudo chmod +x /usr/local/bin/um
  sudo chmod +x /usr/local/bin/live-usb
  sudo chmod +x /usr/local/bin/take-screenshot
  sudo chmod +x /usr/local/bin/take-screenshot-s
}

other_settings()
{
  echo "==> Disabling beep"
  sudo rmmod pcspkr
  sudo sh -c "echo 'blacklist pcspkr' >> /etc/modprobe.d/blacklist"

  echo "==> Disabling capslock"
  setxkbmap -option caps:escape &

  echo "==> Setting console font"
  sudo dpkg-reconfigure console-setup

  echo "==> Setting grub"
  sudo vi /etc/default/grub
  sudo update-grub
}


main()
{
  create_directories
  clone_repositories
  config_apt
  install_packages
  clone_dotfiles
  config_other
  copy_scripts
  other_settings
}

main
