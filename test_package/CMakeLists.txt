include(GoogleTest)
include(CTestCoverageCollectGCOV)
include(CTest)
# Setup conan targets

include(${CMAKE_CURRENT_BINARY_DIR}/conanbuildinfo.cmake)
conan_basic_setup(TARGETS)

add_executable(test_cov main_test.cpp)
target_compile_options(test_cov PRIVATE "--coverage")
target_link_options(test_cov PRIVATE "--coverage")
target_include_directories(test_cov PRIVATE ${CONAN_INCLUDE_DIRS})
conan_target_link_libraries(test_cov)

set_target_properties(test_cov PROPERTIES ENVIRONMENT GCOV_PREFIX_STRIP=9999)
gtest_discover_tests(test_cov)

add_custom_target(
  cov
  COMMAND ${CMAKE_MAKE_PROGRAM} test_cov
  WORKING_DIRECTORY ${CMAKE_BINARY_DIR})
add_custom_command(
  TARGET cov
  WORKING_DIRECTORY $<TARGET_FILE_DIR:test_cov>
  COMMAND mv ${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/**/*.gcno .
  COMMAND GCOV_PREFIX_STRIP=9999 $<TARGET_FILE:test_cov>
  COMMAND gcov main_test
  COMMAND lcov --capture -d . --output-file main_coverage.info
  COMMAND genhtml main_coverage.info --output-directory out
)

add_dependencies(cov test_cov)

# ctest_coverage_collect_gcov(TARBALL cov_file.tar)

message("Coucou "${CMAKE_CURRENT_BINARY_DIR})
