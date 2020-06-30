# This does not work in the TOPLEVEL CMakeLists.txt because it requires a direct project(<Name>) call. 

# USE_DIRECTORY_AS_PROJECT_NAME -> Uses the current directory (CMAKE_PARENT_LIST_FILE) name as the project name
# 
macro(cmcs_project)
    set(VAR_PREFIX _cmcs_p)
    #include("${CMAKE_CURRENT_LIST_FILE}/cmakecs_project_options.cmakecs" NO_POLICY_SCOPE)
    cmake_parse_arguments("${VAR_PREFIX}" "${CMAKECS_PROJECT_OPTIONS}" "${CMAKECS_PROJECT_ARGS}" "${CMAKECS_PROJECT_MULTI_ARGS}" "${ARGN}")
    if(${VAR_PREFIX}_UNPARSED_ARGUMENTS AND NOT ${VAR_PREFIX}_EXTENDED_PACKAGES_INFO)
        cmcs_error_message("Unparsed arguments found in call to cmcs_init_project.\nUnparsed:${${VAR_PREFIX}_UNPARSED_ARGUMENTS}")
    endif()
    if(NOT DEFINED ${VAR_PREFIX}_CONDITION OR (${${VAR_PREFIX}_CONDITION}))
        if(${VAR_PREFIX}_USE_DIRECTORY_AS_PROJECT_NAME)
            if(${VAR_PREFIX}_PROJECT_NAME)
                cmcs_error_message("Option USE_DIRECTORY_AS_PROJECT_NAME is not useable with option PROJECT_NAME")
            else()
                get_filename_component(${VAR_PREFIX}_PROJECT_NAME  "${CMAKE_PARENT_LIST_FILE}" DIRECTORY)
                get_filename_component(${VAR_PREFIX}_PROJECT_NAME  "${${VAR_PREFIX}_PROJECT_NAME}" NAME)
                cmcs_trace_variables(${VAR_PREFIX}_PROJECT_NAME)
            endif()
        endif()

        list(FIND CMakeCS_ALL_PROJECTS ${${VAR_PREFIX}_PROJECT_NAME} FOUND_PROJECT)
        if(NOT FOUND_PROJECT EQUAL "-1")
            cmcs_error_message("PROJECT_NAME: ${${VAR_PREFIX}_PROJECT_NAME} was already used! Please use a different name\n Defined Projects: ${CMakeCS_ALL_PROJECTS}")
        endif()
        
        set(_PREVIOUS_CMAKE_PROJECT ${CMAKE_PROJECT_NAME})
        set(_PREVIOUS_PROJECT ${PROJECT_NAME})
        if(PROJECT_NAME)
            cmcs_get_global_property(PROPERTY ${PROJECT_NAME}_LOCKED)
            set(_PREVIOUS_LOCKED ${${PROJECT_NAME}_LOCKED})
        else()
            set(_PREVIOUS_LOCKED FALSE)
        endif()

        if(${VAR_PREFIX}_OPTIONS_FILE)
            if(NOT ${VAR_PREFIX}_OPTIONS)
                cmcs_error_message("${${VAR_PREFIX}_PROJECT_NAME} uses OPTIONS_FILE without specificing the options via OPTIONS")
            endif()
            cmcs_read_option_file()
        elseif(${VAR_PREFIX}_OPTIONS)
        endif()

        if(_PREVIOUS_LOCKED) 
            # Previous project is closed so this is a new project on the same level as the previous project
            if(PROJECT_NAME) # Not toplevel project
                # The previos project was closed so get the parent of that project
                # and set it as the parent of the new project
                cmcs_get_global_property(PROPERTY ${PROJECT_NAME}_PARENT)
                if(${PROJECT_NAME}_PARENT)
                    set(${VAR_PREFIX}_${${VAR_PREFIX}_PROJECT_NAME}_PARENT ${${PROJECT_NAME}_PARENT})
                    cmcs_set_global_property(PREFIX ${VAR_PREFIX} PROPERTY ${${VAR_PREFIX}_PROJECT_NAME}_PARENT)

                    # Add the new project as a child to the previous project parent childs
                    set(${${PROJECT_NAME}_PARENT}_CHILDS ${${VAR_PREFIX}_PROJECT_NAME})
                    cmcs_set_global_property(APPEND_OPTION APPEND PROPERTY ${${PROJECT_NAME}_PARENT}_CHILDS)
                    message(VERBOSE "[CMakeCS]: Creating project:'${${VAR_PREFIX}_PROJECT_NAME}' as child of:'${${PROJECT_NAME}_PARENT}'")
                else()
                    message(VERBOSE "[CMakeCS]: Creating project without parent:'${${VAR_PREFIX}_PROJECT_NAME}'")
                endif()
            else()
                # No Parent. Is toplevel project. 
                message(VERBOSE "[CMakeCS]: Creating toplevel project (previous locked):'${${VAR_PREFIX}_PROJECT_NAME}'")
            endif()
        else()
            #cmake_print_variables(CMAKE_PROJECT_NAME PROJECT_NAME ${VAR_PREFIX}_PROJECT_NAME CMAKE_PARENT_LIST_FILE)
            if(NOT PROJECT_NAME) 
                # 1. Toplevel project since PROJECT_NAME is not set
                # CMAKE_PROJECT_NAME does not work since it will be set after first configure. 
                message(VERBOSE "[CMakeCS]: Creating toplevel project: ${${VAR_PREFIX}_PROJECT_NAME}")
                #set(${VAR_PREFIX}_${${VAR_PREFIX}_PROJECT_NAME}_PARENT "")
                #cmcs_set_global_property(PREFIX ${VAR_PREFIX} PROPERTY ${${VAR_PREFIX}_PROJECT_NAME}_PARENT)
            elseif(NOT CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR) 
                # Not toplevel source dir
                # Project is not locked so the new project is a subproject of the current. 
                message(VERBOSE "[CMakeCS]: Creating project:'${${VAR_PREFIX}_PROJECT_NAME}' as child of:'${PROJECT_NAME}'")

                set(${PROJECT_NAME}_CHILDS ${${VAR_PREFIX}_PROJECT_NAME})
                cmcs_set_global_property(APPEND_OPTION APPEND PROPERTY ${PROJECT_NAME}_CHILDS)

                # Current project is parent of new project.
                set(${VAR_PREFIX}_${${VAR_PREFIX}_PROJECT_NAME}_PARENT ${PROJECT_NAME})
                cmcs_set_global_property(PREFIX ${VAR_PREFIX} PROPERTY ${${VAR_PREFIX}_PROJECT_NAME}_PARENT)
            else()
                cmcs_error_message("Cannot create a new top level project called ${${VAR_PREFIX}_PROJECT_NAME} unless the previous toplevel project called ${PROJECT_NAME} is finalized using cmcs_finalize_project!")
            endif()
        endif()

        set(PROJECT_PARAMS ${${VAR_PREFIX}_PROJECT_NAME})
        if(${VAR_PREFIX}_VERSION)
            list(APPEND PROJECT_PARAMS VERSION ${${VAR_PREFIX}_VERSION})
        endif()
        if(${VAR_PREFIX}_DESCRIPTION)
            list(APPEND PROJECT_PARAMS DESCRIPTION ${${VAR_PREFIX}_DESCRIPTION})
        endif()
        if(${VAR_PREFIX}_HOMEPAGE_URL)
            list(APPEND PROJECT_PARAMS HOMEPAGE_URL ${${VAR_PREFIX}_HOMEPAGE_URL})
        endif()
        if(${VAR_PREFIX}_LANGUAGES)
            list(APPEND PROJECT_PARAMS LANGUAGES ${${VAR_PREFIX}_LANGUAGES})
        endif()

        if(NOT CMakeCS_ENABLE_PROJECT_OVERRIDE)
            message(TRACE "[CMakeCS]: Using project()")
            project(${PROJECT_PARAMS})
        else()
            message(TRACE "[CMakeCS]: Using _project()")
            _project(${PROJECT_PARAMS})
        endif()
        unset(PROJECT_PARAMS)
        if(CMAKE_PROJECT_NAME STREQUAL _PREVIOUS_CMAKE_PROJECT) # Same Top Level Project -> Child Project
            # Check if previous project has been closed 
            # -> If not it is a subcomponent of the project (new parent<->child)
            # -> If yes it is a subcomponent of the parent project (current parent gets an additional child)
        elseif(CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME) # New Top Level Project
            # Check if previous project has been closed!
        endif()

        foreach(_option IN LISTS CMAKECS_PROJECT_OPTIONS CMAKECS_PROJECT_ARGS CMAKECS_PROJECT_MULTI_ARGS)
            unset(${VAR_PREFIX}_${_option})
        endforeach()
        unset(VAR_PREFIX)

        cmcs_init_project(${ARGN})
    endif()
