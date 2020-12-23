#
# Sccsid @(#)heirloom-pkgtools.spec	1.7 (gritter) 5/27/07
#
Summary: The Heirloom Packacing Tools.
Name: heirloom-pkgtools
Version: 000000
Release: 2
License: Other
Source: %{name}-%{version}.tar.bz2
Group: System Environment/Base
Vendor: Gunnar Ritter <gunnarr@acm.org>
URL: <http://heirloom.sourceforge.net>
BuildRoot: %{_tmppath}/%{name}-root

%define	prefix		/usr/ccs
%define	bindir		%{prefix}/bin
%define	susdir		/usr/5bin/posix
%define	libdir		%{prefix}/lib
%define	mandir		%{prefix}/share/man

%define	xcc		gcc
%define	cflags		'-O -fomit-frame-pointer'
%define	cppflags	'-D__NO_STRING_INLINES -D_GNU_SOURCE'

#
# Combine the settings defined above.
#
%define	makeflags	ROOT=%{buildroot} INSTALL=install PREFIX=%{prefix} BINDIR=%{bindir} SUSDIR=%{susdir} LIBDIR=%{libdir} MANDIR=%{mandir} CC=%{xcc} CFLAGS=%{cflags} CPPFLAGS=%{cppflags}

%description

%global debug_package %{nil}

%prep
rm -rf %{buildroot}
%setup

%build
make %{makeflags} 

%install
mkdir -p %{buildroot}/usr/5bin/posix
mkdir -p %{buildroot}/usr/ccs/lib
make %{makeflags} install

rm -f filelist.rpm
#for f in %{bindir} %{susdir} %{libdir} %{mandir} %{prefix}/share %{prefix}/sadm/bin /usr/ccs/5bin 
#do
#	if test -d %{buildroot}/$f
#	then
#		(cd %{buildroot}/$f; find * -type f -o -type l) |
#			sed "s:^:$f/:" |
#			fgrep -v %{mandir}
#	else
#		echo $f
#	fi
#find %{buildroot} -type f
#done | sort -u | sed '
#	1i\
#%defattr(-,root,root)\
#%{mandir}\
#%doc README CHANGES LICENSE/*
#' >filelist.rpm

echo "%defattr(-,root,root)" > filelist.rpm
(cd %{buildroot} && find . ! -type d) | sed -e "s/^\.//" >>filelist.rpm

%clean
cd .. && rm -rf %{_builddir}/%{name}-%{version}
rm -rf %{buildroot}

%files -f filelist.rpm
