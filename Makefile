VERSION = 1.0.1
TARBALL = ftp-$(VERSION).tar.gz

include Makefile.local

FTP_SRCS =		\
	cmds.c		\
	cmds.h		\
	cmdtab.c	\
	complete.c	\
	cookie.c	\
	domacro.c	\
	extern.h	\
	fetch.c		\
	ftp.c		\
	ftp_var.h	\
	list.c		\
	main.c		\
	pathnames.h	\
	ruserpass.c	\
	small.c		\
	small.h		\
	stringlist.c	\
	stringlist.h	\
	util.c

FTP_OBJS =		\
	cmds.o		\
	cmdtab.o	\
	complete.o	\
	cookie.o	\
	domacro.o	\
	fetch.o		\
	ftp.o		\
	list.o		\
	main.o		\
	ruserpass.o	\
	small.o		\
	stringlist.o	\
	util.o

HAVE_SRCS =			\
	have-reallocarray.c	\
	have-strtonum.c

COMPAT_SRCS =			\
	compat-reallocarray.c	\
	compat-strtonum.c

COMPAT_OBJS =			\
	compat-reallocarray.o	\
	compat-strtonum.o

SRCS = $(FTP_SRCS) $(COMPAT_SRCS) $(HAVE_SRCS)
OBJS = $(FTP_OBJS) $(COMPAT_OBJS)

BINS = ftp
MANS = ftp.1

DIST = \
	LICENSE			\
	Makefile		\
	Makefile.depend		\
	configure		\
	$(SRCS)			\
	$(MANS)

all: $(BINS) $(MANS) Makefile.local

ftp: $(OBJS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(OBJS) $(LIBS)

#include Makefile.depend

.SUFFIXES: .c .o

.c.o:
	$(CC) $(CFLAGS) -c $<

lint: $(MANS)
	mandoc -Tlint -Wstyle $(MANS)

install: all
	install -d $(BINDIR) && install -m 0555 $(BINS) $(BINDIR)
	install -d $(MANDIR) && install -m 0444 $(MANS) $(MANDIR)

uninstall:
	cd $(BINDIR) && rm -f $(PROG)
	cd $(MANDIR) && rm -f $(MANS)

clean:
	rm -f $(BINS) $(OBJS)
	rm -rf $(TARBALL) ftp-$(VERSION) .dist
	rm -rf depend _depend .depend
	rm -rf *.dSYM *.core *~ .*~

distclean: clean
	rm -f Makefile.local config.*

Makefile.local config.h: configure $(HAVE_SRCS)
	@echo "$@ is out of date; please run ./configure"
	@exit 1

depend: config.h
	mkdep -f depend $(CFLAGS) $(FTP_SRCS)
	perl -e 'undef $$/; $$_ = <>; s|/usr/include/\S+||g; \
		s|\\\n||g; s|  +| |g; s| $$||mg; print;' \
		depend > _depend
	mv _depend depend

dist: $(TARBALL)
$(TARBALL): $(DIST)
	rm -rf .dist
	mkdir -p .dist/ftp-$(VERSION)/
	$(INSTALL) -m 0644 $(DIST) .dist/ftp-$(VERSION)/
	( cd .dist/ftp-$(VERSION) && chmod 755 configure )
	( cd .dist && tar czf ../$@ ftp-$(VERSION) )
	rm -rf .dist/

distcheck: dist
	rm -rf ftp-$(VERSION) && tar xzf $(TARBALL)
	( cd ftp-$(VERSION) && ./configure && make all )

.PHONY: install uninstall
.PHONY: clean distclean
.PHONY: dist distcheck
.PHONY: lint
