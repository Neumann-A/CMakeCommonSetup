# Function which targets of the project which should be exported and alias the targets 
# for internal builds. 

function(cmcs_finalize_project)
    cmcs_error_if_project_locked()
    cmcs_error_if_project_not_init()
    message(NOTICE "Finializing project: ${PROJECT_NAME}")
    cmcs_get_global_property(PROPERTY ${PROJECT_NAME}_PACKAGE_NAME)
    cmcs_get_global_property(PROPERTY ${PROJECT_NAME}_EXPORT_NAME)
    cmcs_get_global_property(PROPERTY ${PROJECT_NAME}_EXPORTED_TARGETS)
    cmcs_get_global_property(PROPERTY ${PROJECT_NAME}_EXPORT_ON_BUILD)

    cmcs_trace_variables(${PROJECT_NAME}_PACKAGE_NAME ${PROJECT_NAME}_EXPORT_NAME ${PROJECT_NAME}_EXPORTED_TARGETS)
    # In Project find_package calls never work in build and require ALIAS targets
    # This export dues export the targets into the build dir with absoulte paths.
    # It only works if the <packagename>Config.cmake has all requirements to run 
    # correctly in the build dir. This requires that all files required by the config
    # are present in the build dir. If the config only requires targets, version or
    # other generated files this works. If it additionally requires files from the 
    # SOURCE_TREE which are only installed it typically breaks and requires extra
    # code in the config to work! The only way to use those exported files is to have
    # a staged build with e.g. ExternalProject_Add followed by another ExternalProject_Add
    # which depends on the build target of the first and consumes the generated configs
    # from it. This skips the required install step but leaves the question if it is worth
    # the effort since extra care must be taken to make it findable with find_package (
    # e.g. setting <packagename>_DIR correctly) while for **all** installed librarys setting  
    # CMAKE_PREFIX_PATH would be sufficient
    # TL;DR: **This is only useful for ExternalProject_Add and skipping the install step and
    #          requires the config to work form the build dir**
    if(${PROJECT_NAME}_EXPORT_ON_BUILD)
        export(EXPORT ${${PROJECT_NAME}_EXPORT_NAME}
            NAMESPACE ${${PROJECT_NAME}_PACKAGE_NAME}:: 
            FILE ${CMAKE_INSTALL_DATAROOTDIR}/${${PROJECT_NAME}_PACKAGE_NAME}/${${PROJECT_NAME}_PACKAGE_NAME}Targets.cmake)
    endif()

    # This only exists @ install time
    install(EXPORT ${${PROJECT_NAME}_EXPORT_NAME}
            NAMESPACE ${${PROJECT_NAME}_PACKAGE_NAME}:: 
            FILE ${${PROJECT_NAME}_PACKAGE_NAME}Targets.cmake 
            DESTINATION "${CMAKE_INSTALL_DATAROOTDIR}/${${PROJECT_NAME}_PACKAGE_NAME}")
    set(${PROJECT_NAME}_LOCKED TRUE)

    # Alias all exported targets into the namespace ${PROJECT_NAME}_PACKAGE_NAME 
    # just as the target file would do. Assumes that all variables are available just 
    # like if find_package is called.
    foreach(_target IN LISTS ${PROJECT_NAME}_EXPORTED_TARGETS)
        add_library(${${PROJECT_NAME}_PACKAGE_NAME}::${_target} ALIAS ${_target})
    endforeach()
    # Disable find_package for internally available packages. 
    set(CMAKE_DISABLE_FIND_PACKAGE_${${PROJECT_NAME}_PACKAGE_NAME} TRUE CACHE INTERNAL "" FORCE)

    cmcs_set_global_property(PROPERTY ${PROJECT_NAME}_LOCKED)
    message(NOTICE "${PROJECT_NAME} locked!")
endfunction()