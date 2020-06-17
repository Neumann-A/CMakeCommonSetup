function(cmcs_sanetize_input in_var out_var)
    string(REGEX REPLACE "[ \t]*#[^\n\r]+" "" ${out_var} "${${in_var}}") # Filter Comments
    string(REGEX REPLACE "[ \t\n\r]*(\"[^\"]*\"|[^ \t\n\r]+)" "\\1;" ${out_var} "${${out_var}}") # Transform elements to List
    string(REGEX REPLACE "(;[ \t\n\r]*|;?[ \t\n\r]+)+$" "" ${out_var} "${${out_var}}") # Remove trailing Whitespaces and ; @ EOD
    set(${out_var} "${${out_var}}" PARENT_SCOPE)
endfunction()