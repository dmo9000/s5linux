./999-cleanup.sh
./1-setup.sh
./rpmbuild-setup.sh
./heirloom-sourcecapture.sh

# the next section creates a minimal SVR4-like environment

./2-shell.sh
./3-devtools.sh
./4-utils.sh || exit 1
./5-pkgtools.sh

# GNU shell

# ./6-bash.sh

# minimal debugging tools if required
# ./7-coreutils.sh
# ./10-which.sh
# ./11-strace.sh

# initial system configs and bootstrap

./88-configs.sh
./89-copypkgs.sh

# finally bootstrap the image

./998-bootstrap.sh
