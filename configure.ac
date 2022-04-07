AC_PREREQ([2.69])
AC_INIT(["Kara's Generalized Library for Structured File Formats"], [0.1.0], [bugs@kara-online.net], [krossgen], [https://github.com/Kara1147/krossgen])

#host switch
AC_CANONICAL_HOST

AS_CASE(["$host_os"],
  [*linux*], [
   # OS specific stuff here
  ],
#  [*mingw*|*cygwin*], [ # not supporting win32 right now, sorry!
#   # OS specific stuff here
#    AC_DEFINE([WINVER], [_WIN32_WINNT_WIN10],
#      [Define windows version as WIN10])
#    AC_DEFINE([_WIN32_WINNT], [_WIN32_WINNT_WIN10],
#      [Define windows version as WIN10])
#  ],
  [AC_MSG_WARN([unsupported system: $host_os])]
)

#autoconf stuff
AM_INIT_AUTOMAKE
AC_CONFIG_SRCDIR([src/])
AC_CONFIG_HEADERS([config.h])

#program config
AC_PROG_CC
AC_PROG_CXX
AC_PROG_RANLIB

#user and host info
# none

#headers
# none

#headers
# none

#types
# none

#functions
# none

#makefiles
AC_CONFIG_FILES([
  Makefile
  src/Makefile
])
AC_OUTPUT
