       wget = /usr/bin/wget

     PREFIX = ${HOME}/PREFIX

     GVDEPS = ${PREFIX}/lib/libpango-1.0.so ${PREFIX}/lib/libpango-1.0.so \
	      ${PREFIX}/lib/libgts.so ${PREFIX}/lib/libgs.so \
	      ${PREFIX}/lib/librsvg.so ${PREFIX}/lib/libgs.so \
	      ${PREFIX}/lib/libtcl8.6.so ${PREFIX}/lib/libtk8.6.so \
	      ${PREFIX}/lib/libxml2.so ${PREFIX}/lib/libxslt.so

all: ${GVDEPS}

   AUTOCONF = autoconf-2.63.tar.gz
   AUTOMAKE = automake-1.10.1.tar.gz
      BISON = bison-2.3.tar.gz
      CAIRO = cairo-1.8.0.tar.gz
        CVS = cvs-1.11.23.tar.gz
      EXPAT = expat-2.0.1.tar.gz
  FINDUTILS = findutils-4.4.0.tar.gz
       FLEX = flex-2.5.35.tar.gz
 FONTCONFIG = fontconfig-2.6.0.tar.gz
   FREETYPE = freetype-2.3.7.tar.gz
       GAWK = gawk-3.1.5.tar.gz
         GD = gd-2.0.36RC1.tar.gz
    GETTEXT = gettext-0.17.tar.gz
GHOSTSCRIPT = ghostscript-8.63.tar.gz
       GLIB = glib-2.18.2.tar.gz
       GREP = grep-2.5.3.tar.gz
        GTK = gtk+-2.14.4.tar.gz
        GTS = gts-0.7.6.tar.gz
       GZIP = gzip-1.3.12.tar.gz
   LIBICONV = libiconv-1.12.tar.gz
     LIBPNG = libpng-1.2.31.tar.gz
    LIBRSVG = librsvg-2.22.3.tar.gz
    LIBTOOL = libtool-2.2.6a.tar.gz
    LIBXML2 = libxml2-sources-2.7.2.tar.gz
    LIBXSLT = libxslt-1.1.24.tar.gz
         M4 = m4-1.4.12.tar.gz
       MAKE = make-3.81.tar.gz
      PANGO = pango-1.22.0.tar.gz
     PIXMAN = pixman-0.12.0.tar.gz
  PKGCONFIG = pkg-config-0.23.tar.gz
        SED = sed-4.1.5.tar.gz
       SWIG = swig-1.3.35.tar.gz
        TAR = tar-1.20.tar.gz
        TCL = tcl8.6a3-src.tar.gz
         TK = tk8.6a3-src.tar.gz
       WGET = wget-1.11.4.tar.gz
       ZLIB = zlib-1.2.3.tar.gz

allsrc:	${AUTOCONF} ${AUTOMAKE} ${BISON} ${CAIRO} ${CVS} ${EXPAT} ${FINDUTILS} \
	${FLEX} ${FONTCONFIG} ${FREETYPE} ${GAWK} ${GD} ${GETTEXT} ${GHOSTSCRIPT} \
	${GLIB} ${GREP} ${GTK} ${GTS} ${GZIP} ${LIBICONV} ${LIBPNG} ${LIBRSVG} \
	${LIBTOOL} ${LIBXML2} ${LIBXSLT} ${M4} ${MAKE} ${PANGO} ${PIXMAN} \
	${PKGCONFIG} ${SED} ${SWIG} ${TAR} ${TCL} ${TK} ${WGET} ${ZLIB} 

${AUTOCONF}:
	${wget} ftp://ftp.gnu.org/pub/gnu/autoconf/${AUTOCONF}
${AUTOMAKE}:
	${wget} ftp://ftp.gnu.org/pub/gnu/automake/${AUTOMAKE}
${BISON}:
	${wget} ftp://ftp.gnu.org/pub/gnu/bison/${BISON}
${CAIRO}:
	${wget} http://www.cairographics.org/releases/${CAIRO}
${CVS}:
	${wget} http://ftp.gnu.org/non-gnu/cvs/source/stable/1.11.23/${CVS}
${EXPAT}:
	${wget} http://prdownloads.sourceforge.net/expat/${EXPAT}?download
${FINDUTILS}:
	${wget} ftp://ftp.gnu.org/pub/gnu/findutils/${FINDUTILS}
${FLEX}:
	${wget} http://prdownloads.sourceforge.net/flex/${FLEX}?download
${FONTCONFIG}:
	${wget} http://fontconfig.org/release/${FONTCONFIG}
${FREETYPE}:
	${wget} http://download.savannah.gnu.org/releases/freetype/${FREETYPE}
${GAWK}:
	${wget} ftp://ftp.gnu.org/pub/gnu/gawk/${GAWK}
