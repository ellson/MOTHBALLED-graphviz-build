       wget=/usr/bin/wget

   AUTOCONF=autoconf-2.63.tar.gz
   AUTOMAKE=automake-1.10.1.tar.gz
      BISON=bison-2.3.tar.gz
      CAIRO=cairo-1.8.0.tar.gz
        CVS=cvs-1.11.23.tar.gz
      EXPAT=expat-2.0.1.tar.gz
  FINDUTILS=findutils-4.4.0.tar.gz
       FLEX=flex-2.5.35.tar.gz
 FONTCONFIG=fontconfig-2.6.0.tar.gz
   FREETYPE=freetype-2.3.7.tar.gz
       GAWK=gawk-3.1.5.tar.gz
         GD=gd-2.0.36RC1.tar.gz
    GETTEXT=gettext-0.17.tar.gz
GHOSTSCRIPT=ghostscript-8.63.tar.gz
       GLIB=glib-2.18.2.tar.gz
       GREP=grep-2.5.3.tar.gz
        GTK=gtk+-2.14.4.tar.gz
        GTS=gts-0.7.6.tar.gz
       GZIP=gzip-1.3.12.tar.gz
   LIBICONV=libiconv-1.12.tar.gz
     LIBPNG=libpng-1.2.31.tar.gz
    LIBRSVG=librsvg-2.22.3.tar.gz
    LIBTOOL=libtool-2.2.6a.tar.gz
    LIBXML2=libxml2-sources-2.7.2.tar.gz
    LIBXSLT=libxslt-1.1.24.tar.gz
         M4=m4-1.4.12.tar.gz
       MAKE=make-3.81.tar.gz
      PANGO=pango-1.22.0.tar.gz
     PIXMAN=pixman-0.12.0.tar.gz
  PKGCONFIG=pkg-config-0.23.tar.gz
        SED=sed-4.1.5.tar.gz
       SWIG=swig-1.3.35.tar.gz
        TAR=tar-1.20.tar.gz
        TCL=tcl8.6a3-src.tar.gz
         TK=tk8.6a3-src.tar.gz
       WGET=wget-1.11.4.tar.gz
       ZLIB=zlib-1.2.3.tar.gz

all:	${AUTOCONF} ${AUTOMAKE} ${BISON} ${CAIRO} ${CVS} ${EXPAT} ${FINDUTILS} \
	${FLEX} ${FONTCONFIG} ${FREETYPE} ${GAWK} ${GD} ${GETTEXT} ${GHOSTSCRIPT} \
	${GLIB} ${GREP} ${GTK} ${GTS} ${GZIP} ${LIBICONV} ${LIBPNG} ${LIBRSVG} \
	${LIBTOOL} ${LIBXML2} ${LIBXSLT} ${M4} ${MAKE} ${PANGO} ${PIXMAN} \
	${PKGCONFIG} ${SED} ${SWIG} ${TAR} ${TCL} ${TK} ${WGET} ${ZLIB} 

${AUTOCONF}: ${wget}
	wget ftp://ftp.gnu.org/pub/gnu/autoconf/${AUTOCONF}
${AUTOMAKE}: ${wget}
	wget ftp://ftp.gnu.org/pub/gnu/automake/${AUTOMAKE}
${BISON}: ${wget}
	wget ftp://ftp.gnu.org/pub/gnu/bison/${BISON}
${CAIRO}: ${wget}
	wget http://www.cairographics.org/releases/${CAIRO}
${CVS}: ${wget}
	wget http://ftp.gnu.org/non-gnu/cvs/source/stable/1.11.23/${CVS}
${EXPAT}: ${wget}
	wget http://prdownloads.sourceforge.net/expat/${EXPAT}?download
${FINDUTILS}: ${wget}
	wget ftp://ftp.gnu.org/pub/gnu/findutils/${FINDUTILS}
${FLEX}: ${wget}
	wget http://prdownloads.sourceforge.net/flex/${FLEX}?download
${FONTCONFIG}: ${wget}
	wget http://fontconfig.org/release/${FONTCONFIG}
${FREETYPE}: ${wget}
	wget http://download.savannah.gnu.org/releases/freetype/${FREETYPE}
${GAWK}: ${wget}
	wget ftp://ftp.gnu.org/pub/gnu/gawk/${GAWK}
${GD}: ${wget}
	wget http://www.libgd.org/releases/${GD}
${GETTEXT}: ${wget}
	wget ftp://ftp.gnu.org/pub/gnu/gettext/${GETTEXT}
${GHOSTSCRIPT}: ${wget}
	wget http://ghostscript.com/releases/${GHOSTSCRIPT}
${GLIB}: ${wget}
	wget http://ftp.gnome.org/pub/gnome/sources/glib/2.18/${GLIB}
${GREP}: ${wget}
	wget ftp://ftp.gnu.org/pub/gnu/grep/${GREP}
${GTK}: ${wget}
	wget http://ftp.gnome.org/pub/gnome/sources/gtk+/2.14/${GTK}
${GTS}: ${wget}
	wget http://prdownloads.sourceforge.net/gts/${GTS}?download
${GZIP}: ${wget}
	wget ftp://ftp.gnu.org/pub/gnu/gzip/${GZIP}
${LIBICONV}: ${wget}
	wget ftp://ftp.gnu.org/pub/gnu/libiconv/${LIBICONV}
${LIBPNG}: ${wget}
	wget http://prdownloads.sourceforge.net/libpng/${LIBPNG}?download
${LIBRSVG}: ${wget}
	wget http://ftp.gnome.org/pub/GNOME/sources/librsvg/2.22/${LIBRSVG}
${LIBTOOL}: ${wget}
	wget ftp://ftp.gnu.org/pub/gnu/libtool/${LIBTOOL}
${LIBXML2}: ${wget}
	wget ftp://xmlsoft.org/libxml2/${LIBXML2}
${LIBXSLT}: ${wget}
	wget ftp://xmlsoft.org/libxml2/${LIBXSLT}
${M4}: ${wget}
	wget ftp://ftp.gnu.org/pub/gnu/m4/${M4}
${MAKE}: ${wget}
	wget ftp://ftp.gnu.org/pub/gnu/make/${MAKE}
${PANGO}: ${wget}
	wget http://ftp.gnome.org/pub/GNOME/sources/pango/1.22/${PANGO}
${PIXMAN}: ${wget}
	wget http://www.cairographics.org/releases/${PIXMAN}
${PKGCONFIG}: ${wget}
	wget http://pkg-config.freedesktop.org/releases/${PKGCONFIG}
${SED}: ${wget}
	wget ftp://ftp.gnu.org/pub/gnu/sed/${SED}
${SWIG}: ${wget}
	wget http://prdownloads.sourceforge.net/swig/${SWIG}
${TAR}: ${wget}
	wget ftp://ftp.gnu.org/pub/gnu/tar/${TAR}
${TCL}: ${wget}
	wget http://prdownloads.sourceforge.net/tcl/${TCL}
${TK}: ${wget}
	wget http://prdownloads.sourceforge.net/tcl/${TK}
${WGET}: ${wget}
	wget ftp://ftp.gnu.org/pub/gnu/wget/${WGET}
${ZLIB}: ${wget}
	wget http://www.zlib.net/${ZLIB}
