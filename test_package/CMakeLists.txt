include(GoogleTest)
# Setup conan targets

include(${CMAKE_CURRENT_BINARY_DIR}/conanbuildinfo.cmake)
conan_basic_setup(TARGETS)

message("Coucou "${CONAN_INCLUDE_DIRS})

add_executable(test main_test.cpp)
target_compile_options(test PRIVATE "--coverage")
target_link_options(test PRIVATE "--coverage")
target_include_directories(test PRIVATE ${CONAN_INCLUDE_DIRS})
conan_target_link_libraries(test)

gtest_discover_tests(test)
