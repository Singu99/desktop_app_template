# Default Cmake 
cmake_minimum_required(VERSION 3.0.0)

# Only set the cxx_standard if it is not set by someone else
if (NOT DEFINED CMAKE_CXX_STANDARD)
set(CMAKE_CXX_STANDARD 20)
endif()

# strongly encouraged to enable this globally to avoid conflicts between
# -Wpedantic being enabled and -std=c++20 and -std=gnu++20 for example
# when compiling with PCH enabled
set(CMAKE_CXX_EXTENSIONS OFF)

# Project Name
project(HelloWorld VERSION 0.1.0)

include(cmake/PreventInSourceBuilds.cmake)
include(cmake/ProjectOptions.cmake)

# add dependencies
include(cmake/CPM.cmake)

dektop_app_setup_options()

dektop_app_global_options()

include(cmake/Dependencies.cmake)

dektop_app_setup_dependencies()

dektop_app_local_options()

add_subdirectory(src)

#################### Tests ####################

# Don't even look at tests if we're not top level
if(NOT PROJECT_IS_TOP_LEVEL)
  return()
endif()

# Adding the tests:
include(CTest)

if(BUILD_TESTING)
  add_subdirectory(tests)
endif()