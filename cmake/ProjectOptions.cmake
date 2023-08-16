include(cmake/SystemLink.cmake)
include(cmake/LibFuzzer.cmake)
include(CMakeDependentOption)
include(CheckCXXCompilerFlag)


macro(dektop_app_supports_sanitizers)
  if((CMAKE_CXX_COMPILER_ID MATCHES ".*Clang.*" OR CMAKE_CXX_COMPILER_ID MATCHES ".*GNU.*") AND NOT WIN32)
    set(SUPPORTS_UBSAN ON)
  else()
    set(SUPPORTS_UBSAN OFF)
  endif()

  if((CMAKE_CXX_COMPILER_ID MATCHES ".*Clang.*" OR CMAKE_CXX_COMPILER_ID MATCHES ".*GNU.*") AND WIN32)
    set(SUPPORTS_ASAN OFF)
  else()
    set(SUPPORTS_ASAN ON)
  endif()
endmacro()

macro(dektop_app_setup_options)
  option(dektop_app_ENABLE_HARDENING "Enable hardening" ON)
  option(dektop_app_ENABLE_COVERAGE "Enable coverage reporting" OFF)
  cmake_dependent_option(
    dektop_app_ENABLE_GLOBAL_HARDENING
    "Attempt to push hardening options to built dependencies"
    ON
    dektop_app_ENABLE_HARDENING
    OFF)

  dektop_app_supports_sanitizers()

  if(NOT PROJECT_IS_TOP_LEVEL OR dektop_app_PACKAGING_MAINTAINER_MODE)
    option(dektop_app_ENABLE_IPO "Enable IPO/LTO" OFF)
    option(dektop_app_WARNINGS_AS_ERRORS "Treat Warnings As Errors" OFF)
    option(dektop_app_ENABLE_USER_LINKER "Enable user-selected linker" OFF)
    option(dektop_app_ENABLE_SANITIZER_ADDRESS "Enable address sanitizer" OFF)
    option(dektop_app_ENABLE_SANITIZER_LEAK "Enable leak sanitizer" OFF)
    option(dektop_app_ENABLE_SANITIZER_UNDEFINED "Enable undefined sanitizer" OFF)
    option(dektop_app_ENABLE_SANITIZER_THREAD "Enable thread sanitizer" OFF)
    option(dektop_app_ENABLE_SANITIZER_MEMORY "Enable memory sanitizer" OFF)
    option(dektop_app_ENABLE_UNITY_BUILD "Enable unity builds" OFF)
    option(dektop_app_ENABLE_CLANG_TIDY "Enable clang-tidy" OFF)
    option(dektop_app_ENABLE_CPPCHECK "Enable cpp-check analysis" OFF)
    option(dektop_app_ENABLE_PCH "Enable precompiled headers" OFF)
    option(dektop_app_ENABLE_CACHE "Enable ccache" OFF)
  else()
    option(dektop_app_ENABLE_IPO "Enable IPO/LTO" ON)
    option(dektop_app_WARNINGS_AS_ERRORS "Treat Warnings As Errors" ON)
    option(dektop_app_ENABLE_USER_LINKER "Enable user-selected linker" OFF)
    option(dektop_app_ENABLE_SANITIZER_ADDRESS "Enable address sanitizer" ${SUPPORTS_ASAN})
    option(dektop_app_ENABLE_SANITIZER_LEAK "Enable leak sanitizer" OFF)
    option(dektop_app_ENABLE_SANITIZER_UNDEFINED "Enable undefined sanitizer" ${SUPPORTS_UBSAN})
    option(dektop_app_ENABLE_SANITIZER_THREAD "Enable thread sanitizer" OFF)
    option(dektop_app_ENABLE_SANITIZER_MEMORY "Enable memory sanitizer" OFF)
    option(dektop_app_ENABLE_UNITY_BUILD "Enable unity builds" OFF)
    option(dektop_app_ENABLE_CLANG_TIDY "Enable clang-tidy" ON)
    option(dektop_app_ENABLE_CPPCHECK "Enable cpp-check analysis" ON)
    option(dektop_app_ENABLE_PCH "Enable precompiled headers" OFF)
    option(dektop_app_ENABLE_CACHE "Enable ccache" ON)
  endif()

  if(NOT PROJECT_IS_TOP_LEVEL)
    mark_as_advanced(
      dektop_app_ENABLE_IPO
      dektop_app_WARNINGS_AS_ERRORS
      dektop_app_ENABLE_USER_LINKER
      dektop_app_ENABLE_SANITIZER_ADDRESS
      dektop_app_ENABLE_SANITIZER_LEAK
      dektop_app_ENABLE_SANITIZER_UNDEFINED
      dektop_app_ENABLE_SANITIZER_THREAD
      dektop_app_ENABLE_SANITIZER_MEMORY
      dektop_app_ENABLE_UNITY_BUILD
      dektop_app_ENABLE_CLANG_TIDY
      dektop_app_ENABLE_CPPCHECK
      dektop_app_ENABLE_COVERAGE
      dektop_app_ENABLE_PCH
      dektop_app_ENABLE_CACHE)
  endif()

  dektop_app_check_libfuzzer_support(LIBFUZZER_SUPPORTED)
  if(LIBFUZZER_SUPPORTED AND (dektop_app_ENABLE_SANITIZER_ADDRESS OR dektop_app_ENABLE_SANITIZER_THREAD OR dektop_app_ENABLE_SANITIZER_UNDEFINED))
    set(DEFAULT_FUZZER ON)
  else()
    set(DEFAULT_FUZZER OFF)
  endif()

  option(dektop_app_BUILD_FUZZ_TESTS "Enable fuzz testing executable" ${DEFAULT_FUZZER})

