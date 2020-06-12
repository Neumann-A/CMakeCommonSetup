
project(CMakeCS_TestFunctionality)

if(TARGET CMakeCS::General_TestTarget)
  message(STATUS "TARGET CMakeCS::General_TestTarget EXISTS")
else()
  message(STATUS "TARGET CMakeCS::General_TestTarget DOES NOT EXISTS")
endif()
find_package(CMakeCS)
if(TARGET CMakeCS::General_TestTarget)
  message(STATUS "TARGET CMakeCS::General_TestTarget EXISTS")
else()
  message(SEND_ERROR "TARGET CMakeCS::General_TestTarget DOES NOT EXISTS")
endif()

add_executable(DepCheckDummy ${CMAKE_CURRENT_LIST_DIR}/dummy.cpp)
target_link_libraries(DepCheckDummy PRIVATE CMakeCS::General_TestTarget)
