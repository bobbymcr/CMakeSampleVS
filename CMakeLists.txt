cmake_minimum_required(VERSION 3.17)
project(sample LANGUAGES CXX)

include(GenerateExportHeader)
include(GoogleTest)
find_package(GTest)

add_library(sample-core STATIC
    src/core/Sample.cpp
)

set_property(TARGET sample-core
    PROPERTY POSITION_INDEPENDENT_CODE ON
)

target_include_directories(sample-core
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/inc/core
)

add_library(sample-lib SHARED
    src/lib/SampleLib.cpp
)

generate_export_header(sample-lib
    BASE_NAME samplelib
    EXPORT_MACRO_NAME SAMPLE_LIB_EXPORT)

target_include_directories(sample-lib
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/inc/lib
        ${CMAKE_CURRENT_BINARY_DIR}
)

target_link_libraries(sample-lib
    sample-core
)

add_executable(sample-app
    src/app/main.cpp
)

target_link_libraries(sample-app
    sample-lib
)

add_executable(sample-test
    test/core/SampleTest.cpp
)

target_link_libraries(sample-test
    sample-core
    GTest::GTest
    GTest::Main
)

enable_testing()

gtest_discover_tests(sample-test)

add_test(sample-app-UsageError
    sample-app
)

set_tests_properties(sample-app-UsageError PROPERTIES
    PASS_REGULAR_EXPRESSION "Please pass a string!"
)

add_test(sample-app-HelloWorld
    sample-app world
)

set_tests_properties(sample-app-HelloWorld PROPERTIES
    PASS_REGULAR_EXPRESSION "Hello, world!"
)
