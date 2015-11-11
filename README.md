gantry
======
Deploy docker images on physical machines.

Description
-----------
*Please note that this README is a bad case of
[Readme Driven Development](rdd) (or rather Wishful Programming). None
of this is actually in working order yet.*

Gantry deploys docker images to virtual or physical
machines. Provisioning VMs using gantry allows you to reuse the docker
toolchain and is much faster than using debootstrap or similar tools.

Usage
-----
```bash
export VOLUME_GROUP=vg0
export VMNAME=bobinsky
export LVPATH=/dev/${VOLUME_GROUP}/${VMNAME}
sudo lvcreate -L 5G -n ${VMNAME} ${VOLUME_GROUP}
sudo mkfs.ext4 ${LVPATH}
sudo gantry --grub ${LVPATH} \
    --commmand 'apt-get update' \
    --command 'apt-get -y install grub-pc linux-image-amd64' \
    debian:jessie ${LVPATH}
```

Copyright
---------
Copyright (c) 2015 Sebastian Boehm. See [LICENSE](LICENSE) for
details.

[rdd]: http://tom.preston-werner.com/2010/08/23/readme-driven-development.html
