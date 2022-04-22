dnl## Process this file with autoconf to produce configure.
dnl## In general, the safest way to proceed is to run ./autogen.sh

dnl# ensure we are interpreted by some minimal autoconf:
AC_PREREQ([2.70])

AC_INIT([ctemplate],[2.2],[google-ctemplate@googlegroups.com])
AM_SILENT_RULES([yes])dnl

# Update this value for every release!  (A:B:C will map to foo.so.(A-C).C.B)
# http://www.gnu.org/software/libtool/manual/html_node/Updating-version-info.html
SO_VERSION=2:1:0

dnl# The argument here is just something that should be in the current directory
dnl# (for sanity checking)
AC_CONFIG_SRCDIR([README])
AC_CONFIG_MACRO_DIR([m4])
AC_CONFIG_AUX_DIR([build-aux])
AC_CANONICAL_HOST
AM_INIT_AUTOMAKE([foreign dist-zip subdir-objects])
AM_MAINTAINER_MODE
AC_CONFIG_HEADERS([src/config.h])dnl

# Checks for programs.
AM_PROG_AR
AC_DEFUN([AC_REQUIRE_COMPILER],[
  AC_REQUIRE([AC_PROG_CXX])dnl
  AC_REQUIRE([AC_PROG_CC])dnl
  AC_REQUIRE([AM_PROG_CC_C_O])dnl
  AC_REQUIRE([AC_PROG_CPP])dnl
  m4_ifdef([AC_PROG_RANLIB],[
    AC_REQUIRE([AC_PROG_RANLIB])dnl
  ])dnl
])dnl
AC_REQUIRE_COMPILER
AM_CONDITIONAL([GCC],
               [test "x${GCC}" = "xyes"]) # let the Makefile know if we are gcc

# MinGW uses autoconf, but also needs the windows shim routines
# (since it doesn't have its own support for, say, pthreads).
# This requires us to #include a special header file, and also to
# link in some windows versions of .o's instead of the unix versions.
AH_BOTTOM([
#if defined( __MINGW32__) || defined(__MINGW64__)
#include "windows/port.h"
#endif
])
case ${host_os} in
  *mingw*)
    # Disabling fast install keeps libtool from creating wrapper scripts
    # around the executables it builds.  Such scripts have caused failures on
    # MinGW.  Using this option means an extra link step is executed during
    # "make install".
    AC_DISABLE_FAST_INSTALL
    ;;
   *)
    AC_ENABLE_FAST_INSTALL
    ;;
esac
AM_CONDITIONAL([MINGW],[expr ${host} : '.*-mingw' >/dev/null 2>&1])dnl

# Uncomment this if you will be exporting libraries (.so's)
LT_INIT([dlopen win32-dll])dnl
AC_SUBST([LIBTOOL_DEPS])dnl
AC_SUBST([SO_VERSION])dnl
LT_PREREQ([2.4.7])dnl

AC_PROG_LN_S

AX_C___ATTRIBUTE__

# Check whether some low-level functions/files are available...
AC_CHECK_INCLUDES_DEFAULT
if test "x${EGREP}" = "x"; then
  test -z "${EGREP}"
  AC_PROG_EGREP
fi
if test "x${ac_cv_header_inttypes_h}" = "x"; then
  test -z "${ac_cv_header_inttypes_h}"
  AC_CHECK_HEADERS([inttypes.h])
fi
if test "x${ac_cv_header_stdint_h}" = "x"; then
  test -z "${ac_cv_header_stdint_h}"
  AC_CHECK_HEADERS([stdint.h])
fi
if test "x${ac_cv_header_unistd_h}" = "x"; then
  test -z "${ac_cv_header_unistd_h}"
  AC_CHECK_HEADERS([unistd.h])
fi
AC_CHECK_HEADERS([stddef.h])dnl

# Defines PRIuS:
AC_COMPILER_CHARACTERISTICS

# Here are some examples of how to check for the existence of a fn or file:
AC_CHECK_FUNCS([getopt_long getopt])
AC_CHECK_HEADERS([getopt.h])
AC_CHECK_HEADERS([utime.h])           # used by unittests to mock file-times

# These are the types I need.  We look for them in either stdint.h,
# sys/types.h, or inttypes.h, all of which are part of the default-includes.
AC_CHECK_TYPES([uint32_t])
AC_CHECK_TYPES([u_int32_t])
AC_CHECK_TYPES([__int32])
AC_CHECK_TYPES([uint64_t])
AC_CHECK_TYPES([u_int64_t])
AC_CHECK_TYPES([__int64])dnl

# Checks for typedefs, structures, and compiler characteristics.
AC_HEADER_STDBOOL dnl# also "_CHECK"s it
AC_C_INLINE
AC_TYPE_OFF_T
AC_TYPE_SIZE_T
AC_TYPE_UINT32_T
AC_TYPE_UINT64_T
AC_CHECK_TYPES([ptrdiff_t])dnl

AC_HEADER_DIRENT               # for template_unittest.cc, template_regtest.cc

# We need to do byte-swapping efficiently to hash efficiently in
# template_string.cc.  Different architectures do this differently.
AC_CHECK_HEADERS([byteswap.h])              # Linux (GNU in general)
AC_CHECK_HEADERS([libkern/OSByteOrder.h])   # OS X
AC_CHECK_HEADERS([sys/byteorder.h])         # Solaris 10
AC_CHECK_HEADERS([endian.h])                # Linux
AC_CHECK_HEADERS([machine/endian.h])        # OS X
AC_CHECK_HEADERS([sys/endian.h])            # FreeBSD
AC_CHECK_HEADERS([sys/isa_defs.h])          # Solaris 10

