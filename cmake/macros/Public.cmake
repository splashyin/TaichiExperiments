#
# Public-facing convenience functions & macros for building.
#

include(
    Private
)

# Build doxygen documentation utility.
#
# Options:
#   GENERATE_TAGFILE
#       Boolean option to specify if a tagfile should be generated.
#
# Single value arguments:
#   DOXYFILE
#       Doxyfile which will be configured by CMake and used to generate documentation.
#
# Multi-value arguments:
#   INPUTS
#       Input source files to generate documentation for.
#   TAGFILES
#       Tag files for linking to external documentation.
#   DEPENDENCIES
#       Target names which the documentation generation should depend on.
#
# The source DOXYFILE will be configured with visible CMake variables.
# doxygen_documentation will introduce the following variables within the scope of
# the function, based on arguments:
# - DOXYGEN_INPUTS
#       Set from INPUTS argument.
#       Please assign @DOXYGEN_INPUTS@ to the INPUTS property in the DOXYFILE.
# - DOXYGEN_TAGFILES
#       Set from TAGFILES argument.
#       Please assign @DOXYGEN_TAGFILES@ to the TAGFILES property in the DOXYFILE.
# - DOXYGEN_TAGFILE
#       Path to the generated tagfile - if GENERATE_TAGFILE is TRUE.
#       Please assign @DOXYGEN_TAGFILE@ to the GENERATE_TAGFILE property in the DOXYFILE.
# - DOT_EXECUTABLE
#       Path to the dot executable, via find_program.
#       Please assign @DOT_EXECUTABLE@ to DOT_PATH property in the DOXYFILE.
# - DOXYGEN_OUTPUT_DIR
#       Output directory for generated documentation.
#       Please assign @DOXYGEN_OUTPUT_DIR@ to OUTPUT_DIRECTORY property in the DOXYFILE.
function(
    doxygen_documentation
    DOCUMENTATION_NAME
)
    set(options
        GENERATE_TAGFILE
    )
    set(oneValueArgs
        DOXYFILE
    )
    set(multiValueArgs
        INPUTS
        TAGFILES
        DEPENDENCIES
    )

    cmake_parse_arguments(
        args
        "${options}"
        "${oneValueArgs}"
        "${multiValueArgs}"
        ${ARGN}
    )

    # Find doxygen executable
    find_program(DOXYGEN_EXECUTABLE
        NAMES doxygen
    )
    if (EXISTS ${DOXYGEN_EXECUTABLE})
        message(STATUS "Found doxygen: ${DOXYGEN_EXECUTABLE}")
    else()
        message(FATAL_ERROR "doxygen not found.")
    endif()

    # Find dot executable
    find_program(DOT_EXECUTABLE
        NAMES dot
    )
    if (EXISTS ${DOT_EXECUTABLE})
        message(STATUS "Found dot: ${DOT_EXECUTABLE}")
    else()
        message(FATAL_ERROR "dot not found.")
    endif()

    # Configure Doxyfile.
    set(DOXYGEN_INPUT_DOXYFILE ${args_DOXYFILE})
    string(REPLACE ";" " \\\n" DOXYGEN_INPUTS "${args_INPUTS}")
    string(REPLACE ";" " \\\n" DOXYGEN_TAGFILES "${args_TAGFILES}")
    set(DOXYGEN_OUTPUT_DIR ${CMAKE_BINARY_DIR}/docs/${DOCUMENTATION_NAME})
    set(DOXYGEN_OUTPUT_DOXYFILE "${DOXYGEN_OUTPUT_DIR}/Doxyfile")
    set(DOXYGEN_OUTPUT_HTML_INDEX "${DOXYGEN_OUTPUT_DIR}/html/index.html")
    if (${args_GENERATE_TAGFILE})
        set(DOXYGEN_TAGFILE "${DOXYGEN_OUTPUT_DIR}/${DOCUMENTATION_NAME}.tag")
    endif()

    configure_file(
        ${DOXYGEN_INPUT_DOXYFILE}
        ${DOXYGEN_OUTPUT_DOXYFILE}
    )

    # Build documentation.
    add_custom_command(
        COMMAND ${DOXYGEN_EXECUTABLE} ${DOXYGEN_OUTPUT_DOXYFILE}
        OUTPUT ${DOXYGEN_OUTPUT_HTML_INDEX}
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        MAIN_DEPENDENCY ${DOXYGEN_OUTPUT_DOXYFILE} ${DOXYGEN_INPUT_DOXYFILE}
        DEPENDS ${args_DEPENDENCIES}
        COMMENT "Generating doxygen documentation."
    )

    add_custom_target(
        ${DOCUMENTATION_NAME} ALL
        DEPENDS
            ${DOXYGEN_OUTPUT_HTML_INDEX}
    )

    install(
        DIRECTORY ${DOXYGEN_OUTPUT_DIR}
        DESTINATION ${CMAKE_INSTALL_PREFIX}/docs
    )

