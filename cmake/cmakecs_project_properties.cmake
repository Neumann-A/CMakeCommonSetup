#define_property(<GLOBAL | DIRECTORY | TARGET | SOURCE |
#                 TEST | VARIABLE | CACHED_VARIABLE>
#                 PROPERTY <name> [INHERITED]
#                 BRIEF_DOCS <brief-doc> [docs...]
#                 FULL_DOCS <full-doc> [docs...])
function(cmcs_define_project_properties) # Defines general project properties
    cmcs_create_function_variable_prefix(_VAR_PREFIX)
    cmake_parse_arguments(PARSE_ARGV 0 "${_VAR_PREFIX}" "" "PROJECT_NAME" "")
    cmcs_variable_exists_or_error(PREFIX ${_VAR_PREFIX} VARIABLES "PROJECT_NAME")
    cmcs_define_global_property(PROPERTY ${${_VAR_PREFIX}_PROJECT_NAME}_PACKAGE_NAME 
                                BRIEF_DOCS "Projects find_package name (inherited from parent)"
                                FULL_DOCS  "Stores the package name to use for find_package calls ")
    cmcs_define_global_property(PROPERTY ${${_VAR_PREFIX}_PROJECT_NAME}_NAMESPACE
                                BRIEF_DOCS "Namespace of exported targets (inherited from parent)"
                                FULL_DOCS  " ")
    cmcs_define_global_property(PROPERTY ${${_VAR_PREFIX}_PROJECT_NAME}_REQUIRED_PACKAGES 
                                BRIEF_DOCS "Stores the list of required package dependencies." FULL_DOCS " ")                            
    cmcs_define_global_property(PROPERTY ${${_VAR_PREFIX}_PROJECT_NAME}_OPTIONAL_PACKAGES 
                                BRIEF_DOCS "Stores the list of optional package dependencies." FULL_DOCS " ")
    cmcs_define_global_property(PROPERTY ${${_VAR_PREFIX}_PROJECT_NAME}_OPTIONAL_DEPENDENT_PACKAGES 
                                BRIEF_DOCS "Stores the list of optional package dependencies which depent on another package being available." FULL_DOCS " ")
    cmcs_define_global_property(PROPERTY ${${_VAR_PREFIX}_PROJECT_NAME}_PARENT 
                                BRIEF_DOCS "Stores the name of the parent project." FULL_DOCS " ")
    cmcs_define_global_property(PROPERTY ${${_VAR_PREFIX}_PROJECT_NAME}_CHILDS
                                BRIEF_DOCS "List of child projects." FULL_DOCS " ")
    cmcs_define_global_property(PROPERTY ${${_VAR_PREFIX}_PROJECT_NAME}_EXPORTED_TARGETS
                                BRIEF_DOCS "Stores a list of exported targets in this project." FULL_DOCS " ")
    cmcs_define_global_property(PROPERTY ${${_VAR_PREFIX}_PROJECT_NAME}_EXPORT_NAME
                                BRIEF_DOCS "Stores the name of the export group for this project." FULL_DOCS " ")
    cmcs_define_global_property(PROPERTY ${${_VAR_PREFIX}_PROJECT_NAME}_CONFIG_INSTALL_DESTINATION
                                BRIEF_DOCS "Stores the installation destination for ${PACKAGE_NAME}Config.cmake and related files" FULL_DOCS " ")
    cmcs_define_global_property(PROPERTY ${${_VAR_PREFIX}_PROJECT_NAME}_PUBLIC_CMAKE_FILES
                                BRIEF_DOCS "Paths to public cmake files or modules which are required to be installed." 
                                FULL_DOCS "Installation of cmake files/modules will be done into ${${_VAR_PREFIX}_PROJECT_NAME}_CONFIG_INSTALL_DESTINATION}/cmake")
    cmcs_define_global_property(PROPERTY ${${_VAR_PREFIX}_PROJECT_NAME}_PUBLIC_CMAKE_DIRS
                                BRIEF_DOCS "Paths to public cmake files or modules which are required to be installed." 
                                FULL_DOCS "Installation of cmake files/modules will be done into ${${_VAR_PREFIX}_PROJECT_NAME}_CONFIG_INSTALL_DESTINATION}/cmake")
    cmcs_define_global_property(PROPERTY ${${_VAR_PREFIX}_PROJECT_NAME}_LOCKED
                                BRIEF_DOCS "Is the project finalized and locked?" FULL_DOCS " ")
endfunction()

function(cmcs_define_project_used_package_properties) # Defines properties of used packages of this project
    cmcs_create_function_variable_prefix(_VAR_PREFIX)
    cmake_parse_arguments(PARSE_ARGV 0 "${_VAR_PREFIX}" "" "PROJECT_NAME;PACKAGE_NAME" "")
    cmcs_variable_exists_or_error(PREFIX ${_VAR_PREFIX} VARIABLES "PROJECT_NAME;PACKAGE_NAME")
    cmcs_define_global_property(PROPERTY ${PROJECT_NAME}_${PACKAGE_NAME}_VERSION
                            BRIEF_DOCS "Package Version of ${PACKAGE_NAME} used by ${PROJECT_NAME}" FULL_DOCS " ")
    cmcs_define_global_property(PROPERTY ${PROJECT_NAME}_${PACKAGE_NAME}_CONDITION
                            BRIEF_DOCS "Condition under which ${PACKAGE_NAME} is used by ${PROJECT_NAME}" FULL_DOCS " ")
    cmcs_define_global_property(PROPERTY ${PROJECT_NAME}_${PACKAGE_NAME}_COMPONENTS
                                BRIEF_DOCS "Components of ${PACKAGE_NAME} used by ${PROJECT_NAME}" FULL_DOCS " ")
    cmcs_define_global_property(PROPERTY ${PROJECT_NAME}_${PACKAGE_NAME}_FIND_OPTIONS
                                BRIEF_DOCS "Additional options used in the find_package call for ${PACKAGE_NAME} used by ${PROJECT_NAME}" FULL_DOCS " ")
    cmcs_define_global_property(PROPERTY ${PROJECT_NAME}_${PACKAGE_NAME}_FIND_PACKAGE
                                BRIEF_DOCS "find_package call for ${PACKAGE_NAME} used by ${PROJECT_NAME}" FULL_DOCS " ")
endfunction()