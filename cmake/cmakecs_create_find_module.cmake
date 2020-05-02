function(cmcs_create_find_module)
    cmcs_create_function_variable_prefix(_VAR_PREFIX)
    cmake_parse_arguments(PARSE_ARGV 0 "${_VAR_PREFIX}" "" "MODULE_NAME;NAMESPACE_NAME" "TARGETS")
    foreach(_target)
    endforeach()
endfunction(cmcs_create_find_module)

# include(${CMAKE_CURRENT_LIST_DIR}/FindPackageHandleStandardArgs.cmake)
# find_package_handle_standard_args(JPEG
#   REQUIRED_VARS JPEG_LIBRARY JPEG_INCLUDE_DIR
#   VERSION_VAR JPEG_VERSION)

# find_package_handle_standard_args(<PackageName>
#   [FOUND_VAR <result-var>]
#   [REQUIRED_VARS <required-var>...]
#   [VERSION_VAR <version-var>]
#   [HANDLE_COMPONENTS]
#   [CONFIG_MODE]
#   [NAME_MISMATCHED]
#   [REASON_FAILURE_MESSAGE <reason-failure-message>]
#   [FAIL_MESSAGE <custom-failure-message>]
#   )