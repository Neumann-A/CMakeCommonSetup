cmake_minimum_required (VERSION 3.17)

set(CMAKE_MESSAGE_LOG_LEVEL VERBOSE CACHE STRING "CMake message log level (default: VERBOSE)")

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules)

# How to define options correctly for consumption with feature options
include(FeatureSummary)
set(CMakeCS_ENABLE_GTest OFF CACHE BOOL "" FORCE)
#option(WITH_GTestWrapper "Enables the creation of the GTestWrapper target" ON)
#add_feature_info(GTestWrapper WITH_GTestWrapper "Adds the CMakeCS::GTestWrapper target")
option(WITH_MYFEAT1 "Help for MYFEAT1" ON)
add_feature_info(Feature_1 WITH_MYFEAT1 "The Feature_1 feature provides very hot stuff.")

find_package(VCPKG)
# How to define package properties.
set_package_properties(VCPKG PROPERTIES
                             PURPOSE "- used to find dependencies")

include(cmake/CMakeCS.cmake)

project("Project.CMakeCS.cmakecs") 

# Showing off the feature sommary
feature_summary(WHAT ALL)

### Alternativ style (without project() override)
# This is ugly but will fire a CMake warning if the first project 
# call is not directly called in the toplevel CMakeLists.txt

# set(CMakeCS_ENABLE_PROJECT_OVERRIDE OFF CACHE BOOL "")
# include(cmake/CMakeCS.cmake)
# set(PROJECT_FILE "Project.CMakeCS.cmakecs") # Just used for the alternativ style
# cmcs_get_toplevel_project_info(PROJECT_PARAMETERS ${PROJECT_FILE})
# project(${PROJECT_PARAMETERS}) 
# cmcs_project_file(${PROJECT_FILE} TOPLEVEL)
