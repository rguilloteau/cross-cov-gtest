include(GoogleTest)

add_executable(test main_test.cpp)
gtest_discover_tests(test)
target_link_libraries(test greatestof3 CONAN_PKG::gtest)

install(TARGETS test)
