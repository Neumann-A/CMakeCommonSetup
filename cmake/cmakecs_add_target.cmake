function(cmcs_add_target)
    cmcs_create_function_variable_prefix(_VAR_PREFIX)
    cmake_parse_arguments(PARSE_ARGV 0 "${_VAR_PREFIX}" 
                                       "${CMAKECS_TARGET_OPTIONS}" 
                                       "${CMAKECS_TARGET_ARGS}" 
                                       "${CMAKECS_TARGET_MULTI_ARGS}")
    cmcs_get_global_property(PROPERTY ${PROJECT_NAME}_PACKAGE_NAME)
    cmcs_get_global_property(PROPERTY ${PROJECT_NAME}_VERSION)
    
    if(${_VAR_PREFIX}_CONDITION)
        if(NOT ${${_VAR_PREFIX}_CONDITION})
            return()
        endif()
    endif()

    if(${_VAR_PREFIX}_AUTO_GLOB_SOURCE) 
        file(GLOB_RECURSE ${_VAR_PREFIX}_SOURCES CONFIGURE_DEPENDS "src/*")
    endif()

    if(${_VAR_PREFIX}_AUTO_GLOB_INCLUDE) 
        file(GLOB_RECURSE ${_VAR_PREFIX}_HEADERS CONFIGURE_DEPENDS "include/*")
        set(${_VAR_PREFIX}_HEADER_DIRECTORIES_TO_INSTALL include)
    endif()

    if(${_VAR_PREFIX}_GENERATE_EXPORT_HEADER)
        set(BASE_NAME ${${_VAR_PREFIX}_TARGET_NAME})
        list(APPEND ${_VAR_PREFIX}_HEADERS ${PROJECT_BINARY_DIR}/${BASE_NAME}_export.h)
    endif()

    if(${_VAR_PREFIX}_EXECUTABLE OR ${_VAR_PREFIX}_EXECUTABLE_TYPE)
        add_executable(${${_VAR_PREFIX}_TARGET_NAME} ${${_VAR_PREFIX}_EXECUTABLE_TYPE} ${${_VAR_PREFIX}_SOURCES} ${${_VAR_PREFIX}_HEADERS})
    else()
        add_library(${${_VAR_PREFIX}_TARGET_NAME} ${${_VAR_PREFIX}_LIBRARY_TYPE} ${${_VAR_PREFIX}_SOURCES} ${${_VAR_PREFIX}_HEADERS})
    endif()

    if(${_VAR_PREFIX}_GENERATE_EXPORT_HEADER)        
        generate_export_header(${${_VAR_PREFIX}_TARGET_NAME} BASE_NAME ${BASE_NAME}) 
        # PREFIX_NAME 
        if(NOT BUILD_SHARED_LIBS OR ${_VAR_PREFIX}_LIBRARY_TYPE MATCHES "STATIC")
            if(${${_VAR_PREFIX}_LIBRARY_TYPE} MATCHES "INTERFACE")
                target_compile_definitions(${${_VAR_PREFIX}_TARGET_NAME} INTERFACE $<UPPER_CASE:${BASE_NAME}>_STATIC_DEFINE) # Will not generate header
            else()
                target_compile_definitions(${${_VAR_PREFIX}_TARGET_NAME} PUBLIC $<UPPER_CASE:${BASE_NAME}>_STATIC_DEFINE)
            endif()
        else()
            target_compile_definitions(${${_VAR_PREFIX}_TARGET_NAME} PRIVATE ${BASE_NAME}_EXPORTS)
        endif()
        install(FILES ${PROJECT_BINARY_DIR}/${BASE_NAME}_export.h  DESTINATION include/${${PROJECT_NAME}_PACKAGE_NAME}-${${PROJECT_NAME}_VERSION} COMPONENT Development)
        list(APPEND ${_VAR_PREFIX}_HEADERS ${PROJECT_BINARY_DIR}/${BASE_NAME}_export.h)
    endif()

    ## Setup target
    set(_deps_list "PRIVATE" "PUBLIC" "INTERFACE")
    foreach(_dep IN LISTS _deps_list)
        if(${_VAR_PREFIX}_${_dep}_DEPENDS)
            target_link_libraries(${${_VAR_PREFIX}_TARGET_NAME} ${_dep} ${${_VAR_PREFIX}_${_dep}_DEPENDS})
            string(REPLACE "$<" "?<" ${_VAR_PREFIX}_${_dep}_DEPENDS_QUESTION "${${_VAR_PREFIX}_${_dep}_DEPENDS}") # cannot have generator expressions in custom properties
            set_property(TARGET ${${_VAR_PREFIX}_TARGET_NAME} PROPERTY cmakecs_${_dep}_DEPENDS ${${_VAR_PREFIX}_${_dep}_DEPENDS_QUESTION})
            set_property(TARGET ${${_VAR_PREFIX}_TARGET_NAME} APPEND PROPERTY EXPORT_PROPERTIES cmakecs_${_dep}_DEPENDS)
        endif()
        if(${_VAR_PREFIX}_${_dep}_LINK_LIBRARIES)
            target_link_libraries(${${_VAR_PREFIX}_TARGET_NAME} ${_dep} ${${_VAR_PREFIX}_${_dep}_LINK_LIBRARIES})
        endif()
        if(${_VAR_PREFIX}_${_dep}_DEFINITIONS)
            target_compile_definitions(${${_VAR_PREFIX}_TARGET_NAME} ${_dep} ${${_VAR_PREFIX}_${_dep}_DEFINITIONS})
        endif()
        if(${_VAR_PREFIX}_${_dep}_COMPILE_DEFINITIONS)
            target_compile_definitions(${${_VAR_PREFIX}_TARGET_NAME} ${_dep} ${${_VAR_PREFIX}_${_dep}_COMPILE_DEFINITIONS})
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
            target_sources(${${_VAR_PREFIX}_TARGET_NAME} ${_dep} $<BUILD_INTERFACE:${${_VAR_PREFIX}_${_dep}_SOURCES}>)
            if(${_VAR_PREFIX}_IDE_INTERFACE_TARGET)
                list(APPEND ${${_VAR_PREFIX}_TARGET_NAME}_IDE_SOURCES ${${_VAR_PREFIX}_${_dep}_SOURCES})
            endif()
            source_group(TREE ${CMAKE_CURRENT_LIST_DIR} FILES ${${_VAR_PREFIX}_${_dep}_SOURCES})
        endif()
        if(${_VAR_PREFIX}_${_dep}_LINK_OPTIONS)
          target_link_options(${${_VAR_PREFIX}_TARGET_NAME} ${_dep} ${${_VAR_PREFIX}_${_dep}_LINK_OPTIONS})
        endif()
        if(${_VAR_PREFIX}_${_dep}_PRECOMPILE_HEADERS)
            target_precompile_headers(${${_VAR_PREFIX}_TARGET_NAME} ${_dep} ${${_VAR_PREFIX}_${_dep}_PRECOMPILE_HEADERS})
            if(${_VAR_PREFIX}_IDE_INTERFACE_TARGET)
                list(APPEND ${${_VAR_PREFIX}_TARGET_NAME}_IDE_SOURCES ${${_VAR_PREFIX}_${_dep}_PRECOMPILE_HEADERS})
            endif()
        endif()
        if(${_VAR_PREFIX}_${_dep}_HEADER)
            set_property(TARGET ${${_VAR_PREFIX}_TARGET_NAME} APPEND PROPERTY ${_dep}_HEADER ${${_VAR_PREFIX}_${_dep}_HEADER})
            if(${_VAR_PREFIX}_IDE_INTERFACE_TARGET)
                list(APPEND ${${_VAR_PREFIX}_TARGET_NAME}_IDE_SOURCES ${${_VAR_PREFIX}_${_dep}_HEADER})
            endif()
        endif()
    endforeach()

    if(${_VAR_PREFIX}_IDE_INTERFACE_TARGET)
        add_custom_target(${${_VAR_PREFIX}_TARGET_NAME}_IDE DEPENDS ${${_VAR_PREFIX}_TARGET_NAME} SOURCES ${${${_VAR_PREFIX}_TARGET_NAME}_IDE_SOURCES})
    endif()

    if(${_VAR_PREFIX}_REUSE_PRECOMPILE_HEADERS_FROM_TARGETS)
        foreach(_reusetarget IN LISTS ${_VAR_PREFIX}_REUSE_PRECOMPILE_HEADERS_FROM_TARGETS)
            target_precompile_headers(${${_VAR_PREFIX}_TARGET_NAME} REUSE_FROM ${_reusetarget})
        endforeach()
    endif()

    source_group(TREE ${CMAKE_CURRENT_LIST_DIR} FILES ${${_VAR_PREFIX}_SOURCES} ${${_VAR_PREFIX}_HEADERS})

    if(${_VAR_PREFIX}_PROPERTIES)
        set_target_properties(${${_VAR_PREFIX}_TARGET_NAME} PROPERTIES ${${_VAR_PREFIX}_PROPERTIES})
    endif()

    #target_include_directories(${${_VAR_PREFIX}_TARGET_NAME} PUBLIC $<INSTALL_INTERFACE:include/${${PROJECT_NAME}_PACKAGE_NAME}-${${PROJECT_NAME}_VERSION}>)

    if(${_VAR_PREFIX}_HEADER_DIRECTORIES_TO_INSTALL OR ${_VAR_PREFIX}_PUBLIC_HEADERS)
        cmcs_get_global_property(PROPERTY ${PROJECT_NAME}_PACKAGE_NAME)
        cmcs_get_global_property(PROPERTY ${PROJECT_NAME}_INSTALL_INCLUDEDIR)
        cmcs_get_global_property(PROPERTY ${PROJECT_NAME}_USAGE_INCLUDEDIR)
        if(${${_VAR_PREFIX}_LIBRARY_TYPE} MATCHES "INTERFACE")
            set(_INC_ACCESS INTERFACE)
        else()
            set(_INC_ACCESS PUBLIC)
        endif()

        foreach(_headerdir IN LISTS ${_VAR_PREFIX}_HEADER_DIRECTORIES_TO_INSTALL)
            if(IS_ABSOLUTE "${_headerdir}")
                target_include_directories(${${_VAR_PREFIX}_TARGET_NAME} ${_INC_ACCESS} $<BUILD_INTERFACE:${_headerdir}>)
            else()
                target_include_directories(${${_VAR_PREFIX}_TARGET_NAME} ${_INC_ACCESS} $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/${_headerdir}>
                                                                                        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURE_DIR}/${_headerdir}>)
            endif()
        endforeach()

        if(${PROJECT_NAME}_USAGE_INCLUDEDIR)
            target_include_directories(${${_VAR_PREFIX}_TARGET_NAME} ${_INC_ACCESS} $<INSTALL_INTERFACE:${${PROJECT_NAME}_USAGE_INCLUDEDIR}>)
        endif()
        if(${PROJECT_NAME}_BUILD_INCLUDEDIR)
            target_include_directories(${${_VAR_PREFIX}_TARGET_NAME} ${_INC_ACCESS} $<BUILD_INTERFACE:${${PROJECT_NAME}_BUILD_INCLUDEDIR}>)
        endif()
        install(DIRECTORY ${${_VAR_PREFIX}_HEADER_DIRECTORIES_TO_INSTALL} DESTINATION ${${PROJECT_NAME}_INSTALL_INCLUDEDIR} COMPONENT Development)

        unset(_INC_ACCESS)
    endif()

    if(NOT ${_VAR_PREFIX}_NO_TARGET_EXPORT)     
        set(${PROJECT_NAME}_EXPORTED_TARGETS ${${PROJECT_NAME}_EXPORTED_TARGETS} ${${_VAR_PREFIX}_TARGET_NAME} CACHE INTERNAL "")
        cmcs_set_global_property(APPEND_OPTION "APPEND" PROPERTY ${PROJECT_NAME}_EXPORTED_TARGETS)
        cmcs_get_global_property(PROPERTY ${PROJECT_NAME}_EXPORT_NAME)
        install(TARGETS ${${_VAR_PREFIX}_TARGET_NAME} 
                EXPORT ${${PROJECT_NAME}_EXPORT_NAME}
                RUNTIME DESTINATION bin COMPONENT Runtime
                LIBRARY DESTINATION lib COMPONENT Development
                ARCHIVE DESTINATION lib COMPONENT Development
                PUBLIC_HEADER DESTINATION ${${PROJECT_NAME}_INSTALL_INCLUDEDIR} COMPONENT Development)
    endif()

    set(${PROJECT_NAME}_PROJECT_TARGETS ${${PROJECT_NAME}_PROJECT_TARGETS} ${${_VAR_PREFIX}_TARGET_NAME} CACHE INTERNAL "")
endfunction()

function(cmcs_read_target_file _filename)
    set(${VAR_PREFIX} _cmcs_rtf)
    get_filename_component(${VAR_PREFIX}_filename_full_path "${_filename}" ABSOLUTE)
    if(NOT EXISTS "${${VAR_PREFIX}_filename_full_path}")
        cmcs_error_message("cmcs_read_target_file requires a valid relative or absolute filepath. Path given is:${_filename}|${${VAR_PREFIX}_filename_full_path}")
    endif()
    #message(VERBOSE "[CMakeCS]: Loading target file:${${VAR_PREFIX}_filename_full_path}")
    file(READ "${${VAR_PREFIX}_filename_full_path}" ${VAR_PREFIX}_contents)
    cmcs_sanetize_input(${VAR_PREFIX}_contents ${VAR_PREFIX}_contents) # Transforms everything into a list
    string(CONFIGURE "${${VAR_PREFIX}_contents}" ${VAR_PREFIX}_contents) # Expands CMake variables   
    message(TRACE "[CMakeCS]: Target contents:${${VAR_PREFIX}_contents}")
    cmcs_add_target(${${VAR_PREFIX}_contents})
endfunction()
