##
## Author(s):
##  - Cedric GESTES <gestes@aldebaran-robotics.com>
##
## Copyright (C) 2010 Aldebaran Robotics
##

clean(ZEROMQ)

fpath(ZEROMQ zmq.h)
flib(ZEROMQ zmq)
set(ZEROMQ_DEPENDS "UUID")

export_lib(ZEROMQ)