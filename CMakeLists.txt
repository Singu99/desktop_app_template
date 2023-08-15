# Default Cmake 
cmake_minimum_required(VERSION 3.0.0)

# Project Name
project(HelloWorld VERSION 0.1.0)

# C++ 20
set(CMAKE_CXX_STANDARD 20)

set(DEPENDENCIES_DIR ${CMAKE_CURRENT_SOURCE_DIR}/dependencies)

# All files inside dependencies folder
file(GLOB_RECURSE LIB_SOURCES ${DEPENDENCIES_DIR}/glad/src/*.c)

# Add Executable
add_executable(HelloWorld main.cpp ${LIB_SOURCES})

#################### CPM ####################

# add dependencies
include(cmake/CPM.cmake)

CPMAddPackage("gh:fmtlib/fmt#7.1.3")
CPMAddPackage("gh:nlohmann/json@3.10.5")
CPMAddPackage("gh:catchorg/Catch2@3.2.1")

# CPM add glfw and glad
CPMAddPackage(
    NAME glfw
    GITHUB_REPOSITORY glfw/glfw
    GIT_TAG 3.3.2
    OPTIONS
        "GLFW_BUILD_DOCS OFF"
        "GLFW_BUILD_TESTS OFF"
        "GLFW_BUILD_EXAMPLES OFF"
)

#################### Dependencies ####################
add_subdirectory(${DEPENDENCIES_DIR}/imgui)


# specify the include directories for your app and its dependencies
target_include_directories(HelloWorld PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/include)
target_include_directories(HelloWorld SYSTEM PRIVATE ${fmt_SOURCE_DIR}/include)
target_include_directories(HelloWorld SYSTEM PRIVATE ${nlohmann_json_SOURCE_DIR}/include)
target_include_directories(HelloWorld SYSTEM PRIVATE ${Catch2_SOURCE_DIR}/include)
target_include_directories(HelloWorld SYSTEM PRIVATE ${glfw_SOURCE_DIR}/include)
target_include_directories(HelloWorld SYSTEM PRIVATE ${DEPENDENCIES_DIR}/glad/include)

# link dependencies
target_include_directories(imgui PRIVATE ${glfw_SOURCE_DIR}/include)

# main app
target_link_libraries(HelloWorld fmt::fmt nlohmann_json::nlohmann_json Catch2::Catch2WithMain glfw imgui)