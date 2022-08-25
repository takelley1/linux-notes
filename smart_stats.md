## SMART

### Testing

- `smartctl -t long /dev/sdc` = Start a long HDD self test. After the test is done (could take 12+ hours), check the results with `smartctl -a /dev/sdc`.
<br><br>
- `smartctl -a /dev/ | grep Current_Pending_Sector`         = Pending sector reallocations.
- `smartctl -a /dev/ | grep Reallocated_Sector_Ct`          = Reallocated sector count.
- `smartctl -a /dev/ | grep UDMA_CRC_Error_Count`           = UDMA CRC errors.
- `diskinfo -wS`                                            = HDD and SSD write latency consistency (unformatted drives only!).
- `smartctl -a /dev/ | grep Power_On_Hours`                 = HDD and SSD hours.
- `nvmecontrol logpage -p 2 nvme0 | grep “Percentage used”` = NVMe percentage used.

### Field Names

- `Normalized value` = Commonly referred to as just "value". This is a most universal measurement, on the scale from 0
                       (bad) to some maximum (good) value. Maximum values are typically 100, 200 or 253. Rule of thumb
                       is: high values are good, low values are bad.
- `Threshold` = The minimum normalized value limit for the attribute. If the normalized value falls below the threshold,
                the disk is considered defective and should be replaced under warranty. This situation is called "T.E.C."
                (Threshold Exceeded Condition).
- `Raw value` = The value of the attribute as it is tracked by the device, before any normalization takes place. Some
                raw numbers provide valuable insight when properly interpreted. These cases will be discussed later on.
                Raw values are typically listed in hexadecimal numbers.

### [Attributes](https://www.z-a-recovery.com/manual/smart.aspx)

- `Reallocated sectors count`
  - How many defective sectors were discovered on drive and remapped to spare
    sectors. Low values in absence of other fault indications point to a disk
    surface problem. Raw value indicates the exact number of such sectors.
<br><br>
- `Current pending sectors count`
  - How many suspected defective sectors are pending "investigation." These will
    not necessarily be remapped. In fact, such sectors my be not defective at
    all (e.g. if some transient condition prevented reading of the sector, it
    will be marked "pending") - they will be then re-tested by the device
    off-line scan1 procedure and returned to the pool of serviceable sectors.
    Raw value indicates the exact number of such sectors.
<br><br>
- `Off-line uncorrectable sectors count`
  - Similar to "Reallocated sectors count". Indicates how many defective sectors
    were found during the off-line scan1.
<br><br>
- `Read error rate`, `read error retry rate`, `write error rate`, `seek error rate`
  - Rate at which the specified errors occur. Lower value indicates more errors.
    Retries do not necessarily indicate a persistent problem, but one should
    proceed with caution if any of these attributes is degraded.
<br><br>
- `Recalibration retries`
  - How often the drive is unable to recalibrate at the first attempt. Raw value
    may show the exact number of recalibration events (at least with some
    vendors) but this should be taken with a grain of salt.
<br><br>
- `Spin up time`
  - Low value indicates that a drive takes longer than expected to spin up to
    its rated speed. May indicate either a controller or a spindle bearing
    problem.
<br><br>
- `Spin retry count`
  - How many times the drive was unable to spin its platters up to the rated
    rotation speed in due time. Spin-up attempt was aborted and retried. This
    typically indicates severe controller or bearing problem, but may sometimes
    be caused by power supply problems.
<br><br>
- `Drive start/stop count`, `Power off/retract cycle count`
  - Estimation of drive wear. Vendor estimates the supposed device lifetime and
    the number of cycles. The value for these attributes is then computed based
    on this estimation. The T.E.C. condition with one of these attributes does
    not necessarily indicate a drive failure, but rather suggests that a drive
    should be considered unreliable due to the wear and tear. Raw values are
    typically just the count of events.
<br><br>
- `Power on hours count`, `Head flying hours count`
  - Normalized values are computed similar to the above. Despite what the name
    suggests, the raw value of the attribute is stored using all sorts of
    measurement units (hours, half-hours, or ten-minute intervals to name a few)
    depending on the manufacturer of the device.
<br><br>
- `Temperature`
  - Device temperature, if the appropriate sensor is fitted. Lowest byte of the
    raw value contains the exact temperature value (in Celsius).
<br><br>
- `Ultra DMA CRC error rate`
  - Low value of this attribute typically indicates that something is wrong with
    the connectors and/or cables. Disk-to-host transfers are protected by CRC
    error detection code when Ultra-DMA 66 or 100 is used. So if the data gets
    garbled between the disk and the host machine, the receiving controller
    senses this and the retransmission is initiated. Such a situation is called
    "UDMA CRC error." Once the problem is rectified (typically by replacing a
    cable), the attribute value returns to normal levels.
<br><br>
- `G-sense error rate`
  - Indicates if errors are occurring from physical shocks to the drive (either
    due to the environmental factors or due to improper installation). The hard
    drive must be fitted with the appropriate sensor to get information about
    the G-loads. This attribute is mainly limited to notebook (2.5") drives.
    Once the operation conditions are corrected, the attribute value will return
    to normal.
