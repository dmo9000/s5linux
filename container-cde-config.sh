#!/bin/sh
export PATH=$PATH:/usr/5bin
/bootstrap.sh /packages/ksh.pkgs
/cde-2.3.2/admin/IntegTools/dbTools/installCDE -s /cde-2.3.2
yes | pkgrm S5LXksh 1>/dev/null 2>&1
yes | pkgrm S5LXsudo 1>/dev/null 2>&1
rm -rf /cde-2.3.2
rm -rf /tmp/CDE-*.{good,err,missing,lst}
mv installCDE.*.log /tmp/

