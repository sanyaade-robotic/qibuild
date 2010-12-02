##
## Author(s):
##  - Cedric GESTES <gestes@aldebaran-robotics.com>
##
## Copyright (C) 2009, 2010 Cedric GESTES
##

#! QiBuild Tests
# ==============
# Cedric GESTES <gestes@aldebaran-robotics.com>
#
# This cmake module provide function to interface gtest with ctest.


set(_TESTS_RESULTS_FOLDER "${CMAKE_BINARY_DIR}/tests-results" CACHE INTERNAL "" FORCE)
# create tests_results folder if it does not exist
file(MAKE_DIRECTORY "${_TESTS_RESULTS_FOLDER}")


#! This compiles and add_test's a C++ test that uses gtest.
# (so that the test can be run by CTest)
# When run, the C++ test outputs a xUnit xml file in CMAKE_SOURCE_DIR/test_name.xml.
#
# \flag:NO_ADD_TEST do not call add_test, just create the binary
# \param:TIMEOUT the timeout of the test
# \group:SRC sources
# \group:DEPENDS dependencies to pass to use_lib
# \group:ARGUMENTS arguments to pass to add_test (to your test program)
function(qi_create_gtest name)
  qi_debug("qi_create_gtest(${name})")
  cmake_parse_arguments(ARG "NO_ADD_TEST" "TIMEOUT" "SRC;DEPENDS;ARGUMENTS" ${ARGN})

  if (NOT TARGET "autotest")
    add_custom_target("autotest")
  endif()

  if(NOT ARG_TIMEOUT)
    set(ARG_TIMEOUT 20)
  endif()

  # Create the binary test, link with dependencies.
  if (BUILD_TESTS)
    qi_create_bin("${name}_bin" ${ARG_SRC} NO_INSTALL)
  else()
    qi_create_bin("${name}_bin" EXCLUDE_FROM_ALL ${ARG_SRC} NO_INSTALL)
  endif()
  add_dependencies("autotest" "${name}_bin")
  qi_use_lib("${name}_bin" ${ARG_DEPENDS})

  if (ARG_NO_ADD_TEST)
    return()
  endif()

  #TODO: get this back
  return()

  # use sdk trampoline (.bat on windows) to set all environment variables correctly.
  if(WIN32)
    #TODO: get this back
    #qi_create_insource_launcher("${name}_bin" "${name}.bat")
    qi_add_gtest("${name}.bat" ${name} ARGUMENTS ${_arguments})
  else()
    #TODO: get this back
    #qi_create_insource_launcher("${name}_bin" ${name})
    qi_add_gtest(${name} ${name} ARGUMENTS ${_arguments})
  endif()
  set_tests_properties(${name} PROPERTIES TIMEOUT ${_timeout})
endfunction()


#! add a gtest program to ctest.
# Xml output (test_name.xml) will be in build/tests_results
#
# \arg:executable_name the executable
# \arg:test_case_name the test's name
# \argn: program arguments
function(qi_add_gtest executable_name test_name)
  set(xml_output_name "${_TESTS_RESULTS_FOLDER}/${_test_name}.xml")

  # Replaces / for windows, and remove .bat from xml name:
  if (WIN32)
    string(REPLACE "/" "\\\\" xml_output_name ${xml_output_name})
  endif()

  # Add gtest for ctest with xml output file.
  add_test(${test_name} ${SDK_DIR}/bin/${executable_name} --gtest_output=xml:${xml_output_name} ${ARGN})
endfunction()