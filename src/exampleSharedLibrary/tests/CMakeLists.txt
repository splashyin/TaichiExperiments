file(GLOB CPPFILES *.cpp)
foreach(CPPFILE ${CPPFILES})
    get_filename_component(TEST_PROGRAM ${CPPFILE} NAME_WE)
    cpp_test_program(
        ${LIBRARY_NAME}_${TEST_PROGRAM}
        CPPFILES
            ${CPPFILE}
        LIBRARIES
            ${LIBRARY_NAME}
    )
endforeach(CPPFILE)
