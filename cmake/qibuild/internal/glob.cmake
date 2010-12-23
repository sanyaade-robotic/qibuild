##
## glob.cmake
## Login : <ctaf42@cgestes-de2>
## Started on  Thu Dec  2 19:48:52 2010 Cedric GESTES
## $Id$
##
## Author(s):
##  - Cedric GESTES <gestes@aldebaran-robotics.com>
##
## Copyright (C) 2010 Cedric GESTES
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program; if not, write to the Free Software
## Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
##

function(qi_glob _OUT_srcs)
  set(_temp)
  foreach(_arg ${ARGN})
    #is this a globbing expression?
    if ("${_arg}" MATCHES "(\\*)|(\\[.*\\])")
      file(GLOB _glob "${_arg}")
      if ("${_glob}" STREQUAL "")
        qi_error("${_arg} does not match")
      else()
        set(_temp ${_temp} ${_glob})
      endif()
    else()
      set(_temp ${_temp} ${_arg})
    endif()
  endforeach()
  set(${_OUT_srcs} ${_temp} PARENT_SCOPE)
endfunction()

function(qi_abspath _OUT_srcs)
  set(_temp)
  foreach(_arg ${ARGN})
    get_filename_component(_abspath ${_arg} ABSOLUTE)
    list(APPEND _temp "${_abspath}")
  endforeach()
  set(${_OUT_srcs} ${_temp} PARENT_SCOPE)
endfunction()