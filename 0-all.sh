# in the initial phase, we checkout the heirloom sources, apply many patches, 
# and capture the modified sources to tarballs both for the purposes of creating Redhat RPMS 
# for the bootstrapping Fedora system, and for later packaging in SVR4 format

./999-cleanup.sh
./1-setup.sh
./rpmbuild-setup.sh
./heirloom-sourcecapture.sh

# the next section installs a minimal SVR4-like environment, with everything statically linked
# these files will be overwritten once the SVR4 packages are installed during the bootstrap. 

./2-shell.sh
./3-devtools.sh
./4-utils.sh || exit 1
./5-pkgtools.sh

# copy initial system configs and packages 

./88-configs.sh
./89-copypkgs.sh

# finally bootstrap the image - comment out this step if you just want the minimal static SVR4 base

./998-bootstrap.sh
