
add_library(CMakeCSDummy)
target_link_libraries(CMakeCSDummy PRIVATE GTest::gtest)
target_compile_features(CMakeCSDummy PUBLIC cxx_std_17)
target_sources(CMakeCSDummy PRIVATE "src/dummy.cpp" "src/dummy_private.h" "include/dummy.h")
target_include_directories(CMakeCSDummy PRIVATE include)

install(DIRECTORY include DESTINATION "${CMAKE_INSTALL_INCLUDE}/${PROJECT_NAME}/dummy" MESSAGE_NEVER)
# Does not keep folder layout!
#set_property(TARGET CMakeCSDummy APPEND PROPERTY PUBLIC_HEADER "include/dummy.h;include/named_folder/named_dummy.h" )

install(TARGETS CMakeCSDummy EXPORT ${PROJECT_NAME}_EXPORTS)
#            ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
#            LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
#            RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
#            PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
#            INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

set(${PROJECT_NAME}_EXPORTED_TARGETS ${${PROJECT_NAME}_EXPORTED_TARGETS} CMakeCSDummy CACHE INTERNAL "")

#list(APPEND ${PROJECT_NAME}_TARGET_EXPORT_NAMES CMakeCSDummy)