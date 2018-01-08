#!/usr/bin/env bash

## Generates a password for the kernel cmdline
password=$( cat /dev/urandom| tr -dc a-zA-Z0-9 | fold -w 20 | head -n 1 )

echo "## Installing kexec-tools, aria2" && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --assume-yes --show-progress kexec-tools aria2 && \
    apt-get clean

echo "## Downloading RancherOS ISO" && \
    aria2c https://github.com/rancher/os/releases/download/v1.1.3/rancheros.iso

echo "## CRC Checksum of rancheros.iso - v1.1.3" && \
    sha256sum rancheros.iso  | grep  \
        6d53c39fa4d11851bdb22866f12fa8f1c1f6df044ede9c77c74e396902fa2f4c;
    [ $? -eq 0 ] && mount -t iso9660 rancheros.iso /mnt || echo bad iso image

echo "## Entering Mounted RancherOS ISO" && \
    [ -d /mnt/boot ] \
        && cd /mnt/ \
        || echo exit

echo "## Credentials: ${password}    (rancher)" && echo "## Kernel-Executing RancherOS" && echo "## Server will now get rebooted to boot the rancher installer and you can connct using ssh rancher@ip to install rancheros" && \
    kexec --initrd ./boot/initrd-v1.1.3 \
    --command-line="rancher.password=${password}" \
    ./boot/vmlinuz-4.9.24-rancher
