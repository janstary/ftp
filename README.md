# ftp

This is a standalone version of [OpenBSD](http://www.openbsd.org)'s `ftp(1)`
to be used on other systems which don't have it, such as MacOS since 10.13,
or whose version is seriously outdated.

## instalation

Short story:

```
$ cd src && git clone git@github.com:janstary/ftp.git
$ cd ftp && ./configure && make
$ sudo make install
```

Long story: this version of ftp aims to be very portable.
It uses a build system borrowed from [mandoc](http://mandoc.bsd.lv/),
consisting of a simple Makefile and a hand-written `./configure` script,
accompanied by a set of trivial `have-*.c` programs
autodetecting the presence (or lack) of certain features,
and portable `compat-*.c` implementations for those not found
(mostly taken from OpenBSD).

### configuration

Run `./configure`. This will produce three files:

* `config.h` containing the `#include` and `HAVE_` lines
* `config.log` containing the details of autodetection
* `Makefile.local` defining `CC`, `PREFIX`, `LIBS` and the like

Read `./configure`'s standard output and `Makefile.local`.
If these look different from what you expected,
copy `configure.example` to `configure.local`,
override the autodetection, and run `./configure` again.

For example, you might need to edit `CFLAGS` and `LDFLAGS` to point to
the required libraries and their headers. In particular, you will need
a recent enough `libtls` from [LibreSSL](https://www.libressl.org/).
See `configure.example` for the details.

Read `config.h` and check that the `#define HAVE_*` lines
match your expectations.

Read `config.log`, which shows the actual compiler commands
used to test the presence of features on your system,
and their standard output and standard error output.
Failures are most likely to happen
if headers or libraries are installed in unusual places
or interfaces defined in unusual headers.

Please submit an issue here if any of the autodetection fails
or any of the compatibility functions dont't work.

### build and install

Run `make` to build `ftp`.
Run `make install` (or `sudo make install`)
to install the `ftp` binary and the `ftp.1` manpage.

## systems

These are the systems where I test this.
Please let me know if it doesn't work for you.

* MacOS 10.13.6
