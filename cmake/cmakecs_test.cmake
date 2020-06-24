function(cmakecs_basic_test)
    cmake_parse_arguments("_cmcs_act" "" "PROJECT_NAME" "DEPENDS" ${ARGN})
endfunction()