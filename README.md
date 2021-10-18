# marchis
This is a very barebones and beginner friendly script to install arch linux.
The script has two parts, the first part is to be run in the live disk install medium, and ends after chrooting into the install.
Then, the second part of the script should be run.

Method to run the scripts would be something like this:
```console
root@archiso ~ # pacman -Sy git
root@archiso ~ # git clone https://github.com/jnishwanth/marchis.git
root@archiso ~ # bash script1.sh
```
```console
[root@archiso /]# pacman -S git
[root@archiso /]# git clone https://github.com/jnishwanth/marchis.git
[root@archiso /]# bash script2.sh
```

Read the [Installation Guide](https://wiki.archlinux.org/title/Installation_guide) on the arch wiki for more information and learn how to customize the script.
