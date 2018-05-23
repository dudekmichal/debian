#!/usr/bin/env bash

echo "==> Setting global variables"
ROOT_UID=0
REPO="$HOME/repo/debian"

# clone repo to the correct location
if [[ ! -d $REPO ]]; then
    mkdir -p $HOME/repo
    git clone https://github.com/qeni/debian.git $REPO
fi;

# check if script is executed by non-root user
echo "==> Checking if not root"
if [[ "$UID" == "$ROOT_UID" ]]; then
  echo "Please run this script as a user"
  exit 126
fi

create_directories()
{
  echo "==> Creating directories"
  mkdir -p $HOME/tmp
  mkdir -p $HOME/mnt
  mkdir -p $HOME/documents
  mkdir -p $HOME/music
  mkdir -p $HOME/movies
  mkdir -p $HOME/download
  mkdir -p $HOME/repo
  mkdir -p $HOME/pictures/screenshots
}

clone_repositories()
{
  echo "==> Cloning repositories"
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
  echo "==> Installing packages"
  # non-free wireless driver for Lenovo G580: firmware-brcm80211
  sudo apt install xserver-xorg xinit \
  feh alsa-utils electrum hedgewars xbacklight libnotify gcalcli \
  vim-nox cmake curl exuberant-ctags lua5.2 xfonts-terminus console-setup \
  python3 python gcc cmake zsh acpi nethack-console python-autopep8 \
  leafpad mpv chromium git htop newsbeuter scrot youtube-dl rtorrent \
  texmaker texlive zathura mc ranger w3m w3m-img\
  i3lock i3 i3status rofi suckless-tools xterm irssi lxrandr help2man \
  dtrx p7zip unrar-free unzip ssh gmtp redshift fonts-font-awesome breeze-icon-theme \
  wicd-gtk wicd-curses links apg moc mutt \
  build-essential libncurses5-dev libssl-dev man-db mpd ncmpcpp mpc -y
}

install_cli_packages()
{
  echo "==> Installing packages"
  sudo apt install vim-nox xfonts-terminus console-setup \
  python3 python gcc cmake zsh acpi nethack-console python-autopep8 \
  git htop newsbeuter rtorrent mc ranger w3m w3m-img irssi dtrx \
  ssh wicd-curses links apg mutt build-essential \
  libncurses5-dev libssl-dev man-db mpd ncmpcpp mpc -y
}

clone_dotfiles()
{
  if [[ ! -d $HOME/repo/dotfiles ]]; then
    git clone https://github.com/qeni/dotfiles.git $HOME/repo/dotfiles
  fi;

  cp -R $HOME/repo/dotfiles/.* $HOME/
  rm -rf $HOME/repo/dotfiles
}

config_other()
{
  echo "==> Setting other packages"
  chsh -s /bin/zsh $USER
  xrdb -merge $HOME/.Xresources

  sudo mkdir -p /var/games/nethack

  git clone https://github.com/haikarainen/light $HOME/tmp/light
  cd $HOME/tmp/light
  make && sudo make install
  cd $HOME && rm -rf $HOME/tmp/light

  sudo mv ~/.mpd/mpd.conf /etc/mpd.conf
  sudo systemctl enable mpd
  sudo systemctl start mpd
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
  #install_cli_packages
  clone_dotfiles
  config_other
  other_settings
}

main
