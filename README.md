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
| core | Linux kernel |
| iso | CRUX installation image |
| live | Live-update script |
| locale | Russian system locales |
| pkgnew | A set of shell scripts for administering packages |
| rss | Reports/Restore shell scripts for administration |

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

1. Default URL for Linux CRUX distribution: *http://crux/CRUX-3.5*

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
$ ln -s $(bash -c '. /etc/pkgmk.conf; echo $PKGMK_PACKAGE_DIR') /var/www/crux/CRUX-3.5
```

3. To set up a TFTP-server for *Linux CRUX*, check */var/tftp/pxelinux.cfg/default*:
```
LABEL CRUX-3.5
	kernel boot/vmlinuz
	initrd boot/initrd
	append quiet
```
and copy required files:
```
$ cp /boot/{vmlinuz,initrd} /var/tftp/boot/
```

4. To update Linux live to the *CRUX-3.5*, do:
```
$ wget http://crux/CRUX-3.5/CRUX-3.5-live.run
$ sh CRUX-3.5-live.run
```