${GD}:
	${wget} http://www.libgd.org/releases/${GD}
${GETTEXT}:
	${wget} ftp://ftp.gnu.org/pub/gnu/gettext/${GETTEXT}
${GHOSTSCRIPT}:
	${wget} http://ghostscript.com/releases/${GHOSTSCRIPT}
${GLIB}:
	${wget} http://ftp.gnome.org/pub/gnome/sources/glib/2.18/${GLIB}
${GREP}:
	${wget} ftp://ftp.gnu.org/pub/gnu/grep/${GREP}
${GTK}:
	${wget} http://ftp.gnome.org/pub/gnome/sources/gtk+/2.14/${GTK}
${GTS}:
	${wget} http://prdownloads.sourceforge.net/gts/${GTS}?download
${GZIP}:
	${wget} ftp://ftp.gnu.org/pub/gnu/gzip/${GZIP}
${LIBICONV}:
	${wget} ftp://ftp.gnu.org/pub/gnu/libiconv/${LIBICONV}
${LIBPNG}:
	${wget} http://prdownloads.sourceforge.net/libpng/${LIBPNG}?download
${LIBRSVG}:
	${wget} http://ftp.gnome.org/pub/GNOME/sources/librsvg/2.22/${LIBRSVG}
${LIBTOOL}:
	${wget} ftp://ftp.gnu.org/pub/gnu/libtool/${LIBTOOL}
${LIBXML2}:
	${wget} ftp://xmlsoft.org/libxml2/${LIBXML2}
${LIBXSLT}:
	${wget} ftp://xmlsoft.org/libxml2/${LIBXSLT}
${M4}:
	${wget} ftp://ftp.gnu.org/pub/gnu/m4/${M4}
${MAKE}:
	${wget} ftp://ftp.gnu.org/pub/gnu/make/${MAKE}
${PANGO}:
	${wget} http://ftp.gnome.org/pub/GNOME/sources/pango/1.22/${PANGO}
${PIXMAN}:
	${wget} http://www.cairographics.org/releases/${PIXMAN}
${PKGCONFIG}:
	${wget} http://pkg-config.freedesktop.org/releases/${PKGCONFIG}
${SED}:
	${wget} ftp://ftp.gnu.org/pub/gnu/sed/${SED}
${SWIG}:
	${wget} http://prdownloads.sourceforge.net/swig/${SWIG}
${TAR}:
	${wget} ftp://ftp.gnu.org/pub/gnu/tar/${TAR}
${TCL}:
	${wget} http://prdownloads.sourceforge.net/tcl/${TCL}
${TK}:
	${wget} http://prdownloads.sourceforge.net/tcl/${TK}
${WGET}:
	${wget} ftp://ftp.gnu.org/pub/gnu/wget/${WGET}
${ZLIB}:
	${wget} http://www.zlib.net/${ZLIB}


${PREFIX}:
	mkdir -p ${PREFIX}
	
BASETOOLS = ${PREFIX} ${PREFIX}/bin/bison ${PREFIX}/bin/flex ${PREFIX}/bin/grep \
	${PREFIX}/bin/make ${PREFIX}/bin/pkg-config ${PREFIX}/bin/sed \
	${PREFIX}/bin/tar ${PREFIX}/bin/tclsh ${PREFIX}/bin/wget 

#${PREFIX}/bin/gawk
#${PREFIX}/bin/gzip

CVSTOOLS = ${BASETOOLS} ${PREFIX}/bin/cvs ${PREFIX}/bin/autoconf ${PREFIX}/bin/automake \
	   ${PREFIX}/bin/libtoolize ${PREFIX}/bin/swig

${PREFIX}/bin/autoconf: ${AUTOCONF} ${BASETOOLS}
	zcat ${AUTOCONF} | tar xf -
	(cd `echo ${AUTOCONF} | sed s/.tar.gz//`; ./configure --prefix=${PREFIX}; make install)
${PREFIX}/bin/automake: ${AUTOMAKE} ${BASETOOLS}
	zcat ${AUTOMAKE} | tar xf -
	(cd `echo ${AUTOMAKE} | sed s/.tar.gz//`; ./configure --prefix=${PREFIX}; make install)
${PREFIX}/bin/bison: ${BISON} ${PREFIX}/bin/make
	zcat ${BISON} | tar xf -
	(cd `echo ${BISON} | sed s/.tar.gz//`; ./configure --prefix=${PREFIX}; make install)
${PREFIX}/lib/libcairo.so: ${CAIRO} ${BASETOOLS} ${PREFIX}/lib/libpixman-1.so ${PREFIX}/lib/libfreetype.so ${PREFIX}/lib/libpng.so
	zcat ${CAIRO} | tar xf -
	(cd `echo ${CAIRO} | sed s/.tar.gz//`; ./configure --prefix=${PREFIX} --disable-visibility --disable-xlib-xrender; make install)
