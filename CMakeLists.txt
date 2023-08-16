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

dektop_app_setup_options()

dektop_app_global_options()

include(cmake/Dependencies.cmake)

dektop_app_setup_dependencies()

dektop_app_local_options()

# set(DEPENDENCIES_DIR ${CMAKE_CURRENT_SOURCE_DIR}/dependencies)

# All files inside dependencies folder
# file(GLOB_RECURSE LIB_SOURCES ${DEPENDENCIES_DIR}/glad/src/*.c)

# Application sources
# file(GLOB APP_SOURCES CONFIGURE_DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp)

# Add Executable
# add_executable(HelloWorld ${APP_SOURCES} ${LIB_SOURCES})

add_subdirectory(src)

#################### CPM ####################

# add dependencies
include(cmake/CPM.cmake)



#################### Dependencies ####################
# add_subdirectory(${DEPENDENCIES_DIR}/imgui)

# specify the include directories for your app and its dependencies
# target_include_directories(HelloWorld PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/include)
# target_include_directories(HelloWorld SYSTEM PRIVATE ${fmt_SOURCE_DIR}/include)
# target_include_directories(HelloWorld SYSTEM PRIVATE ${nlohmann_json_SOURCE_DIR}/include)
# target_include_directories(HelloWorld SYSTEM PRIVATE ${Catch2_SOURCE_DIR}/include)
# target_include_directories(HelloWorld SYSTEM PRIVATE ${glfw_SOURCE_DIR}/include)
# target_include_directories(HelloWorld SYSTEM PRIVATE ${DEPENDENCIES_DIR}/glad/include)
# 
# # link dependencies
# target_include_directories(imgui PRIVATE ${glfw_SOURCE_DIR}/include)
# 
# # main app
# target_link_libraries(HelloWorld fmt::fmt nlohmann_json::nlohmann_json Catch2::Catch2WithMain glfw imgui)