# My personal ports collection for [CRUX](https://crux.nu) Linux

## Goals

1. Support for upgrading *Linux CRUX* host software from one primary host
2. Live upgrade system to new *Linux CRUX* release
3. Network boot and installation *Linux CRUX*
4. Install the system in accordance with the specified functional role
5. Create individual *Linux CRUX* installation image

## Collection content

| Port | Description |
|---|---|
| bind | ISC Berkeley Internet Name Domain Service |
| brother_dcp1600 | Brother DCP-1600 printer driver |
| core | Linux kernel |
| dhcp | ISC DHCP server, client and relay agent |
| firefox-esr | Firefox Extended Support Release |
| i2c-tools | I2C Tools for Linux |
| iso | CRUX installation image |
| jwm | A lightweight window manager for the X11 Window System |
| libreoffice-ru | Full featured cross platform office suite for russian (binary) |
| live | Live-update script |
| locale | Russian system locales |
| lshw | Show detailed computer configuration information |
| net-snmp | SNMP daemon and client tools |
| ntp | Network Time Protocol software |
| p7-zip | File archiver with a high compression ratio |
| pkgnew | A set of shell scripts for administering packages |
| rdesktop | Open source client for Windows NT Terminal Server |
| rss | Reports/Restore shell scripts for administration |
| tftp-hpa | An enhanced version of the BSD tftp client/server |
| ucarp | Userspace implementation of the CARP protocol |
| xorg-font-paratype-ttf | ParaType font family with extended cyrillic and latin character sets |

## Quick start

```bash
cd /etc/ports
wget --no-ch https://raw.githubusercontent.com/ruxr/CRUX/master/ruxr.{httpup,pub}
ports -u ruxr
cd /usr/ports/ruxr/pkgnew
pkgmk -d -i
pkgnew -bd pkgnew core live rss
```

## Notes

1. Default URL for Linux CRUX distribution: *http://crux/CRUX-3.6*

2. To use **Apache HTTP** server as the *Linux CRUX* update service, check */etc/apache/httpd.conf*:

```
<VirtualHost crux:80>
	DocumentRoot "/var/www/crux"
	<Directory "/var/www/crux">
		Options Indexes FollowSymLinks MultiViews
		AllowOverride None
		Require all granted
	</Directory>
</VirtualHost>
```
and create symbolic link to *Linux CRUX* release:

```
$ ln -s $(bash -c '. /etc/pkgmk.conf; echo $PKGMK_PACKAGE_DIR') /var/www/crux/CRUX-3.6
```

3. To set up a TFTP-server for *Linux CRUX*, check */var/tftp/pxelinux.cfg/default*:
```
LABEL CRUX-3.6
	kernel boot/vmlinuz
	initrd boot/initramfs
	append quiet
```
and copy required files:
```
$ bsdtar -C /var/tftp -xf /var/www/crux/CRUX-3.6/CRUX-3.6.iso boot/{vmlinuz,initramfs}
```

4. To update Linux live to the *CRUX-3.6*, do:
```
$ wget http://crux/CRUX-3.6/CRUX-3.6-live.run
$ sh CRUX-3.6-live.run
```
