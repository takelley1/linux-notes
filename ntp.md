## NTP

- `date +%T –s "16:45:00"` = Manually set time in HH:mm:ss format.
- `date`                   = View current time.

### [Chrony](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/configuring_basic_system_settings/index#migrating-to-chrony_using-chrony-to-configure-ntp)

Show timekeeping stats:
```
[root@host]# chronyc tracking

Reference ID    : 9B1D9843 (hostname.domain)           # Source NTP server.
Stratum         : 4                                    # Number of NTP server hops to a root NTP server.
Ref time (UTC)  : Wed Dec 11 20:42:51 2019             # UTC time of NTP server.
System time     : 0.000126482 seconds slow of NTP time # Difference between host time and NTP server time.
Last offset     : -0.000039551 seconds                 # Changes made during chrony's last modification.
RMS offset      : 0.001020088 seconds                  # Long-term average offset.
Frequency       : 2.941 ppm fast                       # How much faster/slower the default system clock is from NTP server.
Residual freq   : -0.001 ppm                           # Difference between reference frequency and current frequency.
Skew            : 0.135 ppm                            # Margin of error on frequency.
Root delay      : 0.014488510 seconds                  # Network delay for packets to reach NTP server.
Root dispersion : 0.079814211 seconds
Update interval : 64.3 seconds                         # How frequently chrony modifies the system clock.
Leap status     : Normal                               # Whether a leap second is pending to be added/removed.
                                                       # 1 ppm = 1.000001 seconds.
```

- [Other useful commands](https://www.thegeekdiary.com/centos-rhel-7-tips-on-troubleshooting-ntp-chrony-issues/)
  - `chronyc sources -v`
  - `chronyc sourcestats`
  - `chronyc activity`
  - `timedatectl`
