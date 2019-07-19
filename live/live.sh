#!/bin/sh
exec >&2
E() { echo Terminated by error!; exit 1; }
Q() { read -p "$*? [Y/n] " A; case $A in ""|[yY]);; *) exit;; esac; }
[ -n "$1" ] && N=$1 || N=/mnt
Q Use $N as the root of the temporary system
/bin/mkdir -p $N || E
/bin/mount -t tmpfs none $N || E
/bin/sed "1,/^exit/d" $0 | /bin/tar -C $N -xJf - || E
/bin/cp /etc/ssh/ssh_host* $N/etc/ssh || E
/bin/cp /etc/group /etc/hosts /etc/host.conf /etc/inputrc /etc/issue \
	/etc/login.defs /etc/motd /etc/nsswitch.conf /etc/passwd \
	/etc/resolv.conf /etc/rpc /etc/securetty /etc/shadow $N/etc || E
/bin/sed -i "s%/bin/bash%/bin/sh%" $N/etc/passwd || E
for M in /dev /dev/pts /dev/shm /proc /run /sys /tmp; do
        /bin/mountpoint -q $M && /bin/mount --bind $M $N$M || E
done
Q Switch to temporary system in $N
T=$(/usr/bin/tty)
cd $N
/sbin/pivot_root . mnt || E
exec /usr/bin/chroot . /sbin/init S <.$T >.$T 2>&1 || E
exit
