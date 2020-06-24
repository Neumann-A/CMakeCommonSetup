cmake_minimum_required (VERSION 3.17)

if(NOT VCPKG_TARGET_TRIPLET AND NOT DEFINED ENV{VCPKG_DEFAULT_TRIPLET})
  if(WIN32)
    set(VCPKG_TARGET_TRIPLET "x64-windows-static" CACHE STRING "" FORCE)
  elseif(MSYS)
    set(VCPKG_TARGET_TRIPLET "x64-mingw" CACHE STRING "" FORCE)
  elseif(APPLE)
    set(VCPKG_TARGET_TRIPLET "x64-osx" CACHE STRING "" FORCE)
  elseif(UNIX)
    set(VCPKG_TARGET_TRIPLET "x64-linux" CACHE STRING "" FORCE)
  endif()
endif()
if(NOT CMAKE_TOOLCHAIN_FILE)
  message("SETTING TOOLCHAIN!")
  set(CMAKE_TOOLCHAIN_FILE "$ENV{CMAKE_VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake" CACHE INTERNAL "" FORCE)
endif()

set(CMakeCS_ENABLE_PROJECT_OVERRIDE ON CACHE BOOL "")

set(CMAKE_MESSAGE_LOG_LEVEL TRACE CACHE STRING "CMake message log level (default: )")

#enable_language(CXX)
include(cmake/CMakeCS.cmake)

# This is ugly but will fire a CMake warning if the first project 
# call is not directly called in the toplevel CMakeLists.txt

set(PROJECT_FILE "Project.CMakeCS.cmakecs") # Just used for the alternativ style
project(${PROJECT_FILE}) 

feature_summary(WHAT ALL)


### Alternativ style
# cmcs_get_toplevel_project_info(PROJECT_PARAMETERS ${PROJECT_FILE})
# project(${PROJECT_PARAMETERS}) 
# cmcs_project_file(${PROJECT_FILE} TOPLEVEL)

# cmcs_init_project( PACKAGE_NAME CMakeCS
#                    REQUIRED_PACKAGES GTest
#                    NO_FINALIZE
#                  )
# include("Target_TestWrapper.cmake")

# option(BUILD_DUMMY "Build and install dummy project" ON)
# if(BUILD_DUMMY)
#   add_subdirectory(testdummies)
# endif()

# cmcs_finalize_project()

# include(TestExternal/DepCheck/Project-DepCheck.cmake)