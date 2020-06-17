function(cmcs_get_toplevel_project_info _outvar _file)
    set(VAR_PREFIX cmcs_gtpi)

    file(READ "${_file}" ${VAR_PREFIX}_contents)
    cmcs_sanetize_input(${VAR_PREFIX}_contents ${VAR_PREFIX}_contents)
    include("${CMAKE_CURRENT_FUNCTION_LIST_DIR}/cmakecs_project_options.cmake" NO_POLICY_SCOPE)
    cmake_parse_arguments("${VAR_PREFIX}" "${PROJECT_OPTIONS}" "${PROJECT_ARGS}" "${PROJECT_MULTI_ARGS}" "${${VAR_PREFIX}_contents}")
    if(${VAR_PREFIX}_UNPARSED_ARGUMENTS)
        cmcs_error_message("Unparsed arguments found in project file:'${_file}'.\nUnparsed:${${VAR_PREFIX}_UNPARSED_ARGUMENTS}")
    endif()
    
    set(${_outvar} ${${VAR_PREFIX}_PROJECT_NAME}
                   VERSION ${${VAR_PREFIX}_VERSION}
                   DESCRIPTION ${${VAR_PREFIX}_DESCRIPTION}
                   HOMEPAGE_URL ${${VAR_PREFIX}_HOMEPAGE_URL}
                   LANGUAGES ${${VAR_PREFIX}_LANGUAGES} PARENT_SCOPE)
endfunction()