# Get the current source directory.
set(CATCH_INCLUDE_DIR
    ${CMAKE_CURRENT_SOURCE_DIR}
)

# Add catch2 as a library target.
add_library(
    catch2
    IMPORTED  # TODO: Figure out what this keyword does, precisely.
    INTERFACE # This library target does not provide source files.  (Header only!)
    GLOBAL    # Make this library target available in directories above this one.
)

# Any target which links against "catch2" will inherit
# CATCH_INCLUDE_DIR as a compilation include directory.
target_include_directories(
    catch2
    INTERFACE ${CATCH_INCLUDE_DIR}
)
