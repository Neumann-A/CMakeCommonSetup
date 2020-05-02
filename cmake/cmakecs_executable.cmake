
function(cmakecs_library)
    cmake_parse_arguments(PARSE_ARGV 0 "_cmcs_acp" "USE_FOLDERS_AS_SOURCE_GROUPS;NO_EXPORT"
                        "LIBRARY_NAME;EXPORT_NAME;EXPORT_NAMESPACE" "DEPENDS;SOURCES;PUBLIC_HEADERS")
if(NOT _cmcs_acp_LIBRARY_NAME)
    message(SEND_ERROR "cmakecs_add_common_project requires parameter LIBRARY_NAME")
endif()



endfunction()