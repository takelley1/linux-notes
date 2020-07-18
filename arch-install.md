## ARCH LINUX INSTALL PROCESS

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
   1. Add proxy cert to trust store:
      ```bash
      trust anchor /home/temp/cert.crt
      ```

1. Verify system is UEFI. BIOS systemd do not have this directory:
   ```bash
   ls /sys/firmware/efi/efivars
   ```

1. Partition devices with fdisk.
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
   ```bash
   pacstrap /mnt base linux linux-firmware man-db man-pages texinfo vim sshd
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
   ```
   ```
   /etc/locale.conf

   LANG=en_US.UTF-8
   ```
   ```
   /etc/vconsole.conf

   KEYMAP=us
   ```

1. Configure network:
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

[1]: https://wiki.archlinux.org/index.php/Systemd-boot#Configuration
[2]: https://ramsdenj.com/2016/06/23/arch-linux-on-zfs-part-2-installation.html#install-system
