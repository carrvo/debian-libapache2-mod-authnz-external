# Location of apxs command:
#APXS=apxs2
APXS=apxs

TAR= README INSTALL INSTALL.HARDCODE CHANGES CONTRIBUTORS AUTHENTICATORS UPGRADE TODO \
	mod_authnz_external.c test/* Makefile

version = $(error version is not set)

.DEFAULT_GOAL:= debian-package
.PHONY: clean

download:
	mkdir quilt
	mkdir quilt/mod_authnz_external
	cp -R debian quilt/mod_authnz_external/
	cd quilt/mod_authnz_external && uscan

clean:
	sudo rm -rf quilt

debian-package-dependencies:
	sudo apt install build-essential fakeroot devscripts apxs apache2-dev dupload

debian-package-version:
	dch -v $(version)

debian-package: quilt/mod_authnz_external
	cp -R debian quilt/mod_authnz_external/
	cd quilt && tar -xvzf mod_authnz_externallibapache2-mod-authnz-external-$(version).tar.xz
	cp -R quilt/phokz-mod-auth-external-*/* quilt/mod_authnz_external/
	cd quilt/mod_authnz_external && debuild --rootcmd=sudo -us -uc

debsign:
	cd quilt && debsign libapache2-mod-authnz-external_$(version)_amd64.changes

dupload:
	cd quilt && dupload --to debian-mentors
