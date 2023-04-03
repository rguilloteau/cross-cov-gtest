cmake_minimum_required(VERSION 3.14)

set(PROJECT_NAME COVCMAKE)

project(${PROJECT_NAME})


add_compile_options("--coverage")
add_link_options("--coverage")

# Setup conan targets
include(${CMAKE_CURRENT_BINARY_DIR}/conanbuildinfo.cmake)
conan_basic_setup(TARGETS)

# Directories to include in the build.
include_directories(${PROJECT_SOURCE_DIR}/src)

# Headers live in include
include_directories(include)

message(STATUS "\n\n========= Build Options ===========")
message(STATUS "Build Type: ${CMAKE_BUILD_TYPE}")
add_subdirectory(src)
message(STATUS "\n\n-----------------------------------")
