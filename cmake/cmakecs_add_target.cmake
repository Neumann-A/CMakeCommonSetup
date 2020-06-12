function(cmcs_add_target)
    cmcs_create_function_variable_prefix(_VAR_PREFIX)
    cmake_parse_arguments(PARSE_ARGV 0 "${_VAR_PREFIX}" 
                                       "EXECUTABLE;NO_EXPORT;AUTO_GLOB_SOURCE;AUTO_GLOB_INCLUDE" 
                                       "TARGET_NAME;LIBRARY_TYPE;EXECUTABLE_TYPE" 
                                       "PUBLIC_SOURCES;PRIVATE_SOURCES;INTERFACE_SOURCES;SOURCES;PRIVATE_DEPENDS;PUBLIC_DEPENDS;INTERFACE_DEPENDS;PUBLIC_DEFINITIONS;PRIVATE_DEFINITIONS;INTERFACE_DEFINITIONS;PUBLIC_COMPILE_OPTIONS;PRIVATE_COMPILE_OPTIONS;INTERFACE_COMPILE_OPTIONS;PUBLIC_COMPILE_FEATURES;PRIVATE_COMPILE_FEATURES;INTERFACE_COMPILE_FEATURES;PROPERTIES;PUBLIC_INCLUDE_DIRECTORIES;PRIVATE_INCLUDE_DIRECTORIES;INTERFACE_INCLUDE_DIRECTORIES;PUBLIC_LINK_OPTIONS;PRIVATE_LINK_OPTIONS;INTERFACE_LINK_OPTIONS;PUBLIC_PRECOMPILE_HEADERS;PRIVATE_PRECOMPILE_HEADERS;INTERFACE_PRECOMPILE_HEADERS;REUSE_PRECOMPILE_HEADERS_FROM_TARGETS;HEADERS;HEADER_DIRECTORIES_TO_INSTALL")

    if(${_VAR_PREFIX}_AUTO_GLOB_SOURCE) 
        file(GLOB_RECURSE ${_VAR_PREFIX}_SOURCES CONFIGURE_DEPENDS "src/*")
    endif()

    if(${_VAR_PREFIX}_AUTO_GLOB_INCLUDE) 
        file(GLOB_RECURSE ${_VAR_PREFIX}_HEADERS CONFIGURE_DEPENDS "include/*")
        set(${_VAR_PREFIX}_HEADER_DIRECTORIES_TO_INSTALL include)
    endif()

    if(${_VAR_PREFIX}_EXECUTABLE OR ${_VAR_PREFIX}_EXECUTABLE_TYPE)
        add_executable(${${_VAR_PREFIX}_TARGET_NAME} ${${_VAR_PREFIX}_EXECUTABLE_TYPE} ${${_VAR_PREFIX}_SOURCES} ${${_VAR_PREFIX}_HEADERS})
    else()
        add_library(${${_VAR_PREFIX}_TARGET_NAME} ${${_VAR_PREFIX}_LIBRARY_TYPE} ${${_VAR_PREFIX}_SOURCES} ${${_VAR_PREFIX}_HEADERS})
    endif()

    ## Setup target
    set(_deps_list "PRIVATE" "PUBLIC" "INTERFACE")
    foreach(_dep IN LISTS _deps_list)
        if(${_VAR_PREFIX}_${_dep}_DEPENDS)
            target_link_libraries(${${_VAR_PREFIX}_TARGET_NAME} ${_dep} ${${_VAR_PREFIX}_${_dep}_DEPENDS})
            set_property(TARGET ${${_VAR_PREFIX}_TARGET_NAME} PROPERTY CMakeCS_${_dep}_DEPENDS ${${_VAR_PREFIX}_${_dep}_DEPENDS})
        endif()
        if(${_VAR_PREFIX}_${_dep}_DEFINITIONS)
            target_compile_definitions(${${_VAR_PREFIX}_TARGET_NAME} ${_dep} ${${_VAR_PREFIX}_${_dep}_DEFINITIONS})
        endif()
        if(${_VAR_PREFIX}_${_dep}_COMPILE_OPTIONS)
            target_compile_options(${${_VAR_PREFIX}_TARGET_NAME} ${_dep} ${${_VAR_PREFIX}_${_dep}_COMPILE_OPTIONS})
        endif()
        if(${_VAR_PREFIX}_${_dep}_COMPILE_FEATURES)
            target_compile_features(${${_VAR_PREFIX}_TARGET_NAME} ${_dep} ${${_VAR_PREFIX}_${_dep}_COMPILE_FEATURES})
        endif()
        if(${_VAR_PREFIX}_${_dep}_INCLUDE_DIRECTORIES)
            target_include_directories(${${_VAR_PREFIX}_TARGET_NAME} ${_dep} ${${_VAR_PREFIX}_${_dep}_INCLUDE_DIRECTORIES})
        endif()
        if(${_VAR_PREFIX}_${_dep}_SOURCES)
            target_sources(${${_VAR_PREFIX}_TARGET_NAME} ${_dep} ${${_VAR_PREFIX}_${_dep}_SOURCES})
            source_group(TREE ${CMAKE_CURRENT_FUNCTION_LIST_DIR} FILES ${${_VAR_PREFIX}_${_dep}_SOURCES})
        endif()
        if(${_VAR_PREFIX}_${_dep}_LINK_OPTIONS)
          target_link_options(${${_VAR_PREFIX}_TARGET_NAME} ${_dep} ${${_VAR_PREFIX}_${_dep}_LINK_OPTIONS})
        endif()
        if(${_VAR_PREFIX}_${_dep}_PRECOMPILE_HEADERS)
            target_precompile_headers(${${_VAR_PREFIX}_TARGET_NAME} ${_dep} ${${_VAR_PREFIX}_${_dep}_PRECOMPILE_HEADERS})
        endif()
    endforeach()

    if(${_VAR_PREFIX}_REUSE_PRECOMPILE_HEADERS_FROM_TARGETS)
        foreach(_reusetarget IN LISTS ${_VAR_PREFIX}_REUSE_PRECOMPILE_HEADERS_FROM_TARGETS)
            target_precompile_headers(${${_VAR_PREFIX}_TARGET_NAME} REUSE_FROM ${_reusetarget})
        endforeach()
    endif()

    source_group(TREE ${CMAKE_CURRENT_FUNCTION_LIST_DIR} FILES ${${_VAR_PREFIX}_SOURCES} ${${_VAR_PREFIX}_HEADERS})

    if(${_VAR_PREFIX}_PROPERTIES)
        set_target_properties(${${_VAR_PREFIX}_TARGET_NAME} PROPERTIES ${${_VAR_PREFIX}_PROPERTIES})
    endif()

    cmcs_get_global_property(PROPERTY ${PROJECT_NAME}_PACKAGE_NAME)
    cmcs_get_global_property(PROPERTY ${PROJECT_NAME}_VERSION)   
    target_include_directories(${${_VAR_PREFIX}_TARGET_NAME} PUBLIC $<INSTALL_INTERFACE:include/${${PROJECT_NAME}_PACKAGE_NAME}-${${PROJECT_NAME}_VERSION}>)

    if(${_VAR_PREFIX}_HEADER_DIRECTORIES_TO_INSTALL)
        cmcs_get_global_property(PROPERTY ${PROJECT_NAME}_PACKAGE_NAME)
        target_include_directories(${${_VAR_PREFIX}_TARGET_NAME} PUBLIC $<INSTALL_INTERFACE:include/${${PROJECT_NAME}_PACKAGE_NAME}-${${PROJECT_NAME}_VERSION}>)
        foreach(_headerdir IN LISTS ${_VAR_PREFIX}_HEADER_DIRECTORIES_TO_INSTALL)
            if(IS_ABSOLUTE "${_headerdir}")
                target_include_directories(${${_VAR_PREFIX}_TARGET_NAME} PUBLIC $<BUILD_INTERFACE:${_headerdir}>)
            else()
                target_include_directories(${${_VAR_PREFIX}_TARGET_NAME} PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/${_headerdir}>
                                                                                $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURE_DIR}/${_headerdir}>)
            endif()
        endforeach()
        install(DIRECTORY ${${_VAR_PREFIX}_HEADER_DIRECTORIES_TO_INSTALL} DESTINATION include/${${PROJECT_NAME}_PACKAGE_NAME}-${${PROJECT_NAME}_VERSION} COMPONENT Development)
    endif()

    if(NOT ${_VAR_PREFIX}_NO_EXPORT)     
        set(${PROJECT_NAME}_EXPORTED_TARGETS ${${PROJECT_NAME}_EXPORTED_TARGETS} ${${_VAR_PREFIX}_TARGET_NAME} CACHE INTERNAL "")
        cmcs_set_global_property(APPEND_OPTION "APPEND" PROPERTY ${PROJECT_NAME}_EXPORTED_TARGETS)
        cmcs_get_global_property(PROPERTY ${PROJECT_NAME}_EXPORT_NAME)
        install(TARGETS ${${_VAR_PREFIX}_TARGET_NAME} 
                EXPORT ${${PROJECT_NAME}_EXPORT_NAME}
                RUNTIME DESTINATION bin COMPONENT Runtime
                LIBRARY DESTINATION lib COMPONENT Development
                ARCHIVE DESTINATION lib COMPONENT Development
                PUBLIC_HEADER DESTINATION include/${${PROJECT_NAME}_PACKAGE_NAME}-${${PROJECT_NAME}_VERSION} COMPONENT Development)
    endif()

    set(${PROJECT_NAME}_PROJECT_TARGETS ${${PROJECT_NAME}_PROJECT_TARGETS} ${${_VAR_PREFIX}_TARGET_NAME} CACHE INTERNAL "")
    cmcs_set_global_property(APPEND_OPTION "APPEND" PROPERTY ${PROJECT_NAME}_EXPORTED_TARGETS)
endfunction()

function(cmcs_read_target_file _filename)
    get_filename_component(_filename_full_path "${_filename}" ABSOLUTE)
    if(NOT EXISTS "${_filename_full_path}")
        cmcs_error_message("cmcs_read_target_file requires a valid relative or absolute filepath. Path given is:${_filename}")
    endif()

    file(READ "${${VAR_PREFIX}_filename_full_path}" ${VAR_PREFIX}_contents)
    cmcs_add_target(${${VAR_PREFIX}_contents})
endfunction()
