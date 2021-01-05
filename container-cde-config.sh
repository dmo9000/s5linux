#!/bin/sh
set -e
export PATH=$PATH:/usr/5bin

cat << __REQUIRED_PKGS__ | tee /packages/cdeconfig.pkgs
S5LXgmp
S5LXmpfr
S5LXgawk
S5LXksh
__REQUIRED_PKGS__

/bootstrap.sh /packages/cdeconfig.pkgs
rm -f /packages/cdeconfig.pkgs

chown -R root:root /cde-2.3.2
/cde-2.3.2/admin/IntegTools/dbTools/installCDE -s /cde-2.3.2
yes | pkgrm S5LXsudo 1>/dev/null 2>&1
rm -rf /cde-2.3.2
rm -rf /tmp/CDE-*.{good,err,missing,lst}
mv installCDE.*.log /tmp/

