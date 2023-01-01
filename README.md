# xmonad

## Introduction

Xmonad is a  is minimal, stable, beautiful, and featureful tiling window manager. If you find yourself spending a lot of time organizing or managing windows, you may consider trying xmonad.

However, xmonad may have a steep learning curve. It can be somewhat difficult to configure if you're new to Haskell or xmonad.

## Some requirements

* xmonad 0.13
* xmonad-contrib 0.13
* [xmobar 0.24.5](https://github.com/jaor/xmobar)
* [dmenu 4.7](https://tools.suckless.org/dmenu/)
* [scrot 0.8](https://en.wikipedia.org/wiki/Scrot)

### Installing requirements on [Arch Linux](https://www.archlinux.org/)

    sudo pacman -S xmonad xmonad-contrib xmobar dmenu scrot \
        cabal-install xcompmgr



Once xmonad-config is installed, you also need to ensure you can actually
start xmonad.  The mechanism to do this varies based on each environment, but
here are some instructions for some common login managers.

### Starting xmonad from lightdm, xdm, kdm, or gdm

Note: You may need to choose "Custom xsession" or similar at the login screen.

    ln -s ~/.xmonad/xmonad-session-rc ~/.xsession
    # Logout, login from lightdm/xdm/kdm/gdm


### Starting xmonad from slim

    ln -s ~/.xmonad/xmonad-session-rc ~/.xinitrc
    # Logout, login from slim
