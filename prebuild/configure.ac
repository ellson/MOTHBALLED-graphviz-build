# $Id$ $Revision$

# Process this file with autoconf to produce a configure script
AC_PREREQ([2.60])
AC_INIT([graphviz-deps],0.1)
AC_CONFIG_SRCDIR([configure.ac])
AC_CANONICAL_HOST

LIBPOSTFIX=
case "${host_os}" in
  *linux* )
    case "${host_cpu}" in
      powerpc64 | s390x | x86_64 )
        LIBPOSTFIX="64"
        ;;
    esac
    ;;
esac

UWIN=no
CYGWIN=no
MINGW32=no
DARWIN9=no
DARWIN=no
case "${host_os}" in
  *uwin* )
	UWIN=yes
	CFLAGS="${CFLAGS} -DWIN32 -DMSWIN32"
	CXXFLAGS="${CXXFLAGS} -DWIN32 -DMSWIN32"
	PATHSEPARATOR=";"
	;;
  *cygwin* )
	CYGWIN=yes
	PATHSEPARATOR=";"
	;;
  *mingw32* )
	MINGW32=yes
	PATHSEPARATOR=":"
	;;
  *darwin9* )
	DARWIN9=yes
	DARWIN=yes
	PATHSEPARATOR=":"
	AC_DEFINE_UNQUOTED(DARWIN_DYLIB,"$DARWIN_DYLIB",[Define for Darwin-style shared library names.])
	;;
  *darwin* )
	DARWIN=yes
	PATHSEPARATOR=":"
	AC_DEFINE_UNQUOTED(DARWIN_DYLIB,"$DARWIN_DYLIB",[Define for Darwin-style shared library names.])
	;;
  * )
	PATHSEPARATOR=":"
	;;
esac
AC_DEFINE_UNQUOTED(PATHSEPARATOR,"$PATHSEPARATOR",[Path separator character.])

AC_PREFIX_DEFAULT([/usr/local])
if test "x${prefix}" = "xNONE"; then
	prefix=${ac_default_prefix}
	AC_SUBST(prefix)
fi

# automatically check for other dependencies in $prefix first
if test "x${prefix}" != "x/usr"; then
	CPPFLAGS="$CPPFLAGS -I${prefix}/include"
	LDFLAGS="$LDFLAGS -L${prefix}/lib"
	PKG_CONFIG_PATH="$prefix/lib/pkgconfig$PATHSEPARATOR$PKG_CONFIG_PATH"
	export PKG_CONFIG_PATH
fi

dnl -----------------------------------
dnl checks for various programs

AC_ISC_POSIX
AC_PROG_AWK
AC_CHECK_PROG(WGET,wget,wget,false)
AC_CHECK_PROG(TAR,gtar,gtar)
AC_CHECK_PROG(TAR,tar,tar,false)
AC_CHECK_PROG(ZCAT,gzcat,gzcat)
AC_CHECK_PROG(ZCAT,zcat,zcat,false)
AC_CHECK_PROG(BISON,bison,bison,false)
AC_CHECK_PROG(FLEX,flex,flex,false)
AC_CHECK_PROG(SED,gsed,gsed)
AC_CHECK_PROG(SED,sed,sed,false)
AC_CHECK_PROG(GREP,grep,grep,false)
AC_CHECK_PROG(SORT,sort,sort,false)
AC_CHECK_PROG(GROFF,groff,groff,false)
AC_CHECK_PROG(PS2PDF,ps2pdf,ps2pdf,false)
AC_CHECK_PROG(PS2PDF,pstopdf,pstopdf,false)

# Generate Makefiles
AC_CONFIG_FILES(Makefile)
AC_OUTPUT
