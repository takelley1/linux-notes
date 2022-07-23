
### [Desktop Environment](https://wiki.archlinux.org/index.php/Desktop_environment)

Implements the desktop metaphor and bundles together a variety of components, provides its own custom window manager.
- KDE Plasma (default in Kubuntu)
- GNOME (default in Ubuntu, Fedora)
- MATE
- Xfce
- Cinnamon (used by Mint)
- Pantheon (used by ElementaryOS)

---
### [Display Manager](https://wiki.archlinux.org/index.php/Display_manager)

Manages the login screen.
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
### [Window Manager](https://wiki.archlinux.org/index.php/Window_manager)

Controls the placement of windows within the desktop environment, typically an X server client.
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

System-level interface between desktop GUI and hardware.
- X / X11 Window System implementations
  - [X.Org Server / Xorg (most common display server)](https://wiki.archlinux.org/index.php/Xorg)
  - XQuartz
<br><br>
- Wayland Display Server implementations (called compositors)
  - Weston (reference implementation of Wayland)
  - Mutter (also a Window Manager)
  - Enlightenment (also a Window Manager)
<br><br>
- Mir implementations
  - libmir-server / libmir-client
