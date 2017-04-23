#!/usr/bin/env bash

## Generates a password for the kernel cmdline
password=$( cat /dev/urandom| tr -dc a-zA-Z0-9 | fold -w 20 | head -n 1 )

echo "## Installing kexec-tools, aria2" && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --assume-yes --show-progress kexec-tools aria2 && \
    apt-get clean

echo "## Downloading RancherOS ISO" && \
    aria2c https://github.com/rancher/os/releases/download/v1.0.1-rc1/rancheros.iso

echo "## CRC Checksum of rancheros.iso - v1.0.1-rc1" && \
    sha256sum rancheros.iso  | grep  \
        32d21537378de2a7e5799e46ba7f5fa7e0afd28dde69e5f9370f34c67d5f6620;
    [ $? -eq 0 ] && mount -t iso9660 rancheros.iso /mnt || echo bad iso image


echo "## Entering Mounted RancherOS ISO" && \
    [ -d /mnt/boot ] \
        && cd /mnt/ \
        || echo exit


echo "## Credentials: ${password}    (rancher)" && echo "##  Kernel-Executing RancherOS" && \
    kexec --initrd ./boot/initrd-v1.0.1-rc1 \
    --command-line="rancher.password=${password}" \
    ./boot/vmlinuz-4.9.22-rancher
