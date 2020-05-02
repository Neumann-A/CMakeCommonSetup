cmake_minimum_required (VERSION 3.17)

if(NOT VCPKG_TARGET_TRIPLET)
  message("SETTING TRIPLET!")
  set(VCPKG_TARGET_TRIPLET "x64-windows-static" CACHE STRING "" FORCE)
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
                 )
set(PROJECT_SHORT_NAME CMakeCS)
set(PROJECT_INSTALL_PACKAGE "${CMAKE_INSTALL_DATAROOTDIR}/${PROJECT_SHORT_NAME}")
message(STATUS "INSTALL_PACKAGE:${PROJECT_INSTALL_PACKAGE}")
include(Target_TestWrapper.cmake)

cmcs_variable_exists_or_default(VARIABLE CMAKECS_CMAKE_DIR DEFAULT "cmake")

set(INSTALL_DEST ${PROJECT_INSTALL_PACKAGE})
set(TARGET_TEST_DEPENDENCY GTest)
configure_package_config_file(
  "${PROJECT_SHORT_NAME}.in.cmake"
  "share/${PROJECT_SHORT_NAME}/${PROJECT_SHORT_NAME}Config.cmake"
  INSTALL_DESTINATION "${CMAKE_INSTALL_DATAROOTDIR}/${PROJECT_SHORT_NAME}"
  PATH_VARS "CMAKECS_CMAKE_DIR;INSTALL_DEST")
write_basic_package_version_file(share/${PROJECT_SHORT_NAME}/${PROJECT_SHORT_NAME}ConfigVersion.cmake VERSION ${PROJECT_VERSION} COMPATIBILITY AnyNewerVersion ARCH_INDEPENDENT)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_INSTALL_PACKAGE}/${PROJECT_SHORT_NAME}Config.cmake
              ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_INSTALL_PACKAGE}/${PROJECT_SHORT_NAME}ConfigVersion.cmake
        DESTINATION ${PROJECT_INSTALL_PACKAGE} )
install(DIRECTORY "cmake" DESTINATION "${PROJECT_INSTALL_PACKAGE}")

option(BUILD_DUMMY "Build and install dummy project" ON)
if(BUILD_DUMMY)
  add_subdirectory(testdummies)
endif()


cmcs_finalize_project()
feature_summary(WHAT ALL)

include(TestExternal/DepCheck/Project-DepCheck.cmake)