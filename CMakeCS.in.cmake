@PACKAGE_INIT@
cmake_policy(PUSH)
cmake_minimum_required (VERSION 3.17)

#set_and_check(CMAKECS_CMAKE_DIR @PACKAGE_CMAKECS_CMAKE_DIR@)

#CMAKE_MODULE_PATH

#${CMAKE_FIND_PACKAGE_NAME}_MAIN_INCLUDE_FILE

include(CMakeFindDependencyMacro)
message(STATUS "CMakeCS-Prefix:${PACKAGE_PREFIX_DIR}")
#if(BUILD_TESTING)
    #enable_testing()
    find_dependency(@TARGET_TEST_DEPENDENCY@)
    message(STATUS "@PACKAGE_INSTALL_DEST@")
    message(STATUS "@PACKAGE_CMAKECS_CMAKE_DIR@")
    include("${CMAKE_CURRENT_LIST_DIR}/CMakeCSTargets.cmake")

#endif()

cmake_policy(POP)