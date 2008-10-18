# $Id$ $Revision$

# Process this file with autoconf to produce a configure script
AC_PREREQ([2.60])

AC_INIT([graphviz -deps],0.1);

AC_CONFIG_SRCDIR([configure.ac])
AC_CONFIG_AUX_DIR([config])
AC_CONFIG_MACRO_DIR([m4])

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
AC_SUBST(CYGWIN)
AC_SUBST(MINGW32)
AC_SUBST(DARWIN9)
AC_SUBST(DARWIN)
AC_DEFINE_UNQUOTED(PATHSEPARATOR,"$PATHSEPARATOR",[Path separator character.])
AM_CONDITIONAL(WITH_WIN32, [test "x$UWIN" = "xyes" -o "x$CYGWIN" = "xyes" -o "x$MINGW32" = "xyes"])
AM_CONDITIONAL(WITH_DARWIN9, [test "x$DARWIN9" = "xyes"])

AM_INIT_AUTOMAKE(AC_PACKAGE_NAME, AC_PACKAGE_VERSION)
AM_CONFIG_HEADER(config.h)

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
AM_PROG_LEX
AC_PROG_YACC
AC_PROG_AWK
AC_PROG_INSTALL
AC_PROG_LN_S
AC_CHECK_PROG(SED,sed,sed,false)
AC_CHECK_PROG(GREP,grep,grep,false)
AC_CHECK_PROG(SORT,sort,sort,false)
AC_CHECK_PROG(GROFF,groff,groff,false)
AC_CHECK_PROG(PS2PDF,ps2pdf,ps2pdf,false)
AC_CHECK_PROG(PS2PDF,pstopdf,pstopdf,false)
PKG_PROG_PKG_CONFIG

AC_ARG_WITH(tclsh,
  [AC_HELP_STRING([--with-tcl=PROG], [use a specific tclsh])],
  TCLSH=$withval,)

if test "x$TCLSH" = "x"; then
  AC_PATH_PROGS(TCLSH,[tclsh8.6 tclsh8.5 tclsh8.4 tclsh8.3 tclsh])
  if test "x$TCLSH" = "x"; then
    AC_MSG_ERROR([Unable to find a tclsh. Tclsh is a required program for building graphviz, independent of wether tcl-based graphviz products are built])
    use_tcl="No (tclsh unavailable)"
  fi
fi

# are we building for windows?
# (these tests must follow AC_ISC_POSIX)
#AC_CYGWIN
#AC_MINGW32

AC_CHECK_PROGS(RC,rc windres,false)
AM_CONDITIONAL(RC_IS_RC, [test "x$RC" = "xrc"])
AM_CONDITIONAL(RC_IS_WINDRES, [test "x$RC" = "xwindres"])

dnl -----------------------------------
dnl checks for compilers

AC_PROG_CC
AC_PROG_CXX

# Workaround for native compilers
#  HP  : http://bugs.gnome.org/db/31/3163.html
#  DEC : Enable NaN/Inf

if test "${GCC}" != "yes" ; then
    case "${build}" in
        *-*-hpux* )
	    CFLAGS="${CFLAGS} -Wp,-H30000"
            ;;
        *-dec-osf* )
            CFLAGS="${CFLAGS} -ieee"
            ;;
	*-apple-darwin* )
	    CFLAGS="${CFLAGS} -fno-common"
	    ;;
	*-sgi-irix* )
	    ;;
    esac
else
    case "${CC}" in
	*icc* )
	    # -Wall causes relocation errors with icc
	    CFLAGS="${CFLAGS} -wd269"
	    # icc doesn't like -pipe
	    CFLAGS=`echo ${CFLAGS} | sed 's/ -pipe//'`
	    # icc doesn't like -ffast-math
	    CFLAGS=`echo ${CFLAGS} | sed 's/ -ffast-math//'`
	    # icc doesn't like -O2
	    CFLAGS=`echo ${CFLAGS} | sed 's/ -O2/ -O0/'`
	    ;;
        * )
            case "${build}" in
	        *-dec-osf* )
	            CFLAGS="${CFLAGS} -mieee -Wall"
	            ;;
                *alpha*-*-linux* )
                    CFLAGS="${CFLAGS} -mieee -Wall"
                    ;;
	        *-apple-darwin* )
	            CFLAGS="${CFLAGS} -fno-common -Wall"
	            ;;
	        *-freebsd* )
	            CFLAGS="${CFLAGS} -Wstrict-prototypes -Wpointer-arith -Wall -ffast-math"
		    ;;
	        * )
		    # -Wno-unused-parameter only needed for bug in gcc3
		    # this test from: http://cvs.auriga.wearlab.de/cgi-bin/cvsweb.cgi/dillo/configure.in?rev=1.90;content-type=text%2Fplain;cvsroot=dillo
		    if test "`$CC -v 2>&1 | $GREP 'version 3'`" != ""; then
		        CFLAGS="${CFLAGS} -Wno-unused-parameter"
		    fi
	            CFLAGS="${CFLAGS} -Wno-unknown-pragmas -Wstrict-prototypes -Wpointer-arith -Wall -ffast-math"
	            ;;
            esac
	    ;;
    esac
fi
# -ffast-math is incompatible with FP error trapping
#     ref: https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=175793
if `echo ${CFLAGS} | $GREP ffast-math >/dev/null`; then
    AC_DEFINE_UNQUOTED(NO_FPERR,1,[Define if no fpu error exception handling is required.])
fi

# Checks for libraries.
#AC_CHECK_LIB([ICE], [main])
#AC_CHECK_LIB([SM], [main])
#AC_CHECK_LIB([Xaw], [main])
#AC_CHECK_LIB([Xpm], [main])
#AC_CHECK_LIB([art_lgpl_2], [main])
#AC_CHECK_LIB([cairo], [main])
#AC_CHECK_LIB([dl], [main])
#AC_CHECK_LIB([fl], [main])
#AC_CHECK_LIB([fontconfig], [main])
#AC_CHECK_LIB([freetype], [main])
#AC_CHECK_LIB([iconv], [main])
#AC_CHECK_LIB([intl], [main])
#AC_CHECK_LIB([jpeg], [main])
#AC_CHECK_LIB([m], [main])
#AC_CHECK_LIB([perl], [main])
#AC_CHECK_LIB([png], [main])
#AC_CHECK_LIB([popt], [main])
#AC_CHECK_LIB([xml2], [main])
#AC_CHECK_LIB([z], [main])

dnl -----------------------------------
dnl check for SWIG - needed for script-language bindings

AC_ARG_ENABLE(swig,
  [AC_HELP_STRING([--enable-swig=yes], [swig-generated language bindings])],
  [],[enable_swig=yes])

if test "x$enable_swig" != "xyes"; then
  use_swig="No (disabled)"
else
  AC_CHECK_PROG(SWIG,swig,swig)
  if test "x$SWIG" = "x"; then
    use_swig="No (swig not available)"
  else
    SWIG_VERSION=`$SWIG -version 2>&1 | $GREP Version | cut -d ' ' -f 3`
    SWIG_VERSION_MAJOR=`echo $SWIG_VERSION | cut -d '.' -f 1`
    SWIG_VERSION_MINOR=`echo $SWIG_VERSION | cut -d '.' -f 2`
    if test $SWIG_VERSION_MAJOR -lt 2; then
      if test $SWIG_VERSION_MAJOR -lt 1; then
	SWIG=
      else
        if test $SWIG_VERSION_MINOR -lt 3; then
	  SWIG=
        fi
      fi
    fi
    if test "x$SWIG" = "x"; then
      AC_MSG_WARN([The version of swig is too old.])
      use_swig="No (swig too old)"
    else
      use_swig="Yes"
    fi
fi
fi
AM_CONDITIONAL(WITH_SWIG, [test "x$SWIG" != "x"])

dnl -----------------------------------
dnl INCLUDES and LIBS for C#

