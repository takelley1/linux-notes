## ARCH LINUX INSTALL PROCESS <sup>[1][2][3]</sup>

1. If necessary, connect to a WLAN with iwd.

1. Set keyboard layout and clock:
   ```bash
   loadkeys us
   timedatectl set-ntp true
   ```

1. Configure proxies and certs if needed:
   1. Set proxies:
      ```bash
      export http_proxy="http://10.0.0.15:8080"
      export https_proxy="http://10.0.0.15:8080"
      ```
   1. Prepare system for scp:
      ```
      systemctl start sshd
      useradd --create-home temp
      passwd temp
      ```
   1. Transfer proxy cert to /home/temp from separate host using scp.
      ```bash
      scp cert.crt temp@<IP_ADDRESS>:~
      ```
   1. Add proxy cert to trust store:
      ```bash
      trust anchor /home/temp/cert.crt
      ```

1. Verify system is UEFI. BIOS systemd do not have this directory:
   ```bash
   ls /sys/firmware/efi/efivars
   ```

1. Partition devices with fdisk.
   ```bash
   fdisk /dev/sda
   ```
   - Ensure /dev/sda1 has label `EFI System Partition` and is 260-512M in size.

1. Create filesystems.
   - EFI boot partition must be FAT32:
     ```bash
     mkfs.vfat -F32 /dev/sda1
     ```

1. Mount filesystems:
   ```bash
   mount /dev/sda1 /mnt
   mkdir /mnt/boot
   mount /dev/sda2 /mnt/boot
   ```

1. Install base system:
   - \* Only install iwd if required to access WLAN networks.
   ```bash
   pacstrap /mnt base linux linux-firmware man-db man-pages texinfo sudo vim openssh iwd*
   ```

1. Generate fstab:
   ```bash
   genfstab -U /mnt >> /mnt/etc/fstab
   ```

1. Chroot into system:
   ```bash
   arch-chroot /mnt
   ```

1. Set timezone and localization settings:
   ```bash
   ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
   hwclock --systohc
   locale-gen

   echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
   echo "LANG=en_US.UTF-8" > /etc/locale.conf
   echo "KEYMAP=us" > /etc/vconsole.conf
   ```

1. Configure network:
   ```
   /etc/hostname

   hostname
   ```
   ```
   /etc/hosts

   127.0.0.1      localhost
   ::1        localhost
   127.0.1.1      hostname.domain hostname
   ```

1. Set root password:
   ```bash
   passwd
   ```

1. Install bootloader:
   ```bash
   bootctl --path=/boot install
   ```
   ```
   /boot/loader/entries/arch.conf

   title     Arch Linux
   linux     /vmlinuz-linux
   initrd    /initramfs-linux.img
   options   root=/dev/sda2 rw
   ```

1. Reboot

## POST-INSTALL NETWORK CONFIGURATION

1. Configure DNS
   1. Enable DNSSEC and configure DNS servers in in `/etc/systemd/resolved.conf`
   1. Start and enable resolved:
   ```bash
   systemctl enable systemd-resolved --now
   ```

1. Configure network
   - For LAN:
     1. Configure networkd unit file, see /usr/lib/systemd/network for examples.
     1. Start and enable systemd-networkd:
     ```bash
     systemctl enable systemd-networkd --now
     ```
   - For WLAN:
     1. Start and enable iwd:
     ```bash
     systemctl enable iwd --now
     ```
     1. Authenticate to WLAN:
     ```bash
     # See manpage for syntax:
     man iwctl
     ```

## POST-INSTALL USER CONFIGURATION

1. Start and enable homed:
   ```bash
   systemctl enable systemd-homed --now
   ```

1. Create user:
   ```bash
   homectl create austin --member-of=wheel --disk-space=75G --storage=luks
   ```

1. Create homed file for pam:
   ```
   /etc/pam.d/homed

   auth      sufficient  pam_systemd_home.so
   account   sufficient  pam_systemd_home.so
   password  sufficient  pam_systemd_home.so
   session   optional    pam_systemd_home.so
   ```

1. Reference homed in other pam files:
   ```
   /etc/pam.d/su

   #%PAM-1.0
   auth        include     homed
   auth        sufficient  pam_rootok.so
   auth        required    pam_unix.so
   account     include     homed
   account     required    pam_unix.so
   session     include     homed
   session     required    pam_unix.so
   ```
   ```
   /etc/pam.d/system-auth

   #%PAM-1.0
   auth      include   homed
   auth      required  pam_unix.so     try_first_pass nullok
   auth      optional  pam_permit.so
   auth      required  pam_env.so

   account   include   homed
   account   required  pam_unix.so
   account   optional  pam_permit.so
   account   required  pam_time.so

   password  include   homed
   password  required  pam_unix.so     try_first_pass nullok sha512 shadow
   password  optional  pam_permit.so

   session   include   homed
   session   required  pam_limits.so
   session   required  pam_unix.so
   session   optional  pam_permit.so
   ```
   ```
   /etc/pam.d/system-login

   #%PAM-1.0
   auth       required   pam_tally2.so        onerr=succeed file=/var/log/tallylog
   auth       required   pam_shells.so
   auth       include    homed
   auth       requisite  pam_nologin.so
   auth       include    system-auth

   account    required   pam_tally2.so 
   account    required   pam_access.so
   account    include    homed
   account    required   pam_nologin.so
   account    include    system-auth

   password   include    system-auth

   session    optional   pam_loginuid.so
   session    optional   pam_keyinit.so       force revoke
   session    include    system-auth
   session    optional   pam_motd.so          motd=/etc/motd
   session    optional   pam_mail.so          dir=/var/spool/mail standard quiet
   -session   optional   pam_systemd.so
   session    required   pam_env.so
   ```

[1]: https://wiki.archlinux.org/index.php/Systemd-boot#Configuration
[2]: https://ramsdenj.com/2016/06/23/arch-linux-on-zfs-part-2-installation.html#install-system
[3]: https://wiki.archlinux.org/index.php/Installation_guide
