function(cmcs_write_basic_config_file)
    cmcs_create_function_variable_prefix(_VAR_PREFIX)
    cmake_parse_arguments(PARSE_ARGV 0 "${_VAR_PREFIX}" "" 
                        "INPUT_FILE" "COMPATIBILITY;TARGET_FILES;PACKAGE_OPTIONS;PACKAGE_DEPENDENCIES")

    set(OUTPUT_CONFIG "@PACKAGE_INIT@\n")
    string(APPEND OUTPUT_CONFIG "cmake_policy(PUSH)\n")
    string(APPEND OUTPUT_CONFIG "cmake_minimum_required (VERSION 3.16)\n\n")
    string(APPEND OUTPUT_CONFIG "include(CMakeFindDependencyMacro)\n\n")
    string(APPEND OUTPUT_CONFIG "cmake_policy(POP)\n")
endfunction()