
cmake_minimum_required (VERSION 3.17)
include_guard(GLOBAL)

include(CMakePackageConfigHelpers) # https://cmake.org/cmake/help/latest/module/CMakePackageConfigHelpers.html

include(CMakeDependentOption) # https://cmake.org/cmake/help/latest/module/CMakeDependentOption.html

include(FeatureSummary) # https://cmake.org/cmake/help/latest/module/FeatureSummary.html
set(FeatureSummary_DEFAULT_PKG_TYPE REQUIRED CACHE INTERNAL "" FORCE)
include(CMakePrintHelpers) # https://cmake.org/cmake/help/latest/module/CMakePrintHelpers.html
#include(CMakePrintSystemInformation)

#include(SelectLibraryConfigurations) #https://cmake.org/cmake/help/latest/module/SelectLibraryConfigurations.html
include(GenerateExportHeader) # https://cmake.org/cmake/help/latest/module/GenerateExportHeader.html
#include(WriteCompilerDetectionHeader) #https://cmake.org/cmake/help/latest/module/WriteCompilerDetectionHeader.html
#include(InstallRequiredSystemLibraries) https://cmake.org/cmake/help/latest/module/InstallRequiredSystemLibraries.html

# Not applicable includes:
#include(GNUInstallDirs) # https://cmake.org/cmake/help/latest/module/GNUInstallDirs.html (Requires prior project() call)

set_property(GLOBAL PROPERTY USE_FOLDERS ON) # Enable folder layout as source layout in IDEs supporting it
set_property(GLOBAL PROPERTY REPORT_UNDEFINED_PROPERTIES "${CMAKE_BINARY_DIR}/undef_properties.log")

# Disable language extensions
set(CMAKE_C_EXTENSIONS OFF)
set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_DISABLE_IN_SOURCE_BUILD ON CACHE INTERNAL "Disable building in source directory." FORCE)
set(CMAKE_DISABLE_SOURCE_CHANGES ON CACHE INTERNAL "Disable changes to sources" FORCE)
set(GLOBAL_DEPENDS_NO_CYCLES ON CACHE INTERNAL "Disallow cyclic dependencies between all targets" FORCE)

#set(CMAKE_FOLDER "BLA" CACHE INTERNAL "Enable folder layout as source layout in IDEs supporting it." FORCE)

set(CMakeCS_MSG_ERROR_TYPE SEND_ERROR CACHE INTERNAL "CMakeCS message error type! (DEFAULT: SEND_ERROR)")
set(CMakeCS_MSG_WARNING_TYPE SEND_ERROR CACHE INTERNAL "CMakeCS message warning type!  (DEFAULT: SEND_ERROR)")

if ("${CMAKE_SOURCE_DIR}" STREQUAL "${CMAKE_BINARY_DIR}")
  message(${CMakeCS_MSG_ERROR_TYPE} "In-source builds are not allowed.")
endif ()

option(CMakeCS_ENABLE_PROJECT_OVERRIDE "Enable override of the cmake function project() with the one from CMakeCS (default:ON)" ON)
CMAKE_DEPENDENT_OPTION(CMakeCS_USE_PROJECT_OVERRIDE "Use the project() override in the project call" ON "CMakeCS_ENABLE_PROJECT_OVERRIDE" OFF)
#option(CMakeCS_ENABLE_OPTION_OVERRIDE "Enable override of the cmake function option() with the one from CMakeCS to register options in CMakeCS (default:ON)" ON)
#CMAKE_DEPENDENT_OPTION(CMakeCS_USE_OPTION_OVERRIDE "Use the option() override in the option call" ON "CMakeCS_ENABLE_OPTION_OVERRIDE" OFF)
option(CMakeCS_ENABLE_PACKAGE_FEATURE_SUMMARY "Enable automatic listing of optional packages enable variable in feature summary (default:ON)" ON)

mark_as_advanced(CMakeCS_ENABLE_PROJECT_OVERRIDE 
                 CMakeCS_USE_PROJECT_OVERRIDE 
                 CMakeCS_ENABLE_PACKAGE_FEATURE_SUMMARY)

# Reset global variables. 
set(CMakeCS_ALL_PROJECTS "" CACHE INTERNAL "List of all projects")
set(CMakeCS_TOP_PROJECTS "" CACHE INTERNAL "List of only top level projects")

list(APPEND cmakecs_cmake_files 
            common_cmake_options
            small_macros_and_functions
            parse_arguments_helpers
            error_if_project_locked
            error_if_project_not_init
            sanetize_input
            create_config_files
            target_options
            add_target
            project_options
            project
            project_properties
            init_project
            finalize_project
            test
            get_toplevel_project_info
)
foreach(_file IN LISTS cmakecs_cmake_files)
    include("${CMAKE_CURRENT_LIST_DIR}/cmakecs_${_file}.cmake")
endforeach()

set(CMakeCS_IF_KEYWORD_REGEX_LOGICAL "^(NOT|AND|OR)$" CACHE INTERNAL "Regex containing all possible logical cmake keywords for if()")
set(CMakeCS_IF_KEYWORD_REGEX_CMAKE "^(COMMAND|POLICY|TARGET|TEST|IN_LIST|DEFINED)$" CACHE INTERNAL "Regex containing all possible cmake based keywords for if()")
set(CMakeCS_IF_KEYWORD_REGEX_FILESYSTEM "^(EXISTS|IS_NEWER_THAN|IS_DIRECTORY|IS_SYMLINK|IS_ABSOLUTE)$" CACHE INTERNAL "Regex containing all possible filesystem cmake keywords for if()")
set(CMakeCS_IF_KEYWORD_REGEX_COMPARE "^(MATCHES|LESS|GREATER|EQUAL|LESS_EQUAL|GREATER_EQUAL|STRLESS|STRGREATER|STREQUAL|STRLESS_EQUAL|STRGREATER_EQUAL|VERSION_LESS|VERSION_GREATER|VERSION_EQUAL|VERSION_LESS_EQUAL|VERSION_GREATER_EQUAL)$" CACHE INTERNAL "Regex containing all possible cmake compare keywords for if()")