cmake_minimum_required(VERSION 3.14)

set(PROJECT_NAME COVCMAKE)

project(${PROJECT_NAME})

# Let CMake paths to easily find our custom CMake modules
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/modules)
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/sanitizers)
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/static-analysis)

include(cmake/macros.cmake)
include(cmake/compiler-config.cmake)
include(cmake/ccache.cmake)
include(cmake/openmp.cmake)
include(cmake/conan_auto_install.cmake)

default_build_type("RelWithDebInfo")
common_output_dirs()

# Conan package manager List of packages used by the project is container in
# conanfile.py
option(CONAN_AUTO_INSTALL "Let CMake call conan install automatically" ON)
option(CONAN_BUILD_MISSING
       "Have conan compile packages that have recipes, but no matching build"
       ON)
if(CONAN_AUTO_INSTALL)
  set(CONAN_PROFILE "default"
      CACHE STRING "Conan profile to use during installation")
  conan_auto_install(${CONAN_PROFILE})
endif()

# Use GNU standard installation directories
include(GNUInstallDirs)
# set the path to libs and binaries to $ORIGIN/../lib during installation
set(CMAKE_INSTALL_RPATH "$ORIGIN/../lib")

# Setup conan targets
if(EXISTS ${CMAKE_CURRENT_BINARY_DIR}/conanbuildinfo.cmake)
  include(${CMAKE_CURRENT_BINARY_DIR}/conanbuildinfo.cmake)
  conan_basic_setup(TARGETS)
else()
  message(
    FATAL_ERROR
      "
        Missing conanbuildinfo.cmake file in your build folder \"${CMAKE_CURRENT_BINARY_DIR}\".
        Make sure that CONAN_AUTO_INSTALL is ON to let CMake handle the Conan dependencies automatically
        or, alternatively, manually run \"conan install ${CMAKE_CURRENT_SOURCE_DIR}\"."
    )
endif()

conan_check_overridden_packages()

# Include Address, Memory, Thread, and Undefined Behavior sanitizers support
# Switch on any of the following options when running cmake SANITIZE_ADDRESS,
# SANITIZE_MEMORY, SANITIZE_THREAD, SANITIZE_UNDEFINED
#
# Example: cmake -DSANITIZE_MEMORY=ON will enable memory sanitizer for all
# targets marked for sanitization
find_package(Sanitizers)

# Enable static analysis tools to find bugs and inefficiences in the code.
# Avaliable flags include: USE_CLANG_TIDY - assumes clang-tidy-6.0 is installed
# USE_CPPCHECK   - runs cppcheck on all targets
find_package(StaticAnalysis)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

# Directories to include in the build.
include_directories(${PROJECT_SOURCE_DIR}/src)

# Headers live in include
include_directories(include)

option(BUILD_APP "Build Example App" ON)
option(BUILD_DOCS "Build Doxygen documentation by providing 'make doc'." ON)

if(BUILD_DOCS)
  include(doxygen)
  enable_doxygen()
endif()

message(STATUS "\n\n========= Build Options ===========")
message(STATUS "Build Type: ${CMAKE_BUILD_TYPE}")
build_optional(BUILD_APP src)
message(STATUS "\n\n-----------------------------------")