${PREFIX}/bin/cvs: ${CVS} ${BASETOOLS}
	zcat ${CVS} | tar xf -
	(cd `echo ${CVS} | sed s/.tar.gz//`; ./configure --prefix=${PREFIX}; make install)
${PREFIX}/lib/libexpat.so: ${EXPAT} ${BASETOOLS}
	zcat ${EXPAT} | tar xf -
	(cd `echo ${EXPAT} | sed s/.tar.gz//`; ./configure --prefix=${PREFIX}; make install)
${PREFIX}/bin/findutils: ${FINDUTILS} ${BASETOOLS}
	zcat ${FINDUTILS} | tar xf -
	(cd `echo ${FINDUTILS} | sed s/.tar.gz//`; ./configure --prefix=${PREFIX}; make install)
${PREFIX}/bin/flex: ${FLEX} ${PREFIX}/bin/make
	zcat ${FLEX} | tar xf -
	(cd `echo ${FLEX} | sed s/.tar.gz//`; ./configure --prefix=${PREFIX}; make install)
${PREFIX}/lib/libfontconfig.so: ${FONTCONFIG} ${BASETOOLS} ${PREFIX}/lib/libfreetype.so ${PREFIX}/lib/libexpat.so
	zcat ${FONTCONFIG} | tar xf -
	(cd `echo ${FONTCONFIG} | sed s/.tar.gz//`; ./configure --prefix=${PREFIX} --disable-docs; make install)
${PREFIX}/lib/libfreetype.so: ${FREETYPE} ${BASETOOLS}
	zcat ${FREETYPE} | tar xf -
	(cd `echo ${FREETYPE} | sed s/.tar.gz//`; ./configure --prefix=${PREFIX}; make install)
${PREFIX}/bin/gawk: ${GAWK} ${PREFIX}/bin/make 
	zcat ${GAWK} | tar xf -
	(cd `echo ${GAWK} | sed s/.tar.gz//`; ./configure --prefix=${PREFIX}; make install)
${PREFIX}/lib/libgd.so: ${GD} ${BASETOOLS}
	zcat ${GD} | tar xf -
	(cd `echo ${GD} | sed s/.tar.gz//`; ./configure --prefix=${PREFIX}; make install)
${PREFIX}/lib/libgettextlib.so: ${GETTEXT} ${BASETOOLS}
	zcat ${GETTEXT} | tar xf -
	(cd `echo ${GETTEXT} | sed s/.tar.gz//`; ./configure --prefix=${PREFIX}; make install)
${PREFIX}/lib/libgs.so: ${GHOSTSCRIPT} ${BASETOOLS} ${PREFIX}/lib/libfontconfig.so
	zcat ${GHOSTSCRIPT} | tar xf -
	(cd `echo ${GHOSTSCRIPT} | sed s/.tar.gz//`; ./configure --prefix=${PREFIX} --disable-cups; make install)
${PREFIX}/lib/libglib-2.0.so: ${GLIB} ${BASETOOLS} ${PREFIX}/lib/libgettextlib.so
	zcat ${GLIB} | tar xf -
	(cd `echo ${GLIB} | sed s/.tar.gz//`; ./configure --prefix=${PREFIX} --disable-visibility; make install)
${PREFIX}/bin/grep: ${GREP} ${PREFIX}/bin/make 
	zcat ${GREP} | tar xf -
	(cd `echo ${GREP} | sed s/.tar.gz//`; ./configure --prefix=${PREFIX}; make install)
${PREFIX}/lib/libgtk+.so: ${GTK} ${BASETOOLS}
	zcat ${GTK} | tar xf -
	(cd `echo ${GTK} | sed s/.tar.gz//`; ./configure --prefix=${PREFIX}; make install)
${PREFIX}/lib/libgts.so: ${GTS} ${BASETOOLS}
	zcat ${GTS} | tar xf -
	(cd `echo ${GTS} | sed s/.tar.gz//`; ./configure --prefix=${PREFIX}; make install)
${PREFIX}/bin/gzip: ${GZIP} ${PREFIX}/bin/make
	zcat ${GZIP} | tar xf -
	(cd `echo ${GZIP} | sed s/.tar.gz//`; ./configure --prefix=${PREFIX}; make install)
${PREFIX}/lib/libiconv.so: ${LIBICONV} ${BASETOOLS}
	zcat ${LIBICONV} | tar xf -
	(cd `echo ${LIBICONV} | sed s/.tar.gz//`; ./configure --prefix=${PREFIX}; make install)
