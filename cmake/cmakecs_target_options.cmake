set(CMAKECS_TARGET_OPTIONS "EXECUTABLE"
                           "NO_TARGET_EXPORT"
                           "AUTO_GLOB_SOURCE;AUTO_GLOB_INCLUDE"
                           "GENERATE_EXPORT_HEADER" 
                           CACHE INTERNAL "")
set(CMAKECS_TARGET_ARGS "TARGET_NAME;LIBRARY_TYPE;EXECUTABLE_TYPE" 
                        CACHE INTERNAL "")
set(CMAKECS_TARGET_MULTI_ARGS "PUBLIC_SOURCES;PRIVATE_SOURCES;INTERFACE_SOURCES;SOURCES"
                              "PUBLIC_DEPENDS;PRIVATE_DEPENDS;INTERFACE_DEPENDS" # Same as <type>_LINK_LIBRARIES which additional gets exported in a cmakcs property
                              "PUBLIC_LINK_LIBRARIES;PRIVATE_LINK_LIBRARIES;INTERFACE_LINK_LIBRARIES"
                              "PUBLIC_DEFINITIONS;PRIVATE_DEFINITIONS;INTERFACE_DEFINITIONS" # Shorter replacement for COMPILE_DEFINITIONS
                              "PUBLIC_COMPILE_DEFINITIONS;PRIVATE_COMPILE_DEFINITIONS;INTERFACE_COMPILE_DEFINITIONS"
                              "PUBLIC_COMPILE_OPTIONS;PRIVATE_COMPILE_OPTIONS;INTERFACE_COMPILE_OPTIONS"
                              "PUBLIC_COMPILE_FEATURES;PRIVATE_COMPILE_FEATURES;INTERFACE_COMPILE_FEATURES"
                              "PUBLIC_INCLUDE_DIRECTORIES;PRIVATE_INCLUDE_DIRECTORIES;INTERFACE_INCLUDE_DIRECTORIES"
                              "PUBLIC_LINK_OPTIONS;PRIVATE_LINK_OPTIONS;INTERFACE_LINK_OPTIONS"
                              "PUBLIC_PRECOMPILE_HEADERS;PRIVATE_PRECOMPILE_HEADERS;INTERFACE_PRECOMPILE_HEADERS"
                              "REUSE_PRECOMPILE_HEADERS_FROM_TARGETS"
                              "PROPERTIES" # same as set_properties(TARGET PROPERTIES <args>)
                              "CONDITION" # Condition for which the target is generated
                              "TARGET_OPTIONS_FILE;EXPORTED_OPTIONS" # List of variables which gets added as a custom property to the target (TODO: not yet implemented)
                              "HEADERS;HEADER_DIRECTORIES_TO_INSTALL" CACHE INTERNAL "")




