# stl_namespace.m4 serial 1
# We check what namespace stl code like vector expects to be executed in

AC_DEFUN([AC_CXX_STL_NAMESPACE],
  [AC_CACHE_CHECK(
      what namespace STL code is in,
      ac_cv_cxx_stl_namespace,
      [AC_REQUIRE([AC_CXX_NAMESPACES])
      AC_LANG_SAVE
      AC_LANG([C++])
      AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[#include <vector>]], [[vector<int> t; return 0;]])],[ac_cv_cxx_stl_namespace=none],[])
      AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[#include <vector>]], [[std::vector<int> t; return 0;]])],[ac_cv_cxx_stl_namespace=std],[])
      AC_LANG_RESTORE])
   if test "$ac_cv_cxx_stl_namespace" = none; then
      AC_DEFINE(STL_NAMESPACE,,
                [the namespace where STL code like vector<> is defined])
   fi
   if test "$ac_cv_cxx_stl_namespace" = std; then
      AC_DEFINE(STL_NAMESPACE,std,
                [the namespace where STL code like vector<> is defined])
   fi
])