endmacro()

macro(cmcs_project_file _filename)
    set(VAR_PREFIX _cmcs_pf)
    cmake_parse_arguments("${VAR_PREFIX}" "TOPLEVEL" "" "" ${ARGN})
    get_filename_component(${VAR_PREFIX}_filename_full_path "${_filename}" ABSOLUTE)
    if(NOT EXISTS "${${VAR_PREFIX}_filename_full_path}")
        cmcs_error_message("cmcs_project_file requires a valid relative or absolute filepath. Path given is:${_filename}; Absolute Path:${${VAR_PREFIX}_filename_full_path}")
    endif()

    file(READ "${${VAR_PREFIX}_filename_full_path}" ${VAR_PREFIX}_contents)
    cmcs_sanetize_input(${VAR_PREFIX}_contents ${VAR_PREFIX}_contents) # Transforms everything into a list
    string(CONFIGURE "${${VAR_PREFIX}_contents}" ${VAR_PREFIX}_contents) # Expands CMake variables
    message(TRACE "[CMakeCS] Project file contents:${${VAR_PREFIX}_contents}")
    if(${VAR_PREFIX}_TOPLEVEL)
        cmcs_init_project(${${VAR_PREFIX}_contents}) 
    else()
        cmcs_project(${${VAR_PREFIX}_contents})
    endif()

    unset(${VAR_PREFIX}_TOPLEVEL)
    unset(${VAR_PREFIX}_filename_full_path )
    unset(${VAR_PREFIX}_contents)
    unset(VAR_PREFIX)
endmacro()

## project() call overrie
if(CMakeCS_ENABLE_PROJECT_OVERRIDE)
    macro(project)
        get_filename_component(ARGV0_PATH "${ARGV0}" ABSOLUTE)
        if(EXISTS "${ARGV0_PATH}")
            message(VERBOSE "[CMakeCS]: Creating project from: '${ARGV0}'")
            cmcs_project_file("${ARGV0_PATH}")
        else() 
            if(CMakeCS_USE_PROJECT_OVERRIDE)
                cmcs_project(${ARGN})
            else()
                _project(${ARGN})
            endif()
        endif()
    endmacro()
endif()