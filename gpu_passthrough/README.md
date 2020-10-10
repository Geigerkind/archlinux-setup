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

## Nvidia Error 43
Pascal graphic cards make problems. To resolve it change the vendor id, hide kvm and provide a ROM.  
https://github.com/Matoking/NVIDIA-vBIOS-VFIO-Patcher

## Nett to Know
* Get virtio driver and install them for mouse, keyboard and storage
* Install Win10 as Pro version, cause else you cant make an offline account
* USB redirectors are useful
* Check the box to start the virtual network on startup

See win10.conf and qemu.conf for configurations.

## LookingGlass
Install following packages: 
`pacman -Syu binutils sdl2 sdl2_ttf libx11 nettle fontconfig cmake spice-protocol gnu-free-fonts`
  
Download latest source from: `https://looking-glass.hostfission.com/downloads`
  
Compile and install the client binary.  

Edit VM configs and add below devices:
```
<shmem name='looking-glass'>
  <model type='ivshmem-plain'/>
  <size unit='M'>32</size>
</shmem>
```
Add a spice server and a Video Device with "none" to the VM configs.


Make sure that the VM Bios does not have Secure Boot enabled.

Install IVSHMEM Driver:
`"Device Manager" -> "System Devices" -> "PCI standard RAM Controller"`
Download it here: `https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/upstream-virtio/`

Download and install the Windows LookingGlass client from:
`https://looking-glass.hostfission.com/downloads`
