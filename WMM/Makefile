# Makefile for WMM

CC = gcc
CFLAGS = -g -O2 -Wall -W -fPIC
LDFLAGS = -lm
LIBFLAGS = -static

# Library name
LIBNAME = libwmm

# Executable name
BINARIES = wmm_point wmm

LIBSRCFILES = WMM_SubLibrary.c
LIBOBJFILES = ${LIBSRCFILES:.c=.o}

all: ${BINARIES}

#lib: ${LIBNAME}.a ${LIBNAME}.so
#	ar rcs ${LIBNAME}.a ${LIBOBJFILES}
#	${CC} -shared -Wl,-soname,${LIBNAME}.so.1 -o ${LIBNAME}.so ${LIBOBJFILES}

%.la : %.lo
	libtool --mode=link ${CC} ${CFLAGS} -o $@ $<

%.lo: %.c
	libtool --mode=compile ${CC} ${CFLAGS} -c -o $@ $<

%.o: %.c
	libtool --mode=compile ${CC} ${CFLAGS} -c -o $@ $<

#${LIBNAME}.a: ${LIBOBJFILES}
#	ar rcs ${LIBNAME}.a ${LIBOBJFILES}

#${LIBNAME}.so: ${LIBOBJFILES}
#	${CC} -shared -Wl,-soname,${LIBNAME}.so.1 -o ${LIBNAME}.so ${LIBOBJFILES}

wmm_point: wmm_point.o libwmm.la
	libtool --mode=link ${CC} -o $@ $< libwmm.la ${LDFLAGS}

wmm: wmm.o libwmm.la
	libtool --mode=link ${CC} -o $@ $< libwmm.la ${LDFLAGS}

clean:
	rm -fr *.o .libs *.lo *.la *.o *.exe ${BINARIES}

