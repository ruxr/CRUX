#!/bin/sh
exec >&2
E() { echo Terminated by error!; exit 1; }
Q() { read -p "$*? [Y/n] " A; case $A in ""|[yY]);; *) exit;; esac; }
[ -n "$1" ] && N=$1 || N=/mnt
Q Use $N as the root of the temporary system
mkdir -p $N || E
mount -t tmpfs none $N || E
sed '1,/^exit/d' $0 | tar -C $N -xJf - || E
cp /etc/ssh/ssh_host* $N/etc/ssh || E
cp /etc/group /etc/hosts /etc/host.conf /etc/inputrc /etc/issue \
	/etc/login.defs /etc/motd /etc/nsswitch.conf /etc/passwd \
	/etc/resolv.conf /etc/rpc /etc/securetty /etc/shadow $N/etc || E
sed -i 's%/bin/bash%/bin/sh%' $N/etc/passwd || E
for M in /dev /proc /run /sys /tmp; do
        /bin/mountpoint -q $M && /bin/mount --rbind $M $N$M || E
done
Q Switch to temporary system in $N
T=$(tty)
cd $N
pivot_root . mnt || E
exec chroot . /sbin/init S <.$T >.$T 2>&1 || E
exit