AC_ARG_ENABLE(sharp,
  [AC_HELP_STRING([--enable-sharp=yes], [C# language bindings])],
  [],[enable_sharp=yes])

if test "x$enable_sharp" != "xyes"; then
  use_sharp="No (disabled)"
else
  if test "x$use_swig" != "xYes"; then
    use_sharp="No (swig not available)"
  else
    if test `$SWIG -help 2>&1 | $GREP -c '\-csharp *- Generate'` = 0; then
      use_sharp="No (swig does not support -csharp option)"
    else
      AC_CHECK_PROG(MCS,mcs,mcs)
      if test "x$MCS" = "x"; then
        use_sharp="No (mcs not available)"
      else
        use_sharp="Yes"
        SHARP_INCLUDES=
        SHARP_LIBS=
        AC_SUBST(SHARP_INCLUDES)
        AC_SUBST(SHARP_LIBS)
      fi
    fi
  fi
fi
AM_CONDITIONAL(WITH_SHARP, [test "x$use_sharp" = "xYes"])

dnl -----------------------------------
dnl INCLUDES and LIBS for GUILE

AC_ARG_ENABLE(guile,
  [AC_HELP_STRING([--enable-guile=yes], [guile language bindings])],
  [],[enable_guile=yes])

if test "x$enable_guile" != "xyes"; then
  use_guile="No (disabled)"
else
  if test "x$use_swig" != "xYes"; then
    use_guile="No (swig not available)"
  else
    if test `$SWIG -help 2>&1 | $GREP -c '\-guile *- Generate'` = 0; then
      use_guile="No (swig does not support -guile option)"
    else
      AC_CHECK_PROG(GUILE,guile,guile)
      if test "x$GUILE" = "x"; then
        use_guile="No (guile not available)"
      else
        GUILE_VERSION=`$GUILE --version | head -1 | cut -d ' ' -f 2`
        GUILE_VERSION_MAJOR=`echo $GUILE_VERSION | cut -d '.' -f 1`
        GUILE_VERSION_MINOR=`echo $GUILE_VERSION | cut -d '.' -f 2`
        if test $GUILE_VERSION_MAJOR -lt 2; then
          if test $GUILE_VERSION_MAJOR -lt 1; then
            GUILE=
          else
            if test $GUILE_VERSION_MINOR -lt 4; then
	      GUILE=
            fi
          fi
        fi
        if test "x$GUILE" = "x"; then
	  use_guile="No (guile is too old)"
        else
          GUILE_INCLUDES=
          GUILE_LIBS=
          AC_CHECK_HEADER(libguile.h,,[
            use_guile="No (guile header missing)"
            GUILE=
          ])
          if test "x$GUILE" != "x"; then
	    use_guile="Yes"
            AC_SUBST(GUILE_INCLUDES)
            AC_SUBST(GUILE_LIBS)
          fi
        fi
      fi
    fi
  fi
fi
AM_CONDITIONAL(WITH_GUILE, [test "x$use_guile" = "xYes"])

dnl -----------------------------------
dnl INCLUDES and LIBS for IO   (disbled until supported by swig)

AC_ARG_ENABLE(io,
  [AC_HELP_STRING([--enable-io=no], [io language bindings])],
  [], [enable_io=no])

if test "x$enable_io" != "xyes"; then
  use_io="No (disabled by default - no swig support yet)"
else
  if test "x$use_swig" != "xYes"; then
    use_io="No (swig not available)"
  else
    if test `$SWIG -help 2>&1 | $GREP -c '\-io *- Generate'` = 0; then
      use_io="No (swig does not support -io option)"
    else
      AC_CHECK_PROG(IO,io,io)
      if test "x$IO" = "x"; then
        use_io="No (io not available)"
      else
        use_io="Yes"
        IO_INCLUDES=
        IO_LIBS=
        AC_SUBST(IO_INCLUDES)
        AC_SUBST(IO_LIBS)
      fi
    fi
  fi
fi
AM_CONDITIONAL(WITH_IO, [test "x$use_io" = "xYes"])

dnl -----------------------------------
dnl INCLUDES and LIBS for JAVA

AC_ARG_ENABLE(java,
  [AC_HELP_STRING([--enable-java=yes], [java language bindings])],
  [], [enable_java=yes])

if test "x$enable_java" != "xyes"; then
  use_java="No (disabled)"
else
  if test "x$use_swig" != "xYes"; then
    use_java="No (swig not available)"
  else
    if test `$SWIG -help 2>&1 | $GREP -c '\-java *- Generate'` = 0; then
      use_java="No (swig does not support -java option)"
    else
      AC_CHECK_PROG(JAVA,java,java)
      if test "x$JAVA" = "x"; then
        use_java="No (java not available)"
      else
	case "${host_os}" in
	  *darwin* )
            JAVA_INCLUDES="-I/System/Library/Frameworks/JavaVM.framework/Headers"
	    JAVA_LIBS=
	    ;;
	  *)
            JAVA_INCLUDES=
	    JAVA_LIBS=
	    ;;
        esac
	save_CPPFLAGS=$CPPFLAGS
        CPPFLAGS="$CPPFLAGS $JAVA_INCLUDES"
        AC_CHECK_HEADER(jni.h,,[
            use_java="No (missing header)"
  	    JAVA=
        ])
        CPPFLAGS="$save_CPPFLAGS"
        if test "x$JAVA" != "x"; then
          use_java="Yes"
	  AC_SUBST(JAVA_INCLUDES)
          AC_SUBST(JAVA_LIBS)
        fi
      fi
    fi
  fi
fi
AM_CONDITIONAL(WITH_JAVA, [test "x$use_java" = "xYes"])

dnl -----------------------------------
dnl INCLUDES and LIBS for LUA

AC_ARG_ENABLE(lua,
  [AC_HELP_STRING([--enable-lua=yes], [lua language bindings])],
  [], [enable_lua=yes])

if test "x$enable_lua" != "xyes"; then
  use_lua="No (disabled)"
else
  if test "x$use_swig" != "xYes"; then
    use_lua="No (swig not available)"
  else
    if test `$SWIG -help 2>&1 | $GREP -c '\-lua *- Generate'` = 0; then
      use_lua="No (swig does not support -lua option)"
    else
      AC_CHECK_PROG(LUA,lua,lua)
      if test "x$LUA" = "x"; then
        use_lua="No (lua not available)"
      else
        ac_save_CPPFLAGS="$CPPFLAGS"
        ac_save_CFLAGS="$CFLAGS"
        ac_save_LDFLAGS="$LDFLAGS"
    
        AC_CHECK_PROG(LUA,lua,lua)
    
        LUA_INCLUDES=""
        LUA_LIBS=""
        LUA_INSTALL_DIR=""
    
        if test -n "$lua_inc"; then
           CFLAGS="$CFLAGS -I$lua_inc"
           CPPFLAGS="$CPPFLAGS -I$lua_inc"
        fi
        if test -n "$lua_lib"; then
           LDFLAGS="$LDFLAGS -L$lua_lib"
        fi
    
        if test "x$LUA_INCLUDES" = "x" -o "x$LUA_LIBS" = "x" ; then
            PKGCONFIG=""
            AC_CHECK_PROGS(PKGCONFIG, pkg-config)
            if test "x$PKGCONFIG" != "x"; then
	        AC_MSG_CHECKING(for Lua headers and libraries with pkg-config)
	        echo
	        for l in "$lua_suffix" "" "51" "5.1" "50" "5.0" ; do
	            pkgconfig_lua_found=`$PKGCONFIG --exists lua$l 2>/dev/null`
	            if test "x$?" = "x0" ; then
		        LUA_VERSION=`$PKGCONFIG --modversion lua$l`
                        LUA_INCLUDES="$LUA_CFLAGS "`$PKGCONFIG --cflags lua$l`
                        LUA_LIBS="$LUA_LFLAGS "`$PKGCONFIG --libs lua$l`
		        LUA_INSTALL_DIR="/usr/lib$LIBPOSTFIX/lua/`$PKGCONFIG --variable=V lua`"
    
		        pkgconfig_lualib_found=`$PKGCONFIG --exists lualib$l 2>/dev/null`
		        if test  "x$?" = "x0"; then
		           LUA_INCLUDES="$LUA_CFLAGS "`$PKGCONFIG --cflags lualib$l`
		           LUA_LIBS="$LUA_LFLAGS "`$PKGCONFIG --libs lualib$l`
		        fi
                        break
                    fi
                done
            fi
        fi
    
        if test "x$LUA_INCLUDES" = "x" -o "x$LUA_LIBS" = "x" ; then
            LUACONFIG=""
            AC_CHECK_PROGS(LUACONFIG, lua-config lua-config51 lua-config5.1 lua-config50 lua-config5.0)
            if test "x$LUACONFIG" != "x" ; then
                AC_MSG_CHECKING(for Lua headers and libraries with lua-config)
	        echo
                LUA_INCLUDES=`$LUACONFIG --include`
                LUA_LIBS=`$LUACONFIG --libs`
	        LUA_VERSION="5.0.x"
	        LUA_INSTALL_DIR="/usr/lib$LIBPOSTFIX/lua/5.0"
            fi
        fi
    
        if test "x$LUA_INCLUDES" = "x" -o "x$LUA_LIBS" = "x" ; then
            AC_MSG_CHECKING(for Lua headers and libraries)
	    echo
            AC_CHECK_HEADER(lua.h,ac_found_lua_header="yes",ac_found_lua_header="no")
            AC_CHECK_HEADER(lualib.h,ac_found_liblua_header="yes",ac_found_liblua_header="no")
            if test "x$ac_found_lua_header" = "xyes" -a "x$ac_found_liblua_header" = "xyes"; then
                LUA_INCLUDES="$CFLAGS"
            fi
            for l in "$lua_suffix" "" "51" "5.1" "50" "5.0" ; do
                AC_CHECK_LIB(lua$l,lua_call,ac_found_lua_lib="yes",ac_found_lua_lib="no")
                if test "x$ac_found_lua_lib" = "xyes" ; then
	            LUA_VERSION=">=5.1.0"
    
	            LUA_LIBS="$LDFLAGS -llua$l -lm"
    
		    ac2_save_LDFLAGS="$LDFLAGS"
		    LDFLAGS="$LDFLAGS -llua$l -lm"
    
		    if echo "$host_os" | grep "^linux" 1>/dev/null 2>&1 ; then
		       LDFLAGS="$LDFLAGS -ldl"
		    fi
    
		    AC_CHECK_LIB(lualib$l,luaL_openlib,ac_found_liblua_lib="yes",ac_found_liblua_lib="no")
		    if test "x$ac_found_liblua_lib" = "xyes" ; then
		       LUA_VERSION="5.0.x"
    
		       LUA_LIBS="$LUA_LFLAGS -llualib$l"
    
		       if echo "$host_os" | grep "^linux" 1>/dev/null 2>&1 ; then
		          LUA_LIBS="$LUA_LFLAGS -ldl"
		       fi
		    fi
    
		    LDFLAGS="$ac2_save_LDFLAGS"
		    break
	        fi
            done
        fi
    
        AC_MSG_CHECKING(for Lua compiling and linking)
        LUA_TEST=`LT=luatest.c ; echo "#include <lua.h>" > $LT;  echo "#include <lualib.h>" >> $LT; echo "int main() { luaopen_base((lua_State *)lua_open()); return 0; }" >> $LT ; $CC -Wall $LT -o $LT.out $LUA_INCLUDES $LUA_LIBS $CFLAGS $LDFLAGS 1>/dev/null 2>&1 ; echo $?; rm -f $LT $LT.out 1>/dev/null 2>&1`
        if test "x$LUA_TEST" != "x0" ; then
          AC_MSG_RESULT(no)
          AC_MSG_WARN([
*** Lua (>=5.0) headers and/or libraries could not be found in your system.
*** Try to install liblua, liblualib and liblua-dev with your software package manager.
*** Graphviz will be built without Lua support.])
          use_lua="No ($not_found lua)"
        else
	  use_lua="Yes"
          AC_SUBST(LUA_INCLUDES)
          AC_SUBST(LUA_LIBS)
          AC_SUBST(LUA_INSTALL_DIR)
          # Not needed for Graphviz: AC_DEFINE(PLUGIN_LUA)
        fi
        CFLAGS="$ac_save_CFLAGS"
        CPPFLAGS="$ac_save_CPPFLAGS"
        LDFLAGS="$ac_save_LDFLAGS"
      fi
    fi
  fi
fi
AM_CONDITIONAL(WITH_LUA, [test "x$use_lua" = "xYes"])


dnl -----------------------------------
dnl INCLUDES and LIBS for OCAML

AC_ARG_ENABLE(ocaml,
  [AC_HELP_STRING([--enable-ocaml=yes], [ocaml language bindings])],
  [], [enable_ocaml=yes])

if test "x$enable_ocaml" != "xyes"; then
  use_ocaml="No (disabled)"
else
  if test "x$use_swig" != "xYes"; then
    use_ocaml="No (swig not available)"
  else
    if test `$SWIG -help 2>&1 | $GREP -c '\-ocaml *- Generate'` = 0; then
      use_ocaml="No (swig does not support -ocaml option)"
    else
      AC_CHECK_PROG(OCAML,ocaml,ocaml)
      if test "x$OCAML" = "x"; then
        use_ocaml="No (ocaml not available)"
      else
        AC_CHECK_PROG(OCAML_OPT,ocamlopt,ocamlopt)
        OCAML_INCLUDES=-I/usr/lib$LIBPOSTFIX/ocaml
        OCAML_LIBS=-L/usr/lib$LIBPOSTFIX/ocaml
        save_CPPFLAGS=$CPPFLAGS
        CPPFLAGS="$CPPFLAGS $OCAML_INCLUDES"
        AC_CHECK_HEADER(caml/mlvalues.h,[
	  use_ocaml="Yes"
          AC_SUBST(OCAML_INCLUDES)
          AC_SUBST(OCAML_LIBS)
	],[
	  use_ocaml="No (missing header)"
          AC_MSG_WARN([Unable to find header caml/mlvalues.h. The OCAML packages will not be built])
        ])
        CPPFLAGS=$save_CPPFLAGS
      fi
    fi
  fi
fi
AM_CONDITIONAL(WITH_OCAML, [test "x$use_ocaml" = "xYes"])
AM_CONDITIONAL(WITH_OCAMLOPT, [test "x$OCAML_OPT" != "x"])

dnl -----------------------------------
dnl INCLUDES and LIBS for PERL

AC_ARG_ENABLE(perl,
  [AC_HELP_STRING([--enable-perl=yes], [perl language bindings])],
  [], [enable_perl=yes])

if test "x$enable_perl" != "xyes"; then
  use_perl="No (disabled)"
else
  if test "x$use_swig" != "xYes"; then
    use_perl="No (swig not available)"
  else
    if test `$SWIG -help 2>&1 | $GREP -c '\-perl *- Generate'` = 0; then
      use_perl="No (swig does not support -perl option)"
    else
      AC_CHECK_PROG(PERL,perl,perl)
      if test "x$PERL" = "x"; then
        use_perl="No (perl not available)"
      else
        if test $PERL -e 'exit !($] <= 5.004)' > /dev/null 2>&1 ; then
	  use_perl="No (perl is too old)"
	  PERL=
	else
          PERL_INCLUDES="`$PERL $srcdir/config/config_perl.pl PERL_INCLUDES`"
          PERL_LIBS="`$PERL $srcdir/config/config_perl.pl PERL_LIBS`"
          PERL_INSTALL_DIR="`$PERL $srcdir/config/config_perl.pl PERL_INSTALL_DIR`"
	  save_CPPFLAGS=$CPPFLAGS
	  CPPFLAGS="$CPPFLAGS $PERL_INCLUDES"
          AC_CHECK_HEADER(EXTERN.h,,[
            use_perl="No (missing header)"
  	    PERL=
          ])
	  CPPFLAGS=$save_CPPFLAGS
	fi
        if test "x$PERL" != "x"; then
          use_perl="Yes"
	  AC_SUBST(PERL_INCLUDES)
          AC_SUBST(PERL_LIBS)
	  AC_SUBST(PERL_INSTALL_DIR)
        fi
      fi
    fi
  fi
fi
AM_CONDITIONAL(WITH_PERL, [test "x$use_perl" = "xYes"])

dnl -----------------------------------
dnl INCLUDES and LIBS for PHP

AC_ARG_ENABLE(php,
  [AC_HELP_STRING([--enable-php=yes], [php language bindings])],
  [], [enable_php=yes])

if test "x$enable_php" != "xyes"; then
  use_php="No (disabled)"
else
  if test "x$use_swig" != "xYes"; then
    use_php="No (swig not available)"
  else
    if test `$SWIG -help 2>&1 | $GREP -c '\-php5 *- Generate'` = 0; then
      use_php="No (swig does not support -php5 option)"
    else
      AC_CHECK_PROG(PHP,php,php)
      if test "x$PHP" = "x"; then
        use_php="No (php not available)"
      else
        if test -d /usr/include/php5; then
          PHP_INCLUDES="-I/usr/include/php5 -I/usr/include/php5/main -I/usr/include/php5/Zend -I/usr/include/php5/TSRM"
        else
          PHP_INCLUDES="-I/usr/include/php -I/usr/include/php/main -I/usr/include/php/Zend -I/usr/include/php/TSRM"
        fi
        PHP_INSTALL_DIR="/usr/lib${LIBPOSTFIX}/php/modules"
        PHP_INSTALL_DATADIR="/usr/share/php"
        PHP_LIBS=
        save_CPPFLAGS=$CPPFLAGS
        CPPFLAGS="$CPPFLAGS $PHP_INCLUDES"
        AC_CHECK_HEADER(php.h,,[
          use_php="No (missing header)"
          PHP=
        ])
        CPPFLAGS=$save_CPPFLAGS
	if test "x$PHP" != "x"; then
	  use_php="Yes"
          AC_SUBST(PHP_INSTALL_DATADIR)
          AC_SUBST(PHP_INSTALL_DIR)
          AC_SUBST(PHP_INCLUDES)
          AC_SUBST(PHP_LIBS)
        fi
      fi
    fi
  fi
fi
AM_CONDITIONAL(WITH_PHP, [test "x$use_php" = "xYes"])

dnl -----------------------------------
dnl INCLUDES and LIBS for PYTHON

AC_ARG_ENABLE(python,
  [AC_HELP_STRING([--enable-python=yes], [python language bindings])],
  [], [enable_python=yes])

if test "x$enable_python" != "xyes"; then
  use_python="No (disabled)"
else
  if test "x$use_swig" != "xYes"; then
    use_python="No (swig not available)"
  else
    if test `$SWIG -help 2>&1 | $GREP -c '\-python *- Generate'` = 0; then
      use_python="No (swig does not support -python option)"
    else
      AC_CHECK_PROG(PYTHON,python,python)
      if test "x$PYTHON" = "x"; then
        use_python="No (python not available)"
      else
        PYTHON_VERSION=`$PYTHON -V 2>&1 | $GREP Python | cut -d ' ' -f 2`
        if test "x$PYTHON_VERSION" = "x"; then
          PYTHON=
        else
          PYTHON_VERSION_MAJOR=`echo $PYTHON_VERSION | cut -d '.' -f 1`
          PYTHON_VERSION_MINOR=`echo $PYTHON_VERSION | cut -d '.' -f 2`
          PYTHON_VERSION_SHORT=$PYTHON_VERSION_MAJOR.$PYTHON_VERSION_MINOR
          if test $PYTHON_VERSION_MAJOR -lt 3; then
            if test $PYTHON_VERSION_MAJOR -lt 2; then
	      PYTHON=
            else
              if test $PYTHON_VERSION_MINOR -lt 3; then
	        PYTHON=
              fi
            fi
          fi
        fi
      fi
      if test "x$PYTHON" = "x"; then
	use_python="No (python is too old)"
      else
        PYTHON_PREFIX=`$PYTHON -c "import sys; print sys.prefix"`
        PYTHON_INCLUDES=-I$PYTHON_PREFIX/include/python$PYTHON_VERSION_SHORT
        PYTHON_LIBS="-lpython$PYTHON_VERSION_SHORT"
        PYTHON_INSTALL_DIR="`$PYTHON $srcdir/config/config_python.py archsitelib`"
        save_CPPFLAGS=$CPPFLAGS
        CPPFLAGS="$CPPFLAGS $PYTHON_INCLUDES"
        AC_CHECK_HEADER(Python.h,,[
          use_python="No (missing header)"
          PYTHON=
        ])
        CPPFLAGS=$save_CPPFLAGS
	if test "x$PYTHON" != "x"; then
	  use_python="Yes"
          AC_SUBST(PYTHON_INSTALL_DIR)
          AC_SUBST(PYTHON_INCLUDES)
          AC_SUBST(PYTHON_LIBS)
        fi
      fi
    fi
  fi
fi
AM_CONDITIONAL(WITH_PYTHON, [test "x$use_python" = "xYes"])

dnl -----------------------------------
dnl INCLUDES and LIBS for R

AC_ARG_ENABLE(r,
  [AC_HELP_STRING([--enable-r=yes], [R language bindings])],
  [], [enable_r=yes])

if test "x$enable_r" != "xyes"; then
  use_r="No (disabled)"
else
  if test "x$use_swig" != "xYes"; then
    use_r="No (swig not available)"
  else
    if test `$SWIG -help 2>&1 | $GREP -c '\-r *- Generate'` = 0; then
      use_r="No (swig does not support -r option)"
    else
      PKG_CHECK_MODULES(R, [libR],[
	use_r="Yes"
	AC_SUBST(R_CFLAGS)
	AC_SUBST(R_LIBS)
      ],[
	use_r="No (R not available)"
      ])
    fi
  fi
fi
AM_CONDITIONAL(WITH_R, [test "x$use_r" = "xYes"])

dnl -----------------------------------
dnl INCLUDES and LIBS for RUBY

AC_ARG_ENABLE(ruby,
  [AC_HELP_STRING([--enable-ruby=yes], [ruby language bindings])],
  [], [enable_ruby=yes])

if test "x$enable_ruby" != "xyes"; then
  use_ruby="No (disabled)"
else
  if test "x$use_swig" != "xYes"; then
    use_ruby="No (swig not available)"
  else
    if test `$SWIG -help 2>&1 | $GREP -c '\-ruby *- Generate'` = 0; then
      use_ruby="No (swig does not support -ruby option)"
    else
      AC_CHECK_PROG(RUBY,ruby,ruby)
      if test "x$RUBY" = "x"; then
	use_ruby="No (ruby not available)"
      else
        RUBY_INCLUDES="-I`$RUBY $srcdir/config/config_ruby.rb INCLUDES`"
        RUBY_LIBS="-L`$RUBY $srcdir/config/config_ruby.rb lib` `$RUBY -rrbconfig -e \"puts Config::CONFIG[['LIBRUBYARG_SHARED']]\"`"
        RUBY_INSTALL_DIR="`$RUBY $srcdir/config/config_ruby.rb archsitelib`"
        save_CPPFLAGS=$CPPFLAGS
        CPPFLAGS="$CPPFLAGS $RUBY_INCLUDES"
        AC_CHECK_HEADER(ruby.h,,[
          use_python25="No (missing header)"
          RUBY=
        ])
        CPPFLAGS=$save_CPPFLAGS
      fi
      if test "x$RUBY" != "x"; then
	use_ruby="Yes"
        AC_SUBST(RUBY_INCLUDES)
        AC_SUBST(RUBY_LIBS)
        AC_SUBST(RUBY_INSTALL_DIR)
      fi
    fi
  fi
fi
AM_CONDITIONAL(WITH_RUBY, [test "x$use_ruby" = "xYes"])

dnl -----------------------------------
dnl ...borrow test for -lsocket -lnsl from tk8.3.3/unix/configure.in

save_LIBS=$LIBS
LIBS=
tk_checkBoth=0
AC_CHECK_FUNC(connect, tk_checkSocket=0, tk_checkSocket=1)
if test "$tk_checkSocket" = 1; then
  AC_CHECK_LIB(socket, main, LIBS="$LIBS -lsocket", tk_checkBoth=1)
fi
if test "$tk_checkBoth" = 1; then
  tk_oldLibs=$LIBS
  LIBS="$LIBS -lsocket -lnsl"
  AC_CHECK_FUNC(accept, tk_checkNsl=0, [LIBS=$tk_oldLibs])
fi  
AC_CHECK_FUNC(gethostbyname, , [AC_CHECK_LIB(nsl, main, [LIBS="$LIBS -lnsl"])])
SOCKET_LIBS=$LIBS
AC_SUBST(SOCKET_LIBS)
LIBS=$save_LIBS

dnl -----------------------------------
dnl INCLUDES and LIBS for EXPAT

AC_ARG_WITH(expat,
  [AC_HELP_STRING([--with-expat=yes], [use expat])],
  [],[with_expat=yes])

if test "x$with_expat" != "xyes"; then
  use_expat="No (disabled)"
else

  save_CPPFLAGS=$CPPFLAGS
  save_LDFLAGS=$LDFLAGS
  AC_PATH_PROG(EXPAT_CONFIG,expat-config)
  if test -n "$EXPAT_CONFIG"; then
	EXPAT_INCLUDES=`$EXPAT_CONFIG --cflags`
	EXPAT_PREFIX=`$EXPAT_CONFIG --prefix`
	if test "${EXPAT_PREFIX}/lib" != "/usr/lib" ; then
		EXPAT_LIBS="-L${EXPAT_PREFIX}/lib"
	fi
  else         
	EXPAT_INCLUDES=""
	EXPAT_LIBS=""
  fi
  AC_ARG_WITH(expatincludedir,
    [AC_HELP_STRING([--with-expatincludedir=DIR], [use EXPAT includes from DIR])],
    [EXPAT_INCLUDES="-I$withval"])
  CPPFLAGS="$CPPFLAGS $EXPAT_INCLUDES"
  EXPAT_LIBDIR="/usr/lib$LIBPOSTFIX"
  AC_ARG_WITH(expatlibdir,
    [AC_HELP_STRING([--with-expatlibdir=DIR], [use EXPAT libraries from DIR])],
    [EXPAT_LIBDIR="$withval"])
  if test "$EXPAT_LIBDIR" != "/usr/lib$LIBPOSTFIX"; then
	  EXPAT_LIBS="-L$EXPAT_LIBDIR"
	  LDFLAGS="$LDFLAGS $EXPAT_LIBS"
  fi
  AC_CHECK_HEADERS([expat.h],
    [],
    [use_expat="No (missing header)"
     AC_MSG_WARN(Optional expat library not available - missing headers)],
    [])
  AC_CHECK_LIB(expat,main,
    [EXPAT_LIBS="$EXPAT_LIBS -lexpat"],
    [use_expat="No (missing library)"
     AC_MSG_WARN(Optional expat library not available)],
    [])
  LDFLAGS=$save_LDFLAGS
  CPPFLAGS=$save_CPPFLAGS
fi
if test "x$use_expat" = "x"; then
  use_expat="Yes"
  AC_DEFINE_UNQUOTED(HAVE_EXPAT,1,
    [Define if you have the expat library])
  AC_SUBST(EXPAT_INCLUDES)
  AC_SUBST(EXPAT_LIBS)
fi
  
dnl -----------------------------------
dnl INCLUDES and LIBS for DEVIL

AC_ARG_WITH(devil,
  [AC_HELP_STRING([--with-devil=yes], [DevIL plugin])],
  [],[with_devil=yes])

if test "x$with_devil" != "xyes"; then
  use_devil="No (disabled)"
else

  AC_ARG_WITH(devilincludedir,
    [AC_HELP_STRING([--with-devilincludedir=DIR], [use DevIL includes from DIR])],
    [DEVIL_INCLUDES="-I$withval"])
  AC_ARG_WITH(devillibdir,
    [AC_HELP_STRING([--with-devillibdir=DIR], [use DevIL libraries from DIR])],
    [DEVIL_LIBS="-L$withval"])

  save_CPPFLAGS=$CPPFLAGS
  save_LDFLAGS=$LDFLAGS
  CPPFLAGS="$CPPFLAGS $DEVIL_INCLUDES"
  LDFLAGS="$LDFLAGS $DEVIL_LIBS"
  AC_CHECK_HEADERS([IL/il.h],
    [],
    [use_devil="No (missing header)"
     AC_MSG_WARN(Optional DevIL library not available - missing headers)],
    [])
  AC_CHECK_LIB(IL,main,
    [DEVIL_LIBS="$DEVIL_LIBS -lIL -lILU"],
    [use_devil="No (missing library)"
     AC_MSG_WARN(Optional DevIL library not available)],
    [])
  LDFLAGS=$save_LDFLAGS
  CPPFLAGS=$save_CPPFLAGS
fi
if test "x$use_devil" = "x"; then
  use_devil="Yes"
  AC_DEFINE_UNQUOTED(HAVE_DEVIL,1,
    [Define if you have the DevIL library])
  AC_SUBST(DEVIL_INCLUDES)
  AC_SUBST(DEVIL_LIBS)
fi

AM_CONDITIONAL(WITH_DEVIL, [test "x$use_devil" = "xYes"])

dnl -----------------------------------
dnl INCLUDES and LIBS for XPM
#
# we don't want an X11 dependency in libgd
# so we set HAVE_LIBXPMFORLEFTY instead of the usual HAVE_LIBXPM
#

AC_ARG_WITH(Xpmincludedir,
  [AC_HELP_STRING([--with-Xpmincludedir=DIR], [use Xpm includes from DIR])],
  [XPM_INCLUDES="-I$withval"])
AC_ARG_WITH(Xpmlibdir,
  [AC_HELP_STRING([--with-Xpmlibdir=DIR], [use Xpm libraries from DIR])],
  [XPM_LIBS="-L$withval"])

save_CPPFLAGS=$CPPFLAGS
save_LDFLAGS=$LDFLAGS
CPPFLAGS="$CPPFLAGS $XPM_INCLUDES $X_CFLAGS"
LDFLAGS="$LDFLAGS $XPM_LIBS $X_LIBS $X_EXTRA_LIBS $X_PRE_LIBS $SOCKET_LIBS"
AC_CHECK_LIB(Xpm,main,
  [XPM_LIBS="$XPM_LIBS -lXpm"
   AC_DEFINE_UNQUOTED(HAVE_LIBXPMFORLEFTY,1,[Define if you have the XPM library])],
   AC_MSG_WARN(Optional Xpm library not available), [-lXmu -lXt -lX11 -lXext $SOCKET_LIBS])
LDFLAGS=$save_LDFLAGS
CPPFLAGS=$save_CPPFLAGS
AC_SUBST(XPM_INCLUDES)
AC_SUBST(XPM_LIBS)

dnl -----------------------------------
dnl INCLUDES and LIBS for XAW

AC_ARG_WITH(Xawincludedir,
  [AC_HELP_STRING([--with-Xawincludedir=DIR], [use Xaw includes from DIR])],
  [XAW_INCLUDES="-I$withval"])
AC_ARG_WITH(Xawlibdir,
  [AC_HELP_STRING([--with-Xawlibdir=DIR], [use Xaw libraries from DIR])],
  [XAW_LIBS="-L$withval"])
save_CPPFLAGS=$CPPFLAGS
save_LDFLAGS=$LDFLAGS
CPPFLAGS="$CPPFLAGS $XAW_INCLUDES $X_CFLAGS"
LDFLAGS="$LDFLAGS $X_LIBS $XAW_LIBS $XPM_LIBS $X_EXTRA_LIBS $X_PRE_LIBS $SOCKET_LIBS"
AC_CHECK_HEADERS([X11/Intrinsic.h])
AC_CHECK_HEADERS([X11/Xaw/Text.h],
		 [],
		 [with_xaw=no
		  AC_MSG_WARN(Optional Xaw library not available - missing headers)],
		 [#if HAVE_X11_INTRINSIC_H
		  # include <X11/Intrinsic.h>
		  # endif
		  ])
if test "x$with_xaw" != "xno"; then
AC_CHECK_LIB(Xaw,main,
	     [XAW_LIBS="$X_LIBS $XAW_LIBS -lXaw"],
	     [with_xaw=no
	      AC_MSG_WARN(Optional Xaw library not available)],
	      [$X_LIBS -lXmu -lXt -lX11 -lXext $SOCKET_LIBS])
fi
LDFLAGS=$save_LDFLAGS
CPPFLAGS=$save_CPPFLAGS
AC_SUBST(XAW_INCLUDES)
AC_SUBST(XAW_LIBS)
AM_CONDITIONAL(WITH_XAW, [test "x$with_xaw" != "xno"])
if test "x$with_xaw" = "xno" && "x$no_x" != xyes; then
	AC_MSG_WARN(Lefty cannot be built)
fi

dnl -----------------------------------
dnl INCLUDES and LIBS for Z

AC_ARG_WITH(zincludedir,
  [AC_HELP_STRING([--with-zincludedir=DIR], [use Z includes from DIR])],
  [Z_INCLUDES="-I$withval"])
AC_ARG_WITH(zlibdir,
  [AC_HELP_STRING([--with-zlibdir=DIR], [use Z libraries from DIR])],
  [Z_LIBS="-L$withval"])

save_CPPFLAGS=$CPPFLAGS
save_LDFLAGS=$LDFLAGS
CPPFLAGS="$CPPFLAGS $Z_INCLUDES"
LDFLAGS="$LDFLAGS $Z_LIBS"
AC_CHECK_HEADER(zlib.h,
	[AC_CHECK_LIB(z,main,
		[Z_LIBS="$Z_LIBS -lz"
		AC_DEFINE_UNQUOTED(HAVE_LIBZ,1,[Define if you have the Z library])],
			AC_MSG_WARN(Optional z library not available))],
	AC_MSG_WARN(Optional z library not available - no zlib.h))
	LDFLAGS="$LDFLAGS $Z_LIBS"
        AC_CHECK_FUNCS(deflateBound)
LDFLAGS=$save_LDFLAGS
CPPFLAGS=$save_CPPFLAGS
AC_SUBST(Z_INCLUDES)
AC_SUBST(Z_LIBS)

dnl -----------------------------------
dnl INCLUDES and LIBS for RSVG
                                                                                
AC_ARG_WITH(rsvg,
  [AC_HELP_STRING([--with-rsvg=yes], [rsvg library])],
  [], [with_rsvg=yes])

if test "x$with_rsvg" != "xyes"; then
  use_rsvg="No (disabled)"
else
  PKG_CHECK_MODULES(RSVG, [librsvg-2.0],[
    use_rsvg="Yes"
    AC_DEFINE_UNQUOTED(HAVE_RSVG,1,
      [Define if you have the rsvg library])
    AC_SUBST(RSVG_CFLAGS)
    AC_SUBST(RSVG_LIBS)
  ],[
    use_rsvg="No (rsvg library not available)"
  ])
fi
AM_CONDITIONAL(WITH_RSVG, [test "x$use_rsvg" = "xYes"])

dnl -----------------------------------
dnl INCLUDES and LIBS for GS
                                                                                
AC_ARG_WITH(gs,
  [AC_HELP_STRING([--with-gs=yes], [gs library])],
  [], [with_gs=yes])

if test "x$with_gs" != "xyes"; then
  use_gs="No (disabled)"
else
  AC_CHECK_HEADER(ghostscript/iapi.h, GS_CFLAGS="",use_gs="No (missing headers)")
  if test "x$use_gs" = "x"; then
    AC_CHECK_LIB(gs, main, GS_LIBS="-lgs", use_gs="No (missing lib)")
    if test "x$use_gs" = "x"; then
      use_gs="Yes"
      AC_DEFINE_UNQUOTED(HAVE_GS,1,
        [Define if you have the gs library])
      AC_SUBST(GS_CFLAGS)
      AC_SUBST(GS_LIBS)
    fi
  fi
fi
AM_CONDITIONAL(WITH_GS, [test "x$use_gs" = "xYes"])

dnl -----------------------------------
dnl INCLUDES and LIBS for PANGO, CAIRO et.al.
                                                                                
AC_ARG_WITH(pangocairo,
  [AC_HELP_STRING([--with-pangocairo=yes], [pangocairo library])],
  [], [with_pangocairo=yes])

if test "x$with_pangocairo" != "xyes"; then
  use_pangocairo="No (disabled)"
else
  # require at least the version available on centos5 (fc6 has 1.14.10)
  PKG_CHECK_MODULES(PANGOCAIRO, [pangocairo >= 1.14.9],[
    use_pangocairo="Yes"
    AC_DEFINE_UNQUOTED(HAVE_PANGOCAIRO,1,
      [Define if you have the pangocairo library])
    AC_SUBST(PANGOCAIRO_CFLAGS)
    AC_SUBST(PANGOCAIRO_LIBS)
  ],[
    use_pangocairo="No (pangocairo library not available)"
  ])
fi
AM_CONDITIONAL(WITH_PANGOCAIRO, [test "x$use_pangocairo" = "xYes"])

# see if pango uses a fontconfig/freetype2 backend
if test "x$use_pangocairo" = "xYes"; then
    save_LIBS=$LIBS
    LIBS="$LIBS $PANGOCAIRO_LIBS"
    AC_CHECK_FUNCS([pango_fc_font_lock_face pango_fc_font_unlock_face])
    LIBS=$save_LIBS
fi

dnl -----------------------------------
dnl INCLUDES and LIBS for LASI
                                                                                
AC_ARG_WITH(lasi,
  [AC_HELP_STRING([--with-lasi=yes], [lasi library])],
  [], [with_lasi=yes])

if test "x$with_lasi" != "xyes"; then
  use_lasi="No (disabled)"
else
  PKG_CHECK_MODULES(LASI, [lasi],[
    use_lasi="Yes"
    AC_DEFINE_UNQUOTED(HAVE_LASI,1,
      [Define if you have the lasi library])
    AC_SUBST(LASI_CFLAGS)
    AC_SUBST(LASI_LIBS)
  ],[
    use_lasi="No (lasi library not available)"
  ])
fi
AM_CONDITIONAL(WITH_LASI, [test "x$use_lasi" = "xYes"])

dnl -----------------------------------
dnl INCLUDES and LIBS for GLITZ
                                                                                
AC_ARG_WITH(glitz,
  [AC_HELP_STRING([--with-glitz=no], [glitz library])],
  [], [with_glitz=no])

if test "x$with_glitz" != "xyes"; then
  use_glitz="No (disabled by default - incomplete)"
else
  PKG_CHECK_MODULES(GLITZ, [glitz],[
    use_glitz="Yes"
    AC_DEFINE_UNQUOTED(HAVE_GLITZ,1,
      [Define if you have the glitz library])
    AC_SUBST(GLITZ_CFLAGS)
    AC_SUBST(GLITZ_LIBS)
  ],[
    use_glitz="No (glitz library not available)"
  ])
fi
AM_CONDITIONAL(WITH_GLITZ, [test "x$use_glitz" = "xYes"])

dnl -----------------------------------
dnl INCLUDES and LIBS for FREETYPE2
                                                                                
AC_ARG_WITH(freetype2,
  [AC_HELP_STRING([--with-freetype2=yes], [freetype2 library])],
  [], [with_freetype2=yes])

if test "x$with_freetype2" != "xyes"; then
  use_freetype="No (disabled)"
else
  PKG_CHECK_MODULES(FREETYPE2, [freetype2],[
    use_freetype="Yes"
  ],[
    AC_MSG_WARN(pkg-config did not find a freetype2.pc.  Looking for freetype-config.)
  ])
fi

# pkgconfig for freetype2 did not exist in redhat[78]
if test "x$use_freetype" = "x"; then
    if test "x$FREETYPE_DIR" = "xyes"; then
	AC_PATH_PROG(FREETYPE_CONFIG,freetype-config)
    else
	AC_PATH_PROG(FREETYPE_CONFIG,freetype-config,,[$FREETYPE_DIR/bin:$PATH])
    fi

    if test -n "$FREETYPE_CONFIG"; then
        if test "x$FREETYPE_DIR" != "xyes"; then
	    FREETYPE2_CFLAGS="`$FREETYPE_CONFIG --cflags` -I$FREETYPE_DIR/include"
	else
	    FREETYPE2_CFLAGS=`$FREETYPE_CONFIG --cflags`
	fi
	FREETYPE2_LIBS=`$FREETYPE_CONFIG --libs`
	use_freetype="Yes"
    else
        AC_MSG_WARN(freetype library not available)
	use_freetype="No (missing freetype-config)"
    fi
fi

if test "x$use_freetype" = "xYes"; then
  AC_DEFINE_UNQUOTED(HAVE_FREETYPE2,1,[Define if you have the freetype2 library])
  AC_SUBST(FREETYPE2_CFLAGS)
  AC_SUBST(FREETYPE2_LIBS)
fi
AM_CONDITIONAL(WITH_FREETYPE2, [test "x$ue_freetype" = "xYes"])

dnl -----------------------------------
dnl INCLUDES and LIBS for FONTCONFIG
                                                                                
AC_ARG_WITH(fontconfig,
  [AC_HELP_STRING([--with-fontconfig=yes], [use fontconfig library])],
  [], [with_fontconfig=yes])

if test "x$with_fontconfig" != "xyes"; then
  use_fontconfig="No (disabled)"
else
  PKG_CHECK_MODULES(FONTCONFIG, [fontconfig],[
    use_fontconfig="Yes"
  ],[
    AC_MSG_WARN(pkg-config did not find a fontconfig.pc.  Looking for fontconfig-config.)
  ])
fi

# just in case pkgconfig for fontconfig does not exist
if test "x$use_fontconfig" = "x"; then
    if test "x$FONTCONFIG_DIR" = "xyes"; then
	AC_PATH_PROG(FONTCONFIG_CONFIG,fontconfig-config)
    else
	AC_PATH_PROG(FONTCONFIG_CONFIG,fontconfig-config,,[$FONTCONFIG_DIR/bin:$PATH])
    fi

    if test -n "$FONTCONFIG_CONFIG"; then
        if test "x$FONTCONFIG_DIR" != "xyes"; then
	    FONTCONFIG_CFLAGS="`$FONTCONFIG_CONFIG --cflags` -I$FONTCONFIG_DIR/include"
	else
	    FONTCONFIG_CFLAGS=`$FONTCONFIG_CONFIG --cflags`
	fi
	FONTCONFIG_LIBS=`$FONTCONFIG_CONFIG --libs`
	use_fontconfig="Yes"
    else
	use_fontconfig="No (missing fontconfig-config)"
        AC_MSG_WARN(fontconfig library not available)
    fi
fi

if test "x$use_fontconfig" = "xYes"; then
  AC_DEFINE_UNQUOTED(HAVE_FONTCONFIG,1,[Define if you have the fontconfig library])
  AC_SUBST(FONTCONFIG_CFLAGS)
  AC_SUBST(FONTCONFIG_LIBS)
fi
AM_CONDITIONAL(WITH_FONTCONFIG, [test "x$use_fontconfig" = "xYes"])

dnl -----------------------------------
dnl INCLUDES and LIBS for GDK_PIXBUF.

AC_ARG_WITH(gdk-pixbuf,
  [AC_HELP_STRING([--with-gdk-pixbuf=yes], [gdk-pixbuf library])],
  [], [with_gdk_pixbuf=yes])

if test "x$with_gdk_pixbuf" != "xyes"; then
  use_gdk_pixbuf="No (disabled)"
else
  PKG_CHECK_MODULES(GDK_PIXBUF, [gdk-pixbuf-2.0],[
    use_gdk_pixbuf="Yes"
    AC_DEFINE_UNQUOTED(HAVE_GDK_PIXBUF,1,
      [Define if you have the gdk_pixbuf library])
    AC_SUBST(GDK_PIXBUF_CFLAGS)
    AC_SUBST(GDK_PIXBUF_LIBS)
  ],[
    use_gdk_pixbuf="No (gdk_pixbuf library not available)"
  ])
fi
AM_CONDITIONAL(WITH_GDK_PIXBUF, [test "x$use_gdk_pixbuf" = "xYes"])

dnl -----------------------------------
dnl INCLUDES and LIBS for GTK.

AC_ARG_WITH(gtk,
  [AC_HELP_STRING([--with-gtk=yes], [gtk+ library])],
  [], [with_gtk=yes])

if test "x$with_gtk" != "xyes"; then
  use_gtk="No (disabled)"
else
  PKG_CHECK_MODULES(GTK, [gtk+-2.0 >= 2.7.0],[
    use_gtk="Yes"
    AC_DEFINE_UNQUOTED(HAVE_GTK,1,
      [Define if you have the gtk library])
    AC_SUBST(GTK_CFLAGS)
    AC_SUBST(GTK_LIBS)
  ],[
    use_gtk="No (gtk library not available)"
  ])
fi
AM_CONDITIONAL(WITH_GTK, [test "x$use_gtk" = "xYes"])

dnl -----------------------------------
dnl INCLUDES and LIBS for GTKGL.

AC_ARG_WITH(gtkgl,
  [AC_HELP_STRING([--with-gtkgl=yes], [gtkgl library])],
  [], [with_gtkgl=yes])

if test "x$with_gtkgl" != "xyes"; then
  use_gtkgl="No (disabled)"
else
  PKG_CHECK_MODULES(GTKGL, [gtkgl-2.0],[
    use_gtkgl="Yes"
    AC_DEFINE_UNQUOTED(HAVE_GTKGL,1,
      [Define if you have the gtkgl library])
    AC_SUBST(GTKGL_CFLAGS)
    AC_SUBST(GTKGL_LIBS)
  ],[
    use_gtkgl="No (gtkgl library not available)"
  ])
fi
AM_CONDITIONAL(WITH_GTKGL, [test "x$use_gtkgl" = "xYes"])

dnl -----------------------------------
dnl INCLUDES and LIBS for GTKGLEXT.

AC_ARG_WITH(gtkglext,
  [AC_HELP_STRING([--with-gtkglext=yes], [gtkglext library])],
  [], [with_gtkglext=yes])

if test "x$with_gtkglext" != "xyes"; then
  use_gtkglext="No (disabled)"
else
  PKG_CHECK_MODULES(GTKGLEXT, [gtkglext-1.0],[
    use_gtkglext="Yes"
    AC_DEFINE_UNQUOTED(HAVE_GTKGLEXT,1,
      [Define if you have the gtkglext library])
    AC_SUBST(GTKGLEXT_CFLAGS)
    AC_SUBST(GTKGLEXT_LIBS)
  ],[
    use_gtkglext="No (gtkglext library not available)"
  ])
fi
AM_CONDITIONAL(WITH_GTKGLEXT, [test "x$use_gtkglext" = "xYes"])

dnl -----------------------------------
dnl INCLUDES and LIBS for GTS.

AC_ARG_WITH(gts,
  [AC_HELP_STRING([--with-gts=yes], [gts library])],
  [], [with_gts=yes])

if test "x$with_gts" != "xyes"; then
  use_gts="No (disabled)"
else
  PKG_CHECK_MODULES(GTS, [gts],[
    use_gts="Yes"
    AC_DEFINE_UNQUOTED(HAVE_GTS,1,
      [Define if you have the gts library])
    AC_SUBST(GTS_CFLAGS)
    AC_SUBST(GTS_LIBS)
  ],[
    use_gts="No (gts library not available)"
  ])
fi
AM_CONDITIONAL(WITH_GTS, [test "x$use_gts" = "xYes"])

dnl -----------------------------------
dnl INCLUDES and LIBS for GLADE.

AC_ARG_WITH(glade,
  [AC_HELP_STRING([--with-glade=yes], [glade library])],
  [], [with_glade=yes])

if test "x$with_glade" != "xyes"; then
  use_glade="No (disabled)"
else
  PKG_CHECK_MODULES(GLADE, [libglade-2.0],[
    use_glade="Yes"
    AC_DEFINE_UNQUOTED(HAVE_GLADE,1,
      [Define if you have the glade library])
    AC_SUBST(GLADE_CFLAGS)
    AC_SUBST(GLADE_LIBS)
  ],[
    use_glade="No (glade library not available)"
  ])
fi
AM_CONDITIONAL(WITH_GLADE, [test "x$use_glade" = "xYes"])

dnl -----------------------------------
dnl INCLUDES and LIBS for GNOMEUI.

AC_ARG_WITH(gnomeui,
  [AC_HELP_STRING([--with-gnomeui=yes], [gnomeui library])],
  [], [with_gnomeui=yes])

if test "x$with_gnomeui" != "xyes"; then
  use_gnomeui="No (disabled)"
else
  PKG_CHECK_MODULES(GNOMEUI, [libgnomeui-2.0],[
    use_gnomeui="Yes"
    AC_DEFINE_UNQUOTED(HAVE_GNOMEUI,1,
      [Define if you have the gnomeui library])
    AC_SUBST(GNOMEUI_CFLAGS)
    AC_SUBST(GNOMEUI_LIBS)
  ],[
    use_gnomeui="No (gnomeui library not available)"
  ])
fi
AM_CONDITIONAL(WITH_GNOMEUI, [test "x$use_gnomeui" = "xYes"])

dnl -----------------------------------
dnl INCLUDES and LIBS for MING (SWF renderer)

AC_ARG_WITH(ming,
  [AC_HELP_STRING([--with-ming=no], [ming library (plugin for -Tswf)])],
  [], [with_ming=no])

if test "x$with_ming" != "xyes"; then
  use_ming="No (disabled by default - incomplete)"
else
  PKG_CHECK_MODULES(MING, [libming >= 0.4],[
    use_ming="Yes"
    AC_DEFINE_UNQUOTED(HAVE_MING,1,
      [Define if you have the ming library for SWF support])
    AC_SUBST(MING_CFLAGS)
    AC_SUBST(MING_LIBS)
  ],[
    use_ming="No (ming library not available)"
  ])
fi
AM_CONDITIONAL(WITH_MING, [test "x$use_min" = "xYes"])

dnl -----------------------------------
dnl INCLUDES and LIBS for QUARTZ 

AC_ARG_WITH(quartz,
  [AC_HELP_STRING([--with-quartz=no], [Quartz framework (Mac OS X)])],
  [], [with_quartz=no])

if test "x$with_quartz" != "xyes"; then
  use_quartz="No (disabled by default - Mac only)"
else
  if test -d "/System/Library/Frameworks/ApplicationServices.framework"; then
    use_quartz="Yes"
    AC_DEFINE_UNQUOTED(HAVE_QUARTZ,1,[Define if you have the Quartz framework for Mac OS X])
    QUARTZ_CFLAGS=''
    QUARTZ_LIBS='-framework ApplicationServices'
    AC_SUBST(QUARTZ_CFLAGS)
    AC_SUBST(QUARTZ_LIBS)
  else
    use_quartz="No (missing ApplicationServices.framework)"
  fi
fi
AM_CONDITIONAL(WITH_QUARTZ, [test "x$use_quartz" = "xYes"])

dnl -----------------------------------
dnl INCLUDES and LIBS for PLATFORMSDK

AC_ARG_WITH(platformsdkincludedir,
  [AC_HELP_STRING([--with-platformsdkincludedir=DIR], [use Platform SDK (Windows) includes from DIR])],
  [PLATFORMSDKINCLUDE=$withval; PLATFORMSDKINCLUDE_ESCAPED=${PLATFORMSDKINCLUDE//'\\'/\\\\}; PLATFORMSDKINCLUDE_ESCAPED=${PLATFORMSDKINCLUDE_ESCAPED// /\\ }])

AC_ARG_WITH(platformsdklibdir,
  [AC_HELP_STRING([--with-platformsdklibdir=DIR], [use Platform SDK (Windows) libraries from DIR])],
  [PLATFORMSDKLIB=$withval])

AC_SUBST(PLATFORMSDKINCLUDE)
AC_SUBST(PLATFORMSDKINCLUDE_ESCAPED)
AC_SUBST(PLATFORMSDKLIB) 

dnl -----------------------------------
dnl INCLUDES and LIBS for GDI+ 

AC_ARG_WITH(gdiplus,
  [AC_HELP_STRING([--with-gdiplus=no], [GDI+ framework (Windows)])],
  [], [with_gdiplus=no])

if test "x$with_gdiplus" != "xyes"; then
  use_gdiplus="No (disabled by default - Windows only)"
else
  if test -f "$PLATFORMSDKINCLUDE\GdiPlus.h" -a -f "$PLATFORMSDKLIB\GdiPlus.lib"; then
    use_gdiplus="Yes"
    AC_DEFINE_UNQUOTED(HAVE_GDIPLUS,1,[Define if you have the GDI+ framework for Windows])
    GDIPLUS_HEADS=`cd "$PLATFORMSDKINCLUDE" && echo GdiPlus*.h`
    GDIPLUS_CFLAGS=''
    GDIPLUS_LIBS=''
    AC_SUBST(GDIPLUS_HEADS)
    AC_SUBST(GDIPLUS_CFLAGS)
    AC_SUBST(GDIPLUS_LIBS)
  else
    use_gdiplus="No (missing headers)"
    AC_MSG_WARN(--with-gdiplus requires valid --with-platformsdkincludedir and --with-platformsdklibdir.)
  fi
fi
AM_CONDITIONAL(WITH_GDIPLUS, [test "x$use_gdiplus" = "xYes"])

dnl -----------------------------------
dnl INCLUDES and LIBS for GD
                                                                                
AC_ARG_WITH(libgd,
  [AC_HELP_STRING([--with-libgd=yes], [use gd library])],
  [], [with_libgd=yes])

AC_ARG_WITH(mylibgd,
  [AC_HELP_STRING([--with-mylibgd=no],
    [use internal gd library in preference to any installed libgd])],
  [], [with_mylibgd=no])

if test "x$with_mylibgd" = "xyes"; then
  with_libgd=yes
fi

if test "x$with_libgd" != "xyes"; then
  use_gd="No (disabled)"
else
  if test "x$with_libgd" = "xyes"; then
    if test "x$with_mylibgd" = "xno"; then
      AC_PATH_PROG(GDLIB_CONFIG,gdlib-config)
      if test -n "$GDLIB_CONFIG"; then
        GD_INCLUDES=`$GDLIB_CONFIG --includes`
        GD_LDFLAGS=`$GDLIB_CONFIG --ldflags`
        GD_LIBS=`$GDLIB_CONFIG --libs`
        GD_MAJORVERSION=`$GDLIB_CONFIG --majorversion`
        GD_MINORVERSION=`$GDLIB_CONFIG --minorversion`
        GD_REVISION=`$GDLIB_CONFIG --revision`
        for f in `$GDLIB_CONFIG --features` ; do
	    if test "$f" = "GD_PNG"; then
                AC_DEFINE_UNQUOTED(HAVE_GD_PNG,1,[Define if the GD library supports PNG])
	    fi
	    if test "$f" = "GD_JPEG"; then
                AC_DEFINE_UNQUOTED(HAVE_GD_JPEG,1,[Define if the GD library supports JPEG])
	    fi
	    if test "$f" = "GD_XPM"; then
                AC_DEFINE_UNQUOTED(HAVE_GD_XPM,1,[Define if the GD library supports XPM])
	    fi
	    if test "$f" = "GD_FONTCONFIG"; then
		HAVE_GD_FONTCONFIG=1
                AC_DEFINE_UNQUOTED(HAVE_GD_FONTCONFIG,1,[Define if the GD library supports FONTCONFIG])
	    fi
	    if test "$f" = "GD_FREETYPE"; then
		HAVE_GD_FREETYPE=1
                AC_DEFINE_UNQUOTED(HAVE_GD_FREETYPE,1,[Define if the GD library supports FREETYPE])
	    fi
	    if test "$f" = "GD_GIF"; then
                AC_DEFINE_UNQUOTED(HAVE_GD_GIF,1,[Define if the GD library supports GIF])
	    fi
	    if test "$f" = "GD_GIFANIM"; then
                AC_DEFINE_UNQUOTED(HAVE_GD_GIFANIM,1,[Define if the GD library supports GIFANIM])
	    fi
	    if test "$f" = "GD_OPENPOLYGON"; then
                AC_DEFINE_UNQUOTED(HAVE_GD_OPENPOLYGON,1,[Define if the GD library supports OPENPOLYGON])
	    fi
        done

	if test "x$HAVE_GD_FONTCONFIG" = "x"; then
            AC_MSG_WARN(Your libgd was not built with freetype support. This may result in problems displaying fonts.)
	fi
	if test "x$HAVE_GD_FREETYPE" = "x"; then
	    AC_MSG_WARN(Your libgd was not built with fontconfig support. This may result in problems resolving fonts.)
        fi

        # GD version check >= 2.0.34  else revert to --with-mylibgd
        REQ_GD_MAJORVERSION=2
        REQ_GD_MINORVERSION=0
        REQ_GD_REVISION=34
        if test $GD_MAJORVERSION -lt $REQ_GD_MAJORVERSION; then
	    with_mylibgd=yes
        else
            if test $GD_MAJORVERSION -eq $REQ_GD_MAJORVERSION; then
                if test $GD_MINORVERSION -lt $REQ_GD_MINORVERSION; then
	            with_mylibgd=yes
	        else
                    if test $GD_MINORVERSION -eq $REQ_GD_MINORVERSION; then
		        if test $GD_REVISION -lt $REQ_GD_REVISION; then
		            with_mylibgd=yes
		        fi
	            fi
	        fi
            fi
        fi
        if test "x$with_mylibgd" = "xyes"; then
            AC_MSG_WARN(GD library version < $REQ_GD_MAJORVERSION.$REQ_GD_MINORVERSION.$REQ_GD_REVISION)
        fi
      else
        with_mylibgd=yes
        AC_MSG_WARN(No gdlib-config found.)
      fi
    fi
  fi

  if test "x$with_mylibgd" = "xno"; then
    if test "x$with_libgd" = "xyes"; then
    # see if we can use the external gd lib
      save_CPPFLAGS=$CPPFLAGS
      save_LDFLAGS=$LDFLAGS
      AC_ARG_WITH(gdincludedir,
        [AC_HELP_STRING([--with-gdincludedir=DIR], [use GD includes from DIR])],
        GD_INCLUDES="-I$withval")
      CPPFLAGS="$CPPFLAGS $GD_INCLUDES"
      AC_ARG_WITH(gdlibdir,
        [AC_HELP_STRING([--with-gdlibdir=DIR], [use GD libraries from DIR])],
        [GD_LDFLAGS="-L$withval"])
      LDFLAGS="$LDFLAGS $GD_LDFLAGS"
      AC_CHECK_HEADER(gd.h,,[
        AC_MSG_WARN(Optional GD library not available - no gd.h)
        use_gd="No (gd headers not found)"
      ])
      if test "x$use_gd" = "x"; then
        AC_CHECK_LIB(gd,main,[
	  GD_LIBS="$GD_LDFLAGS -lgd $GD_LIBS"
          AC_DEFINE_UNQUOTED(HAVE_LIBGD,1,[Define if you have the GD library])
	  use_gd="Yes"
        ],[
          AC_MSG_WARN(Optional GD library not available)
          use_gd="No (gd library found)"
        ], $GD_LIBS)
      fi
      LDFLAGS=$save_LDFLAGS
      CPPFLAGS=$save_CPPFLAGS
    fi
  else
    # using the internal libgd
    use_gd="Yes [internal]"
    AC_MSG_WARN(Using internal libgd source.)
    AC_DEFINE_UNQUOTED(HAVE_GD_GIF,1,[Define if the GD library has the GD_GIF feature])
    AC_DEFINE_UNQUOTED(HAVE_LIBGD,1,[Define if either internal or external GD library is availabel])
    GD_INCLUDES='-I$(top_srcdir)/lib/gd'
    GD_LIBS='$(top_builddir)/lib/gd/libgvgd.la'
  fi
  AC_SUBST(GD_INCLUDES)
  AC_SUBST(GD_LIBS)
fi
AM_CONDITIONAL(WITH_LIBGD, [test "x$with_libgd" = "xyes"])
AM_CONDITIONAL(WITH_MYLIBGD, [test "x$with_mylibgd" = "xyes"])

dnl ----------------------------------
dnl INCLUDES and LIBS for FREETYPE2 and FONTCONFIG (only with mylibgd)

if test "x$with_mylibgd" = "xyes"; then
  if test "x$use_freetype" = "xYes"; then
    AC_DEFINE_UNQUOTED(HAVE_GD_FREETYPE,1,[Define if the GD library has the GD_FREETYPE feature])
  fi
  if test "x$use_fontconfig" = "xYes"; then
    AC_DEFINE_UNQUOTED(HAVE_GD_FONTCONFIG,1,[Define if the GD library has the GD_FONTCONFIG feature])
  fi
fi

dnl -----------------------------------
dnl INCLUDES and LIBS for ICONV (only with mylibgd)

if test "x$with_mylibgd" = "xyes"; then

save_CPPFLAGS=$CPPFLAGS
save_LDFLAGS=$LDFLAGS
AC_ARG_WITH(iconvincludedir,
  [AC_HELP_STRING([--with-iconvincludedir=DIR], [use ICONV includes from DIR])],
  [ICONV_INCLUDES="-I$withval"])
CPPFLAGS="$CPPFLAGS $ICONV_INCLUDES"
AC_ARG_WITH(iconvlibdir,
  [AC_HELP_STRING([--with-iconvlibdir=DIR], [use ICONV libraries from DIR])],
  [ICONV_LIBS="-L$withval"])
LDFLAGS="$LDFLAGS $ICONV_LIBS"

# Some systems have iconv in a separate library (e.g. Tru64 UNIX)
AM_ICONV
if test -n "$LIBICONV" ; then
  ICONV_LIBS="$LIBICONV"
else
  ICONV_LIBS=""
fi

AC_CHECK_HEADERS(iconv.h,
  [AC_MSG_CHECKING(whether iconv.h defines iconv_t)
   AC_EGREP_HEADER([typedef.*iconv_t],iconv.h,
     [AC_MSG_RESULT(yes)
      AC_DEFINE(HAVE_ICONV_T_DEF, 1,
                [Define if <iconv.h> defines iconv_t.])],
      AC_MSG_RESULT(no))])

LDFLAGS=$save_LDFLAGS
CPPFLAGS=$save_CPPFLAGS
AC_SUBST(ICONV_INCLUDES)
AC_SUBST(ICONV_LIBS)

fi

dnl -----------------------------------
dnl INCLUDES and LIBS for PNG (only with mylibgd)

if test "x$with_mylibgd" = "xyes"; then

save_CPPFLAGS=$CPPFLAGS
save_LDFLAGS=$LDFLAGS
AC_PATH_PROG(LIBPNG_CONFIG,libpng-config)
if test -n "$LIBPNG_CONFIG"; then
        PNG_INCLUDES=`$LIBPNG_CONFIG --cflags`
        PNG_PREFIX=`$LIBPNG_CONFIG --prefix`
	if test "${PNG_PREFIX}/lib" != "/usr/lib" ; then
  		PNG_LIBS="-L${PNG_PREFIX}/lib"
 	fi
else
	PNG_INCLUDES=""
fi
AC_ARG_WITH(pngincludedir,
  [AC_HELP_STRING([--with-pngincludedir=DIR], [use PNG includes from DIR])],
  [PNG_INCLUDES="-I$withval"])
CPPFLAGS="$CPPFLAGS $PNG_INCLUDES $Z_INCLUDES"
AC_ARG_WITH(pnglibdir,
  [AC_HELP_STRING([--with-pnglibdir=DIR], [use PNG libraries from DIR])],
  [PNG_LIBS="-L$withval"])
LDFLAGS="$LDFLAGS $PNG_LIBS $Z_LIBS"
AC_CHECK_HEADER(png.h,
	AC_CHECK_LIB(png,main,
		[PNG_LIBS="$PNG_LIBS -lpng"
		AC_DEFINE_UNQUOTED(HAVE_GD_PNG,1,[Define if the GD library has the GD_PNG feature])
		AC_DEFINE_UNQUOTED(HAVE_LIBPNG,1,[Define if you have the PNG library])],
		AC_MSG_WARN(Optional png library not available),
		[$Z_LIBS $MATH_LIBS]),
	AC_MSG_WARN(Optional png library not available - no png.h))
LDFLAGS=$save_LDFLAGS
CPPFLAGS=$save_CPPFLAGS
AC_SUBST(PNG_INCLUDES)
AC_SUBST(PNG_LIBS)

fi

dnl -----------------------------------
dnl INCLUDES and LIBS for JPEG (only with mylibgd)

if test "x$with_mylibgd" = "xyes"; then

save_CPPFLAGS=$CPPFLAGS
save_LDFLAGS=$LDFLAGS
AC_ARG_WITH(jpegincludedir,
  [AC_HELP_STRING([--with-jpegincludedir=DIR], [use JPEG includes from DIR])],
  [JPEG_INCLUDES="-I$withval"])
CPPFLAGS="$CPPFLAGS $JPEG_INCLUDES"
JPEG_LIBDIR="/usr/lib$LIBPOSTFIX"
AC_ARG_WITH(jpeglibdir,
  [AC_HELP_STRING([--with-jpeglibdir=DIR], [use JPEG libraries from DIR])],
  [JPEG_LIBDIR="$withval"])
if test "$JPEG_LIBDIR" != "/usr/lib$LIBPOSTFIX"; then
	JPEG_LIBS="-L$JPEG_LIBDIR"
	LDFLAGS="$LDFLAGS $JPEG_LIBS"
fi
if test -f "$JPEG_LIBDIR/libjpeg.la"; then
        JPEG_LIBS="$JPEG_LIBDIR/libjpeg.la"
fi
AC_CHECK_HEADER(jpeglib.h,
	AC_CHECK_LIB(jpeg,main,
		[JPEG_LIBS="$JPEG_LIBS -ljpeg"
		AC_DEFINE_UNQUOTED(HAVE_GD_JPEG,1,[Define if the GD library has the GD_JPEG feature])
		AC_DEFINE_UNQUOTED(HAVE_LIBJPEG,1,[Define if you have the JPEG library])],
			AC_MSG_WARN(Optional jpeg library not available)),
	AC_MSG_WARN(Optional jpeg library not available - no jpeglib.h))
LDFLAGS=$save_LDFLAGS
CPPFLAGS=$save_CPPFLAGS
AC_SUBST(JPEG_INCLUDES)
AC_SUBST(JPEG_LIBS)

fi

# -----------------------------------
# tclInt.h
if test -f "$TCL_SRC_DIR/generic/tclInt.h"; then
TCLINT_INCLUDES="-I$TCL_SRC_DIR/generic"
else
if test -f "/usr/include/tclInt.h"; then
TCLINT_INCLUDES=""
else
if test -f "/usr/local/include/tclInt.h"; then
TCLINT_INCLUDES="-I/usr/local/include"
else
TCLINT_INCLUDES='-I$(top_srcdir)/tclpkg/tclstubs'
fi
fi
fi
AC_SUBST(TCLINT_INCLUDES)

# -----------------------------------
# tkInt.h
if test -f "$TK_SRC_DIR/generic/tkInt.h"; then
TKINT_INCLUDES="-I$TK_SRC_DIR/generic -I$TK_SRC_DIR/unix"
else
if test -f "/usr/include/tkInt.h"; then
TKINT_INCLUDES=""
else
if test -f "/usr/local/include/tkInt.h"; then
TKINT_INCLUDES="-I/usr/local/include"
else
TKINT_INCLUDES='-I$(top_srcdir)/tclpkg/tkstubs'
fi
fi
fi
AC_SUBST(TKINT_INCLUDES)

# ------------------------------------
# triangle.[ch]

if test -f "lib/sfdpgen/triangle.c"; then
if test -f "lib/sfdpgen/triangle.h"; then
    AC_DEFINE_UNQUOTED(HAVE_TRIANGLE,1,[Define if triangle.[ch] are available.])
fi
fi

# ----------------------------------
# tcl/tk pkgIndex.tcl generation

TCL_PKGINDEX=""
TCL_PKGINDEX_GD=""
TCL_PKGINDEX_SWIG=""
TK_PKGINDEX=""
if test "$use_tcl" = "Yes"; then
    TCL_PKGINDEX="tcldot/pkgIndex.tcl tclpathplan/pkgIndex.tcl"
    if test "x$with_libgd" = "xyes"; then
	TCL_PKGINDEX_GD="gdtclft/pkgIndex.tcl"
    fi
    if test "x$SWIG" != "x"; then
	TCL_PKGINDEX_SWIG="gv/pkgIndex.tcl"
    fi
    if test "$HAVE_TK" = "1"; then
        TK_PKGINDEX="tkspline/pkgIndex.tcl"
    fi
fi
AC_SUBST(TCL_PKGINDEX)
AC_SUBST(TCL_PKGINDEX_GD)
AC_SUBST(TCL_PKGINDEX_SWIG)
AC_SUBST(TK_PKGINDEX)

# Generate Makefiles
AC_CONFIG_FILES(Makefile)

AC_OUTPUT

dnl ===========================================================================

echo ""
echo "----------------------------------------------------------------"
echo ""
echo "graphviz-dependencies will be compiled with the following:"
echo ""
echo "options:"
echo "  expat:         $use_expat"
echo "  fontconfig:    $use_fontconfig"
echo "  freetype:      $use_freetype"
echo "  gts:           $use_gts"
echo "  devil:         $use_devil"
echo "  gd:            $use_gd"
echo "  gdiplus:       $use_gdiplus"
echo "  gdk_pixbuf:    $use_gdk_pixbuf"
echo "  glitz:         $use_glitz"
echo "  gs:            $use_gs"
echo "  gtk:           $use_gtk"
echo "  lasi:          $use_lasi"
echo "  ming:          $use_ming"
echo "  pangocairo:    $use_pangocairo"
echo "  quartz:        $use_quartz"
echo "  rsvg:          $use_rsvg"
echo "  xlib:          $use_xlib"
echo ""
echo "language extensions:"
echo "  sharp:         $use_sharp"
echo "  guile:         $use_guile"
echo "  io:            $use_io"
echo "  java:          $use_java"
echo "  lua:           $use_lua"
echo "  ocaml:         $use_ocaml"
echo "  perl:          $use_perl"
echo "  php:           $use_php"
echo "  python:        $use_python"
echo "  R:             $use_r"
echo "  ruby:          $use_ruby"
echo "  tcl:           $use_gv_tcl"
