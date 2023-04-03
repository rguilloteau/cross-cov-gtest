# Example of generating code coverage report for cross-compilation project with Conan, CMake, and GTest

# Build
Details can be found at https://channgo2203.github.io/articles/2020-02/cross_cov

```
mkdir build && cd build
conan install ..
conan build ..
mv src/CMakeFiles/greatestof3.dir/greatestof3.cpp.gcno src/CMakeFiles/test.dir/main_test.cpp.gcno bin/
cd bin
GCOV_PREFIX_STRIP=9999 ./test
gcovr -r ../.. --exclude-unreachable-branches --print-summary --html-details coverage.html
```
