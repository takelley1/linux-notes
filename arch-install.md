## ARCH LINUX INSTALL PROCESS <sup>[1][2][3]</sup>

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

1. Partition devices with fdisk.<br>
   ```bash
   fdisk /dev/vda
   ```
   - Ensure /dev/sda1 has label `EFI System Partition` and is 260-512M in size.

1. Create filesystems.<br>
   - EFI boot partition must be FAT32:
     ```bash
     mkfs.vfat -F32 /dev/sda1
     ```

1. Mount filesystems:<br>
   ```bash
   mount /dev/sda1 /mnt
   mkdir /mnt/boot
   mount /dev/sda2 /mnt/boot
   ```

1. Install base system:<br>
   ```bash
   pacstrap /mnt base linux linux-firmware man-db man-pages texinfo vim sshd
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

   myhostname
   ```
   ```
   /etc/hosts

   127.0.0.1	localhost
   ::1		    localhost
   127.0.1.1	myhostname.localdomain	myhostname
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

[1]: https://wiki.archlinux.org/index.php/Systemd-boot#Configuration
[2]: https://ramsdenj.com/2016/06/23/arch-linux-on-zfs-part-2-installation.html#install-system
[3]: https://wiki.archlinux.org/index.php/Installation_guide
