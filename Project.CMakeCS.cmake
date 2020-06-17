# This file will be directly passed to cmcs_project()
PROJECT_NAME    # Project Name
    CMakeCommonSetup
PACKAGE_NAME    # Name for later find_package calls; Also used as a Namespace for exported targets if NAMESPACE is not given
    CMakeCS
VERSION 
    0.1.0
VERSION_COMPATIBILITY
    AnyNewerVersion
DESCRIPTION 
    "Common CMake scripts to setup projects, tests, dependencies (via package managers) and other stuff"
HOMEPAGE_URL
    "https://github.com/Neumann-A/CMakeCommonSetup"
LANGUAGES 
    CXX
PUBLIC_CMAKE_DIRS
    cmake
CONFIG_WITH_MODULES
MODULES_TO_INCLUDE
    CMakeCS
REQUIRED_PACKAGES
    GTest
TARGET_FILES
    Target.TestWrapper.cmake
