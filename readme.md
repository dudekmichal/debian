<h1 align="center">
 <img src="https://user-images.githubusercontent.com/45159366/107439772-7225c680-6ae7-11eb-90ae-05908496c8d1.png">
  <br />
  Debian configuration
</h1>

Script for automated configuration of fresh installed Debian. Script also copies my personal dotfiles from [dudekmichal/dotfiles](https://github.com/dudekmichal/dotfiles).

1. mkdir ~/repo
2. su
3. apt install sudo git vim
4. vim /etc/sudoers 
`username ALL=(ALL)`
or
`username ALL=(ALL) NOPASSWD:ALL` (unsafe)
5. exit
6. git clone https://github.com/dudekmichal/debian.git ~/repo/debian
7. bash ~/repo/debian/debian.sh