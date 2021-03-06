## Component Options
set(CMAKECS_COMPONENT_OPTIONS "USE_DIRECTORY_AS_COMPONENT_NAME"
                            "NO_FINALIZE;NO_AUTOMATIC_CONFIG_FILE"
                            "CONFIG_WITH_MODULES"
                            "EXTENDED_PACKAGES_INFO" # Just to block cmake_parse_argument for MULTI_ARGS
                            #"SYMLINKED_BUILD_INCLUDEDIR" # creates a mirror of the installed include layout in CMAKE_BINARY_DIR via symlinks
                            CACHE INTERNAL "")
set(CMAKECS_COMPONENT_ARGS "COMPONENT_NAME;VERSION;DESCRIPTION"
                         "COMPONENT_NAMESPACE"
                         "EXPORT_NAME"
                         "VERSION_COMPATIBILITY;CONFIG_INPUT_FILE;CONFIG_INSTALL_DESTINATION"
                         #"OPTION_FILE" # TODO
                         #"PUBLIC_MODULE_DIRECTORIES" #TODO: Should be handle on Project Scope
                         #"INSTALL_INCLUDEDIR"
                         #"USAGE_INCLUDEDIR"
                         "TARGETS_FOLDER"
                         CACHE INTERNAL "")
set(CMAKECS_COMPONENT_MULTI_ARGS #"LANGUAGES"
                               "REQUIRED_PACKAGES;OPTIONAL_PACKAGES;OPTIONAL_CONDITIONAL_PACKAGES"
                               "RECOMMENDED_PACKAGES;RUNTIME_PACKAGES" # TODO
                               "INCLUDES;SUBDIRECTORIES;INCLUDES_AFTER_SUBDIRECTORIES;TARGET_FILES;INCLUDES_AFTER_TARGETS"
                               "EXPORTED_VARIABLES" # These variables will be exported in the config 
                               "CONDITION" # Condition for which the COMPONENT is loaded"
                                CACHE INTERNAL "")
mark_as_advanced(CMAKECS_COMPONENT_OPTIONS CMAKECS_COMPONENT_ARGS CMAKECS_COMPONENT_MULTI_ARGS)


