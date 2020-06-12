cmake_minimum_required (VERSION 3.17)

if(NOT VCPKG_TARGET_TRIPLET)
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


set(CMAKE_MESSAGE_LOG_LEVEL TRACE CACHE STRING "CMake message log level (default: )")
enable_language(C CXX)
include(cmake/CMakeCS.cmake)

project(CMakeCommonSetup 
        VERSION 0.1.0 
        DESCRIPTION "Common CMake scripts to setup projects, tests, dependencies (via package managers) and other stuff"
        HOMEPAGE_URL "https://github.com/Neumann-A/CMakeCommonSetup"
        LANGUAGES CXX
        )
cmcs_init_project( PACKAGE_NAME CMakeCS
                   REQUIRED_PACKAGES GTest
                   NO_FINALIZE
                 )
set(PROJECT_SHORT_NAME CMakeCS)
set(PROJECT_INSTALL_PACKAGE "${CMAKE_INSTALL_DATAROOTDIR}/${PROJECT_SHORT_NAME}")
message(STATUS "INSTALL_PACKAGE:${PROJECT_INSTALL_PACKAGE}")
include("Target_TestWrapper.cmake")


cmcs_variable_exists_or_default(VARIABLE MODULE_DIR DEFAULT "\"\${CMAKE_CURRENT_LIST_DIR}/cmake\"")
cmcs_variable_exists_or_default(VARIABLE INCLUDE_DIR DEFAULT "include")
cmcs_variable_exists_or_default(VARIABLE CMakeCS_MODULE_DIR DEFAULT "cmake")
cmcs_variable_exists_or_default(VARIABLE cmakecs_MODULE_DIR DEFAULT "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

set(INSTALL_DEST "${PROJECT_INSTALL_PACKAGE}")
set(INSTALL_dest "${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_DATAROOTDIR}/${PROJECT_SHORT_NAME}")
file(RELATIVE_PATH REL_BUILD_PATH "${CMAKE_BINARY_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}")
set(TARGET_TEST_DEPENDENCY GTest)
#configure_package_config_file(
#  "${PROJECT_SHORT_NAME}.in.cmake"
#  "${CMAKE_INSTALL_DATAROOTDIR}/${PROJECT_SHORT_NAME}/${PROJECT_SHORT_NAME}Config.cmake"
#  INSTALL_DESTINATION "$<INSTALL_INTERFACE:${CMAKE_INSTALL_DATAROOTDIR}/${PROJECT_SHORT_NAME}/>$<BUILD_INTERFACE:${REL_BUILD_PATH}/>"
#  PATH_VARS "CMAKECS_CMAKE_DIR;INSTALL_DEST")

 #NO_SET_AND_CHECK_MACRO
#NO_CHECK_REQUIRED_COMPONENTS_MACRO 

#write_basic_package_version_file(share/${PROJECT_SHORT_NAME}/${PROJECT_SHORT_NAME}ConfigVersion.cmake VERSION ${PROJECT_VERSION} COMPATIBILITY AnyNewerVersion ARCH_INDEPENDENT)
message(STATUS PROJECT_NAME:${PROJECT_NAME})
cmcs_create_config_files(SETUP_MODULE_PATH VARS MODULE_DIR PATH_VARS CMakeCS_MODULE_DIR cmakecs_MODULE_DIR INSTALL_DEST INSTALL_dest INCLUDE_DIR)
message(STATUS PROJECT_NAME:${PROJECT_NAME})
#install(FILES ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_INSTALL_PACKAGE}/${PROJECT_SHORT_NAME}Config.cmake
#              ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_INSTALL_PACKAGE}/${PROJECT_SHORT_NAME}ConfigVersion.cmake
#        DESTINATION ${PROJECT_INSTALL_PACKAGE} )
#install(DIRECTORY "cmake" DESTINATION "${PROJECT_INSTALL_PACKAGE}")

option(BUILD_DUMMY "Build and install dummy project" ON)
if(BUILD_DUMMY)
  add_subdirectory(testdummies)
endif()


cmcs_finalize_project()
feature_summary(WHAT ALL)

include(TestExternal/DepCheck/Project-DepCheck.cmake)