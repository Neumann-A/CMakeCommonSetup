set(CMAKECS_PROJECT_OPTIONS "USE_DIRECTORY_AS_PROJECT_NAME"
                            "NO_FINALIZE;NO_AUTOMATIC_CONFIG_FILE"
                            "CONFIG_WITH_MODULES"
                            "EXTENDED_PACKAGES_INFO" # Just to block cmake_parse_argument for MULTI_ARGS
                            "SYMLINKED_BUILD_INCLUDEDIR" # creates a mirror of the installed include layout in CMAKE_BINARY_DIR via symlinks
                            CACHE INTERNAL "")
set(CMAKECS_PROJECT_ARGS "PROJECT_NAME;VERSION;HOMEPAGE_URL;DESCRIPTION"
                         "PACKAGE_NAME;NAMESPACE;EXPORT_NAME"
                         "VERSION_COMPATIBILITY;CONFIG_INPUT_FILE;CONFIG_INSTALL_DESTINATION"
                         "OPTION_FILE" # TODO
                         "PUBLIC_MODULE_DIRECTORIES" #TODO 
                         "INSTALL_INCLUDEDIR"
                         "USAGE_INCLUDEDIR"
                         CACHE INTERNAL "")
set(CMAKECS_PROJECT_MULTI_ARGS "LANGUAGES"
                               "REQUIRED_PACKAGES;OPTIONAL_PACKAGES;OPTIONAL_CONDITIONAL_PACKAGES"
                               "RECOMMENDED_PACKAGES;RUNTIME_PACKAGES" # TODO
                               "PUBLIC_CMAKE_FILES;PUBLIC_CMAKE_DIRS" # These will probably be renamed
                               "MODULES_TO_INCLUDE" # Modules to include in the generated config
                               "SUBDIRECTORIES"
                               "TARGET_FILES"
                               "EXPORTED_VARIABLES" # These variables will be exported in the config 
                               "CONDITION" # Condition for which the project is loaded"
                                CACHE INTERNAL "")

## Additional options for every package after EXTENDED_PACKAGES_INFO:
# ONE_ARG: <package>_(VERSION|PURPOSE)
# MULTI_ARG: <package>_(COMPONENTS|FIND_OPTIONS|CONDITION)
# *CONDITION only used for OPTIONAL_CONDITIONAL_PACKAGES (needs to be a valid if(<CONDITION>))
# *FIND_OPTIONS to specify further find options. 
