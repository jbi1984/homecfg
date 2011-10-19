#General project info
PRJ=homecfg
VER:=$(shell grep VER= homecfg | cut -d = -f 2 | tr -d \")
PKG=${PRJ}-${VER}

#Archlinux package
PKGBUILD=dist/arch/PKGBUILD
ARCHREL:=$(shell grep pkgrel= $(PKGBUILD) | cut -d = -f 2)
ARCHPKG=dist/arch/$(PKG)-$(ARCHREL)-any.pkg.tar.xz

#Fun starts here
FILES=homecfg \
		dist


.PHONY : dist all source archlinux clean PKGBUILD

all: source dist
	
source: PKGBUILD
	if [[ -d /tmp/$(PKG) ]]; then rm -r /tmp/$(PKG); fi
	mkdir /tmp/$(PKG)
	cp -a $(FILES) /tmp/$(PKG)
	tar -C /tmp --exclude=*~ --exclude=.*.swp --exclude=homecfg-*.tar.gz -zcvf dist/homecfg-$(VER).tar.gz $(PKG)

#Replace version in PKGBUILD with $(VER)
PKGBUILD:
	sed -i -e 's/pkgver=.*$$/pkgver=$(VER)/'  $(PKGBUILD)
	
#Build all packages for different distributions
dist: archlinux

archlinux: $(ARCHPKG)

dist/arch/$(PKG)-$(ARCHREL)-any.pkg.tar.xz:
	cd /tmp/$(PKG)/dist/arch; \
	md5=`makepkg -g` && sed -i -e "s/^.*md5sums.*$$//g" PKGBUILD && echo "$$md5" >> PKGBUILD ; \
	makepkg -f  
	cp /tmp/$(PKG)/dist/arch/$(PKG)*.tar.xz dist/arch
	echo "Archlinux package is in /dist/arch/$(PKG)*.tar.xz"
	
#Delete files which are generated during build
clean:
	find . -name "*~" -delete
	rm dist/arch/$(PRJ)-*-any.pkg.tar.xz
	rm dist/$(PRJ)-*.tar.gz 

install: source
	cp homecfg ~/sbin
	chmod u+x,go-w,go-x ~/sbin/homecfg

