# Location of apxs command:
#APXS=apxs2
APXS=apxs

TAR= README INSTALL INSTALL.HARDCODE CHANGES CONTRIBUTORS AUTHENTICATORS UPGRADE TODO \
	mod_authnz_external.c test/* Makefile

version = $(error version is not set)

.DEFAULT_GOAL:= debian-package
.PHONY: clean

download:
	wget https://github.com/phokz/mod-auth-external/archive/mod_authnz_external-$(version).tar.gz
	tar -xvzf mod_authnz_external-$(version).tar.gz
	mv mod-auth-external-mod_authnz_external-$(version) libapache2-mod-authnz-external-$(version)

clean:
	rm -rf mod_authnz_external*
	rm -rf mod_auth_external*
	rm -rf libapache2-mod-authnz-external*

mae.tar: $(TAR)
	tar cvf mae.tar $(TAR)

debian-package-dependencies:
	sudo apt install build-essential fakeroot devscripts apxs apache2-dev

debian-package-version:
	dch -v $(version)

debian-package:
	debuild --rootcmd=sudo --no-tgz-check -us -uc
