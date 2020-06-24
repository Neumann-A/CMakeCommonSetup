# CMakeCommonSetup
Common CMake scripts to setup projects, tests, dependencies (via package managers) and other stuff The aim of CMakeCS is to reduce the mental burden to setup CMake projects by providing a declarative project/target setup which automatically deals with correctly exporting and installing targets without too much effort. It can be used either from a build, install or even droped into your project. The recommended way to use CMakeCS is to install it and use `find_package(CMakeCS)` with `CMakeCS_Dir` set to the directory containing the installed `CMakeCSConfig.cmake` file.   

### Key features
 - declarative project/target setup (similar to VTKs new module system)
 - declaration follows CMake style e.g in a target file `INTERFACE_LINK_LIBRARIES <Args>` is synonym to `target_link_libraries(target INTERFACE ${Args})`
 - correct external dependency handling on a project basis via `find_package()`. Use one of `"REQUIRED_PACKAGES;OPTIONAL_PACKAGES;OPTIONAL_CONDITIONAL_PACKAGES"` to depend on external packages. Additional options might be add via e.g. `<packagename>_COMPONENTS` (Requires: `EXTENDED_PACKAGES_INFO` due to the usage of `cmake_parse_arguments`)
 - You can mix and match normal `CMakeLists.txt` with the target/project files used by CMakeCS
 - target/project files can use normal cmake variables and generator expressions where CMake allows it. (It uses `string(CONFIGURE)`)
 - Provides `CMakeCS::CompilerWarnings` with a selection of good (and maybe noisy) compiler warnings for different compilers (Clang,GCC,MSVC|TODO:Intel)

### Future possible features
 - vendoring third party (CMake) dependencies with automatic addition of `<package_prefix>` to the library name to avoid conflicts. (VTK style) 

### Features to probably never to be included
 - automatic download of third party dependencies. 3rd party dependencies should be handled by a package manager and not by the build system itself

## Examples
 - The project itself uses CMakeCS, so you can directly inspect the `CMakeLists.txt` to get and idea 
 - The minimal example is:
```
cmake_minimum_required (VERSION 3.17)
set(CMakeCS_Dir <CMakeCS_Install_Directory> CACHE PATH "") # Cache variable so that it might be overwritten by the CMake command
find_package(CMakeCS) # or include(<CMakeCS_Install_Directory>/cmake/CMakeCS.cmake)
project(<filename>)
```
`"<filename>"` is a CMakeCS project description file. You can look into `Project.CMakeCS.cmakecs` to get an idea how it works 
 - TODO: More examples

## Internals

If you want to know more how this all works. Here a short introduction: project/target files are simply read using `file(READ)`, sanitzed and passed to the functions `cmcs_project` or `cmcs_add_target` where `cmake_parse_arguments` does all the work. Available project/target options can be found in `cmakecs_project_options.cmake` and `cmakecs_target_options.cmake`.

## The anatomy of every CMake project
 1) Define toplevel project
 3) (Define subprojects)
 4) Import some (optional) dependencies (via find_package)
 5) Define 'buildable' targets (libraries, executables, others [including code generators] )
 6) Add something to those targets dependendent on some options or the found dependencies (sources,definitions,linkage,etc.)
 ---
 7) install some (not necessary all) targets (sometimes forgotten)
 8) export the installed targets of the project into a cmake file. (probably forgotten)
 9) generate a config including the file from 8) with a find_dependency call for all required dependencies and write a version file (probably forgotten)
 10) maybe restart with 1)

 ### Common problems from the view of package manager
 
 To point 4)
 - having optional dependencies without an explicit option to enable disable the option.
 Observed Problems:
 - Link errors in static builds due to missing dependencies; Builds on different machine not reproduciable due to different system libraries.  
 Solution:
 - Have an explicit named option `<ProjectName>_ENABLE_<PackageName>` which is defaulted to `OFF`
   (Yes there is `CMAKE_DISABLE_FIND_PACKAGE_<PackageName>` but this requires implicit knowledge that the project uses `<PackageName>`)
 - Define `find_package` dependencies on the project levels. Helps integrating those information into the later generated config file. 

### Common problems from the view of the author
 To point 6)
  - linking imported targets without knowledge where they came from. 
 Observed Problems:
  - missing find_dependency call in `<PackageName>Config.cmake` (if it even exits)
 Solution: 
  - 

--- 
 TODO
 Improve README.md
 
 (things to check)
 Check global property ENABLED_FEATURES and file FeatureSummary.cmake
 GLOBAL_DEPENDS_NO_CYCLES
 TARGETS:
 EXPORT_PROPERTIES
 WINDOWS_EXPORT_ALL_SYMBOLS
 FOLDERS

 Global:
 PACKAGES_FOUND
 PACKAGES_NOT_FOUND

 Directory properties:
 BUILDSYSTEM_TARGETS
 VARIABLES
 CMAKE_CONFIGURE_DEPENDS

 - Add Target/Project options and register them to add them into the generated config
 - Add the possibility to create instantiations of C++ templates in a common way