PRJ=homecfg
VER=0.3
FILES=homecfg \
		dist

all: source packages
	
source: 
	rm -r /tmp/${PRJ}-${VER}
	mkdir /tmp/${PRJ}-${VER}
	cp -a ${FILES} /tmp/${PRJ}-${VER}
	tar -C /tmp --exclude=*~ --exclude=.*.swp --exclude=homecfg-*.tar.gz -zcvf dist/homecfg-${VER}.tar.gz ${PRJ}-${VER}
	
packages: arch

arch:
	cd /tmp/${PRJ}-${VER}/dist/arch; \
	md5=`makepkg -g`&& \
	sed -i -e 's/^.*md5sums.*$$/${md5}/g' PKGBUILD ; \
	makepkg -f  
	cp /tmp/"${PRJ}-${VER}"/dist/arch/"${PRJ}-${VER}"*.tar.xz dist/arch
	