## Compononent Function
function(cmcs_component)
    list(APPEND CMAKE_MESSAGE_CONTEXT "component")
    message(TRACE "[CMakeCS cmcs_component]: ${ARGN}|${ARGC}")

    cmcs_create_function_variable_prefix(_FUNC_PREFIX)
    cmake_parse_arguments(PARSE_ARGV 0 "${_FUNC_PREFIX}" "" "COMPONENT_NAME" "")
    set(COMPONENT_NAME ${${_FUNC_PREFIX}_COMPONENT_NAME})
    set(_VAR_PREFIX "${_FUNC_PREFIX}_${PROJECT_NAME}_${COMPONENT_NAME}")
    #include("${CMAKE_CURRENT_FUNCTION_LIST_DIR}/cmakecs_project_options.cmake" NO_POLICY_SCOPE)
    cmake_parse_arguments(PARSE_ARGV 0 "${_VAR_PREFIX}" "${CMAKECS_PROJECT_OPTIONS}" "${CMAKECS_PROJECT_ARGS}" "${CMAKECS_PROJECT_MULTI_ARGS}")
    
    #cmcs_get_global_property(PROPERTY ${PROJECT_NAME}_PARENT)

    #cmcs_variable_exists_or_default(VARIABLE ${_VAR_PREFIX}_PACKAGE_NAME DEFAULT ${PROJECT_NAME})
    # cmcs_get_global_property(PROPERTY ${${PROJECT_NAME}}_NAMESPACE)
    # cmcs_variable_exists_or_default(VARIABLE ${_VAR_PREFIX}_TARGETS_FOLDER DEFAULT  ${${_VAR_PREFIX}_PACKAGE_NAME})
    # cmcs_variable_exists_or_default(VARIABLE ${_VAR_PREFIX}_NAMESPACE DEFAULT ${${_VAR_PREFIX}_PACKAGE_NAME})
    # if(CMAKE_PROJECT_VERSION)
    #     cmcs_variable_exists_or_default(VARIABLE ${_VAR_PREFIX}_VERSION DEFAULT ${CMAKE_PROJECT_VERSION})
    # else()
    #     cmcs_variable_exists_or_default(VARIABLE ${_VAR_PREFIX}_VERSION DEFAULT "0.1.1")
    # endif()
    # cmcs_variable_exists_or_default(VARIABLE ${_VAR_PREFIX}_VERSION_COMPATIBILITY DEFAULT "AnyNewerVersion")
    # if(${_VAR_PREFIX}_VERSION)
    #     cmcs_variable_exists_or_default(VARIABLE ${_VAR_PREFIX}_INSTALL_INCLUDEDIR DEFAULT "${CMAKE_INSTALL_INCLUDEDIR}/${${_VAR_PREFIX}_PACKAGE_NAME}-${${_VAR_PREFIX}_VERSION}/${${_VAR_PREFIX}_PACKAGE_NAME}")
    #     cmcs_variable_exists_or_default(VARIABLE ${_VAR_PREFIX}_USAGE_INCLUDEDIR DEFAULT "${CMAKE_INSTALL_INCLUDEDIR}/${${_VAR_PREFIX}_PACKAGE_NAME}-${${_VAR_PREFIX}_VERSION}")
    # else()
    #     cmcs_variable_exists_or_default(VARIABLE ${_VAR_PREFIX}_INSTALL_INCLUDEDIR DEFAULT "${CMAKE_INSTALL_INCLUDEDIR}/${${_VAR_PREFIX}_PACKAGE_NAME}")
    #     cmcs_variable_exists_or_default(VARIABLE ${_VAR_PREFIX}_USAGE_INCLUDEDIR DEFAULT "${CMAKE_INSTALL_INCLUDEDIR}")
    # endif()
    # cmcs_variable_exists_or_default(VARIABLE ${_VAR_PREFIX}_INCLUDEDIR_TREE DEFAULT "include/${${_VAR_PREFIX}_PACKAGE_NAME}")
    # cmcs_variable_exists_or_default(VARIABLE ${_VAR_PREFIX}_BUILD_INCLUDEDIR DEFAULT "${CMAKE_CURRENT_BINARY_DIR}/${${_VAR_PREFIX}_INCLUDEDIR_TREE}")

    # cmcs_variable_exists_or_default(VARIABLE ${_VAR_PREFIX}_CONFIG_INSTALL_DESTINATION DEFAULT "${CMAKE_INSTALL_DATAROOTDIR}/${${_VAR_PREFIX}_PACKAGE_NAME}")


    if(${_VAR_PREFIX}_OPTION_FILE)
        include("${${_VAR_PREFIX}_OPTION_FILE}")
    endif()

    # Setup component export name/group
    cmcs_get_global_property(PROPERTY ${PROJECT_NAME}_PACKAGE_NAME)
    cmcs_variable_exists_or_default(VARIABLE ${_VAR_PREFIX}_EXPORT_NAME DEFAULT ${${PROJECT_NAME}_PACKAGE_NAME}_${COMPONENT_NAME})
    cmcs_set_global_property(PREFIX ${_FUNC_PREFIX} PROPERTY ${PROJECT_NAME}_${COMPONENT_NAME}_EXPORT_NAME)
    # Setup export namespace
    cmcs_get_global_property(PROPERTY ${PROJECT_NAME}_NAMESPACE)
    if(${_VAR_PREFIX}_COMPONENT_NAMESPACE)
        set(${_VAR_PREFIX}_NAMESPACE "${${PROJECT_NAME}_NAMESPACE}::${${_VAR_PREFIX}_COMPONENT_NAMESPACE}")
    else()
        set(${_VAR_PREFIX}_NAMESPACE "${${PROJECT_NAME}_NAMESPACE}")
    endif()
    cmcs_set_global_property(PREFIX ${_FUNC_PREFIX} PROPERTY ${PROJECT_NAME}_${COMPONENT_NAME}_NAMESPACE)
    cmcs_set_global_property(PREFIX ${_FUNC_PREFIX} PROPERTY ${PROJECT_NAME}_${COMPONENT_NAME}_COMPONENT_NAMESPACE)

    cmcs_define_project_properties(PROJECT_NAME ${PROJECT_NAME})
    # TODO: Replace with foreach()
    #cmcs_set_global_property(PREFIX ${_FUNC_PREFIX} PROPERTY ${PROJECT_NAME}_PACKAGE_NAME)

    #cmcs_set_global_property(PREFIX ${_FUNC_PREFIX} PROPERTY ${PROJECT_NAME}_PACKAGE_NAME)
    #cmcs_set_global_property(PREFIX ${_FUNC_PREFIX} PROPERTY ${PROJECT_NAME}_NAMESPACE)

    cmcs_set_global_property(APPEND_OPTION "APPEND" PROPERTY ${PROJECT_NAME}_COMPONENTS ${COMPONENT_NAME})



    cmcs_set_global_property(PREFIX ${_FUNC_PREFIX} PROPERTY ${PROJECT_NAME}_${COMPONENT_NAME}_OPTIONS)

    cmcs_set_global_property(PROPERTY CURRENT_COMPONENT_NAME "${COMPONENT_NAME}")
    #cmcs_set_global_property(PREFIX ${_FUNC_PREFIX} PROPERTY ${PROJECT_NAME}_${COMPONENT_NAME}_TARGETS)
    #cmcs_set_global_property(PREFIX ${_FUNC_PREFIX} PROPERTY ${PROJECT_NAME}_${COMPONENT_NAME}_EXPORT_NAME)
    #cmcs_set_global_property(PREFIX ${_FUNC_PREFIX} PROPERTY ${PROJECT_NAME}_REQUIRED_PACKAGES)
    #cmcs_set_global_property(PREFIX ${_FUNC_PREFIX} PROPERTY ${PROJECT_NAME}_OPTIONAL_PACKAGES)
    #cmcs_set_global_property(PREFIX ${_FUNC_PREFIX} PROPERTY ${PROJECT_NAME}_RECOMMENDED_PACKAGES)
    #cmcs_set_global_property(PREFIX ${_FUNC_PREFIX} PROPERTY ${PROJECT_NAME}_RUNTIME_PACKAGES) 
    #cmcs_set_global_property(PREFIX ${_FUNC_PREFIX} PROPERTY ${PROJECT_NAME}_OPTIONAL_CONDITIONAL_PACKAGES)
    #cmcs_set_global_property(PREFIX ${_FUNC_PREFIX} PROPERTY ${PROJECT_NAME}_VERSION)
    #cmcs_set_global_property(PREFIX ${_FUNC_PREFIX} PROPERTY ${PROJECT_NAME}_VERSION_COMPATIBILITY)
    #cmcs_set_global_property(PREFIX ${_FUNC_PREFIX} PROPERTY ${PROJECT_NAME}_CONFIG_INSTALL_DESTINATION)
    #cmcs_set_global_property(PREFIX ${_FUNC_PREFIX} PROPERTY ${PROJECT_NAME}_CONFIG_INPUT_FILE)
    #cmcs_set_global_property(PREFIX ${_FUNC_PREFIX} PROPERTY ${PROJECT_NAME}_PUBLIC_CMAKE_FILES)
    #cmcs_set_global_property(PREFIX ${_FUNC_PREFIX} PROPERTY ${PROJECT_NAME}_PUBLIC_CMAKE_DIRS)
    #cmcs_set_global_property(PREFIX ${_FUNC_PREFIX} PROPERTY ${PROJECT_NAME}_MODULES_TO_INCLUDE)
    #cmcs_set_global_property(PREFIX ${_FUNC_PREFIX} PROPERTY ${PROJECT_NAME}_PUBLIC_MODULE_DIRECTORIES)
    #cmcs_set_global_property(PREFIX ${_FUNC_PREFIX} PROPERTY ${PROJECT_NAME}_OPTIONS)
    #cmcs_set_global_property(PREFIX ${_FUNC_PREFIX} PROPERTY ${PROJECT_NAME}_EXPORTED_VARIABLES)
    #cmcs_set_global_property(PREFIX ${_FUNC_PREFIX} PROPERTY ${PROJECT_NAME}_INSTALL_INCLUDEDIR)
    #cmcs_set_global_property(PREFIX ${_FUNC_PREFIX} PROPERTY ${PROJECT_NAME}_USAGE_INCLUDEDIR)
    #cmcs_set_global_property(PREFIX ${_FUNC_PREFIX} PROPERTY ${PROJECT_NAME}_BUILD_INCLUDEDIR)
    #cmcs_set_global_property(PREFIX ${_FUNC_PREFIX} PROPERTY ${PROJECT_NAME}_INCLUDEDIR_TREE)
    #cmcs_set_global_property(PREFIX ${_FUNC_PREFIX} PROPERTY ${PROJECT_NAME}_SYMLINKED_BUILD_INCLUDEDIR)
    #cmcs_set_global_property(PREFIX ${_FUNC_PREFIX} PROPERTY ${PROJECT_NAME}_TARGETS_FOLDER)

    set(${_FUNC_PREFIX}_${PROJECT_NAME}_${COMPONENT_NAME}_EXPORT_ON_BUILD ON) # TODO: Check if necessary or always export
    cmcs_set_global_property(PREFIX ${_FUNC_PREFIX} PROPERTY ${PROJECT_NAME}_${COMPONENT_NAME}_EXPORT_ON_BUILD)


    #cmcs_get_global_property(PROPERTY ${CMAKE_PROJECT_NAME}_PACKAGE_NAME)
    #set(${PROJECT_NAME}_PARENT ${CMAKE_PROJECT_NAME}_PACKAGE_NAME)
    #cmcs_set_global_property(PROPERTY ${PROJECT_NAME}_PARENT)

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
    set(PACKAGE_OPTION_ARG)
    foreach(_package IN LISTS ${_VAR_PREFIX}_REQUIRED_PACKAGES ${_VAR_PREFIX}_OPTIONAL_PACKAGES ${_VAR_PREFIX}_RECOMMENDED_PACKAGES ${_VAR_PREFIX}_OPTIONAL_CONDITIONAL_PACKAGES)
        list(APPEND PACKAGE_SINGLE_ARG "${_package}_VERSION;${_package}_PURPOSE" )
        list(APPEND PACKAGE_MULTI_ARG "${_package}_COMPONENTS;${_package}_FIND_OPTIONS;${_package}_CONDITION" )
    endforeach()
    cmake_parse_arguments("${_VAR_PREFIX}" "${PACKAGE_OPTION_ARG}" "${PACKAGE_SINGLE_ARG}" "${PACKAGE_MULTI_ARG}" ${${_VAR_PREFIX}_UNPARSED_ARGUMENTS})

    foreach(_package IN LISTS ${_VAR_PREFIX}_REQUIRED_PACKAGES)
        cmcs_define_project_used_package_properties(PROJECT_NAME "${PROJECT_NAME}" PACKAGE_NAME "${_package}")
        set(_find_string "${_package}")
        if(DEFINED ${_VAR_PREFIX}_${_package}_VERSION)
            string(APPEND _find_string ";${${_VAR_PREFIX}_${_package}_VERSION}")
        endif()
        cmcs_get_global_property(PROPERTY _CMakeCS_${_package}_FOUND)
        if(_CMakeCS_${_package}_FOUND)
            foreach(_comp IN LISTS ${${_VAR_PREFIX}_${_package}_COMPONENTS})
                cmcs_get_global_property(PROPERTY _CMakeCS_${_package}_${_comp}_FOUND)
                if(NOT _CMakeCS_${_package}_${_comp}_FOUND)
                    message(SEND_ERROR "${_package} was found but component ${_comp} was not found!")
                endif()
            endforeach()
        else()
            string(APPEND _find_string ";REQUIRED")
        endif()
        if(DEFINED ${_VAR_PREFIX}_${_package}_COMPONENTS)
            string(APPEND _find_string ";COMPONENTS;${${_VAR_PREFIX}_${_package}_COMPONENTS}")
        endif()
        if(DEFINED ${_VAR_PREFIX}_${_package}_FIND_OPTIONS)
            string(APPEND _find_string ";${${_VAR_PREFIX}_${_package}_FIND_OPTIONS}")
        endif()
        set(${PROJECT_NAME}_${_package}_FIND_PACKAGE "${_find_string}" CACHE INTERNAL "")
        cmcs_set_global_property(PREFIX ${_FUNC_PREFIX} PROPERTY ${PROJECT_NAME}_${COMPONENT_NAME}_${_package}_FIND_PACKAGE)
        find_package(${_find_string})
        if(${_VAR_PREFIX}_${_package}_PURPOSE)
            string(REPLACE "\"" "" ${_VAR_PREFIX}_${_package}_PURPOSE ${${_VAR_PREFIX}_${_package}_PURPOSE})
            set_package_properties(${_package} PROPERTIES PURPOSE "${${_VAR_PREFIX}_${_package}_PURPOSE}")
        endif()
        unset(_find_string)
    endforeach()
    foreach(_package IN LISTS ${_VAR_PREFIX}_OPTIONAL_PACKAGES)
        cmake_print_variables(${${_VAR_PREFIX}_PACKAGE_NAME}_ENABLE_${_package})
        option(${${_VAR_PREFIX}_PACKAGE_NAME}_ENABLE_${_package} "Enable usage of package ${_package} within ${PROJECT_NAME}" OFF)
        if(CMakeCS_ENABLE_PACKAGE_FEATURE_SUMMARY)
            add_feature_info(${${_VAR_PREFIX}_PACKAGE_NAME}_ENABLE_${_package} ${${_VAR_PREFIX}_PACKAGE_NAME}_ENABLE_${_package} "Enables ${_package} within ${PROJECT_NAME}")
        endif()
        cmcs_define_project_used_package_properties(PROJECT_NAME "${PROJECT_NAME}" PACKAGE_NAME "${_package}")
        set(_find_string "${_package}")
        if(DEFINED ${_VAR_PREFIX}_${_package}_VERSION)
            string(APPEND _find_string ";${${_VAR_PREFIX}_${_package}_VERSION}")
        endif()
        if(DEFINED ${_VAR_PREFIX}_${_package}_COMPONENTS)
            string(APPEND _find_string ";COMPONENTS;${${_VAR_PREFIX}_${_package}_COMPONENTS}")
        endif()
        if(DEFINED ${_VAR_PREFIX}_${_package}_FIND_OPTIONS)
            string(APPEND _find_string ";${${_VAR_PREFIX}_${_package}_FIND_OPTIONS}")
        endif()
        set(${PROJECT_NAME}_${_package}_FIND_PACKAGE "${_find_string}" CACHE INTERNAL "")
        cmcs_set_global_property(PREFIX ${_FUNC_PREFIX} PROPERTY ${PROJECT_NAME}_${COMPONENT_NAME}_${_package}_FIND_PACKAGE)
        if(NOT ${${_VAR_PREFIX}_PACKAGE_NAME}_ENABLE_${_package})
            #set(CMAKE_DISABLE_FIND_PACKAGE_${_package} TRUE CACHE BOOL "Disable search for ${_package}" FORCE) # This does not work with feature summary
            # Trick to make feature summary work with optional dependencies! 
            set(_DISABLE_FIND ";NO_DEFAULT_PATH")
        else()
            # Reenable search if disabled
            set(CMAKE_DISABLE_FIND_PACKAGE_${_package} FALSE CACHE BOOL "Disable search for ${_package}" FORCE)
        endif()        
        find_package(${_find_string}${_DISABLE_FIND})  # Cannot have this in an if for FeatureSummary
        unset(_find_string)
        unset(_DISABLE_FIND)
        if(${${_VAR_PREFIX}_PACKAGE_NAME}_ENABLE_${_package} AND NOT _package)
            cmcs_error_message("${_package} requested but not found!")
        endif()
        if(${_VAR_PREFIX}_${_package}_PURPOSE)
            string(REPLACE "\"" "" ${_VAR_PREFIX}_${_package}_PURPOSE ${${_VAR_PREFIX}_${_package}_PURPOSE})
            set_package_properties(${_package} PROPERTIES PURPOSE "${${_VAR_PREFIX}_${_package}_PURPOSE}")
        endif()
        set_package_properties(${_package} PROPERTIES TYPE OPTIONAL)
    endforeach()
    foreach(_package IN LISTS ${_VAR_PREFIX}_RECOMMENDED_PACKAGES)
        option(${${_VAR_PREFIX}_PACKAGE_NAME}_ENABLE_${_package} "Enable usage of package ${_package} within ${PROJECT_NAME}" ON)
        if(CMakeCS_ENABLE_PACKAGE_FEATURE_SUMMARY)
            add_feature_info(${_package}_VAR ${${_VAR_PREFIX}_PACKAGE_NAME}_ENABLE_${_package} "Enables ${_package} within ${PROJECT_NAME}")
        endif()
        cmcs_define_project_used_package_properties(PROJECT_NAME "${PROJECT_NAME}" PACKAGE_NAME "${_package}")
        set(_find_string "${_package}")
        if(DEFINED ${_VAR_PREFIX}_${_package}_VERSION)
            string(APPEND _find_string ";${${_VAR_PREFIX}_${_package}_VERSION}")
        endif()
        if(DEFINED ${_VAR_PREFIX}_${_package}_COMPONENTS)
            string(APPEND _find_string ";COMPONENTS;${${_VAR_PREFIX}_${_package}_COMPONENTS}")
        endif()
        if(DEFINED ${_VAR_PREFIX}_${_package}_FIND_OPTIONS)
            string(APPEND _find_string ";${${_VAR_PREFIX}_${_package}_FIND_OPTIONS}")
        endif()
        set(${PROJECT_NAME}_${_package}_FIND_PACKAGE "${_find_string}" CACHE INTERNAL "")
        cmcs_set_global_property(PREFIX ${_FUNC_PREFIX} PROPERTY ${PROJECT_NAME}_${COMPONENT_NAME}_${_package}_FIND_PACKAGE)
        if(NOT ${${_VAR_PREFIX}_PACKAGE_NAME}_ENABLE_${_package})
            #set(CMAKE_DISABLE_FIND_PACKAGE_${_package} TRUE CACHE BOOL "Disable search for ${_package}" FORCE) # This does not work with feature summary
            # Trick to make feature summary work with optional dependencies! 
            set(_DISABLE_FIND ";NO_DEFAULT_PATH")
        else()
            # Reenable search if disabled
            set(CMAKE_DISABLE_FIND_PACKAGE_${_package} FALSE CACHE BOOL "Disable search for ${_package}" FORCE)
        endif()        
        find_package(${_find_string}${_DISABLE_FIND})  # Cannot have this in an if for FeatureSummary
        unset(_find_string)
        unset(_DISABLE_FIND)
        if(${${_VAR_PREFIX}_PACKAGE_NAME}_ENABLE_${_package} AND NOT _package)
            cmcs_error_message("${_package} requested but not found!")
        endif()
        if(${_VAR_PREFIX}_${_package}_PURPOSE)
            string(REPLACE "\"" "" ${_VAR_PREFIX}_${_package}_PURPOSE ${${_VAR_PREFIX}_${_package}_PURPOSE})
            set_package_properties(${_package} PROPERTIES PURPOSE "${${_VAR_PREFIX}_${_package}_PURPOSE}")
        endif()
        set_package_properties(${_package} PROPERTIES TYPE RECOMMENDED)
    endforeach()
    foreach(_package IN LISTS ${_VAR_PREFIX}_OPTIONAL_CONDITIONAL_PACKAGES)
        CMAKE_DEPENDENT_OPTION(${${_VAR_PREFIX}_PACKAGE_NAME}_ENABLE_${_package} "Enable usage of package ${_package} within ${PROJECT_NAME}" ON ${${_VAR_PREFIX}_${_package}_CONDITION} OFF)
        set(_find_string "${_package}")
        if(DEFINED ${_VAR_PREFIX}_${_package}_VERSION)
            string(APPEND _find_string ";${${_VAR_PREFIX}_${_package}_VERSION}")
        endif()
        if(DEFINED ${_VAR_PREFIX}_${_package}_COMPONENTS)
            string(APPEND _find_string ";COMPONENTS;${${_VAR_PREFIX}_${_package}_COMPONENTS}")
        endif()
        if(DEFINED ${_VAR_PREFIX}_${_package}_FIND_OPTIONS)
            string(APPEND _find_string ";${${_VAR_PREFIX}_${_package}_FIND_OPTIONS}")
        endif()
        set(${PROJECT_NAME}_${_package}_FIND_PACKAGE "${_find_string}" CACHE INTERNAL "")
        cmcs_set_global_property(PREFIX ${_FUNC_PREFIX} PROPERTY ${PROJECT_NAME}_${COMPONENT_NAME}_${_package}_FIND_PACKAGE)
        if(NOT ${${_VAR_PREFIX}_PACKAGE_NAME}_ENABLE_${_package})
            # Trick to make feature summary work with optional dependencies! 
            set(_DISABLE_FIND ";NO_DEFAULT_PATH")
        else()
            # Reenable search if disabled
            set(CMAKE_DISABLE_FIND_PACKAGE_${_package} FALSE CACHE BOOL "Disable search for ${_package}" FORCE)
        endif() 
        find_package(${_find_string}${_DISABLE_FIND}) # Cannot have this in an if for FeatureSummary
        unset(_find_string)
        unset(_DISABLE_FIND)
        if(${${_VAR_PREFIX}_PACKAGE_NAME}_ENABLE_${_package} AND NOT _package)
            cmcs_error_message("${_package} requested but not found!")
        endif()
        if(${_VAR_PREFIX}_${_package}_PURPOSE)
            string(REPLACE "\"" "" ${_VAR_PREFIX}_${_package}_PURPOSE ${${_VAR_PREFIX}_${_package}_PURPOSE})
            set_package_properties(${_package} PROPERTIES PURPOSE "${${_VAR_PREFIX}_${_package}_PURPOSE}")
        endif()
    endforeach()
    ## Include CMake
    foreach(_include IN LISTS ${_VAR_PREFIX}_INCLUDES)
        message(VERBOSE "[CMakeCS] '${${_VAR_PREFIX}_PACKAGE_NAME}': Including '${_include}' (Project:'${PROJECT_NAME}')")
        include("${_include}")
    endforeach()
    ## Add subdir
    foreach(_subdir IN LISTS ${_VAR_PREFIX}_SUBDIRECTORIES)
        message(VERBOSE "[CMakeCS] '${${_VAR_PREFIX}_PACKAGE_NAME}': Adding subdirectory '${_subdir}' (Project:'${PROJECT_NAME}')")
        add_subdirectory("${_subdir}")
    endforeach()
    ## Includes after subdirs
    foreach(_include IN LISTS ${_VAR_PREFIX}_INCLUDES_AFTER_SUBDIRECTORIES)
        message(VERBOSE "[CMakeCS] '${${_VAR_PREFIX}_PACKAGE_NAME}': Including '${_include}' (Project:'${PROJECT_NAME}')")
        include("${_include}")
    endforeach()
    ## Files with target definitions
    foreach(_targetfile IN LISTS ${_VAR_PREFIX}_TARGET_FILES)
        message(VERBOSE "[CMakeCS] '${${_VAR_PREFIX}_PACKAGE_NAME}': Creating target from '${_targetfile}'")
        cmcs_read_target_file(${_targetfile})
    endforeach()
    ## Include after targets
    foreach(_include IN LISTS ${_VAR_PREFIX}_INCLUDES_AFTER_TARGETS)
        message(VERBOSE "[CMakeCS] '${${_VAR_PREFIX}_PACKAGE_NAME}': Including '${_include}' (Project:'${PROJECT_NAME}')")
        include("${_include}")
    endforeach()

    if(NOT ${_VAR_PREFIX}_NO_AUTOMATIC_CONFIG_FILE)
        if(${_VAR_PREFIX}_CONFIG_WITH_MODULES)
            cmcs_create_config_files(SETUP_MODULE_PATH)
        else()
            cmcs_create_config_files()
        endif()
    endif()

    if(NOT ${_VAR_PREFIX}_NO_FINALIZE)
        cmcs_finalize_component()
    endif()

    unset(COMPONENT_NAME)
    cmcs_set_global_property(PROPERTY CURRENT_COMPONENT_NAME "")
    list(POP_BACK CMAKE_MESSAGE_CONTEXT)
endfunction()

function(cmcs_read_component_file)
endfunction()

function(cmcs_finalize_component)
endfunction()