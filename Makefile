PREFIX = /usr

all: check cursor

cursor:
	cd cursors-src/loginspinner/ && make

check: check-same-icon check-perm
	gtk-update-icon-cache gxde || exit 101
	gtk-update-icon-cache gxde-dark || exit 101
	-rm -f gxde/icon-theme.cache
	-rm -f gxde-dark/icon-theme.cache

check-name-unique:
	find gxde -name "*.svg" | xargs -n1 basename | sort | uniq -d | xargs -I '{}' find -name '{}'
	find gxde-dark -name "*.svg" | xargs -n1 basename | sort | uniq -d | xargs -I '{}' find -name '{}'
check-same-icon:
	find gxde -type f | xargs md5sum | sort | uniq --check-chars=32 -d
	find gxde-dark -type f | xargs md5sum | sort | uniq --check-chars=32 -d

check-perm: #hicolor-links
	@echo "Fix icon files permission"
	find gxde -type f -exec chmod 644 {} \;
	find gxde-dark -type f -exec chmod 644 {} \;

prepare: check-name-unique check-same-icon
	mkdir -p build

build: prepare convert

convert:
	mkdir -p build
	python tools/convert.py gxde build

clean:
	rm -rf build


install-icons:
	mkdir -p $(DESTDIR)$(PREFIX)/share/icons/gxde
	cp deepin $(DESTDIR)$(PREFIX)/share/icons/
	cp -r gxde/* $(DESTDIR)$(PREFIX)/share/icons/gxde
	mkdir -p $(DESTDIR)$(PREFIX)/share/icons/gxde-dark
	cp -r gxde-dark/* $(DESTDIR)$(PREFIX)/share/icons/gxde-dark

install-cursors:
	mkdir -p $(DESTDIR)$(PREFIX)/share/icons/gxde
	cp -r gxde/cursors $(DESTDIR)$(PREFIX)/share/icons/gxde
	install -m644 gxde/cursor.theme $(DESTDIR)$(PREFIX)/share/icons/gxde/cursor.theme

#hicolor-links:
#	./tools/hicolor.links gxde hicolor.list ./