endfunction()

# List all the sub-directories, under PARENT_DIRECTORY, and store into SUBDIRS.
macro(
    list_subdirectories
    SUBDIRS
    PARENT_DIRECTORY
)
    # Glob all files under current directory.
    file(
        GLOB
        CHILDREN
        RELATIVE ${PARENT_DIRECTORY}
        ${PARENT_DIRECTORY}/*
    )

    set(DIRECTORY_LIST "")

    foreach(CHILD ${CHILDREN})
        if(IS_DIRECTORY ${PARENT_DIRECTORY}/${CHILD})
            list( APPEND DIRECTORY_LIST ${CHILD})
        endif()
    endforeach()

    set(${SUBDIRS} ${DIRECTORY_LIST})
endmacro()

# Builds a new C++ library.
#
# Single value Arguments:
#   TYPE
#       The type of library, STATIC or SHARED.
#
# Multi-value Arguments:
#   CPPFILES
#       C++ source files.
#   PUBLIC_HEADERS
#       Header files, which will be deployed for external usage.
#   INCLUDE_PATHS
#       Include paths for compiling the source files.
#   LIBRARIES
#       Library dependencies used for linking, but also inheriting INTERFACE properties.
#   DEFINES
#       Custom preprocessor defines to set.
#
function(
    cpp_library
    LIBRARY_NAME
)
    set(options)
    set(oneValueArgs
        TYPE
    )
    set(multiValueArgs
        CPPFILES
        PUBLIC_HEADERS
        INCLUDE_PATHS
        LIBRARIES
        DEFINES
    )

    cmake_parse_arguments(
        args
        "${options}"
        "${oneValueArgs}"
        "${multiValueArgs}"
        ${ARGN}
    )

    # Install public headers for build and distribution.
    _install_public_headers(
        ${LIBRARY_NAME}
        PUBLIC_HEADERS
            ${args_PUBLIC_HEADERS}
    )

    # Default to STATIC library if TYPE is not specified.
    if (NOT args_TYPE)
        set(LIBRARY_TYPE "STATIC")
    else()
        set(LIBRARY_TYPE ${args_TYPE})
    endif()

    # Add a new shared library target.
    add_library(
        ${LIBRARY_NAME}
        ${args_TYPE}
        ${args_CPPFILES}
        ${args_PUBLIC_HEADERS}
    )

    # Apply common compiler properties, and include path properties.
    _set_compile_properties(${LIBRARY_NAME}
        INCLUDE_PATHS
            ${args_INCLUDE_PATHS}
        DEFINES
            ${args_DEFINES}
    )

    _set_link_properties(${LIBRARY_NAME})

    # Link to libraries.
    target_link_libraries(
        ${LIBRARY_NAME}
        PRIVATE
            ${args_LIBRARIES}
    )

    # Install the built library.
    install(
        TARGETS ${LIBRARY_NAME}
        EXPORT ${CMAKE_PROJECT_NAME}-targets
        LIBRARY DESTINATION lib
        ARCHIVE DESTINATION lib
    )

endfunction() # cpp_library

# Builds a new C++ executable program.
#
# Multi-value Arguments:
#   CPPFILES
#       C++ source files.
#   INCLUDE_PATHS
#       Include paths for compiling the source files.
#   LIBRARIES
#       Library dependencies used for linking, but also inheriting INTERFACE properties.
#   DEFINES
#       Custom preprocessor defines to set.
function(
    cpp_program
    PROGRAM_NAME
)
    set(options)
    set(oneValueArgs)
    set(multiValueArgs
        CPPFILES
        INCLUDE_PATHS
        LIBRARIES
        DEFINES
    )

    cmake_parse_arguments(
        args
        "${options}"
        "${oneValueArgs}"
        "${multiValueArgs}"
        ${ARGN}
    )

    _cpp_program(${PROGRAM_NAME}
        CPPFILES
            ${args_CPPFILES}
        INCLUDE_PATHS
            ${args_INCLUDE_PATHS}
        LIBRARIES
            ${args_LIBRARIES}
        DEFINES
            ${args_DEFINES}
    )

    # Install built executable.
    install(
        TARGETS ${PROGRAM_NAME}
        DESTINATION ${CMAKE_INSTALL_PREFIX}/bin
    )

endfunction() # cpp_program

# Build C++ test executable program.
# The assumed test framework is Catch2, and will be provided as a library dependency.
#
# Multi-value Arguments:
#   CPPFILES
#       C++ source files.
#   INCLUDE_PATHS
#       Include paths for compiling the source files.
#   LIBRARIES
#       Library dependencies used for linking, but also inheriting INTERFACE properties.
#   DEFINES
#       Custom preprocessor defines to set.
function(
    cpp_test_program
    TEST_NAME
)
    set(options)
    set(oneValueArgs)
    set(multiValueArgs
        CPPFILES
        INCLUDE_PATHS
        LIBRARIES
        DEFINES
    )

    cmake_parse_arguments(
        args
        "${options}"
        "${oneValueArgs}"
        "${multiValueArgs}"
        ${ARGN}
    )

    _cpp_program(${TEST_NAME}
        CPPFILES
            ${args_CPPFILES}
        INCLUDE_PATHS
            ${args_INCLUDE_PATHS}
        LIBRARIES
            catch2
            ${args_LIBRARIES}
        DEFINES
            ${args_DEFINES}
    )

    # Install built executable.
    install(
        TARGETS ${TEST_NAME}
        DESTINATION ${CMAKE_INSTALL_PREFIX}/tests
    )

    # Add TEST_NAME to be executed when running the "test" target.
    add_test(
        NAME ${TEST_NAME}
        COMMAND $<TARGET_FILE:${TEST_NAME}>
    )

endfunction() # cpp_test_program

# Export this project for external usage.
# Targets will be exported, and the supplied Config cmake file will configured & deployed.
#
# Arguments:
#   INPUT_CONFIG
#       Path to a Config.cmake.in which will be configured with CMake variables.
function(
    export_project
    INPUT_CONFIG
)
    # Install exported targets (libraries).
    install(
        EXPORT ${CMAKE_PROJECT_NAME}-targets
        FILE
            ${CMAKE_PROJECT_NAME}Targets.cmake
        DESTINATION
            ${CMAKE_INSTALL_PREFIX}/cmake
    )

    # Configure & install <Project>Config.cmake
    set(OUTPUT_CONFIG ${CMAKE_BINARY_DIR}/${CMAKE_PROJECT_NAME}Config.cmake)
    configure_file(${INPUT_CONFIG} ${OUTPUT_CONFIG} @ONLY)
    install(
        FILES ${OUTPUT_CONFIG}
        DESTINATION ${CMAKE_INSTALL_PREFIX}
    )
endfunction()

# Convenience macro for calling add_subdirectory on all the sub-directories
# in the current source directory.
macro(
    add_subdirectories
)
    list_subdirectories(
        SUBDIRS
        ${CMAKE_CURRENT_SOURCE_DIR}
    )

    foreach(
        subdir
        ${SUBDIRS}
    )
        add_subdirectory(
            ${subdir}
        )
    endforeach()
endmacro()
