#https://cmake.org/cmake/help/latest/command/option.html
#https://cmake.org/cmake/help/latest/module/CMakeDependentOption.html#module:CMakeDependentOption

# Good practice to have options completly seperated from the rest since it makes it easier 
# for a user to check what certain options will probably do. No deep dive into the CMakeLists.txt
# This file will be included after the project ist created so you can use ${PROJECT_NAME} here for grouping
# This option file should only be used for options unrelated to the existance of optional external dependencies

option(${PROJECT_NAME}_MY_OPTION_1 "Just an example 1" ON)

option(${PROJECT_NAME}_MY_OPTION_2 "Just an example 2" OFF)

CMAKE_DEPENDENT_OPTION(${PROJECT_NAME}_MY_DEP_OPTION "Just an example" ON
                       "${PROJECT_NAME}_MY_OPTION_2;NOT ${PROJECT_NAME}_MY_OPTION_1" OFF)