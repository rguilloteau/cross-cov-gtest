include(GoogleTest)

add_executable(greatestof3 greatestof3.cpp main_test.cpp)
gtest_discover_tests(greatestof3)
target_link_libraries(greatestof3 CONAN_PKG::gtest)

install(TARGETS greatestof3)
