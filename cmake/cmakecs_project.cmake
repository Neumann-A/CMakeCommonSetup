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

    project(${${_VAR_PREFIX}_PROJECT_NAME}
            VERSION ${${_VAR_PREFIX}_VERSION}
            DESCRIPTION ${${_VAR_PREFIX}_DESCRIPTION}
            HOMEPAGE_URL ${${_VAR_PREFIX}_HOMEPAGE_URL}
            LANGUAGES ${${_VAR_PREFIX}_LANGUAGES})
    cmcs_init_project(${${_VAR_PREFIX}_UNPARSED_ARGUMENTS})
endmacro()