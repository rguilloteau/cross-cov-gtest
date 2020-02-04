project_add_test(greatestof3 greatestof3.cpp main_test.cpp)

target_link_libraries(greatestof3 CONAN_PKG::gtest)

install(TARGETS greatestof3)
