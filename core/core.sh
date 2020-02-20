#!/bin/sh
/bin/sed '1,/^exit/d' $0 | /bin/tar -C ${1:-/} -xJf - || exit
B=$1/boot/
V=$(/bin/sed 's|^Linux version \([^ ]*\).*|\1|' /proc/version)
for F in vmlinuz initrd System.map config; do
	/bin/ln -f $B$F-#REL# $B$F
done
for F in $1/lib/modules/*; do
	case " $V #REL# " in *\ ${F##*/}\ *) continue;; esac
	/bin/rm -rf $F $B*-${F##*/}
done
exit
