# Define SMALL to disable command line editing and https support
CFLAGS+=-DSMALL

CFLAGS+=	-Wall -pedantic
CPPFLAGS+=	-I/usr/local/include -I/opt/local/include
LDFLAGS+=	-L/usr/local/lib     -L/opt/local/lib

BINDIR=		$(PREFIX)/bin
MANDIR=		$(PREFIX)/man/man1

PROG=	ftp
MAN1=	ftp.1
SRCS=	cmds.c cmdtab.c complete.c cookie.c domacro.c fetch.c ftp.c \
	list.c main.c ruserpass.c small.c stringlist.c util.c
OBJS=	cmds.o cmdtab.o complete.o cookie.o domacro.o fetch.o ftp.o \
	list.o main.o ruserpass.o small.o stringlist.o util.o
LIBS=	-ledit -lcurses -lutil -ltls -lssl -lcrypto

all: $(PROG)
ftp: $(OBJS)
	$(CC) $(CFLAGS) $(CPPFLAGS) -o ftp $(OBJS) $(LIBS)

.SUFFIXES: .c .o
.c.o:
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $<

lint: $(MAN1)
	mandoc -Tlint -Wstyle $(MAN1)

install: $(PROG) $(MAN1)
	install -d $(BINDIR) && install -m 555 $(PROG) $(BINDIR)
	install -d $(MANDIR) && install -m 444 $(MAN1) $(MANDIR)

uninstall:
	cd $(BINDIR) && rm -f $(PROG)
	cd $(MANDIR) && rm -f $(MAN1)

clean:
	rm -f $(PROG) $(OBJS) *.core *~

