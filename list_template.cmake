cmake_minimum_required (VERSION 3.1)
set(CMAKE_CXX_STANDARD 11)

# add options for testing
option(CODE_COVERAGE "Enable code coverage testing." OFF)
option(MEMORY_CHECK "Enable testing for memory leaks." OFF)

# define project name
project (@PROJECT_NAME@ VERSION @PROJECT_VERSION@)

# set path to custom modules
list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)

# create the package config install
include(CreatePackage)
create_package("@PROJECT_DESCRIPTION@")

# create config header
include(CreateConfigHeader)
create_config_header()

# add directories
add_subdirectory(src)
add_subdirectory(tests)

# Setup testing
enable_testing()

if (MEMORY_CHECK)
	include(MemCheckTest)
	add_memcheck_test(${PROJECT_NAME}-test ${PROJECT_BINARY_DIR}/tests/${PROJECT_NAME}_test)
else ()
	add_test(${PROJECT_NAME}-test ${PROJECT_BINARY_DIR}/tests/${PROJECT_NAME}_test)
endif()

# add target for code coverage
if(CODE_COVERAGE)
	include(CodeCoverage)
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CMAKE_CXX_FLAGS_COVERAGE}")
	setup_target_for_coverage(${PROJECT_NAME}-coverage ${PROJECT_BINARY_DIR}/tests/${PROJECT_NAME}_test ${PROJECT_SOURCE_DIR}/coverage)
endif()

