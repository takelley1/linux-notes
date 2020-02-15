
### Desktop Environment

implements the desktop metaphor and bundles together a variety of components, provides its own custom window manager [1]
- KDE Plasma (default in Kubuntu)
- GNOME (default in Ubuntu, Fedora)
- MATE
- Xfce
- Cinnamon (used by Mint)
- Pantheon (used by ElementaryOS)

---
### Display Manager

manages the login screen [2]
- Console
  - CDM
  - Ly
  - tbsm
- Graphical
  - GDM (GNOME Display Manager) (default in GNOME)
  - LightDM
  - SDDM (used by Plasma)
  - XDM (X Display Manager)

---
### Window Manager

controls the placement of windows within the desktop environment, typically an X server client [3]
- Tiling: windows can't overlap
  - i3
  - Bspwm
- Stacking: windows *can* overlap
  - lwm
  - Wind
  - Openbox
- Dynamic: windows can both stack and tile
  - xmonad
  - awesome
  - dwm

---
### Display server / Window System

system-level interface between desktop GUI and hardware
- X / X11 Window System implementations
  - X.Org Server / Xorg (most common display server) [4]
  - XQuartz
- Wayland Display Server implementations (called compositors)
  - Weston (reference implementation of Wayland)
  - Mutter (also a Window Manager)
  - Enlightenment (also a Window Manager)
- Mir implementations
  - libmir-server / libmir-client

---
#### sources

[1] https://wiki.archlinux.org/index.php/Desktop_environment   
[2] https://wiki.archlinux.org/index.php/Display_manager   
[3] https://wiki.archlinux.org/index.php/Window_manager  
[4] https://wiki.archlinux.org/index.php/Xorg  

