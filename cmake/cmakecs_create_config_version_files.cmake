function(cmcs_create_config_files)
    cmcs_create_function_variable_prefix(_VAR_PREFIX)
    cmake_parse_arguments(PARSE_ARGV 0 "${_VAR_PREFIX}" "" 
                          "INPUT_FILE" "COMPATIBILITY;TARGET_FILES;PACKAGE_OPTIONS;PACKAGE_DEPENDENCIES")
                          
endfunction()