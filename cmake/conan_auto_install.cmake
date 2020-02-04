# Call `conan install` only if conanbuildinfo.cmake doesn't exist or it's older
# than Conan file This avoids reinstalling the conan packages every single time
# CMake reconfigures
#
# To avoid unnecessarily copying binaries and libraries from the Conan packges
# `imports` rules when the project is being built, the flag --no-imports is
# used. Additionally, a custom install rule is added so when the project is
# installed, then the Conan `imports` rule is explicitly executed and the files
# are copied to the actual CMake installation folder.

function(conan_auto_install profile)
  set(CONAN_FILE ${CMAKE_CURRENT_SOURCE_DIR}/conanfile.py)
  foreach(option ${ARGN})
    set(CONAN_OPTIONS "${CONAN_OPTIONS} -o ${option}")
  endforeach()

  set(CONAN_OPTIONS_HAVE_CHANGED FALSE)

  if(EXISTS ".conan_options")
    file(READ "${CMAKE_CURRENT_BINARY_DIR}/.conan_options" FILE_CONAN_OPTIONS)
    string(COMPARE NOTEQUAL
                   "${FILE_CONAN_OPTIONS}"
                   "${CONAN_OPTIONS}"
                   CONAN_OPTIONS_HAVE_CHANGED)
  endif()

  # Use the CONAN_BUILD_MISSING to auto compile packages that have recipes, but
  # no existing builds for the current compiler/os/architecture options For
  # default testing, merge ready code should have prebuilt packages
  if(CONAN_BUILD_MISSING)
    set(CONAN_OPTIONS "${CONAN_OPTIONS} --build missing")
  endif()

  if(CONAN_OPTIONS_HAVE_CHANGED
     OR NOT EXISTS "conanbuildinfo.cmake"
     OR ${CONAN_FILE} IS_NEWER_THAN "conanbuildinfo.cmake")
    message(STATUS "Installing Conan dependencies with profile ${profile}")
    execute_process(
      COMMAND
        script -e -q -f -c
        "conan install ${CMAKE_CURRENT_SOURCE_DIR} --no-imports --profile ${profile} ${CONAN_OPTIONS}"
      RESULT_VARIABLE CONAN_INSTALL_ERROR)
    file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/.conan_options" ${CONAN_OPTIONS})
  endif()

  if(CONAN_INSTALL_ERROR)
    message(FATAL_ERROR "Conan installation failed.")
  endif()

  # This causes CMake to reconfiure when Conan file changes, and it lets IDEs
  # index the file as well
  set_property(DIRECTORY APPEND PROPERTY CMAKE_CONFIGURE_DEPENDS ${CONAN_FILE})

  # Execute the imports() rules defined in the conanfile.txt, but install to the
  # project specific install folder
  if(COPY_CONAN_ARTIFACTS_TO_INSTALL_FOLDER)
    install(
      CODE
      "execute_process(COMMAND conan imports ${CMAKE_CURRENT_SOURCE_DIR} --import-folder ${CMAKE_INSTALL_PREFIX})"
      )
  endif()
endfunction()

function(conan_option_from_boolean option boolean)
  if(${boolean})
    set(${option} "True" PARENT_SCOPE)
  else()
    set(${option} "False" PARENT_SCOPE)
  endif()
endfunction()

function(conan_check_overridden_packages)
  execute_process(COMMAND conan info --only None ${CMAKE_CURRENT_SOURCE_DIR}
                  COMMAND grep overridden
                  RESULT_VARIABLE CONAN_OVERRIDEN_OK
                  OUTPUT_VARIABLE CONAN_OVERRIDEN_PACKGES)

  if(NOT ${CONAN_OVERRIDEN_OK})
    string(ASCII 27 Esc)
    message(
      WARNING
        "\n${CONAN_OVERRIDEN_PACKAGES}"
        "${Esc}[33mPlease, check that the package overriding was intended. ${Esc}[m\n"
      )
  endif()
endfunction()
