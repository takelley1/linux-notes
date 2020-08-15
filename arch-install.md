## ARCH LINUX INSTALL PROCESS <sup>[1][2][3]</sup>

1. If necessary, connect to a WLAN with iwd

1. Set keyboard layout and clock:<br>
   ```bash
   loadkeys us
   timedatectl set-ntp true
   ```

1. Configure proxies and certs if needed:<br>
   1. Set proxies:<br>
      ```bash
      export http_proxy="http://10.0.0.15:8080"
      export https_proxy="http://10.0.0.15:8080"
      ```
   1. Prepare system for scp:<br>
      ```
      systemctl start sshd
      useradd --create-home temp
      passwd temp
      ```
   1. Transfer proxy cert to /home/temp from separate host using scp.<br>
      ```bash
      scp cert.crt temp@<IP_ADDRESS>:~
      ```
   1. Add proxy cert to trust store:<br>
      ```bash
      trust anchor /home/temp/cert.crt
      ```

1. Verify system is UEFI. BIOS systemd do not have this directory:<br>
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
   pacstrap /mnt base linux linux-firmware man-db man-pages texinfo vim openssh iwd*
   ```

1. Generate fstab:<br>
   ```bash
   genfstab -U /mnt >> /mnt/etc/fstab
   ```

1. Chroot into system:<br>
   ```bash
   arch-chroot /mnt
   ```

1. Set timezone and localization settings:<br>
   ```bash
   ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
   hwclock --systohc
   locale-gen
   ```
   ```
   /etc/locale.conf

   LANG=en_US.UTF-8
   ```
   ```
   /etc/vconsole.conf

   KEYMAP=us
   ```

1. Configure network:<br>
   ```
   /etc/hostname

   hostname
   ```
   ```
   /etc/hosts

   127.0.0.1	  localhost
   ::1		  localhost
   127.0.1.1	  hostname.domain hostname
   ```

1. Set root password:<br>
   ```bash
   passwd
   ```

1. Install bootloader:<br>
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
   1. Start and enable resolved
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
     1. Start and enable iwd
     ```bash
     systemctl enable iwd --now
     ```
     1. Authenticate to WLAN
     ```bash
     # See manpage for syntax:
     man iwctl
     ```

[1]: https://wiki.archlinux.org/index.php/Systemd-boot#Configuration
[2]: https://ramsdenj.com/2016/06/23/arch-linux-on-zfs-part-2-installation.html#install-system
[3]: https://wiki.archlinux.org/index.php/Installation_guide
