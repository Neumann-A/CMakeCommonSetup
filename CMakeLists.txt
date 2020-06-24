cmake_minimum_required (VERSION 3.17)

set(CMAKE_MESSAGE_LOG_LEVEL VERBOSE CACHE STRING "CMake message log level (default: VERBOSE)")

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules)
find_package(VCPKG)

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
