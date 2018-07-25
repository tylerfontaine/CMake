# Searches for an installation of the CGAL libraries. On success, it sets the following variables:
#
#   CGAL_FOUND                                Set to true to indicate the CGAL library was found
#   CGAL_INCLUDE_DIRS                         The directories containing the CGAL header files
#   CGAL_VERSION_MAJOR                        The major version of the CGAL distribution
#   CGAL_VERSION_MINOR                        The minor version of the CGAL distribution
#   CGAL_VERSION_PATCH                        The build version of the CGAL distribution
#   CGAL_DEBUG_CFLAGS                         Compiler flags required by CGAL in debug mode
#   CGAL_RELEASE_CFLAGS                       Compiler flags required by CGAL in release mode
#   CGAL_LIBRARY                              The full path to the main CGAL library (set only if autolinking is disabled))
#   CGAL_LIBRARY_DIRS                         The directory containing the CGAL libraries (use if autolinking is enabled))
#   CGAL_3RD_PARTY_INCLUDE_DIRS               The directories containing 3rd party headers required by CGAL
#   CGAL_3RD_PARTY_DEFINITIONS                The preprocessor definititions required by CGAL to use 3rd party resources
#   CGAL_3RD_PARTY_LIBRARIES                  The full paths to 3rd party libraries required by CGAL
#   CGAL_<component>_LIBRARY                  The full path to a CGAL component library (Core, ImageIO, PDB, Qt3, Qt4) (set only
#                                             if autolinking is disabled)
#   CGAL_<component>_3RD_PARTY_INCLUDE_DIRS   The directories containing 3rd party headers required by a component
#   CGAL_<component>_3RD_PARTY_DEFINITIONS    The preprocessor definititions required by a component to use 3rd party resources
#   CGAL_<component>_3RD_PARTY_LIBRARIES      The full paths to 3rd party libraries required by a component
#
# To specify an additional directory to search, set CGAL_ROOT. To search for CGAL component libraries, add them to the list
# CGAL_FIND_COMPONENTS.
#
# Author: Siddhartha Chaudhuri, 2009
#
# Some Windows-specific extra paths were adapted from the PixelStruct project (http://da.vidr.cc/projects/pixelstruct), which in
# turn copied from the pgRouting project (http://pgrouting.postlbs.org). While these projects are covered by the GPL, I would
# argue that simply copying these filesystem paths does not make this a derivative work. Hence this script is not licensed under
# the GPL.
#

# Look for the CGAL's auto-generated CMake utility, first in the user-specified location and then in the system locations
SET(CGAL_CMAKE_DOC "The directory containing CGAL's autogenerated CGALConfig.cmake file")
FIND_PATH(CGAL_CMAKE_PATH NAMES CGALConfig.cmake PATHS ${CGAL_ROOT}
          PATH_SUFFIXES CGAL cmake/CGAL
                        lib lib/CGAL lib/cmake/CGAL lib/ms lib/ms/CGAL
                        lib64 lib64/CGAL lib64/cmake/CGAL lib64/ms lib64/ms/CGAL
          DOC ${CGAL_CMAKE_DOC} NO_DEFAULT_PATH)
IF(NOT CGAL_CMAKE_PATH)  # now look in system locations
  FIND_PATH(CGAL_CMAKE_PATH NAMES CGALConfig.cmake
            PATHS $ENV{CGAL_DIR}
                  $ENV{ProgramFiles}
                  $ENV{SystemDrive}
            PATH_SUFFIXES CGAL cmake/CGAL
                          lib lib/CGAL lib/cmake/CGAL lib/ms lib/ms/CGAL
                          lib64 lib64/CGAL lib64/cmake/CGAL lib64/ms lib64/ms/CGAL
            DOC ${CGAL_CMAKE_DOC})
ENDIF(NOT CGAL_CMAKE_PATH)

SET(CGAL_FOUND FALSE)

