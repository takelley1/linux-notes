
#### How VMWare snapshots work: 

In VMware VMs, the virtual disk is a .vmdk file residing on a data store (LUN). When a snapshot is created in Snapshot Manager,
the original disk becomes read-only, and all the new data changes are written into a temporary .vmdk delta disk, pointing to the 
original one. The delta disk is the difference between the current state of the virtual disk and the state at the moment the snapshot 
was taken. After a snapshot is deleted (committed), the .vmdk delta disk is merged with the original .vmdk file, and it returns to read-
write mode. 

- if the VM is reverted to the snapshot, the temporary .vmdk delta disk is simply deleted and the VM begins writing to its original disk 

- snapshots are not backups because if the original disk's data is lost, the delta .vmdk becomes useless as it only contains the changes 
to the original data, not the data itself 

 
### Storage protocols

| Storage Spec | Data Bus | Connector(s) |
|--------------|----------|--------------|
| NVMe         | PCIe     | M.2, mPCIe, U.2, or PCIe |
| AHCI         |SATA, PATA, SAS, or IDE | M.2, mPCIe, U.2, SATA, mSATA, SAS, or IDE |


| Name           | Mathematical Equivalent | # of Bytes     |
|:---------------|:-----------------------:|----------------|
| Gigabyte (GB)  | 10<sup>9</sup> bytes              | 1,000,000,000              |
| Gibibyte (GiB) | 2<sup>30</sup> bytes              | 1,073,741,824 (1 GB * 1.07)|
| Gigabit  (Gb)  | 10<sup>9</sup> bits               | 125,000,000 (1 GB / 8)     |


### Memory

- Non-volatile - memory that retains its data after power loss
  - ROM (Read Only Memory) – data not rewritable after manufacture - used in BIOS chips and embedded devices
    - PROM (Programmable Read Only Memory) - programmed only by blowing internal fuses permanently
    - EPROM (Eletrically Programmable Read Only Memory) - can be programed and erased using ultraviolet light
    - EEPROM (Electrically Eraseable Programmable Read Only Memory) – can be erased using a supply rail more times than EPROM
      - FRAM (Ferroelectric Random Access Memory) - type of EEPROM with unlimited writes 
  - Flash – easy to rewrite (like RAM), but nonvolatile (like ROM) - used as a fast replacement to hard drives
    - NOR - Flash based on NOR gates - used for code execution due to its execute-in-place (XIP) feature
    - NAND - Based on NAND gates, cheaper and denser than NOR flash - used for data storage
      - V-NAND (Vertical NAND) / 3D NAND - stacks memory cells to increase density
      - SLC (Single-Level Cell) - NAND that stores only one bit per memory cell - usually a single MOSFET
      - MLC (Multi-Level Cell), TLC (Triple), QLC (Quad) - NAND that stores multiple bits per cell, slower but denser than SLC
  - NVRAM (non-volatile RAM) - memory that acts like RAM but retains its data after losing power
    - 3D XPoint / Optane / QuantX - Balances performance/density of DRAM and flash, uses resistance rather than charge to store bits
    - FeRAM (Ferroelectric RAM)
    
![nand-vs-nor-flash](/linux/images/nand-vs-nor-flash.jpg) [1]
    
- Volatile - memory that loses its data after power loss - used as a working cache to store frequently-accessed data
  - RAM (Random Access Memory) - fast memory to store programs while powered on
    - DRAM (Dynamic RAM) - cheaper than SRAM, but slower, used as main PC memory
      - SDRAM (Synchronous DRAM) - RAM that synchronizes its clock with the CPU, most modern RAM is SDRAM
        - DDR (Double Data Rate) - Doubles transfer rate of RAM without increasing the clock
        - GDDR (Graphics DDR) - SDRAM designed for use with GPUs
        - HBM (High Bandwidth Memory) - 3D-stacked SDRAM for graphics and network devices
    - SRAM (Static RAM) - expensive but fast, used as caches in CPUs
    

How SSD storage over-provisioning works 

The 7.37% Inherent OP (Over-Provisioning) is due to the fact that a GiB is 7.37% larger than a GB 

The OS measures SSD size in GB, but NAND internally is measured in GiB, so the drive is actually 7.37% larger than what the OS sees 

Factory-set OP is free space set by the manufacturer that cannot be partitioned by the OS 

Dynamic OP is partitioned space that has not yet been used by the filesystem 


- [1] https://www.embedded.com/flash-101-nand-flash-vs-nor-flash/
