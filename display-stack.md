HIGHEST LEVEL
^^^^^^^^^^^^^

### Desktop Environment
implements the desktop metaphor and bundles together a variety of components, provides its own custom window manager 
- Plasma (used by KDE, Kubuntu)
- GNOME (used by Ubuntu, Fedora)
- MATE
- Xfce
- Cinnamon (used by Mint)
- Pantheon (used by ElementaryOS)

### Display Manager
manages the login screen 
- Console
- CDM
- Ly
- tbsm
- Graphical
- GDM (GNOME Display Manager)
- LightDM
- SDDM
- XDM

### Window Manager
controls the placement of windows within the desktop environment 
- Tiling: windows don't overlap
    - i3 (also allows stacking)
    - awesome
    - dwm (also allows stacking)
    - sway

- Stacking: windows can overlap
    - lwm
    - Wind
    - Openbox
    - Dynamic
    - xmonad

### Display server / Window System
system-level interface between desktop GUI and hardware
- X / X11 implementations
  - X.Org Server
  - XQuartz
- Wayland implementations (called compositors)
  - Weston (reference implementation of Wayland)
  - Mutter (also a Window Manager)
  - Enlightenment (also a Window Manager)
- Mir implementations
  - libmir-server / libmir-client 
 
vvvvvvvvvvvv
LOWEST LEVEL 