IF(CGAL_CMAKE_PATH)
  SET(CGAL_DIR ${CGAL_CMAKE_PATH})
  IF(CGAL_FIND_REQUIRED)
    FIND_PACKAGE(CGAL NO_MODULE REQUIRED ${CGAL_FIND_COMPONENTS})
  ELSE(CGAL_FIND_REQUIRED)
    FIND_PACKAGE(CGAL NO_MODULE COMPONENTS ${CGAL_FIND_COMPONENTS})
  ENDIF(CGAL_FIND_REQUIRED)
ENDIF(CGAL_CMAKE_PATH)

IF(CGAL_FOUND)
  SET(CGAL_DEBUG_CFLAGS    "${CGAL_CXX_FLAGS_INIT} ${CGAL_CXX_FLAGS_DEBUG_INIT}")
  SET(CGAL_RELEASE_CFLAGS  "${CGAL_CXX_FLAGS_INIT} ${CGAL_CXX_FLAGS_RELEASE_INIT}")
  SEPARATE_ARGUMENTS(CGAL_DEBUG_CFLAGS)
  SEPARATE_ARGUMENTS(CGAL_RELEASE_CFLAGS)

  SET(CGAL_VERSION_MAJOR ${CGAL_MAJOR_VERSION})
  SET(CGAL_VERSION_MINOR ${CGAL_MINOR_VERSION})
  SET(CGAL_VERSION_PATCH ${CGAL_BUILD_VERSION})

  GET_FILENAME_COMPONENT(CGAL_LIBRARY_DIRS ${CGAL_LIBRARIES_DIR} ABSOLUTE)
  IF(EXISTS ${CGAL_LIBRARY})
    IF(IS_DIRECTORY ${CGAL_LIBRARY})
      SET(CGAL_WILL_AUTOLINK TRUE)
    ELSE(IS_DIRECTORY ${CGAL_LIBRARY})
      SET(CGAL_WILL_AUTOLINK FALSE)
    ENDIF(IS_DIRECTORY ${CGAL_LIBRARY})
  ELSE(EXISTS ${CGAL_LIBRARY})
    SET(CGAL_WILL_AUTOLINK TRUE)
  ENDIF(EXISTS ${CGAL_LIBRARY})

  IF(CGAL_WILL_AUTOLINK)
    SET(CGAL_LIBRARY )
    FOREACH(CGAL_COMPONENT ${CGAL_FIND_COMPONENTS})
      SET(CGAL_${CGAL_COMPONENT}_LIBRARY )
    ENDFOREACH(CGAL_COMPONENT)
  ENDIF(CGAL_WILL_AUTOLINK)

  IF(NOT CGAL_FIND_QUIETLY)
    IF(CGAL_WILL_AUTOLINK)
      MESSAGE(STATUS "Found CGAL: headers at ${CGAL_INCLUDE_DIRS}, libraries at ${CGAL_LIBRARY_DIRS}")
      FOREACH(CGAL_COMPONENT ${CGAL_FIND_COMPONENTS})
        MESSAGE(STATUS "    ${CGAL_COMPONENT} library found")
      ENDFOREACH(CGAL_COMPONENT)
    ELSE(CGAL_WILL_AUTOLINK)
      MESSAGE(STATUS "Found CGAL: headers at ${CGAL_INCLUDE_DIRS}, library at ${CGAL_LIBRARY}")
      FOREACH(CGAL_COMPONENT ${CGAL_FIND_COMPONENTS})
        MESSAGE(STATUS "    ${CGAL_COMPONENT} library at ${CGAL_${CGAL_COMPONENT}_LIBRARY}")
      ENDFOREACH(CGAL_COMPONENT)
    ENDIF(CGAL_WILL_AUTOLINK)
  ENDIF(NOT CGAL_FIND_QUIETLY)
ELSE(CGAL_FOUND)
  IF(CGAL_FIND_REQUIRED)
    MESSAGE(FATAL_ERROR "CGAL not found")
  ELSE(CGAL_FIND_REQUIRED)
    IF(NOT CGAL_FIND_QUIETLY)
      MESSAGE(STATUS "CGAL not found")
    ENDIF(NOT CGAL_FIND_QUIETLY)
  ENDIF(CGAL_FIND_REQUIRED)
ENDIF(CGAL_FOUND)
