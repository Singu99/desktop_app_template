# Include a system directory (which suppresses its warnings).
# Example function call: target_include_system_directories(my_target INTERFACE include1 include2 PUBLIC include3 PRIVATE include4)

function(target_include_system_directories target)
  set(multiValueArgs INTERFACE PUBLIC PRIVATE)        

  ##
  # Capturing Extra Arguments: 
  # Any arguments that are not explicitly captured by named or multi-value arguments are automatically collected in the ${ARGN} variable.
  ##

  # Parse the arguments of the function:
  # Here: You're telling CMake to look for arguments named INTERFACE, PUBLIC, and PRIVATE, and organize the values passed for these arguments into the ARG variable.
  cmake_parse_arguments(
    ARG                     # The ARG variable will contain the parsed arguments in a structured form.
    ""                      # single-value arguments (NONE)
    ""                      # single-value arguments (NONE)
    "${multiValueArgs}"     # multi-value arguments (INTERFACE, PUBLIC, PRIVATE)
    ${ARGN})                # provided arguments (${ARGN}). (Without target, the variable that we have explicitly defined on the function definition)

  foreach(scope IN ITEMS INTERFACE PUBLIC PRIVATE)
    foreach(lib_include_dirs IN LISTS ARG_${scope})   # This: ARG_${scope} is translating to ARG_INTERFACE, ARG_PUBLIC, ARG_PRIVATE
      if(NOT MSVC)
        # system includes do not work in MSVC
        # awaiting https://gitlab.kitware.com/cmake/cmake/-/issues/18272#
        # awaiting https://gitlab.kitware.com/cmake/cmake/-/issues/17904
        set(_SYSTEM SYSTEM)
      endif()
      if(${scope} STREQUAL "INTERFACE" OR ${scope} STREQUAL "PUBLIC")
        target_include_directories(
          ${target}
          ${_SYSTEM}
          ${scope}
          "$<BUILD_INTERFACE:${lib_include_dirs}>"
          "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>")
      else()
        target_include_directories(
          ${target}
          ${_SYSTEM}
          ${scope}
          ${lib_include_dirs})
      endif()
    endforeach()
  endforeach()

endfunction()

# Include the directories of a library target as system directories (which suppresses their warnings).
function(
  target_include_system_library
  target
  scope
  lib)
  # check if this is a target
  if(TARGET ${lib})
    get_target_property(lib_include_dirs ${lib} INTERFACE_INCLUDE_DIRECTORIES)
    if(lib_include_dirs)
      target_include_system_directories(${target} ${scope} ${lib_include_dirs})
    else()
      message(TRACE "${lib} library does not have the INTERFACE_INCLUDE_DIRECTORIES property.")
    endif()
  endif()
endfunction()

# Link a library target as a system library (which suppresses its warnings).
function(
  target_link_system_library
  target
  scope
  lib)
  # Include the directories in the library
  target_include_system_library(${target} ${scope} ${lib})

  # Link the library
  target_link_libraries(${target} ${scope} ${lib})
endfunction()

# Link multiple library targets as system libraries (which suppresses their warnings).
function(target_link_system_libraries target)
  set(multiValueArgs INTERFACE PUBLIC PRIVATE)
  cmake_parse_arguments(
    ARG
    ""
    ""
    "${multiValueArgs}"
    ${ARGN})

  foreach(scope IN ITEMS INTERFACE PUBLIC PRIVATE)
    foreach(lib IN LISTS ARG_${scope})
      target_link_system_library(${target} ${scope} ${lib})
    endforeach()
  endforeach()
endfunction()
