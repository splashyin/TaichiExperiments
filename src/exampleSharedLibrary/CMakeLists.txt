set(LIBRARY_NAME exampleSharedLibrary)

cpp_library(${LIBRARY_NAME}
    TYPE
        SHARED
    CPPFILES
        add.cpp
    PUBLIC_HEADERS
        add.h
)

if(BUILD_TESTING)
    add_subdirectory(tests)
endif()