# Checks for library functions.
AC_FUNC_ERROR_AT_LINE
AC_FUNC_MALLOC
AC_CHECK_FUNCS([getcwd getpagesize memchr memset mkdir strcasecmp strchr \
                strcspn strerror strncasecmp strstr strtol utime])dnl

# A lot of the code in this directory depends on pthreads:
ACX_PTHREAD

# We would like to use read/write locks in several places in the code.
# See if our pthreads support extends to that.  Note: for linux, it
# does as long as you define _XOPEN_SOURCE appropriately.
AC_RWLOCK

# For mingw/cygwin, figure out if the mutex code needs to use
# 'volatile' in some places.  They differ from MSVC, and the API is
# unclear, so it's best just to check.
AC_INTERLOCKED_EXCHANGE_NONVOLATILE

# Find out what namespace 'normal' STL code lives in, and also what namespace
# the user wants our classes to be defined in:
AC_CXX_STL_NAMESPACE
AC_DEFINE_GOOGLE_NAMESPACE([ctemplate])dnl

# Figures out where hash_map and hash_set live, and what namespace they use:
AC_CXX_STL_HASH

# If we found tr1/unordered_map, prefer unordered_map/unordered_set to
# hash_map/hash_set.
if test "x${ac_cv_cxx_have_unordered_map}" = "xyes"; then
   ac_cv_cxx_hash_map_class="${ac_cv_cxx_hash_namespace}::unordered_map"
   ac_cv_cxx_hash_set_class="${ac_cv_cxx_hash_namespace}::unordered_set"
else
   ac_cv_cxx_hash_map_class="${ac_cv_cxx_hash_namespace}::hash_map"
   ac_cv_cxx_hash_set_class="${ac_cv_cxx_hash_namespace}::hash_set"
fi

AC_SUBST([ac_google_namespace])dnl
AC_SUBST([ac_google_start_namespace])dnl
AC_SUBST([ac_google_end_namespace])dnl
AC_SUBST([ac_cv_cxx_hash_map])dnl
AC_SUBST([ac_cv_cxx_hash_set])dnl
AC_SUBST([ac_cv_cxx_hash_map_class])dnl
AC_SUBST([ac_cv_cxx_hash_set_class])dnl
   ## some conditional substitutions:
if test "x${ac_cv___attribute__}" = "xyes"; then
   AC_SUBST([ac_google_attribute],[1])
else
   AC_SUBST([ac_google_attribute],[0])
fi
if test "x${ac_cv_type_u_int64_t}" = "xyes"; then
   AC_SUBST([ac_cv_uint64],[u_int64_t])
elif test "x${ac_cv_type_uint64_t}" = "xyes"; then
   AC_SUBST([ac_cv_uint64],[uint64_t])
elif test "x${ac_cv_type___int64}" = "xyes"; then
   AC_SUBST([ac_cv_uint64],[unsigned __int64])
else
   AC_SUBST([ac_cv_uint64],[unsigned long long])   # best we can do
fi
# These are used by template_string.h.in
if test "x${ac_cv_header_stdint_h}" = "xyes"; then
   AC_SUBST([ac_cv_have_stdint_h],[1])
else
   AC_SUBST([ac_cv_have_stdint_h],[0])
fi
if test "x$ac_cv_header_inttypes_h" = "xyes"; then
   AC_SUBST([ac_cv_have_inttypes_h],[1])
else
   AC_SUBST([ac_cv_have_inttypes_h],[0])
fi


# One some systems (eg gnu/linux), the linker defines _start and
# data_start to indicate the extent of the .text section.  We can use
# this to know strings are immutable.  In the code, we make the
# variables weak, just in case, but for this check, we only want to
# say "yes" if the linker supports the vars, *and* the compiler supports
# attribute-weak.
AC_LINK_IFELSE([AC_LANG_PROGRAM([[]],[[
                  extern char _start[];
                  extern char data_start[];
                  extern char dummy[]  __attribute__((weak));
                  return (_start && data_start && dummy); ]])],
            [ac_have_attribute_weak=1],[ac_have_attribute_weak=0])
AC_SUBST([ac_have_attribute_weak])dnl

# In unix (that is, using this script), this dll-export stuff will always
# be the empty string.  In windows, we'll replace it with windows-specific
# text.
ac_windows_dllexport_defines=""
ac_windows_dllexport=""
AC_SUBST([ac_windows_dllexport_defines])dnl
AC_SUBST([ac_windows_dllexport])dnl

# This will (should) never change, but we put it here so if we do need
# to change it, to avoid naming conflicts or something, it will be easy to
# do in one place.
ac_htmlparser_namespace=google_ctemplate_streamhtmlparser
AC_SUBST([ac_htmlparser_namespace])dnl
AC_DEFINE_UNQUOTED([HTMLPARSER_NAMESPACE],[${ac_htmlparser_namespace}],
                   [The namespace to put the htmlparser code.])dnl

# Write generated configuration file, and also .h files:
AC_CONFIG_FILES([Makefile \
                 src/ctemplate/template_string.h \
                 src/ctemplate/template_enums.h \
                 src/ctemplate/template.h \
                 src/ctemplate/template_cache.h \
                 src/ctemplate/template_modifiers.h \
                 src/ctemplate/template_emitter.h \
                 src/ctemplate/template_annotator.h \
                 src/ctemplate/template_dictionary.h \
                 src/ctemplate/template_pathops.h \
                 src/ctemplate/template_namelist.h \
                 src/ctemplate/find_ptr.h \
                 src/ctemplate/per_expand_data.h \
                 src/ctemplate/str_ref.h \
                 src/ctemplate/template_dictionary_interface.h \
                 ])dnl
AC_OUTPUT
