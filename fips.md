## FIPS

- `cat /proc/sys/crypto/fips_enabled` = Check if FIPS is enabled.

Disable/Enable FIPS:
1. Add `fips=1` or `fips=0` to `/etc/default/grub`
2. Run `grub2-mkconfig -o /boot/grub2/grub.cfg` (for BIOS) or `grub2-mkconfig -o /boot/efi/EFI/redhat/grub.cfg` (for UEFI)
