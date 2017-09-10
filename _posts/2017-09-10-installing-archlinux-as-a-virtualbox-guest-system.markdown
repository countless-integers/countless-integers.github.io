---
layout: post
title: Installing ArchLinux as a VirtualBox guest system
date: 2017-09-10
published: true
categories: linux
---

# Installing ArchLinux on a VirtualBox Machine

## Preparation
First things first -- obtain the Arch Linux installation media in form of an ISO volume from https://www.archlinux.org/download/.

Assuming you have VirtualBox already installed, create a new VM. ArchLinux is one of the recognized machine types in the VM creator form, so use it. Allocate some of your host machine resources to the machine, adjust accordingly to your rig's capabilities.

One thing I'm going to do, that might not be strictly necessary is to enable EFI under "System" settings (this is related to bootloader configuration described later in this article):

{% include image.html uri="/img/enable-eif-in-vbox.png" description="Enable EFI in VirtualBox settings panel" %}

One last this to remember -- if you enable input capturing inside VirtualBox window, remember you host key. On Windows it'll be the right "Ctrl" key, on MacOs the right "Cmd". Another useful thing: "Ctrl+Home" will open Vbox machine pop-up allowing you to do things like reboot and ejecting virtual devices (e.g. ArchLinux installation ISO image).

Now it's time to follow [ArchLinux installation guide](https://wiki.archlinux.org/index.php/Installation_guide) to the letter.

## Partitioning
I've went with a dynamically allocated 8gb storage volume for my virtual hard drive. I've also decided to go with GPT/EFI partitions.

According to most of the guides I could find, the suggested layout would look as follows:

1. `/boot` partition, 512 MiB in size at the begging
2. swap partition, min. 512 MiB in size
3. `/` partition using the remainder of the drive

To make this happen we can use a multitude of tools: `gdisk`, `fdisk`, `cfdisk`. Here is an example using `gdisk`.

    # gdisk /dev/sda

{% include image.html uri="/img/gdisk-partition-scan.png" description="Partition set-up in gdisk" %}

Running that will start a partition scan to assess the current state of drive's partitioning.

{% include image.html uri="/img/gpt-partitioning.png" description="Partition set-up in gdisk" %}

If you went through some trial and error when creating partitions, `gdisk` will kindly suggest to reboot (something `cfdisk` failed to do for me). Do so if necessary. In the end you should end up with:

{% include image.html uri="/img/ls-of-devs.png" description="List of storage devices" %}

## Formatting
Assuming the layout created above:

```
mkfs.fat -F32 /dev/sda1
mkswap /dev/sda2
mkfs.ext4 /dev/sda3
```
## Mount the partitions
```
# mount /dev/sda3 /mnt
# mkdir /mnt/boot
# mount /dev/sda1 /mnt/boot
# swapon /dev/sda2 # this should not be necessary because of genfstab
```

## Boostrap root partition
Time to install the basics:

    # pacstrap /mnt base

This will install the basic set of packages required to log in to the system.
To inform the newly bootstrap system of all the partitions we're going to use and have them mounted on boot:

    # genfstab -U /mnt >> /mnt/etc/fstab

This will generate a `fstab` file, referencing drives by their UUID (as an alternative to referencing them by their labels).

## Logging-in
Now we can finally log in to the system with:

    # arch-chroot /mnt

Well, technically changing root is not the same as logging in, more like, well changing root directory to a specified folder...

## Basic configuration

Time and localization options:

Uncomment `en_US.UTF-8 UTF-8` and others needed in `/etc/locale.gen` and run:

    # locale-gen

Then:

    # echo "LANG=en_US.UTF-8" > /etc/locale.conf

Set hostname:

    # echo vbox > /etc/hostname

I've used vbox, but you can use whatever. But whatever you use, remember it for this:

    # echo -e "\n127.0.1.1\tvbox.localdomain\tvbox" >> /etc/hosts

`-e` flag will make `echo` interpret escape character like `\t` and help to keep `/etc/hostnames` file consistently formatted.

Networking:

    # systemctl enable dhcpcd

for a wired connection. It's possible to set-up wireless, but I'll not cover this, because for a VBox install it does not seem practical.

XOrg and ALSA for audio-video capabilities:

    # pacman -S xf86-video-intel xf86-video-fbdev xorg-server xorg-xinit xorg-twm xterm alsa-utils pulseaudio pulseaudio-alsa

VirtualBox guest additions:

    # pacman -S virtualbox-guest-utils virtualbox-guest-modules-arch

This will allows us to change screen resolution and a couple of other useful things. [More about guest additions and what can they do.](https://wiki.archlinux.org/index.php/VirtualBox#Installation_steps_for_Arch_Linux_guests)

A window manager (I chose XFCE4 as a compromise between nice to use and light on resources):

    # pacman -S xfce4

Various stuff you might need:

    # pacman -S vim zsh rsync firefox atom terminator python3 nodejs git

Set up password for the root user (interactive command):

    # passwd

Add a non-root user:

    # useradd -m -g users -G adm,lp,wheel,power,audio,video -s /bin/zsh me
    # passwd me
    # EDITOR=vim visudo  # uncomment %wheel

where "me" is you (or whatever login you want to use). `wheel` is a sudoers group, why it's called like that, I do not know.

That should be enough to get started. So now:

```
exit
umount /mnt -R # -R because of /boot partition mounted in /mnt/boot
reboot
```

## Installing the bootloader
Arch guide lists this step near the end, but I decided to make it the first one, since this has been the most troublesome and confusing. Back in the day you would just install to MBR and things would be dandy:

    # pacman -S grub
    # grub-install /dev/sda

However this new madness of (U)EFI firmware came about and now it's more like:

```
# pacman -S grub efibootmgr
# grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub
```

Which should output something like this at the end:
```
Installation finished. No errors reported.
```

Then we can generate GRUB's config file:

    # grub-mkconfig -o /boot/grub/grub.cfg

If that goes well, we're set.

## First actual log-in
I'd recommend to login as the non-root users we created to test if that works correctly. If yes I'd also suggest to run:

    # sudo pacman -Syu

to test that `sudo` was configured properly and update the system at the same time.

Afterwards, we can try the window manager:

    # startxfce4

## Prosper
All is now set, ready to use and further customizations. Enjoy!

{% include image.html uri="/img/xfce-4.png" description="End result -- XFCE 4 running at ArchLinux guest VirtualBox installation" %}

## Extra references

* https://unix.stackexchange.com/questions/288865/file-system-boot-is-not-a-fat-efi-system-partition-esp-file-system?answertab=active#tab-top
* already a bit outdated, but still useful: https://raw.githubusercontent.com/midfingr/youtube_notes/master/arch_way
* https://wiki.archlinux.org/index.php/Installation_guide
* https://wiki.archlinux.org/index.php/GRUB/EFI_examples
* https://wiki.archlinux.org/index.php/GRUB#Check_if_you_have_GPT_and_an_ESPo
* https://wiki.archlinux.org/index.php/VirtualBox#Installation_steps_for_Arch_Linux_guests
* https://wiki.archlinux.org/index.php/Xorg#Installation
* https://wiki.archlinux.org/index.php/partitioning#GUID_Partition_Table
