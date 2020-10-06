# GPU Passthrough
## Grub configuration  
Edit `/etc/default/grub`:  
`GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet iommu=pt amd_iommu=on rd.driver.pre=vfio-pci pcie_acs_override=downstream,multifunction vga=normal i915.modeset=0 nofb video=vesafb:off video=efifb:off"`  

## Modprobe configs  
All these are in different files:
```
# Blacklist
blacklist amdgpu
blacklist radeon
#blacklist nouveau
#blacklist nvidia
#options nouveau modeset=0

# iommu_interrupt
options vfio_iommu_type1 allow_unsafe_interrupts=1

# kvm
options kvm ignore_msrs=1

# vfio
options vfio-pci ids=1002:67df,1002:aaf0 disable_vga=1
```

## Find out IOMMU Group
Activate IOMMU and SR-IOV (if available).
```
#!/bin/bash
shopt -s nullglob
for g in /sys/kernel/iommu_groups/*; do
    echo "IOMMU Group ${g##*/}:"
    for d in $g/devices/*; do
        echo -e "\t$(lspci -nns ${d##*/})"
    done;
done;
```

## Improvements
* CPU Pinning
* Huge pages

## Nett to Know
* Get virtio driver and install them for mouse, keyboard and storage
* Install Win10 as Pro version, cause else you cant make an offline account
* USB redirectors are useful
* Check the box to start the virtual network on startup

See win10.conf and qemu.conf for configurations.


