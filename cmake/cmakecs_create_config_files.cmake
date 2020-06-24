# Automatically create the required <packagename>Config.cmake and <packagename>ConfigVersion.cmake

function(cmcs_create_config_files)
    cmcs_create_function_variable_prefix(_VAR_PREFIX)
    cmake_parse_arguments(PARSE_ARGV 0 "${_VAR_PREFIX}" "NO_SET_CHECK;NO_COMPONENTS;SETUP_MODULE_PATH" 
                          "INPUT_FILE;INSTALL_DESTINATION;COMPATIBILITY" "VARS;PATHLIKE_VARS;PATH_VARS;MODULES_TO_INCLUDE")

    cmcs_error_if_project_locked()
    cmcs_error_if_project_not_init()
    cmcs_get_global_property(PROPERTY ${PROJECT_NAME}_CONFIG_INSTALL_DESTINATION)
    cmcs_variable_exists_or_default(VARIABLE ${_VAR_PREFIX}_INSTALL_DESTINATION DEFAULT "${${PROJECT_NAME}_CONFIG_INSTALL_DESTINATION}")

    cmcs_get_global_property(PROPERTY ${PROJECT_NAME}_PACKAGE_NAME)
    cmcs_get_global_property(PROPERTY ${PROJECT_NAME}_EXPORT_NAME)

    cmcs_get_global_property(PROPERTY ${PROJECT_NAME}_PUBLIC_CMAKE_FILES)
    cmcs_get_global_property(PROPERTY ${PROJECT_NAME}_PUBLIC_CMAKE_DIRS)
    cmcs_get_global_property(PROPERTY ${PROJECT_NAME}_MODULES_TO_INCLUDE)

    if(IS_ABSOLUTE "${${_VAR_PREFIX}_INSTALL_DESTINATION}")
        cmcs_error_message("Config file installation destination needs to be relative! INSTALL_DESTINATION:${${_VAR_PREFIX}_INSTALL_DESTINATION}!")
    endif()

    if(NOT ${_VAR_PREFIX}_INPUT_FILE)
        set(_config_contents)
        string(APPEND _config_contents "#This file was automatically generated by CMakeCS!\n")
        string(APPEND _config_contents "@PACKAGE_INIT@\n")
        string(APPEND _config_contents "cmake_policy (PUSH)\n")
        string(APPEND _config_contents "cmake_minimum_required (VERSION 3.17)\n\n")
        list(APPEND ${PROJECT_NAME}_CONFIG_VARS CMAKE_CURRENT_LIST_FILE)
        if(${_VAR_PREFIX}_SETUP_MODULE_PATH)
            list(APPEND ${PROJECT_NAME}_CONFIG_VARS \${CMAKE_FIND_PACKAGE_NAME}_CMAKE_MODULE_PATH)
            string(APPEND _config_contents "set(\${CMAKE_FIND_PACKAGE_NAME}_CMAKE_MODULE_PATH \"\${CMAKE_CURRENT_LIST_DIR}/cmake\")\n")        
            string(APPEND _config_contents "set(\${CMAKE_FIND_PACKAGE_NAME}_CMAKE_MODULE_PATH_BACKUP \${CMAKE_MODULE_PATH})\n")
            string(APPEND _config_contents "list(PREPEND CMAKE_MODULE_PATH \"\${CMAKE_CURRENT_LIST_DIR}/cmake\")\n") # Prepending makes sure we get the correct modules
            string(APPEND _config_contents "if(@${PROJECT_NAME}_BUILD_DIR_CONFIG@)\n")
            foreach(_dir IN LISTS ${PROJECT_NAME}_PUBLIC_CMAKE_DIRS)
                if(IS_ABSOLUTE "${_dir}")
                    string(APPEND _config_contents "    list(PREPEND CMAKE_MODULE_PATH \"${_dir}\")\n")
                    string(APPEND _config_contents "    list(APPEND \${CMAKE_FIND_PACKAGE_NAME}_CMAKE_MODULE_PATH \"${_dir}\")\n")
                else()
                    string(APPEND _config_contents "    list(PREPEND CMAKE_MODULE_PATH \"${CMAKE_CURRENT_SOURCE_DIR}/${_dir}\")\n")
                    string(APPEND _config_contents "    list(PREPEND CMAKE_MODULE_PATH \"${CMAKE_CURRENT_BINARY_DIR}/${_dir}\")\n")
                    string(APPEND _config_contents "    list(APPEND \${CMAKE_FIND_PACKAGE_NAME}_CMAKE_MODULE_PATH \"${CMAKE_CURRENT_SOURCE_DIR}/${_dir}\")\n")
                    string(APPEND _config_contents "    list(APPEND \${CMAKE_FIND_PACKAGE_NAME}_CMAKE_MODULE_PATH \"${CMAKE_CURRENT_BINARY_DIR}/${_dir}\")\n")
                endif()
            endforeach()
            foreach(_file IN LISTS ${PROJECT_NAME}_PUBLIC_CMAKE_FILES) # should probably be removed
                get_filename_component(_dir "${_file}" DIRECTORY)
                if(IS_ABSOLUTE "${_dir}")
                    string(APPEND _config_contents "    list(PREPEND CMAKE_MODULE_PATH \"${_dir}\")\n")
                    string(APPEND _config_contents "    list(APPEND \${CMAKE_FIND_PACKAGE_NAME}_CMAKE_MODULE_PATH \"${_dir}\")\n")
                else()
                    string(APPEND _config_contents "    list(PREPEND CMAKE_MODULE_PATH \"${CMAKE_CURRENT_SOURCE_DIR}/${_dir}\")\n")
                    string(APPEND _config_contents "    list(PREPEND CMAKE_MODULE_PATH \"${CMAKE_CURRENT_BINARY_DIR}/${_dir}\")\n")
                    string(APPEND _config_contents "    list(APPEND \${CMAKE_FIND_PACKAGE_NAME}_CMAKE_MODULE_PATH \"${CMAKE_CURRENT_SOURCE_DIR}/${_dir}\")\n")
                    string(APPEND _config_contents "    list(APPEND \${CMAKE_FIND_PACKAGE_NAME}_CMAKE_MODULE_PATH \"${CMAKE_CURRENT_BINARY_DIR}/${_dir}\")\n")
                endif()
            endforeach()
            string(APPEND _config_contents "endif()\n")
            string(APPEND _config_contents "list(REMOVE_DUPLICATES CMAKE_MODULE_PATH)\n")
            string(APPEND _config_contents "list(REMOVE_DUPLICATES \${CMAKE_FIND_PACKAGE_NAME}_CMAKE_MODULE_PATH)\n")
            string(APPEND _config_contents "set(\${CMAKE_FIND_PACKAGE_NAME}_CMAKE_MODULE_PATH \"\${\${CMAKE_FIND_PACKAGE_NAME}_CMAKE_MODULE_PATH}\" CACHE INTERNAL \"\")\n\n")   
        endif()


        string(APPEND _config_contents "set(\${CMAKE_FIND_PACKAGE_NAME}_BUILD_AS_SHARED @BUILD_SHARED_LIBS@ CACHE INTERNAL \"\")\n")     
        string(APPEND _config_contents "set(\${CMAKE_FIND_PACKAGE_NAME}_BUILD_DIR_CONFIG @${PROJECT_NAME}_BUILD_DIR_CONFIG@) # Is config within build dir?\n")
        set(${_VAR_PREFIX}_NO_SET_CHECK)
        if(NOT ${_VAR_PREFIX}_PATH_VARS)
            set(${_VAR_PREFIX}_NO_SET_CHECK NO_SET_AND_CHECK_MACRO)
        else()
        string(APPEND _config_contents "\n # Deal with variables\n")
            foreach(_var IN LISTS ${_VAR_PREFIX}_VARS)
                string(APPEND _config_contents "    set(\${CMAKE_FIND_PACKAGE_NAME}_${_var} @${_var}@ CACHE INTERNAL \"\")\n")
                list(APPEND ${PROJECT_NAME}_CONFIG_VARS \${CMAKE_FIND_PACKAGE_NAME}_${_var})
            endforeach()
            string(APPEND _config_contents "if(\${CMAKE_FIND_PACKAGE_NAME}_BUILD_DIR_CONFIG)\n")
            foreach(_path_var IN LISTS ${_VAR_PREFIX}_PATH_VARS)
                list(APPEND ${PROJECT_NAME}_CONFIG_VARS \${CMAKE_FIND_PACKAGE_NAME}_${_path_var})
                string(APPEND _config_contents "    message(\"\${CMAKE_FIND_PACKAGE_NAME}_${_path_var}:@PACKAGE_${_path_var}@\")\n")
                string(APPEND _config_contents "    set_and_check(\${CMAKE_FIND_PACKAGE_NAME}_${_path_var} @PACKAGE_${_path_var}@)\n")   
                string(APPEND _config_contents "    set_and_check(\${CMAKE_FIND_PACKAGE_NAME}_${_path_var} @PACKAGE_${_path_var}@@${PROJECT_NAME}_BUILD_RELATIVE_PATH@)\n")          
            endforeach()
            string(APPEND _config_contents "else()\n")
            foreach(_path_var IN LISTS ${_VAR_PREFIX}_PATH_VARS)
                string(APPEND _config_contents "    message(\"\${CMAKE_FIND_PACKAGE_NAME}_${_path_var}:@PACKAGE_${_path_var}@\")\n")
                string(APPEND _config_contents "    set_and_check(\${CMAKE_FIND_PACKAGE_NAME}_${_path_var} @PACKAGE_${_path_var}@)\n")
            endforeach()
            string(APPEND _config_contents "endif())\n")
        endif(NOT ${_VAR_PREFIX}_PATH_VARS)

        string(APPEND _config_contents "\n # Deal with modules to include\n")
        foreach(_module IN LISTS ${PROJECT_NAME}_MODULES_TO_INCLUDE)
            string(APPEND _config_contents "option(\${CMAKE_FIND_PACKAGE_NAME}_WITHOUT_CMAKE_MODULE_${_module} \"Deactivate inclusion of module ${_module} for \${CMAKE_FIND_PACKAGE_NAME} \" OFF)\n")
            string(APPEND _config_contents "if(NOT \${CMAKE_FIND_PACKAGE_NAME}_WITHOUT_CMAKE_MODULE_${_module})\n")
            string(APPEND _config_contents "    include(${_module})\n")
            string(APPEND _config_contents "endif()\n")
        endforeach()

        string(APPEND _config_contents "\n # Deal with dependencies \n")
        # Deal with dependencies
        cmcs_get_global_property(PROPERTY ${PROJECT_NAME}_REQUIRED_PACKAGES)
        cmcs_get_global_property(PROPERTY ${PROJECT_NAME}_OPTIONAL_PACKAGES)
        cmcs_get_global_property(PROPERTY ${PROJECT_NAME}_OPTIONAL_CONDITIONAL_PACKAGES)

        string(APPEND _config_contents "include(CMakeFindDependencyMacro)\n")
        string(APPEND _config_contents "\n # Required dependencies \n")
        # Write find_dependency calls fo required packages
        foreach(_extpackage IN LISTS ${PROJECT_NAME}_REQUIRED_PACKAGES)
            cmcs_get_global_property(PROPERTY ${PROJECT_NAME}_${_extpackage}_FIND_PACKAGE)
            string(REPLACE ";REQUIRED" "" ${PROJECT_NAME}_${_extpackage}_FIND_PACKAGE "${${PROJECT_NAME}_${_extpackage}_FIND_PACKAGE}")
            string(APPEND _config_contents "find_dependency(")   
            string(APPEND _config_contents "${${PROJECT_NAME}_${_extpackage}_FIND_PACKAGE}") 
            string(APPEND _config_contents ")\n") 
        endforeach()

        string(APPEND _config_contents "\n # Optional dependencies \n")
        # Write find_dependency calls fo optional packages
        foreach(_extpackage IN LISTS ${PROJECT_NAME}_OPTIONAL_PACKAGES)
            cmcs_get_global_property(PROPERTY ${PROJECT_NAME}_${_extpackage}_FIND_PACKAGE)
            list(REMOVE_ITEM ${PROJECT_NAME}_${_extpackage}_FIND_PACKAGE REQUIRED) # handled by find_dependecy
            string(APPEND _config_contents "set (${${PROJECT_NAME}_PACKAGE_NAME}_ENABLE_${_extpackage} @${${PROJECT_NAME}_PACKAGE_NAME}_ENABLE_${_extpackage}@)\n")
            string(APPEND _config_contents "if (${${PROJECT_NAME}_PACKAGE_NAME}_ENABLE_${_extpackage})\n" )
            string(APPEND _config_contents "    find_dependency (")   
            string(APPEND _config_contents "${${PROJECT_NAME}_${_extpackage}_FIND_PACKAGE}") 
            string(APPEND _config_contents ")\n")
            string(APPEND _config_contents "endif ()\n") 
        endforeach()

        string(APPEND _config_contents "\n # Optional dependent dependencies \n")
        # Write find_dependency calls for dependent optional packages
        foreach(_extpackage IN LISTS ${PROJECT_NAME}_OPTIONAL_CONDITIONAL_PACKAGES)
            cmcs_get_global_property(PROPERTY ${PROJECT_NAME}_${_extpackage}_FIND_PACKAGE)
            list(REMOVE_ITEM ${PROJECT_NAME}_${_extpackage}_FIND_PACKAGE REQUIRED) # handled by find_dependecy
            string(APPEND _config_contents "set (${${PROJECT_NAME}_PACKAGE_NAME}_ENABLE_${_extpackage} @${${PROJECT_NAME}_PACKAGE_NAME}_ENABLE_${_extpackage}@)\n")
            string(APPEND _config_contents "if (${${PROJECT_NAME}_PACKAGE_NAME}_ENABLE_${_extpackage})\n" )
            string(APPEND _config_contents "    find_dependency (")   
            string(APPEND _config_contents "${${PROJECT_NAME}_${_extpackage}_FIND_PACKAGE}") 
            string(APPEND _config_contents ")\n")
            string(APPEND _config_contents "endif ()\n") 
        endforeach()

        # Deal with components
        cmcs_get_global_property(PROPERTY ${PROJECT_NAME}_CHILDS)
        set(${_VAR_PREFIX}_NO_COMPONENTS)
        if(${PROJECT_NAME}_CHILDS)
            string(APPEND _config_contents "\n # Deal with components \n")
            set(${_VAR_PREFIX}_NO_COMPONENTS NO_CHECK_REQUIRED_COMPONENTS_MACRO)
            string(APPEND _config_contents "set(${CMAKE_FIND_PACKAGE_NAME}_AVAILABLE_COMPONENTS ${${PROJECT_NAME}_CHILDS})\n")
            foreach(_component IN LISTS ${PROJECT_NAME}_CHILDS)
                string(APPEND _config_contents "find_package(${${PROJECT_NAME}_PACKAGE_NAME}_${_component})\n")
            endforeach() 
            string(APPEND _config_contents "check_required_components(${PROJECT_NAME})\n")           
        endif(${PROJECT_NAME}_CHILDS)


        string(APPEND _config_contents "\n # Finish up \n")
        string(APPEND _config_contents "include(\${CMAKE_CURRENT_LIST_DIR}/${${PROJECT_NAME}_PACKAGE_NAME}Targets.cmake)\n")
        if(${_VAR_PREFIX}_SETUP_MODULE_PATH)
            string(APPEND _config_contents "set(CMAKE_MODULE_PATH \${CMAKE_FIND_PACKAGE_NAME}_CMAKE_MODULE_PATH_BACKUP)\n") # Restoring old module path
        endif()        
        string(APPEND _config_contents "find_package_handle_standard_args(\${CMAKE_FIND_PACKAGE_NAME} HANDLE_COMPONENTS\n")
        if(${PROJECT_NAME}_CONFIG_VARS)
            string(APPEND _config_contents "                                  REQUIRED_VARS @${PROJECT_NAME}_CONFIG_VARS@\n")
        endif()
        string(APPEND _config_contents "                                  )\n")
        string(APPEND _config_contents "cmake_policy (POP)\n")

        file(WRITE "${CMAKE_BINARY_DIR}/${${PROJECT_NAME}_PACKAGE_NAME}Config.in.cmake" "${_config_contents}")
        set(${_VAR_PREFIX}_INPUT_FILE "${CMAKE_BINARY_DIR}/${${PROJECT_NAME}_PACKAGE_NAME}Config.in.cmake")
    endif(NOT ${_VAR_PREFIX}_INPUT_FILE)

    file(RELATIVE_PATH REL_CONFIG_PATH  "${CMAKE_CURRENT_SOURCE_DIR}" "${CMAKE_CURRENT_BINARY_DIR}")

    # Write install config file 
    set(${PROJECT_NAME}_BUILD_DIR_CONFIG FALSE)
    configure_package_config_file(
            "${${_VAR_PREFIX}_INPUT_FILE}"
            "${${_VAR_PREFIX}_INSTALL_DESTINATION}/${${PROJECT_NAME}_PACKAGE_NAME}Config.install.cmake"
            INSTALL_DESTINATION "$<INSTALL_INTERFACE:${${_VAR_PREFIX}_INSTALL_DESTINATION}>"
            PATH_VARS ${${_VAR_PREFIX}_PATH_VARS}
            ${${_VAR_PREFIX}_NO_COMPONENTS}
            ${${_VAR_PREFIX}_NO_SET_CHECK})
    cmcs_get_global_property(PROPERTY ${PROJECT_NAME}_EXPORT_ON_BUILD)
    # Config in build dir!
    if(${PROJECT_NAME}_EXPORT_ON_BUILD)
        set(${PROJECT_NAME}_RELATIVE_SOURCE_PATH "${CMAKE_CURRENT_SOURCE_DIR}")
        set(${PROJECT_NAME}_BUILD_DIR_CONFIG TRUE)
        configure_package_config_file(
                "${${_VAR_PREFIX}_INPUT_FILE}"
                "${${_VAR_PREFIX}_INSTALL_DESTINATION}/${${PROJECT_NAME}_PACKAGE_NAME}Config.cmake"
                INSTALL_DESTINATION "${CMAKE_CURRENT_SOURCE_DIR}"
                #INSTALL_DESTINATION "$<BUILD_INTERFACE:${REL_CONFIG_PATH}/${${_VAR_PREFIX}_INSTALL_DESTINATION}>"
                PATH_VARS ${${_VAR_PREFIX}_PATH_VARS} ${PROJECT_NAME}_RELATIVE_SOURCE_PATH 
                ${${_VAR_PREFIX}_NO_COMPONENTS}
                ${${_VAR_PREFIX}_NO_SET_CHECK}
                INSTALL_PREFIX "${CMAKE_SOURCE_DIR}"
                )
    endif()  
    # Write ConfigVersion
    #cmcs_variable_exists_or_error(PREFIX "${_VAR_PREFIX}" VARIABLE_NAMES "")
    cmcs_variable_exists_or_default(PREFIX "${_VAR_PREFIX}" VARIABLE "COMPATIBILITY" DEFAULT "AnyNewerVersion")

    cmcs_get_global_property(PROPERTY ${PROJECT_NAME}_VERSION)
    cmcs_get_global_property(PROPERTY ${PROJECT_NAME}_VERSION_COMPATIBILITY)
    write_basic_package_version_file("${${_VAR_PREFIX}_INSTALL_DESTINATION}/${${PROJECT_NAME}_PACKAGE_NAME}ConfigVersion.cmake"
                                     VERSION ${${PROJECT_NAME}_VERSION} 
                                     COMPATIBILITY ${${PROJECT_NAME}_VERSION_COMPATIBILITY})
                                     
    install(FILES "${CMAKE_CURRENT_BINARY_DIR}/${${_VAR_PREFIX}_INSTALL_DESTINATION}/${${PROJECT_NAME}_PACKAGE_NAME}Config.install.cmake"
            DESTINATION "${${_VAR_PREFIX}_INSTALL_DESTINATION}"
            RENAME "${${PROJECT_NAME}_PACKAGE_NAME}Config.cmake")                               
    install(FILES "${CMAKE_CURRENT_BINARY_DIR}/${${_VAR_PREFIX}_INSTALL_DESTINATION}/${${PROJECT_NAME}_PACKAGE_NAME}ConfigVersion.cmake"
            DESTINATION "${${_VAR_PREFIX}_INSTALL_DESTINATION}" )

    if(${PROJECT_NAME}_PUBLIC_CMAKE_FILES)
        install(FILES "${${PROJECT_NAME}_PUBLIC_CMAKE_FILES}"
                DESTINATION "${${_VAR_PREFIX}_INSTALL_DESTINATION}/cmake")
    endif()
    if(${PROJECT_NAME}_PUBLIC_CMAKE_DIRS)
        install(DIRECTORY "${${PROJECT_NAME}_PUBLIC_CMAKE_DIRS}"
                DESTINATION "${${_VAR_PREFIX}_INSTALL_DESTINATION}/cmake") 
    endif()
    #install(DIRECTORY "cmake" DESTINATION "${PROJECT_INSTALL_PACKAGE}")
endfunction(cmcs_create_config_files)

