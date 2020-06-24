set(CMAKECS_PROJECT_OPTIONS "USE_DIRECTORY_AS_PROJECT_NAME"
                            "NO_FINALIZE;NO_AUTOMATIC_CONFIG_FILE;CONFIG_WITH_MODULES"
                            "EXTENDED_PACKAGES_INFO" 
                            CACHE INTERNAL "")
set(CMAKECS_PROJECT_ARGS "PROJECT_NAME;VERSION;HOMEPAGE_URL;DESCRIPTION"
                         "PACKAGE_NAME;NAMESPACE;EXPORT_NAME"
                         "VERSION_COMPATIBILITY;CONFIG_INPUT_FILE;CONFIG_INSTALL_DESTINATION"
                         "OPTION_FILE"
                         CACHE INTERNAL "")
set(CMAKECS_PROJECT_MULTI_ARGS "LANGUAGES"
                               "REQUIRED_PACKAGES;OPTIONAL_PACKAGES;OPTIONAL_CONDITIONAL_PACKAGES"
                               "PUBLIC_CMAKE_FILES;PUBLIC_CMAKE_DIRS"
                               "MODULES_TO_INCLUDE"
                               "SUBDIRECTORIES"
                               "TARGET_FILES"
                                CACHE INTERNAL "")
