<h1 align="center">
 <img src="https://user-images.githubusercontent.com/45159366/107439772-7225c680-6ae7-11eb-90ae-05908496c8d1.png">
  <br />
  Debian configuration
</h1>

Script for automated configuration of fresh installed Debian.

Script also copies my personal dotfiles from [dudekmichal/dotfiles](https://github.com/dudekmichal/dotfiles).

```bash
$ ssk-keygen
$ mkdir ~/src
$ su -
$ apt install sudo git vim
$ vim /etc/sudoers 
  username ALL=(ALL) NOPASSWD:ALL
$ exit
$ git clone https://github.com/dudekmichal/debian.git ~/src/debian
$ bash ~/src/debian/debian.sh
```



