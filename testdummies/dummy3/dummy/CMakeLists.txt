project(DummySubSubProject)
add_library(DummySubSubProject)
target_link_libraries(DummySubSubProject PRIVATE GTest::gtest)
target_compile_features(DummySubSubProject PUBLIC cxx_std_17)
target_sources(DummySubSubProject PRIVATE "src/dummy.cpp" "src/dummy_private.h" "include/dummy.h")
target_include_directories(DummySubSubProject PRIVATE include)

install(DIRECTORY include DESTINATION "${CMAKE_INSTALL_INCLUDE}/${PROJECT_NAME}/dummy" MESSAGE_NEVER)
# Does not keep folder layout!
#set_property(TARGET CMakeCSDummy APPEND PROPERTY PUBLIC_HEADER "include/dummy.h;include/named_folder/named_dummy.h" )

install(TARGETS DummySubSubProject EXPORT ${PROJECT_NAME}_EXPORTS)
#            ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
#            LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
#            RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
#            PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
#            INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

set(${PROJECT_NAME}_EXPORTED_TARGETS ${${PROJECT_NAME}_EXPORTED_TARGETS} DummySubSubProject CACHE INTERNAL "")

#list(APPEND ${PROJECT_NAME}_TARGET_EXPORT_NAMES CMakeCSDummy)
message(STATUS "DummySubSubProject")
message(STATUS "PROJECT_NAME:${PROJECT_NAME}")
message(STATUS "CMAKE_PROJECT_NAME:${CMAKE_PROJECT_NAME}")