endmacro()

macro(dektop_app_global_options)
  if(dektop_app_ENABLE_IPO)
    include(cmake/InterproceduralOptimization.cmake)
    dektop_app_enable_ipo()
  endif()

  dektop_app_supports_sanitizers()

  if(dektop_app_ENABLE_HARDENING AND dektop_app_ENABLE_GLOBAL_HARDENING)
    include(cmake/Hardening.cmake)
    if(NOT SUPPORTS_UBSAN 
       OR dektop_app_ENABLE_SANITIZER_UNDEFINED
       OR dektop_app_ENABLE_SANITIZER_ADDRESS
       OR dektop_app_ENABLE_SANITIZER_THREAD
       OR dektop_app_ENABLE_SANITIZER_LEAK)
      set(ENABLE_UBSAN_MINIMAL_RUNTIME FALSE)
    else()
      set(ENABLE_UBSAN_MINIMAL_RUNTIME TRUE)
    endif()
    message("${dektop_app_ENABLE_HARDENING} ${ENABLE_UBSAN_MINIMAL_RUNTIME} ${dektop_app_ENABLE_SANITIZER_UNDEFINED}")
    dektop_app_enable_hardening(dektop_app_options ON ${ENABLE_UBSAN_MINIMAL_RUNTIME})
  endif()
endmacro()

macro(dektop_app_local_options)
  if(PROJECT_IS_TOP_LEVEL)
    include(cmake/StandardProjectSettings.cmake)
  endif()

  add_library(dektop_app_warnings INTERFACE)
  add_library(dektop_app_options INTERFACE)

  include(cmake/CompilerWarnings.cmake)
  dektop_app_set_project_warnings(
    dektop_app_warnings
    ${dektop_app_WARNINGS_AS_ERRORS}
    ""
    ""
    ""
    "")

  if(dektop_app_ENABLE_USER_LINKER)
    include(cmake/Linker.cmake)
    configure_linker(dektop_app_options)
  endif()

  include(cmake/Sanitizers.cmake)
  dektop_app_enable_sanitizers(
    dektop_app_options
    ${dektop_app_ENABLE_SANITIZER_ADDRESS}
    ${dektop_app_ENABLE_SANITIZER_LEAK}
    ${dektop_app_ENABLE_SANITIZER_UNDEFINED}
    ${dektop_app_ENABLE_SANITIZER_THREAD}
    ${dektop_app_ENABLE_SANITIZER_MEMORY})

  set_target_properties(dektop_app_options PROPERTIES UNITY_BUILD ${dektop_app_ENABLE_UNITY_BUILD})

  if(dektop_app_ENABLE_PCH)
    target_precompile_headers(
      dektop_app_options
      INTERFACE
      <vector>
      <string>
      <utility>)
  endif()

  if(dektop_app_ENABLE_CACHE)
    include(cmake/Cache.cmake)
    dektop_app_enable_cache()
  endif()

  include(cmake/StaticAnalyzers.cmake)
  if(dektop_app_ENABLE_CLANG_TIDY)
    dektop_app_enable_clang_tidy(dektop_app_options ${dektop_app_WARNINGS_AS_ERRORS})
  endif()

  if(dektop_app_ENABLE_CPPCHECK)
    dektop_app_enable_cppcheck(${dektop_app_WARNINGS_AS_ERRORS} "" # override cppcheck options
    )
  endif()

  if(dektop_app_ENABLE_COVERAGE)
    include(cmake/Tests.cmake)
    dektop_app_enable_coverage(dektop_app_options)
  endif()

  if(dektop_app_WARNINGS_AS_ERRORS)
    check_cxx_compiler_flag("-Wl,--fatal-warnings" LINKER_FATAL_WARNINGS)
    if(LINKER_FATAL_WARNINGS)
      # This is not working consistently, so disabling for now
      # target_link_options(dektop_app_options INTERFACE -Wl,--fatal-warnings)
    endif()
  endif()

  if(dektop_app_ENABLE_HARDENING AND NOT dektop_app_ENABLE_GLOBAL_HARDENING)
    include(cmake/Hardening.cmake)
    if(NOT SUPPORTS_UBSAN 
       OR dektop_app_ENABLE_SANITIZER_UNDEFINED
       OR dektop_app_ENABLE_SANITIZER_ADDRESS
       OR dektop_app_ENABLE_SANITIZER_THREAD
       OR dektop_app_ENABLE_SANITIZER_LEAK)
      set(ENABLE_UBSAN_MINIMAL_RUNTIME FALSE)
    else()
      set(ENABLE_UBSAN_MINIMAL_RUNTIME TRUE)
    endif()
    dektop_app_enable_hardening(dektop_app_options OFF ${ENABLE_UBSAN_MINIMAL_RUNTIME})
  endif()

endmacro()