${PREFIX}/lib/libpng.so: ${LIBPNG} ${BASETOOLS}
	zcat ${LIBPNG} | tar xf -
	(cd `echo ${LIBPNG} | sed s/.tar.gz//`; ./configure --prefix=${PREFIX}; make install)
${PREFIX}/lib/librsvg.so: ${LIBRSVG} ${BASETOOLS}
	zcat ${LIBRSVG} | tar xf -
	(cd `echo ${LIBRSVG} | sed s/.tar.gz//`; ./configure --prefix=${PREFIX}; make install)
${PREFIX}/bin/libtoolize: ${LIBTOOL} ${BASETOOLS}
	zcat ${LIBTOOL} | tar xf -
	(cd `echo ${LIBTOOL} | sed s/.tar.gz// | sed s/a$$//`; ./configure --prefix=${PREFIX}; make install)
${PREFIX}/lib/libxml2.so: ${LIBXML2} ${BASETOOLS}
	zcat ${LIBXML2} | tar xf -
	(cd `echo ${LIBXML2} | sed s/.tar.gz//`; ./configure --prefix=${PREFIX}; make install)
${PREFIX}/lib/libxslt.so: ${LIBXSLT} ${BASETOOLS}
	zcat ${LIBXSLT} | tar xf -
	(cd `echo ${LIBXSLT} | sed s/.tar.gz//`; ./configure --prefix=${PREFIX}; make install)
${PREFIX}/bin/m4: ${M4} ${BASETOOLS}
	zcat ${M4} | tar xf -
	(cd `echo ${M4} | sed s/.tar.gz//`; ./configure --prefix=${PREFIX}; make install)
${PREFIX}/bin/make: ${MAKE} ${PREFIX}
	zcat ${MAKE} | tar xf -
	(cd `echo ${MAKE} | sed s/.tar.gz//`; ./configure --prefix=${PREFIX}; make install)
${PREFIX}/lib/libpango-1.0.so: ${PANGO} ${BASETOOLS} ${PREFIX}/lib/libglib-2.0.so ${PREFIX}/lib/libfontconfig.so ${PREFIX}/lib/libcairo.so
	zcat ${PANGO} | tar xf -
	(cd `echo ${PANGO} | sed s/.tar.gz//`; ./configure --prefix=${PREFIX} --disable-visibility; make install)
${PREFIX}/lib/libpixman-1.so: ${PIXMAN} ${BASETOOLS}
	zcat ${PIXMAN} | tar xf -
	(cd `echo ${PIXMAN} | sed s/.tar.gz//`; ./configure --prefix=${PREFIX}; make install)
${PREFIX}/bin/pkg-config: ${PKGCONFIG} ${PREFIX}/bin/make
	zcat ${PKGCONFIG} | tar xf -
	(cd `echo ${PKGCONFIG} | sed s/.tar.gz//`; ./configure --prefix=${PREFIX}; make install)
${PREFIX}/bin/sed: ${SED} ${PREFIX}/bin/make
	zcat ${SED} | tar xf -
	(cd `echo ${SED} | sed s/.tar.gz//`; ./configure --prefix=${PREFIX}; make install)
${PREFIX}/bin/swig: ${SWIG} ${BASETOOLS}
	zcat ${SWIG} | tar xf -
	(cd `echo ${SWIG} | sed s/.tar.gz//`; ./configure --prefix=${PREFIX}; make install)
${PREFIX}/bin/tar: ${TAR} ${PREFIX}/bin/make
	zcat ${TAR} | tar xf -
	(cd `echo ${TAR} | sed s/.tar.gz//`; ./configure --prefix=${PREFIX}; make install)
${PREFIX}/lib/libtcl8.6.so ${PREFIX}/bin/tclsh: ${TCL} ${PREFIX}/bin/make
	zcat ${TCL} | tar xf -
	(cd `echo ${TCL} | sed s/.tar.gz// | sed s/-src$$/\\\/unix/`; ./configure --prefix=${PREFIX}; make install)
${PREFIX}/lib/libtk8.6.so ${PREFIX}/bin/wish: ${TK} ${PREFIX}/bin/tclsh
	zcat ${TK} | tar xf -
	(cd `echo ${TK} | sed s/.tar.gz// | sed s/-src$$/\\\/unix/`; ./configure --prefix=${PREFIX}; make install)
${PREFIX}/bin/wget: ${WGET} ${PREFIX}/bin/make
	zcat ${WGET} | tar xf -
	(cd `echo ${WGET} | sed s/.tar.gz//`; ./configure --prefix=${PREFIX}; make install)
${PREFIX}/lib/libz.so: ${ZLIB} ${PREFIX}/bin/make
	zcat ${ZLIB} | tar xf -
	(cd `echo ${ZLIB} | sed s/.tar.gz//`; ./configure --prefix=${PREFIX} --shared; make install)


