# k-vernooy/dotfiles

<img src=https://forthebadge.com/images/badges/works-on-my-machine.svg height=30px> <img src=https://forthebadge.com/images/badges/powered-by-black-magic.svg height=30px>

## About
My dotfile organization repository! Contains config files for my current i3/Arch setup.

## Images
- WM: [i3-gaps](https://github.com/Airblader/i3)
- Compositor: [picom (ibhagwan's fork)](https://github.com/ibhagwan/picom)
- Status bar: [polybar](https://github.com/polybar/polybar)
- Notifications: [dunst](https://github.com/dunst-project/dunst)
![desktop images](screenshots/main.png)
- Terminal: urxvt
- *Applications in below image:* k-vernooy/tetris, cmatrix, cli-visualizer, htop, wttr.in, and vim
![desktop images](screenshots/urxvt.png)
- File manager: Thunar
- GTK Theme: Modified [sweet-dark](https://www.gnome-look.org/p/1253385/)
![desktop images](screenshots/gtk.png)
- App launcher/menus: [rofi](https://github.com/Davatorium/rofi)
![desktop images](screenshots/appmenu.png)
![desktop images](screenshots/powermenu.png)

## Notes
I'll have further instructions here about how to install everything. Until I get around that, note that:

- I'm using ibhagwan's picom fork, which can be installed from its repository. This is for rounded corners and dual-kawase blur.
- This is using Airblader's i3-gaps, not vanilla i3
- I found that Rofi needed to be built from source in order to get the latest icon functionality working; however this may no longer be necessary
- There's no install script, because I'd suggest doing the following manually to avoid conflicts with any files you may already have:
    - installing `/config/` to `$CONFIG`
    - installing `/home/` to `$HOME`
    - installing `/scripts/` to `~/Scripts/`
    - following instructions inside each `/apps/` subdir