function(cmcs_sanetize_input in_var out_var)
    message(TRACE "[CMakeCS]: input line:'${${in_var}}'")
    string(REGEX REPLACE "[ \t]*#.+$" "" ${out_var} "${${in_var}}") # Filter Comments
    string(STRIP "${${out_var}}" ${out_var}) # Strip whitespaces at begin and end
    message(TRACE "[CMakeCS]: sanitzed input line:'${${out_var}}'")
    set(${out_var} "${${out_var}}" PARENT_SCOPE)
endfunction()

function(cmcs_read_input_file in_file out_contents)
    file(STRINGS "${in_file}" _contents)
    set(_sanitzed_input_list)
    foreach(_line IN LISTS _contents)
        set(_sanitzed_line)
        cmcs_sanetize_input(_line _sanitzed_line) # Transforms everything into a list
        list(APPEND _sanitzed_input_list "${_sanitzed_line}")
    endforeach()
    string(CONFIGURE "${${out_contents}}" ${out_contents}) # Expands CMake variables
    set(${out_contents} "${_sanitzed_input_list}" PARENT_SCOPE)
endfunction()