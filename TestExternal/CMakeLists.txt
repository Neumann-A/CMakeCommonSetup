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
include(ExternalProject)
project(CMakeCS-TestExternal)

ExternalProject_Add(CMakeCS SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/.."
                            BINARY_DIR  CMakeCS
                            LOG_DIR log/CmakeCS
                            CMAKE_CACHE_ARGS "-DCMAKE_TOOLCHAIN_FILE:PATH=${CMAKE_TOOLCHAIN_FILE}"
                                             "-DVCPKG_TARGET_TRIPLET:STRING=${VCPKG_TARGET_TRIPLET}"
                                             "-DBUILD_TESTING:BOOL=ON"
                                             "-DBUILD_DUMMY:BOOL=OFF"
                                             "-DCMAKE_INSTALL_PREFIX:STRING=${CMAKE_CURRENT_SOURCE_DIR}/install"
                            STEP_TARGETS install) # required to create a depend target
#set(CMakeCS_DIR "${CMAKE_CURRENT_SOURCE_DIR}/build/CMakeCS" CACHE PATH "")

ExternalProject_Add(DepCheck SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/DepCheck"
                             BINARY_DIR DepCheck
                             LOG_DOR log/DepCheck
                             CMAKE_CACHE_ARGS "-DCMAKE_TOOLCHAIN_FILE:PATH=${CMAKE_TOOLCHAIN_FILE}"
                                              "-DVCPKG_TARGET_TRIPLET:STRING=${VCPKG_TARGET_TRIPLET}"
                                              #"-DCMakeCS_DIR:PATH=${CMAKE_CURRENT_SOURCE_DIR}/build/CMakeCS/share/CMakeCS"
                                              "-DCMAKE_PREFIX_PATH:STRING=${CMAKE_CURRENT_SOURCE_DIR}/install"

                             DEPENDS CMakeCS-install
                             STEP_TARGETS install)
#ExternalProject_Add_StepDependencies(DepCheck build CMakeCS)