## Component Options
set(CMAKECS_COMPONENT_OPTIONS "USE_DIRECTORY_AS_COMPONENT_NAME"
                            "NO_FINALIZE;NO_AUTOMATIC_CONFIG_FILE"
                            "CONFIG_WITH_MODULES"
                            "EXTENDED_PACKAGES_INFO" # Just to block cmake_parse_argument for MULTI_ARGS
                            "SYMLINKED_BUILD_INCLUDEDIR" # creates a mirror of the installed include layout in CMAKE_BINARY_DIR via symlinks
                            CACHE INTERNAL "")
set(CMAKECS_COMPONENT_ARGS "COMPONENT_NAME;VERSION;DESCRIPTION"
                         #"PACKAGE_NAME;NAMESPACE;EXPORT_NAME"
                         "VERSION_COMPATIBILITY;CONFIG_INPUT_FILE;CONFIG_INSTALL_DESTINATION"
                         #"OPTION_FILE" # TODO
                         #"PUBLIC_MODULE_DIRECTORIES" #TODO: Should be handle on Project Scope
                         "INSTALL_INCLUDEDIR"
                         "USAGE_INCLUDEDIR"
                         "TARGETS_FOLDER"
                         CACHE INTERNAL "")
set(CMAKECS_COMPONENT_MULTI_ARGS #"LANGUAGES"
                               "REQUIRED_PACKAGES;OPTIONAL_PACKAGES;OPTIONAL_CONDITIONAL_PACKAGES"
                               "RECOMMENDED_PACKAGES;RUNTIME_PACKAGES" # TODO
                               #"PUBLIC_CMAKE_FILES;PUBLIC_CMAKE_DIRS" # These will probably be renamed
                               #"MODULES_TO_INCLUDE" # Modules to include in the generated config
                               "INCLUDES;SUBDIRECTORIES;INCLUDES_AFTER_SUBDIRECTORIES;TARGET_FILES;INCLUDES_AFTER_TARGETS"
                               "EXPORTED_VARIABLES" # These variables will be exported in the config 
                               "CONDITION" # Condition for which the COMPONENT is loaded"
                                CACHE INTERNAL "")
mark_as_advanced(CMAKECS_COMPONENT_OPTIONS CMAKECS_COMPONENT_ARGS CMAKECS_COMPONENT_MULTI_ARGS)


## Compononent Function
function(cmcs_component)
endfunction()

function(cmcs_read_component_file)
endfunction()

function(cmcs_finalize_component)
endfunction()