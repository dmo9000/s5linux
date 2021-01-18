#!/bin/sh
#

# setup
#
set -e
#

PKGID=S5LXpostfix
PKG=postfix
VERSION=3.5.8
PKGNAME=${PKG}-${VERSION}
NPROC=`nproc`
TOPLEVEL=`pwd`
PKGDIR=${TOPLEVEL}/pkgbuild/${PKGNAME}
cd src
sudo rm -rf ./${PKGNAME}
#xzcat ${PKGNAME}.tar.xz > ${PKGNAME}.tar
tar -zxvf ${PKGNAME}.tar.gz
cd ${PKGNAME} 

# configure/build/install
#./configure --prefix=/usr 
AUXLIBS="-ldb -lnsl -lresolv" CFLAGS="-DNO_NIS -DNO_NISPLUS" make makefiles
AUXLIBS="-ldb -lnsl -lresolv" CFLAGS="-DNO_NIS -DNO_NISPLUS" make 
#AUXLIBS="-ldb -lnsl -lresolv" CFLAGS="-DNO_NIS -DNO_NISPLUS" make install install_root=${PKGDIR}
sudo /bin/sh ./postfix-install -non-interactive install_root=../../pkgbuild/postfix-3.5.8/

sudo mkdir -p ${PKGDIR}/etc/init.d
sudo cp ${TOPLEVEL}/lfs-bootscripts/blfs-bootscripts-20201002/blfs/init.d/postfix ${PKGDIR}/etc/init.d/postfix
sudo chmod 755 ${PKGDIR}/etc/init.d/postfix

sudo mkdir -p ${PKGDIR}/etc/rc0.d
sudo mkdir -p ${PKGDIR}/etc/rc5.d
sudo mkdir -p ${PKGDIR}/etc/rc6.d
cd ${PKGDIR}/etc/rc0.d && sudo ln -sf ../init.d/postfix ./K50postfix
cd ${PKGDIR}/etc/rc5.d && sudo ln -sf ../init.d/postfix ./S50postfix
cd ${PKGDIR}/etc/rc0.d && sudo ln -sf ../init.d/postfix ./K50postfix

cd ${TOPLEVEL}/src/${PKGNAME}

sudo /usr/bin/find ${PKGDIR}/var/spool/postfix -type d ! -name "pid" -exec chown postfix:root {} \;
sudo /bin/chgrp postdrop ${PKGDIR}/var/spool/postfix/{maildrop,public}

# package

cd ${PKGDIR}

PSTAMP=`date +"%Y%m%d%H%M%S"`

cat <<__PKGINFO__ > pkginfo
PKG=${PKGID}
NAME=${PKGNAME}
DESC=postfix
VENDOR=HeadRat Linux
VERSION=${VERSION}
ARCH=x86_64
CATEGORY=utilities
BASEDIR=/
PSTAMP=${PSTAMP}
__PKGINFO__

cat <<__POSTINSTALL__ > postinstall
#!/bin/sh
/usr/sbin/groupadd -g 89 postfix
/usr/sbin/groupadd -g 90 postdrop
/usr/sbin/useradd -u 89 -g 89 postfix
echo "/sbin/nologin" | /usr/bin/chsh -s /sbin/nologin postfix
/usr/sbin/usermod -a -G mail postfix
/usr/bin/find /var/spool/postfix -type d ! -name "pid" -exec chown postfix:root {} \;
/bin/chgrp postdrop /var/spool/postfix/{maildrop,public}
rm -f /usr/bin/newaliases
( cd /usr/bin && ln  -sf ../sbin/sendmail newaliases )
rm -f /usr/lib/sendmail
( cd /usr/lib && ln  -sf ../sbin/sendmail sendmail )
rm -f /usr/bin/mailq
( cd /usr/bin && ln  -sf ../sbin/sendmail mailq )
touch /etc/aliases
/usr/bin/newaliases
chgrp postdrop /usr/sbin/{postqueue,postdrop}
chown root /var/spool/postfix
chown postfix /var/lib/postfix
chmod g+s /usr/sbin/postqueue
chmod g+s /usr/sbin/postdrop
__POSTINSTALL__


../../mkproto.sh
../../mkpkg.sh
