set(CMAKE_CXX_STANDARD 14)
# Use "-fPIC" / "-fPIE" for all targets by default, including static libs
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
# CMake doesn't add "-pie" by default for executables
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -pie")
set_property(GLOBAL PROPERTY GLOBAL_DEPENDS_NO_CYCLES 1)
set(CMAKE_CXX_FLAGS "-Woverloaded-virtual -fprofile-arcs -ftest-coverage")

# Reference: https://github.com/lefticus/cppbestpractices/blob/master/02-Use_the
# _Tools_Available.md#gcc--clang GCC all versions, Clang all versions
add_compile_options(-Wall
                    -Wextra
                    -Wshadow
                    -Wformat-security # security warnings
                    -Wcast-align
                    -Wunused
                    -Wconversion
                    -Werror
                    -Wl,-z,noexecstack # security, use non-executable stacks
                    -Wl,-z,relro,-z,now # security, read-only ELF table
                    -fstack-protector-strong) # This transformation adds stack
                                              # canaries to comply with security
                                              # requirement WI-321

# GCC all versions, Clang >= 3.2
if((CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
   OR ((CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
       AND (CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL 3.2)))
  add_compile_options(-pedantic -Wpedantic)
endif()

# GCC >= 4.3, Clang all versions
if((CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
   OR ((CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
       AND (CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL 4.3)))
  add_compile_options(-Wsign-conversion)
endif()

# GCC >= 4.6, Clang >= 3.8
if(((CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    AND (CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL 4.6))
   OR ((CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
       AND (CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL 3.8)))
  add_compile_options(-Wdouble-promotion)
endif()

# Add fortify source if we have specified to enable it. This is an option so we
# can check it against sanitizers which it conflicts with. Supported in both gcc
# and clang.
option(COMPILER_FORTIFY_SOURCE "Enable the fortify source option" OFF)
if(COMPILER_FORTIFY_SOURCE)
  add_compile_options(-D_FORTIFY_SOURCE=2)
endif()
