include(../cmake/CPM.cmake)

set(CMAKE_BUILD_WITH_INSTALL_RPATH ON)

file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS "*.cpp" "*.hpp" "*.h")

add_executable(dektop_app ${SOURCES})

# TODO: Look into this
#target_link_libraries(
# intro
# PRIVATE best_practices_test::best_practices_test_options
#         best_practices_test::best_practices_test_warnings)

target_link_system_libraries(
        dektop_app
        PRIVATE
        nlohmann_json::nlohmann_json
        spdlog::spdlog
        glm
        glfw
        glad
        imgui
        Catch2
        fmt::fmt)

target_include_directories(glfw PRIVATE ${glfw_SOURCE_DIR}/include)

# target_include_directories(dektop_app PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
