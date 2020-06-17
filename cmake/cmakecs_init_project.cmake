# PACKAGE_NAME name -> Name of the Package for other libraries to find this project via find_package(<name>) (defaults to PROJECT_NAME if none given)

## Packages which require external visibility. 

# REQUIRED_PACKAGES name0 name1 .... -> Name of external packages which are required by this project. 

# OPTIONAL_PACKAGES name0 name1 .... -> Name of external packages which are optional for this project. 
# OPTIONAL_DEPENDENT_PACKAGES name0 name1 .... -> Name of external packages which are optional but dependent on others by this project. 
# optional dependencies create the (dependent) option ${PACKAGE_NAME}_ENABLE_package and default it to OFF

## Package specific

# VERSION_packagename VERSION .... -> Name of external packages which are required by this project. 
# COMPONENTS_packagename -> Components required of external package with name <packagename> for this project 
# FIND_OPTIONS_packagename -> Additional options to pass to find_package(<packagename>)
# DEPENDENT_packagename names .... -> Only for OPTIONAL_DEPENDENT_PACKAGES to define the dependencies in the CMAKE_DEPENDENT_OPTION call

# All info is getting stored in ${PROJECT_NAME}_<parametername>
function(cmcs_init_project)
    message(TRACE "[CMakeCS cmcs_init_project]: ${ARGN}|${ARGC}")
    include(CTest) # https://cmake.org/cmake/help/latest/module/CTest.html
    include(CPack) # https://cmake.org/cmake/help/latest/module/CPack.html
    cmcs_create_function_variable_prefix(_FUNC_PREFIX)
    message(TRACE: "PROJECT_NAME:${PROJECT_NAME}")
    set(_VAR_PREFIX "${_FUNC_PREFIX}_${PROJECT_NAME}")
    message(TRACE: "_VAR_PREFIX:${_VAR_PREFIX}")
    include("${CMAKE_CURRENT_FUNCTION_LIST_DIR}/cmakecs_project_options.cmake" NO_POLICY_SCOPE)
    cmake_parse_arguments(PARSE_ARGV 0 "${_VAR_PREFIX}" "${PROJECT_OPTIONS}" "${PROJECT_ARGS}" "${PROJECT_MULTI_ARGS}")
    message(TRACE: "_VAR_PREFIX:${_VAR_PREFIX}")
    cmcs_get_global_property(PROPERTY ${PROJECT_NAME}_PARENT)
    if(${PROJECT_NAME}_PARENT)
        cmcs_variable_exists_or_default(VARIABLE ${_VAR_PREFIX}_PACKAGE_NAME DEFAULT ${${PROJECT_NAME}_PARENT}${PROJECT_NAME})
        cmcs_get_global_property(PROPERTY ${${PROJECT_NAME}_PARENT}_NAMESPACE)
        cmcs_variable_exists_or_default(VARIABLE ${_VAR_PREFIX}_NAMESPACE DEFAULT ${${${PROJECT_NAME}_PARENT}_NAMESPACE})
        cmcs_get_global_property(PROPERTY ${${PROJECT_NAME}_PARENT}_VERSION)
        cmcs_get_global_property(PROPERTY ${${PROJECT_NAME}_PARENT}_VERSION_COMPATIBILITY)
        cmcs_variable_exists_or_default(VARIABLE ${_VAR_PREFIX}_VERSION_COMPATIBILITY DEFAULT ${${${PROJECT_NAME}_PARENT}_VERSION_COMPATIBILITY})
    else()
        cmcs_variable_exists_or_default(VARIABLE ${_VAR_PREFIX}_PACKAGE_NAME DEFAULT ${PROJECT_NAME})
        cmcs_variable_exists_or_default(VARIABLE ${_VAR_PREFIX}_NAMESPACE DEFAULT ${${_VAR_PREFIX}_PACKAGE_NAME})
        if(CMAKE_PROJECT_VERSION)
            cmcs_variable_exists_or_default(VARIABLE ${_VAR_PREFIX}_VERSION DEFAULT ${CMAKE_PROJECT_VERSION})
        else()
            cmcs_variable_exists_or_default(VARIABLE ${_VAR_PREFIX}_VERSION DEFAULT "0.1")
        endif()
        cmcs_variable_exists_or_default(VARIABLE ${_VAR_PREFIX}_VERSION_COMPATIBILITY DEFAULT "AnyNewerVersion")
    endif()
    
    if(${_VAR_PREFIX}_OPTION_FILE)
        include("${${_VAR_PREFIX}_OPTION_FILE}")
    endif()

    cmcs_variable_exists_or_default(VARIABLE ${_VAR_PREFIX}_EXPORT_NAME DEFAULT ${${_VAR_PREFIX}_PACKAGE_NAME})
    
    cmcs_variable_exists_or_default(VARIABLE ${_VAR_PREFIX}_CONFIG_INSTALL_DESTINATION DEFAULT "${CMAKE_INSTALL_DATAROOTDIR}/${${_VAR_PREFIX}_PACKAGE_NAME}")

    cmcs_define_project_properties(PROJECT_NAME ${PROJECT_NAME})
    cmcs_set_global_property(PREFIX ${_FUNC_PREFIX} PROPERTY ${PROJECT_NAME}_PACKAGE_NAME)
    cmcs_set_global_property(PREFIX ${_FUNC_PREFIX} PROPERTY ${PROJECT_NAME}_NAMESPACE)
    cmcs_set_global_property(PREFIX ${_FUNC_PREFIX} PROPERTY ${PROJECT_NAME}_EXPORT_NAME)
    cmcs_set_global_property(PREFIX ${_FUNC_PREFIX} PROPERTY ${PROJECT_NAME}_REQUIRED_PACKAGES)
    cmcs_set_global_property(PREFIX ${_FUNC_PREFIX} PROPERTY ${PROJECT_NAME}_OPTIONAL_PACKAGES)
    cmcs_set_global_property(PREFIX ${_FUNC_PREFIX} PROPERTY ${PROJECT_NAME}_OPTIONAL_CONDITIONAL_PACKAGES)
    cmcs_set_global_property(PREFIX ${_FUNC_PREFIX} PROPERTY ${PROJECT_NAME}_VERSION)
    cmcs_set_global_property(PREFIX ${_FUNC_PREFIX} PROPERTY ${PROJECT_NAME}_VERSION_COMPATIBILITY)
    cmcs_set_global_property(PREFIX ${_FUNC_PREFIX} PROPERTY ${PROJECT_NAME}_CONFIG_INSTALL_DESTINATION)
    cmcs_set_global_property(PREFIX ${_FUNC_PREFIX} PROPERTY ${PROJECT_NAME}_CONFIG_INPUT_FILE)
    cmcs_set_global_property(PREFIX ${_FUNC_PREFIX} PROPERTY ${PROJECT_NAME}_PUBLIC_CMAKE_FILES)
    cmcs_set_global_property(PREFIX ${_FUNC_PREFIX} PROPERTY ${PROJECT_NAME}_PUBLIC_CMAKE_DIRS)
    cmcs_set_global_property(PREFIX ${_FUNC_PREFIX} PROPERTY ${PROJECT_NAME}_MODULES_TO_INCLUDE)

    set(${_FUNC_PREFIX}_${PROJECT_NAME}_EXPORT_ON_BUILD ON) # TODO: Check if necessary or always export
    cmcs_set_global_property(PREFIX ${_FUNC_PREFIX} PROPERTY ${PROJECT_NAME}_EXPORT_ON_BUILD)

    set(${PROJECT_NAME}_PARENT ${CMAKE_PROJECT_NAME})
    cmcs_set_global_property(PROPERTY ${PROJECT_NAME}_PARENT)

    if(DEFINED ${PROJECT_NAME}_IS_SUBPROJECT)
        cmcs_error_message("${PROJECT_NAME} has two calls to cmcs_init_project! Remove one!")
    endif()
    string(COMPARE NOTEQUAL "${CMAKE_PROJECT_NAME}" "${PROJECT_NAME}" ${PROJECT_NAME}_IS_SUBPROJECT)
    if(${PROJECT_NAME}_IS_SUBPROJECT)
        set(${CMAKE_PROJECT_NAME}_SUBPROJECTS ${${CMAKE_PROJECT_NAME}_SUBPROJECTS} ${PROJECT_NAME} CACHE INTERNAL "")
    else()
        set(CMakeCS_TOP_PROJECTS ${CMakeCS_PROJECTS} ${PROJECT_NAME} CACHE INTERNAL "")
    endif()
    set(CMakeCS_ALL_PROJECTS ${CMakeCS_ALL_PROJECTS} ${PROJECT_NAME} CACHE INTERNAL "")

    set(${PROJECT_NAME}_EXPORTED_TARGETS "" CACHE INTERNAL "Exported targets of the project" FORCE)

    ## Package Setup
    foreach(_package IN LISTS ${_VAR_PREFIX}_REQUIRED_PACKAGES)
        cmcs_define_project_used_package_properties(PROJECT_NAME "${PROJECT_NAME}" PACKAGE_NAME "${_package}")
        cmake_parse_arguments("${_VAR_PREFIX}" 
                              "" 
                              "${_package}_VERSION" 
                              "${_package}_COMPONENTS;${_package}_FIND_OPTIONS" ${${_VAR_PREFIX}_UNPARSED_ARGUMENTS})
        cmcs_set_global_property(PREFIX ${_VAR_PREFIX} PROPERTY OPTIONAL_DEPENDENT_PACKAGES)
        set(_find_string "${_package}")
        if(DEFINED ${_VAR_PREFIX}_${_package}_VERSION)
            string(APPEND _find_string ";${${_VAR_PREFIX}_${_package}_VERSION}")
        endif()
        string(APPEND _find_string ";REQUIRED")
        if(DEFINED ${_VAR_PREFIX}_${_package}_COMPONENTS)
            string(APPEND _find_string ";COMPONENTS;${_VAR_PREFIX}_${_package}_COMPONENTS")
        endif()
        if(DEFINED ${_VAR_PREFIX}_${_package}_FIND_OPTIONS)
            string(APPEND _find_string ";${_VAR_PREFIX}_${_package}_FIND_OPTIONS")
        endif()
        set(${PROJECT_NAME}_${_package}_FIND_PACKAGE "${_find_string}" CACHE INTERNAL "")
        find_package(${_find_string})
        unset(_find_string)
        unset(PACKAGE_NAME)
    endforeach()
    foreach(_package IN LISTS ${_VAR_PREFIX}_OPTIONAL_PACKAGES)
        option(${${PROJECT_NAME}_PACKAGE_NAME}_ENABLE_${_package} "Enable usage of package ${_package} within ${PROJECT_NAME}" OFF)
        cmcs_define_project_used_package_properties(PROJECT_NAME "${PROJECT_NAME}" PACKAGE_NAME "${_package}")
        cmake_parse_arguments("${_VAR_PREFIX}" "" "${_package}_VERSION" "${_package}_COMPONENTS;${_package}_FIND_OPTIONS" ${${_VAR_PREFIX}_UNPARSED_ARGUMENTS})
        set(_find_string "${_package}")
        if(DEFINED ${_VAR_PREFIX}_${_package}_VERSION)
            string(APPEND _find_string ";${${_VAR_PREFIX}_${_package}_VERSION}")
        endif()
        if(DEFINED ${_VAR_PREFIX}_${_package}_COMPONENTS)
            string(APPEND _find_string ";COMPONENTS;${_VAR_PREFIX}_${_package}_COMPONENTS")
        endif()
        if(DEFINED ${_VAR_PREFIX}_${_package}_FIND_OPTIONS)
            string(APPEND _find_string ";${_VAR_PREFIX}_${_package}_FIND_OPTIONS")
        endif()
        set(${PROJECT_NAME}_${_package}_FIND_PACKAGE "${_find_string}" CACHE INTERNAL "")
        if(NOT ${${PROJECT_NAME}_PACKAGE_NAME}_ENABLE_${_package})
            # Trick to make feature summary work with optional dependencies! 
            set(CMAKE_DISABLE_FIND_PACKAGE_${_package} TRUE)    
        endif()        
        find_package(${_find_string})  # Cannot have this in an if for FeatureSummary
        unset(_find_string)
        if(${${PROJECT_NAME}_PACKAGE_NAME}_ENABLE_${_package} AND NOT _package)
            cmcs_error_message("${_package} requested but not found!")
        endif()
    endforeach()
    foreach(_package IN LISTS ${_VAR_PREFIX}_OPTIONAL_CONDITIONAL_PACKAGES)
        cmake_parse_arguments("${_VAR_PREFIX}" "" "${_package}_VERSION" "${_package}_COMPONENTS;${_package}_FIND_OPTIONS;${_package}_CONDITIONAL" ${${_VAR_PREFIX}_UNPARSED_ARGUMENTS})
        if(NOT DEFINED ${_VAR_PREFIX}_DEPENDENT_${_package})
        endif()
        CMAKE_DEPENDENT_OPTION(${${PROJECT_NAME}_PACKAGE_NAME}_ENABLE_${_package} "Enable usage of package ${_package} within ${PROJECT_NAME}" ${${_VAR_PREFIX}_${_package}_CONDITIONAL} OFF)

        set(_find_string "${_package}")
        if(DEFINED ${_VAR_PREFIX}_${_package}_VERSION)
            string(APPEND _find_string ";${${_VAR_PREFIX}_${_package}_VERSION}")
        endif()
        string(APPEND _find_string ";REQUIRED")
        if(DEFINED ${_VAR_PREFIX}_${_package}_COMPONENTS)
            string(APPEND _find_string ";COMPONENTS;${_VAR_PREFIX}_${_package}_COMPONENTS")
        endif()
        if(DEFINED ${_VAR_PREFIX}_${_package}_FIND_OPTIONS)
            string(APPEND _find_string ";${_VAR_PREFIX}_${_package}_FIND_OPTIONS")
        endif()
        set(${PROJECT_NAME}_${_package}_FIND_PACKAGE "${_find_string}" CACHE INTERNAL "")
        if(NOT ${${PROJECT_NAME}_PACKAGE_NAME}_ENABLE_${_package})
            # Trick to make feature summary work with optional dependencies! 
            set(CMAKE_DISABLE_FIND_PACKAGE_${_package} TRUE)    
        endif() 
        find_package(${_find_string}) # Cannot have this in an if for FeatureSummary
        if(${${PROJECT_NAME}_PACKAGE_NAME}_ENABLE_${_package} AND NOT _package)
            cmcs_error_message("${_package} requested but not found!")
        endif()
        unset(_find_string)
    endforeach()

    message(TRACE: "_VAR_PREFIX:${_VAR_PREFIX}")
    foreach(_subdir IN LISTS ${_VAR_PREFIX}_SUBDIRECTORIES)
        message(TRACE "Adding subdirectory ${_subdir} to project ${PROJECT_NAME}")
        add_subdirectory("${_subdir}")
    endforeach()

    message(TRACE: "_VAR_PREFIX:${_VAR_PREFIX}")
    foreach(_targetfile IN LISTS ${_VAR_PREFIX}_TARGET_FILES)
        message(TRACE "Reading target file ${_targetfile} for project ${PROJECT_NAME}")
        cmcs_read_target_file(${_targetfile})
    endforeach()

    message(TRACE: "_VAR_PREFIX:${_VAR_PREFIX}")
    message(STATUS "${_VAR_PREFIX}_NO_AUTOMATIC_CONFIG_FILE:${${_VAR_PREFIX}_NO_AUTOMATIC_CONFIG_FILE}")
    if(NOT ${_VAR_PREFIX}_NO_AUTOMATIC_CONFIG_FILE)
        if(${_VAR_PREFIX}_CONFIG_WITH_MODULES)
            cmcs_create_config_files(SETUP_MODULE_PATH)
        else()
            cmcs_create_config_files()
        endif()
    endif()

    if(NOT ${_VAR_PREFIX}_NO_FINALIZE)
        cmcs_finalize_project()
    endif()
endfunction()