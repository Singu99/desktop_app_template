include(cmake/CPM.cmake)

# Done as a function so that updates to variables like
# CMAKE_CXX_FLAGS don't propagate out to other
# targets
function(dektop_app_setup_dependencies)

    # For each dependency, see if it's
    # already been provided to us by a parent project

    if(NOT TARGET fmtlib::fmtlib)
        CPMAddPackage(
            NAME fmt
            GIT_TAG 10.1.0 # specify the tag without v prefix
            GITHUB_REPOSITORY "fmtlib/fmt"
            OPTIONS
                "FMT_DOC OFF"
                "FMT_TEST OFF"
                "FMT_INSTALL OFF"
                "FMT_HEADER_ONLY ON" # enable header-only mode
                "FMT_CMAKE_DIR ${fmt_SOURCE_DIR}" # point to fmt's CMake directory
        )
    endif()

    if(NOT TARGET spdlog::spdlog)
    CPMAddPackage(
        NAME
        spdlog
        VERSION
        1.12.0
        GITHUB_REPOSITORY
        "gabime/spdlog"
        OPTIONS
        "SPDLOG_FMT_EXTERNAL ON")
    endif()

    if(NOT TARGET nlohmann_json::nlohmann_json)
        CPMAddPackage("gh:nlohmann/json@3.10.5")
    endif()

    if(NOT TARGET glm::glm)
        CPMAddPackage(
            NAME glm
            VERSION 0.9.9.8
            GIT_REPOSITORY https://github.com/g-truc/glm.git
            GIT_TAG 0.9.9.8
        )
    endif()

    if (NOT TARGET catchorg::catch2)
        CPMAddPackage(
            NAME catch2
            GITHUB_REPOSITORY catchorg/Catch2
            GIT_TAG v3.4.0
            OPTIONS
                "CATCH_BUILD_TESTING OFF"
                "CATCH_INSTALL_DOCS OFF"
                "CATCH_INSTALL_HELPERS OFF"
                "CATCH_INSTALL_CONFIGS OFF"
        )
    endif()

    # CPM add glfw and glad
    if (NOT TARGET glfw)
        CPMAddPackage(
            NAME glfw
            GITHUB_REPOSITORY glfw/glfw
            GIT_TAG 3.3.2
            OPTIONS
                "GLFW_BUILD_DOCS OFF"
                "GLFW_BUILD_TESTS OFF"
                "GLFW_BUILD_EXAMPLES OFF"
        )
    endif()

    # Git submodules
    set(GIT_SUBMODULES_DIR ${CMAKE_CURRENT_SOURCE_DIR}/dependencies)
    add_subdirectory(${GIT_SUBMODULES_DIR}/imgui ${CMAKE_CURRENT_BINARY_DIR}/imgui)

    # Dependencies source code
    add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/dependencies/glad ${CMAKE_CURRENT_BINARY_DIR}/glad)


endfunction()