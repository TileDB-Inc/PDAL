###############################################################################
# CMake module to search for SQLite 3 library
#
# On success, the macro sets the following variables:
# SQLITE3_FOUND = if the library found
# SQLITE3_LIBRARY = full path to the library
# SQLITE3_LIBRARIES = full path to the library
# SQLITE3_HAS_LOAD_EXTENSION = was sqlite3 compiled with load extension?
# SQLITE3_INCLUDE_DIR = where to find the library headers
#
# Copyright (c) 2009 Mateusz Loskot <mateusz@loskot.net>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#
###############################################################################

find_path(SQLITE3_INCLUDE_DIR
  NAMES sqlite3.h
  PATH_PREFIXES sqlite sqlite3
  PATHS
  /usr/include
  /usr/local/include
  $ENV{LIB_DIR}/include
  $ENV{LIB_DIR}/include/sqlite
  $ENV{LIB_DIR}/include/sqlite3
  $ENV{ProgramFiles}/SQLite/*/include
  $ENV{ProgramFiles}/SQLite3/*/include
  $ENV{SystemDrive}/SQLite/*/include
  $ENV{SystemDrive}/SQLite3/*/include
  $ENV{SQLITE_ROOT}/include
  ${SQLITE_ROOT_DIR}/include)

set(SQLITE3_NAMES sqlite3_i sqlite3)
find_library(SQLITE3_LIBRARY
  NAMES ${SQLITE3_NAMES}
  PATHS
  /usr/lib
  /usr/local/lib
  $ENV{LIB_DIR}/lib
  $ENV{ProgramFiles}/SQLite/*/lib
  $ENV{ProgramFiles}/SQLite3/*/lib
  $ENV{SystemDrive}/SQLite/*/lib
  $ENV{SystemDrive}/SQLite3/*/lib
  $ENV{SQLITE_ROOT}/lib
  ${SQLITE_ROOT_DIR}/lib)

# If sqlite3 was compiled with `OMIT_LOAD_EXTENSION`, PDAL compilation will fail due
# to a missing symbol, `_sqlite3_enable_load_extension`.
include(CheckCXXSourceRuns)
unset(SQLITE3_HAS_LOAD_EXTENSION CACHE)
set(CMAKE_REQUIRED_INCLUDES "${SQLITE3_INCLUDE_DIR}")
set(CMAKE_REQUIRED_LIBRARIES "${SQLITE3_LIBRARY}")
check_cxx_source_runs("#include <sqlite3.h>
int main(int argc, char** argv) {
    return sqlite3_compileoption_used(\"OMIT_LOAD_EXTENSION\");
}" SQLITE3_HAS_LOAD_EXTENSION)

set(SQLITE3_LIBRARIES ${SQLITE3_LIBRARY})

#message(STATUS ${SQLITE3_LIBRARY})
# Handle the QUIETLY and REQUIRED arguments and set SQLITE3_FOUND to TRUE
# if all listed variables are TRUE
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(SQLITE3
  DEFAULT_MSG
  SQLITE3_LIBRARY
  SQLITE3_INCLUDE_DIR)

mark_as_advanced(SQLITE3_LIBRARY SQLITE3_INCLUDE_DIR SQLITE3_LIBRARY)