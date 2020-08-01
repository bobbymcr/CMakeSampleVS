cmake_minimum_required(VERSION 3.17)
project(sample LANGUAGES CXX)

include(GoogleTest)
find_package(GTest)

add_library(sample-core
    src/core/Sample.cpp
)

target_include_directories(sample-core
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/inc/core
)

add_executable(sample-app
    src/app/main.cpp
)

target_link_libraries(sample-app
    sample-core
)

add_executable(sample-test
    test/SampleTest.cpp
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
