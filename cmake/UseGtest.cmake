# Find gtest or otherwise fetch it into the build_dir/gtest
    if (DEFINED GTEST_ROOT)
        message(STATUS "gtest source specified at ${GTEST_ROOT}")
        find_path(GTEST_ROOT NAMES "include/gtest/gtest.h" HINTS ${GTEST_ROOT})
        if (NOT IS_DIRECTORY ${GTEST_ROOT})
            message(WARNING "Provided wrong GTEST_ROOT. Please unset GTEST_ROOT - gtest will be fetched")
            unset(GTEST_ROOT CACHE)
        endif()
    endif()

    if (NOT DEFINED GTEST_ROOT)
        find_path(GTEST_ROOT1 NAMES "include/gtest/gtest.h" HINTS ${CMAKE_SOURCE_DIR}/gtest-1.6.0  ${CMAKE_SOURCE_DIR}/gtest-1.7.0  ${CMAKE_SOURCE_DIR}/gtest   ${CMAKE_BINARY_DIR}/gtest)
        if (IS_DIRECTORY ${GTEST_ROOT1})
            set (GTEST_ROOT ${GTEST_ROOT1})
        else()
            message(STATUS "Trying to fetch gtest via subversion")
            find_package(Subversion)
            execute_process(COMMAND "${Subversion_SVN_EXECUTABLE}" "checkout" "https://github.com/google/googletest/tags/release-1.7.0" "gtest" WORKING_DIRECTORY ${CMAKE_BINARY_DIR})
            set (GTEST_ROOT "${CMAKE_BINARY_DIR}/gtest")
        endif()
        set (GTEST_ROOT1)
        mark_as_advanced(GTEST_ROOT1)
    endif()

message(STATUS "gtest is in ${GTEST_ROOT}")
if (NOT TARGET ${GTEST_ROOT})
    add_subdirectory(${GTEST_ROOT} ${PROJECT_BINARY_DIR}/gtest)
endif()

set (GTEST_INCLUDE_DIR ${GTEST_ROOT}/include)
set (GTEST_MAIN_LIBRARIES gtest_main)
set (GTEST_MAIN_LIBRARY gtest_main)
set (GTEST_LIBRARY gtest_main)

#mark_as_advanced(GTEST_ROOT)
#mark_as_advanced(gtest_INCLUDE_DIR)
