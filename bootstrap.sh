#!/usr/5bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/5bin
cd /packages
for PKG in `/usr/5bin/cat /bootstrap.pkgs` ; do 
	PKGSIZE=`/usr/5bin/ls -sh /packages/${PKG}.pkg  | /usr/5bin/awk '{ print $1; }'`
	echo "Installing package ${PKG} (${PKGSIZE}) ... "
	( echo 1 && yes) | pkgadd -d ${PKG}.pkg  1>/dev/null 2>&1
	done

exit 0

