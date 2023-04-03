include(GoogleTest)

add_library(greatestof3 greatestof3.cpp)


add_executable(test main_test.cpp)
gtest_discover_tests(test)
target_link_libraries(test greatestof3 CONAN_PKG::gtest)

install(TARGETS test)
