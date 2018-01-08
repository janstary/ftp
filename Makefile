#	$OpenBSD: Makefile,v 1.30 2016/05/06 22:06:09 jca Exp $
#	$OpenBSD: bsd.prog.mk,v 1.75 2017/07/21 11:00:24 schwarze Exp $
#	$NetBSD: bsd.prog.mk,v 1.55 1996/04/08 21:19:26 jtc Exp $
#	@(#)bsd.prog.mk	5.26 (Berkeley) 6/25/91
#	$OpenBSD: bsd.own.mk,v 1.187 2017/10/26 19:08:33 kettenis Exp $
#	$NetBSD: bsd.own.mk,v 1.24 1996/04/13 02:08:09 thorpej Exp $
#	$OpenBSD: bsd.man.mk,v 1.42 2017/07/21 15:18:35 espie Exp $
#	$NetBSD: bsd.man.mk,v 1.23 1996/02/10 07:49:33 jtc Exp $
#	@(#)bsd.man.mk	5.2 (Berkeley) 5/11/90

# Define SMALL to disable command line editing and https support
#CFLAGS+=-DSMALL

#CFLAGS+=	-Wall

PROG=	ftp
MAN1=	ftp.1
SRCS=	cmds.c cmdtab.c complete.c cookie.c domacro.c fetch.c ftp.c \
	list.c main.c ruserpass.c small.c stringlist.c util.c

LDADD+=	-ledit -lcurses -lutil -ltls -lssl -lcrypto
DPADD+=	${LIBEDIT} ${LIBCURSES} ${LIBUTIL} ${LIBTLS} ${LIBSSL} ${LIBCRYPTO}

#COPTS+= -Wall -Wconversion -Wstrict-prototypes -Wmissing-prototypes

BINGRP?=	bin
BINOWN?=	root
BINMODE?=	555
NONBINMODE?=	444
DIRMODE?=	755

MANDIR?=	/usr/share/man/man
MANGRP?=	bin
MANOWN?=	root
MANMODE?=	${NONBINMODE}

LIBDIR?=	/usr/lib
LIBGRP?=	${BINGRP}
LIBOWN?=	${BINOWN}
LIBMODE?=	${NONBINMODE}

DOCDIR?=	/usr/share/doc
DOCGRP?=	bin
DOCOWN?=	root
DOCMODE?=	${NONBINMODE}

INSTALL_COPY?=	-c
.ifndef DEBUG
INSTALL_STRIP?=	-s
.endif


.SUFFIXES: .out .o .c .cc .cpp .C .cxx .y .l .s

LIBCRYPTO?=	${DESTDIR}/usr/lib/libcrypto.a
LIBCURSES?=	${DESTDIR}/usr/lib/libcurses.a
LIBEDIT?=	${DESTDIR}/usr/lib/libedit.a
LIBSSL?=	${DESTDIR}/usr/lib/libssl.a
LIBTLS?=	${DESTDIR}/usr/lib/libtls.a
LIBUTIL?=	${DESTDIR}/usr/lib/libutil.a

OBJS+=	${SRCS:N*.h:N*.sh:R:S/$/.o/}

${PROG}: ${LIBCRT0} ${OBJS} ${LIBC} ${CRTBEGIN} ${CRTEND} ${DPADD}
	${CC} ${LDFLAGS} ${LDSTATIC} -o ${.TARGET} ${OBJS} ${LDADD}

all: ${PROG} ${PROGS} _SUBDIRUSE

clean:
	rm -f $(PROG) $(OBJS) *.core *~

install:
	${INSTALL} ${INSTALL_COPY} -S ${INSTALL_STRIP} \
	    -o ${BINOWN} -g ${BINGRP} \
	    -m ${BINMODE} ${PROG} ${DESTDIR}${BINDIR}/${PROG}

	${INSTALL} ${INSTALL_COPY} -o ${MANOWN} -g ${MANGRP} -m ${MANMODE} \
		${.ALLSRC} ${.TARGET}


# Explicitly list ${BEFOREMAN} to get it done even if ${MAN} is empty.
all: ${BEFOREMAN} ${MAN}

manlint: ${MAN}
.if defined(MAN) && !empty(MAN)
	mandoc -Tlint ${.ALLSRC}
.endif

.PHONY: manlint


# if we already got bsd.lib.mk we don't want to wreck that
.if !defined(_LIBS)
.s.o:
	${COMPILE.S} -MD -MF ${.TARGET:R}.d -o $@ ${.IMPSRC}

.S.o:
	${COMPILE.S} -MD -MF ${.TARGET:R}.d -o $@ ${.IMPSRC}
.endif

.include <bsd.obj.mk>
.include <bsd.dep.mk>
.include <bsd.subdir.mk>
.include <bsd.sys.mk>
