PRJ=homecfg
VER=0.3
REL=1
PKG=${PRJ}-${VER}

FILES=homecfg \
		dist

.PHONY : dist

all: source dist
	
source: 
	if [[ -d /tmp/$(PKG) ]]; then rm -r /tmp/$(PKG); fi
	mkdir /tmp/$(PKG)
	cp -a $(FILES) /tmp/$(PKG)
	tar -C /tmp --exclude=*~ --exclude=.*.swp --exclude=homecfg-*.tar.gz -zcvf dist/homecfg-$(VER).tar.gz $(PKG)
	
dist: archlinux

archlinux: dist/arch/$(PKG)-$(REL)-any.pkg.tar.xz

dist/arch/$(PKG)-$(REL)-any.pkg.tar.xz:
	cd /tmp/$(PKG)/dist/arch; \
	md5=`makepkg -g` && sed -i -e "s/^.*md5sums.*$$//g" PKGBUILD && echo "$$md5" >> PKGBUILD ; \
	makepkg -f  
	cp /tmp/$(PKG)/dist/arch/$(PKG)*.tar.xz dist/arch
	
