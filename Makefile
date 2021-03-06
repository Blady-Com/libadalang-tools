# To build in production mode, do  "make LIBRARY_TYPE=static BUILD_MODE=prod".
# To build in development mode, do "make LIBRARY_TYPE=static BUILD_MODE=dev".

BUILD_MODE = dev
LIBRARY_TYPE = static
PROCESSORS = 0

.PHONY: all
all:
	which gprbuild
	which gcc
	gprbuild -v -k -XLIBRARY_TYPE=${LIBRARY_TYPE} -XXMLADA_BUILD=${LIBRARY_TYPE} \
		-XBUILD_MODE=${BUILD_MODE} -P src/build.gpr -p -j${PROCESSORS}

.PHONY: test
test: all
	bin/utils-var_length_ints-test

install-strip:
	mkdir -p "$(DESTDIR)"
	cp -r bin "$(DESTDIR)/"
	strip "$(DESTDIR)/bin/"*

.PHONY: clean
clean:
	rm -rf obj bin
