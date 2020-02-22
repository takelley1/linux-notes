
## LATENCY <sup>[2]</sup> 

**see also:** [interactive latency](https://colin-scott.github.io/personal_website/research/interactive_latency.html)

```
Latency Comparison Numbers (~2012)
----------------------------------
L1 cache reference                           0.5 ns
Branch mispredict                            5   ns
L2 cache reference                           7   ns                      14x L1 cache
Mutex lock/unlock                           25   ns
Main memory reference                      100   ns                      20x L2 cache, 200x L1 cache
Compress 1K bytes with Zippy             3,000   ns        3 us
Send 1K bytes over 1 Gbps network       10,000   ns       10 us
Read 4K randomly from SSD*             150,000   ns      150 us          ~1GB/sec SSD
Read 1 MB sequentially from memory     250,000   ns      250 us
Round trip within same datacenter      500,000   ns      500 us
Read 1 MB sequentially from SSD      1,000,000   ns    1,000 us    1 ms  ~1GB/sec SSD, 4X memory
Disk seek                           10,000,000   ns   10,000 us   10 ms  20x datacenter roundtrip
Read 1 MB sequentially from disk    20,000,000   ns   20,000 us   20 ms  80x memory, 20X SSD
Send packet CA->Netherlands->CA    150,000,000   ns  150,000 us  150 ms
```

> memory is only about 6 times faster when you're doing sequential access (350 Mvalues/sec for memory compared with 58 Mvalues/sec for disk); but it's about 100,000 times faster when you're doing random access <sup>[3]</sup> 


---
## RAID <sup>[4]</sup> 

```
         ZFS Raid Speed Capacity and Performance Benchmarks
         
=============================================================================
                             SATA HARD DRIVES

 1x 4TB, single drive,          3.7 TB,  w=108MB/s , rw=50MB/s  , r=204MB/s 
 2x 4TB, mirror (raid1),        3.7 TB,  w=106MB/s , rw=50MB/s  , r=488MB/s 
 2x 4TB, stripe (raid0),        7.5 TB,  w=237MB/s , rw=73MB/s  , r=434MB/s 
 3x 4TB, mirror (raid1),        3.7 TB,  w=106MB/s , rw=49MB/s  , r=589MB/s 
 3x 4TB, stripe (raid0),       11.3 TB,  w=392MB/s , rw=86MB/s  , r=474MB/s 
 3x 4TB, raidz1 (raid5),        7.5 TB,  w=225MB/s , rw=56MB/s  , r=619MB/s 
 4x 4TB, 2 striped mirrors,     7.5 TB,  w=226MB/s , rw=53MB/s  , r=644MB/s 
 4x 4TB, raidz2 (raid6),        7.5 TB,  w=204MB/s , rw=54MB/s  , r=183MB/s 
 5x 4TB, raidz1 (raid5),       15.0 TB,  w=469MB/s , rw=79MB/s  , r=598MB/s 
 5x 4TB, raidz3 (raid7),        7.5 TB,  w=116MB/s , rw=45MB/s  , r=493MB/s 
 6x 4TB, 3 striped mirrors,    11.3 TB,  w=389MB/s , rw=60MB/s  , r=655MB/s 
 6x 4TB, raidz2 (raid6),       15.0 TB,  w=429MB/s , rw=71MB/s  , r=488MB/s 
10x 4TB, 2 striped 5x raidz,   30.1 TB,  w=675MB/s , rw=109MB/s , r=1012MB/s 
11x 4TB, raidz3 (raid7),       30.2 TB,  w=552MB/s , rw=103MB/s , r=963MB/s 
12x 4TB, 6 striped mirrors,    22.6 TB,  w=643MB/s , rw=83MB/s  , r=962MB/s 
12x 4TB, 2 striped 6x raidz2,  30.1 TB,  w=638MB/s , rw=105MB/s , r=990MB/s 
12x 4TB, raidz (raid5),        41.3 TB,  w=689MB/s , rw=118MB/s , r=993MB/s 
12x 4TB, raidz2 (raid6),       37.4 TB,  w=317MB/s , rw=98MB/s  , r=1065MB/s 
12x 4TB, raidz3 (raid7),       33.6 TB,  w=452MB/s , rw=105MB/s , r=840MB/s 
22x 4TB, 2 striped 11x raidz3, 60.4 TB,  w=567MB/s , rw=162MB/s , r=1139MB/s 
23x 4TB, raidz3 (raid7),       74.9 TB,  w=440MB/s , rw=157MB/s , r=1146MB/s
24x 4TB, 12 striped mirrors,   45.2 TB,  w=696MB/s , rw=144MB/s , r=898MB/s 
24x 4TB, raidz (raid5),        86.4 TB,  w=567MB/s , rw=198MB/s , r=1304MB/s 
24x 4TB, raidz2 (raid6),       82.0 TB,  w=434MB/s , rw=189MB/s , r=1063MB/s 
24x 4TB, raidz3 (raid7),       78.1 TB,  w=405MB/s , rw=180MB/s , r=1117MB/s 
24x 4TB, striped raid0,        90.4 TB,  w=692MB/s , rw=260MB/s , r=1377MB/s

================================================================================
                           SATA SOLID STATE DRIVES
                            
1x 256GB  a single drive  232 gigabytes ( w= 441MB/s , rw=224MB/s , r= 506MB/s )

2x 256GB  raid0 striped   464 gigabytes ( w= 933MB/s , rw=457MB/s , r=1020MB/s )
2x 256GB  raid1 mirror    232 gigabytes ( w= 430MB/s , rw=300MB/s , r= 990MB/s )

3x 256GB  raid5, raidz1   466 gigabytes ( w= 751MB/s , rw=485MB/s , r=1427MB/s )

4x 256GB  raid6, raidz2   462 gigabytes ( w= 565MB/s , rw=442MB/s , r=1925MB/s )

5x 256GB  raid5, raidz1   931 gigabytes ( w= 817MB/s , rw=610MB/s , r=1881MB/s )
5x 256GB  raid7, raidz3   464 gigabytes ( w= 424MB/s , rw=316MB/s , r=1209MB/s )

6x 256GB  raid6, raidz2   933 gigabytes ( w= 721MB/s , rw=530MB/s , r=1754MB/s )

7x 256GB  raid7, raidz3   934 gigabytes ( w= 591MB/s , rw=436MB/s , r=1713MB/s )

9x 256GB  raid5, raidz1   1.8 terabytes ( w= 868MB/s , rw=618MB/s , r=1978MB/s )
10x 256GB raid6, raidz2   1.8 terabytes ( w= 806MB/s , rw=511MB/s , r=1730MB/s )
11x 256GB raid7, raidz3   1.8 terabytes ( w= 659MB/s , rw=448MB/s , r=1681MB/s )

17x 256GB raid5, raidz1   3.7 terabytes ( w= 874MB/s , rw=574MB/s , r=1816MB/s )
18x 256GB raid6, raidz2   3.7 terabytes ( w= 788MB/s , rw=532MB/s , r=1589MB/s )
19x 256GB raid7, raidz3   3.7 terabytes ( w= 699MB/s , rw=400MB/s , r=1183MB/s )

24x 256GB raid0 striped   5.5 terabytes ( w=1620MB/s , rw=796MB/s , r=2043MB/s )
```


---
## SOLID-STATE MEMORY

- Non-volatile - memory that retains its data after power loss
  - **ROM** (Read Only Memory) - data not rewritable after manufacture, used in BIOS chips and embedded devices
    - PROM (Programmable Read Only Memory) - programmed by blowing internal fuses permanently
    - EPROM (Eletrically Programmable Read Only Memory) - programmed and erased using ultraviolet light
    - EEPROM (Electrically Eraseable Programmable Read Only Memory) - can be erased more times than EPROM
      - FRAM (Ferroelectric Random Access Memory) - type of EEPROM with unlimited writes 
  - **Flash** - easy to rewrite (like RAM), but nonvolatile (like ROM), used as a fast replacement for hard drives
    - NOR - flash based on NOR gates, used for code execution due to its execute-in-place (XIP) feature
    - NAND - based on NAND gates, cheaper and denser than NOR flash, used for data storage
      - V-NAND (Vertical NAND) / 3D NAND - stacks memory cells to increase density
      - SLC (Single-Level Cell) - NAND that stores only one bit per MOSFET memory cell
      - MLC (Multi-Level Cell), TLC (Triple), QLC (Quad) - NAND that stores multiple bits per cell, slower but cheaper than SLC
  - **NVRAM** (non-volatile RAM) - memory that acts like RAM but retains its data after losing power like Flash
    - 3D XPoint / Optane / QuantX - balances the performance and density of DRAM and flash, uses resistance rather than charge to store bits
    - FeRAM (Ferroelectric RAM)
    
![nand-vs-nor-flash](/images/nand-vs-nor-flash.jpg) <sup>[1]</sup> 
    
- Volatile - memory that loses its data after power loss, used as a working cache to store frequently-accessed data
  - **RAM** (Random Access Memory) - fast memory for storing running programs
    - SRAM (Static RAM) - expensive but fast, built into CPU dies to be used as L1-L3 caches
    - DRAM (Dynamic RAM) - cheaper than SRAM, but slower, used as main system memory
      - SDRAM (Synchronous DRAM) - RAM that synchronizes its clock with the CPU, most modern RAM is SDRAM
        - DDR (Double Data Rate) - double the transfer rate of RAM without increasing the clock
        - GDDR (Graphics DDR) - SDRAM designed for use with GPUs
        - HBM (High Bandwidth Memory) - 3D-stacked SDRAM for graphics and network devices

### Data Protocols

| Storage Spec | Data Bus             | Connector / Form Factor                          |
|--------------|----------------------|--------------------------------------------------|
| NVMe         | PCIe                 | M.2, mPCIe, U.2, PCIe                            |
| AHCI         | SATA, PATA, SAS, IDE | M.2, mPCIe, U.2, mSATA, 2.5in/3.5in SATA/SAS/IDE |

### Units of Measurement

| Name           | Mathematical Equivalent | # of Bytes                 |
|:---------------|:-----------------------:|:---------------------------|
| Gigabyte (GB)  | 10<sup>9</sup> bytes    | 1,000,000,000              |
| Gibibyte (GiB) | 2<sup>30</sup> bytes    | 1,073,741,824 (1 GB * 1.07)|
| Gigabit  (Gb)  | 10<sup>9</sup> bits     | 125,000,000 (1 GB / 8)     |


---
## MISC

#### How SSD storage over-provisioning works 

- The 7.37% Inherent OP (Over-Provisioning) is due to the fact that a GiB is 7.37% larger than a GB 
- The OS measures SSD size in GB, but NAND internally is measured in GiB, so the drive is actually 7.37% larger than what the OS sees 
- Factory-set OP is free space set by the manufacturer that cannot be partitioned by the OS 
- Dynamic OP is partitioned space that has not yet been used by the filesystem 

#### How VMWare snapshots work

In VMware VMs, the virtual disk is a .vmdk file residing on a data store (LUN). When a snapshot is created in Snapshot Manager,
the original disk becomes read-only, and all the new data changes are written into a temporary .vmdk delta disk, pointing to the 
original one. The delta disk is the difference between the current state of the virtual disk and the state at the moment the snapshot 
was taken. After a snapshot is deleted (committed), the .vmdk delta disk is merged with the original .vmdk file, and it returns to read-
write mode. 

- if the VM is reverted to the snapshot, the temporary .vmdk delta disk is simply deleted and the VM begins writing to its original disk 

- snapshots are not backups because if the original disk's data is lost, the delta .vmdk becomes useless as it only contains the changes 
to the original data, not the data itself 

[1]: https://www.embedded.com/flash-101-nand-flash-vs-nor-flash/  
[2]: https://colin-scott.github.io/personal_website/research/interactive_latency.html  
[3]: https://stackoverflow.com/questions/1371400/how-much-faster-is-the-memory-usually-than-the-disk  
[4]: https://calomel.org/zfs_raid_speed_capacity.html  

