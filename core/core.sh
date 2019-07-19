#!/bin/sh
exec >&2
E() { echo Installation aborted!; exit 1; }
Q() { read -p "$*? [Y/n] " A; case $A in ""|[yY]);; *) exit;; esac; }
[ $# = 0 ] && Q Install kernel #REL# to /
/bin/sed '1,/^exit/d' $0 | /bin/tar -C ${1:-/} -xJf - || E
V=$(/bin/sed 's|^Linux version \([^ ]*\).*|\1|' /proc/version)
[ $# = 0 ] && Q Set the default kernel as #REL#
for F in vmlinuz initrd System.map config; do
	F=$1/boot/$F
	[ "x$V" = "x#REL#" ] || [ ! -f $F-$V ] || /bin/ln -f $F-$V $F-old || E
	/bin/ln -f $F-#REL# $F || E
done
[ $# = 0 ] && Q Remove unused kernels
F=$1/boot/config-old
[ -f $F ] && V=$(/bin/sed 's|^# Linux/x86 \([^ ]*\).*|\1|p;d' $F)
for F in $1/lib/modules/*; do
	case " $V #REL# " in *\ ${F##*/}\ *) continue;; esac
	/bin/rm -rf $F $1/boot/*-${F##*/}
done
[ "x${1:-/}" = x/ ] && /sbin/lilo
[ $# = 0 ] || exec /bin/rm $0
exit
