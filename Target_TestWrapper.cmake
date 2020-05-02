
#--Setting up a general test harness using gtest
add_library(General_TestTarget INTERFACE)
target_link_libraries(General_TestTarget INTERFACE GTest::gtest GTest::gtest_main)
target_compile_features(General_TestTarget INTERFACE cxx_std_17)

cmcs_get_global_property(PROPERTY ${PROJECT_NAME}_EXPORT_NAME)
install(TARGETS General_TestTarget EXPORT ${${PROJECT_NAME}_EXPORT_NAME} DESTINATION tests)

set(${PROJECT_NAME}_EXPORTED_TARGETS ${${PROJECT_NAME}_EXPORTED_TARGETS} General_TestTarget CACHE INTERNAL "")
cmcs_set_global_property(APPEND_OPTION "APPEND" PROPERTY ${PROJECT_NAME}_EXPORTED_TARGETS)

