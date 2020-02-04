function(enable_doxygen)
  find_package(Doxygen REQUIRED)
  if(DOXYGEN_FOUND)
    get_property(DOXYGEN_COMMAND
                 TARGET Doxygen::doxygen
                 PROPERTY IMPORTED_LOCATION)
    message(STATUS "Doxygen: found ${DOXYGEN_COMMAND}")

    # cmake-format: off
        set(DOXYGEN_AUTOLINK_SUPPORT      YES)
        set(DOXYGEN_BUILTIN_STL_SUPPORT   YES)
        set(DOXYGEN_CALLER_GRAPH          YES)
        set(DOXYGEN_CALL_GRAPH            YES)
        set(DOXYGEN_CASE_SENSE_NAMES      YES)
        set(DOXYGEN_DOT_GRAPH_MAX_NODES   100)
        set(DOXYGEN_EXTRACT_ALL           YES)
        set(DOXYGEN_EXTRACT_LOCAL_CLASSES YES)
        set(DOXYGEN_EXTRACT_PACKAGE       YES)
        set(DOXYGEN_EXTRACT_PRIVATE       YES)
        set(DOXYGEN_EXTRACT_STATIC        YES)
        set(DOXYGEN_GENERATE_DOCSET        NO)
        set(DOXYGEN_GENERATE_HTML         YES)
        set(DOXYGEN_GENERATE_LATEX         NO)
        set(DOXYGEN_GENERATE_TODOLIST      NO)
        set(DOXYGEN_GENERATE_TREEVIEW     YES)
        set(DOXYGEN_HAVE_DOT              YES)
        set(DOXYGEN_INHERIT_DOCS          YES)
        set(DOXYGEN_INLINE_INHERITED_MEMB YES)
        set(DOXYGEN_JAVADOC_AUTOBRIEF     YES)
        set(DOXYGEN_LOOKUP_CACHE_SIZE       1)
        set(DOXYGEN_MARKDOWN_SUPPORT      YES)
        set(DOXYGEN_QUIET                 YES)
        set(DOXYGEN_RECURSIVE             YES)
        set(DOXYGEN_SHORT_NAMES           YES)
        set(DOXYGEN_SORT_BRIEF_DOCS       YES)
        set(DOXYGEN_SUBGROUPING           YES)
        set(DOXYGEN_VERBATIM_HEADERS       NO)
        # cmake-format: on

    set(DOXYGEN_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/doc")
    set(DOXYGEN_USE_MDFILE_AS_MAINPAGE "./README.md")

    doxygen_add_docs(doc README.md src include)
  else()
    message(FATAL_ERROR "Doxygen: doxygen or graphviz package cannot be found.")
  endif()
endfunction()
