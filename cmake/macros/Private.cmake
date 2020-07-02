#
# Private build utilities.
#

# Utility for setting common compilation properties, along with include paths.
function(
    _set_compile_properties
    TARGET_NAME
)
    set(options)
    set(oneValueArgs)
    set(multiValueArgs
        INCLUDE_PATHS
        DEFINES
    )

    cmake_parse_arguments(
        args
        "${options}"
        "${oneValueArgs}"
        "${multiValueArgs}"
        ${ARGN}
    )

    target_compile_options(${TARGET_NAME}
        PRIVATE -g      # Include debug symbols.
                -O3     # Highest degree of code optimisation.
                -Wall   # Enable _all_ warnings.
                -Werror # Error on compilation for warnings.
    )

    target_compile_definitions(${TARGET_NAME}
        PRIVATE
            ${args_DEFINES}
    )

    target_compile_features(${TARGET_NAME}
        PRIVATE cxx_std_17
    )

    # Set-up include paths.
    target_include_directories(${TARGET_NAME}
        PUBLIC
            $<INSTALL_INTERFACE:include>
        PRIVATE
            $<BUILD_INTERFACE:${CMAKE_BINARY_DIR}/include>
            ${args_INCLUDE_PATHS}
    )

endfunction() # _set_compile_properties

function(
    _set_link_properties
    TARGET_NAME
)
    if (CMAKE_CXX_COMPILER_ID MATCHES "Clang")
        target_link_options(
            ${TARGET_NAME}
            PRIVATE
                -Wl,-undefined,error # Link error if there are undefined symbol(s) in output object.
        )
    else()
        target_link_options(
            ${TARGET_NAME}
            PRIVATE
                -Wl,--no-undefined # Link error if there are undefined symbol(s) in output object.
        )
    endif()
endfunction() # _set_link_properties

# Utility function for deploying public headers.
function(
    _install_public_headers
    LIBRARY_NAME
)
    set(options)
    set(oneValueArgs)
    set(multiValueArgs
        PUBLIC_HEADERS
    )

    cmake_parse_arguments(
        args
        "${options}"
        "${oneValueArgs}"
        "${multiValueArgs}"
        ${ARGN}
    )

    file(
        COPY ${args_PUBLIC_HEADERS}
        DESTINATION ${CMAKE_BINARY_DIR}/include/${LIBRARY_NAME}
    )

    install(
        FILES ${args_PUBLIC_HEADERS}
        DESTINATION ${CMAKE_INSTALL_PREFIX}/include/${LIBRARY_NAME}
    )
endfunction() # _install_public_headers

# Internal function for a cpp program.
# This is so cpp_program and cpp_test program can install
# to different locations.
function(
    _cpp_program
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

    # Add a new executable target.
    add_executable(${PROGRAM_NAME}
        ${args_CPPFILES}
    )

    _set_compile_properties(${PROGRAM_NAME}
        INCLUDE_PATHS
            ${args_INCLUDE_PATHS}
        DEFINES
            ${args_DEFINES}
    )

    _set_link_properties(${PROGRAM_NAME})

    target_link_libraries(${PROGRAM_NAME}
        PRIVATE
            ${args_LIBRARIES}
    )
endfunction()
