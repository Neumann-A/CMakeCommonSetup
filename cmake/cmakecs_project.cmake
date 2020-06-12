# This does not work in the TOPLEVEL CMakeLists.txt because it requires a direct project(<Name>) call. 

# USE_DIRECTORY_AS_PROJECT_NAME -> Uses the current directory (CMAKE_PARENT_LIST_FILE) name as the project name
# 
macro(cmcs_project)
    set(_VAR_PREFIX _cmcs_p)
    cmake_parse_arguments("${_VAR_PREFIX}" "USE_DIRECTORY_AS_PROJECT_NAME" "PROJECT_NAME;VERSION;HOMEPAGE_URL;DESCRIPTION" "LANGUAGES" ${ARGN})
    if(DEFINED ${_VAR_PREFIX}_USE_DIRECTORY_AS_PROJECT_NAME)
        if(DEFINED ${_VAR_PREFIX}_PROJECT_NAME)
            cmcs_error_message("Option USE_DIRECTORY_AS_PROJECT_NAME is not useable with option PROJECT_NAME")
        else()
            get_filename_component(${_VAR_PREFIX}_PROJECT_NAME  "${CMAKE_PARENT_LIST_FILE}" DIRECTORY)
            get_filename_component(${_VAR_PREFIX}_PROJECT_NAME  "${${_VAR_PREFIX}_PROJECT_NAME}" NAME)
            cmcs_trace_variables(${_VAR_PREFIX}_PROJECT_NAME)
        endif()
    endif()

    list(FIND CMAKECS_ALL_PROJECTS ${${_VAR_PREFIX}_PROJECT_NAME} FOUND_PROJECT)
    if(NOT FOUND_PROJECT EQUAL "-1")
        cmcs_error_message("PROJECT_NAME: ${${_VAR_PREFIX}_PROJECT_NAME} was already used! Please use a different name\n Defined Projects: ${CMAKECS_ALL_PROJECTS}")
    endif()
    
    set(_PREVIOUS_CMAKE_PROJECT ${CMAKE_PROJECT_NAME})
    set(_PREVIOUS_PROJECT ${PROJECT_NAME})

    cmcs_get_global_property(PROPERTY ${PROJECT_NAME}_LOCKED)

    set(_PREVIOUS_LOCKED ${${PROJECT_NAME}_LOCKED})
    if(_PREVIOUS_LOCKED) 
        # Previous project is closed so this is a new project on the same level as the previous project
        if(NOT CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME) # Not toplevel project
            # The previos project was closed so get the parent of that project
            # and set it as the parent of the new project
            cmcs_get_global_property(PROPERTY ${PROJECT_NAME}_PARENT)
            set(${_VAR_PREFIX}_${${_VAR_PREFIX}_PROJECT_NAME}_PARENT ${${PROJECT_NAME}_PARENT})
            cmcs_set_global_property(PREFIX ${_VAR_PREFIX} PROPERTY ${${_VAR_PREFIX}_PROJECT_NAME}_PARENT)

            # Add the new project as a child to the previous project parent childs
            set(${${PROJECT_NAME}_PARENT}_CHILD ${${_VAR_PREFIX}_PROJECT_NAME})
            cmcs_set_global_property(APPEND_OPTION APPEND PROPERTY ${${PROJECT_NAME}_PARENT}_CHILD)          
        else()
            # No Parent. Is toplevel project. 
        endif()
    else()
        if(NOT CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME) # Not toplevel 
            # Project is not locked so the new project is a subproject of the current. 
            set(${_VAR_PREFIX}_${${_VAR_PREFIX}_PROJECT_NAME}_PARENT ${PROJECT_NAME})
            set(${PROJECT_NAME}_CHILD ${${_VAR_PREFIX}_PROJECT_NAME})
            cmcs_set_global_property(APPEND_OPTION APPEND PROPERTY ${PROJECT_NAME}_CHILD)

            # Current project is parent of new project.
            set(${_VAR_PREFIX}_${${_VAR_PREFIX}_PROJECT_NAME}_PARENT ${PROJECT_NAME})
            cmcs_set_global_property(PREFIX ${_VAR_PREFIX} PROPERTY ${${_VAR_PREFIX}_PROJECT_NAME}_PARENT)
        else()
            cmcs_error_message("Cannot create a new top level project called ${${_VAR_PREFIX}_PROJECT_NAME} unless the previous toplevel project called  ${PROJECT_NAME} is finalized using cmcs_finalize_project!")
        endif()
    endif()
    #cmcs_set_global_property(PREFIX ${_FUNC_PREFIX} PROPERTY ${PROJECT_NAME}_PACKAGE_NAME)
    #cmcs_get_global_property(PROPERTY ${PROJECT_NAME}_PACKAGE_NAME)
    project(${${_VAR_PREFIX}_PROJECT_NAME}
            VERSION ${${_VAR_PREFIX}_VERSION}
            DESCRIPTION ${${_VAR_PREFIX}_DESCRIPTION}
            HOMEPAGE_URL ${${_VAR_PREFIX}_HOMEPAGE_URL}
            LANGUAGES ${${_VAR_PREFIX}_LANGUAGES})
    if(CMAKE_PROJECT_NAME STREQUAL _PREVIOUS_CMAKE_PROJECT) # Same Top Level Project -> Child Project
        # Check if previous project has been closed 
        # -> If not it is a subcomponent of the project (new parent<->child)
        # -> If yes it is a subcomponent of the parent project (current parent gets an additional child)
    elseif(CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME) # New Top Level Project
        # Check if previous project has been closed!
    endif()
    cmcs_init_project(${${_VAR_PREFIX}_UNPARSED_ARGUMENTS})
    if(NOT _PREVIOUS_LOCKED) # Previous Project is closed so this is a new Project on the same level
    endif()
endmacro()

macro(cmcs_project_file _filename)
    set(VAR_PREFIX _cmcs_pf)
    cmake_parse_arguments("${_VAR_PREFIX}" "TOPLEVEL" "" "" ${ARGN})
    get_filename_component(${VAR_PREFIX}_filename_full_path "${_filename}" ABSOLUTE)
    if(NOT EXISTS "${${VAR_PREFIX}_filename_full_path}")
        cmcs_error_message("cmcs_project_file requires a valid relative or absolute filepath. Path given is:${_filename}")
    endif()

    file(READ "${${VAR_PREFIX}_filename_full_path}" ${VAR_PREFIX}_contents)

    if(NOT ${CMAKE_PROJECT_NAME} AND ${_VAR_PREFIX}_TOPLEVEL)
        cmcs_error_message("CMake requires a toplevel project() call in the toplevel CMakeLists.txt")
    elseif(${_VAR_PREFIX}_TOPLEVEL)
        cmcs_init_project(${${VAR_PREFIX}_contents}) 
    else()
        cmcs_project(${${VAR_PREFIX}_contents})
    endif()

    unset(${VAR_PREFIX}_filename_full_path )
    unset(${VAR_PREFIX}_contents)
endmacro()