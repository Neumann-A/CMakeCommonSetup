# This file will be directly passed to cmcs_project()
PROJECT_NAME    # Project Name
    CMakeCS_Example
#PACKAGE_NAME    # Name for later find_package calls; Also used as a Namespace for exported targets if NAMESPACE is not given
#    CMakeCS_Example
VERSION 
    0.0.1
VERSION_COMPATIBILITY
    Any
DESCRIPTION 
    "Example Project for CMakeCS"
HOMEPAGE_URL
    "https://github.com/Neumann-A/CMakeCommonSetup"
LANGUAGES 
    CXX
REQUIRED_PACKAGES   # These external packages are required. CMakeCS will automatically create a find_package call for them
    GTest
    Benchmark
OPTIONAL_PACKAGES   # These external packages are optional. CMakeCS will automatically create a find_package call for them with an additional option variable.
    Eigen3
    boost
boost_COMPONENTS    # This is how you define component requirements. <packagename>_VERSION also exists
    program_options
#OPTIONAL_CONDITIONAL_PACKAGES
#PUBLIC_CMAKE_FILES
#PUBLIC_CMAKE_DIRS
#EXPORT_NAME
#CONFIG_INSTALL_DESTINATION
SUBDIRECTORIES # will be run before including TARGET_FILES
    "Components/Component1"
    "Components/Component2"
TARGET_FILES # Files need to be in order of target requirements. Files will be simply included 
    "Target.MyMainLib.cmake"
    "Target.MyApp.cmake"
OPTION_FILE
    "MyOptions.cmake"
PUBLIC_CMAKE_DIRS
    "cmake"