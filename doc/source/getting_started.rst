.. _qibuild-getting-started:

Getting Started
===============


Requirements
------------

Python 2.7 is the preferred version, but qiBuild should work fine on python
2.6, too. Note that to prepare a possible conversion to python3, python2.5 is
*not* supported.

CMake version 2.8.3 is the preferred version, but you should not have any
problem with CMake 2.6. On Windows, choose to add CMake to your ``%PATH%.``

On windows, to use scripts written in Python, you have to put ``C:\Python2.x`` and
``c:\Python2.x\Scripts`` in your ``PATH``.

Installation
------------

Get the source code from github: https://github.com/aldebaran/qibuild

Linux, mac
++++++++++

Simply run:

.. code-block:: console

  ./install-qibuild.sh

And make sure ``~/.local/bin`` is in your ``PATH``

On mac, make sure ``cmake`` is in your path.

Windows
+++++++

Just run ``install-qibuild.bat``:

.. code-block:: console

  c:\path\to\qibuild> install-qibuild.bat

If you have bash available on your system, and want to use qiBuild from there,
you should also be able to use the .sh script. (Be careful if you are using
cygwin: you must be sure the .sh has UNIX end of lines)

Plase make sure that ``CMake`` is in your ``PATH``

If you'd like to have nice colors in your console, you can install
the Python readline library: http://pypi.python.org/pypi/pyreadline

Creating a work tree
--------------------

First you need to chose a qibuild "worktree".

This path will be the root from where qiBuild searches to find the sources of
your projects.

In the following document, we will use the notation ``QI_WORK_TREE`` to refer
to this path.

Then go to this directory and run

.. code-block:: console

  $ qibuild init --interactive

You will be asked to choose a CMake generator. Choose the one that matches your
platform.

This will create a new qiBuild configuration file in your working directory, in
``QI_WORK_TREE/.qi/build.cfg``


Configuring qiBuild
-------------------

You can run ``qibuild config`` to get a look at your current settings,
and change them in the file ``QI_WORK_TREE/.qi/build.cfg``.


Building with Unix Makefiles
++++++++++++++++++++++++++++

No specific configuration is needed, since this is the default behaviour.
Enjoy!

Configuring qiBuild for Eclipse CDT
+++++++++++++++++++++++++++++++++++

Eclipse supports having distinct directories for the source and the build, but
does not like if the later is a subdirectory of the former.

So you have to use a global build directory, by editing
``QI_WORK_TREE/.qi/qibuild.cfg`` to have

.. code-block:: ini

  [general]
  build.directory = /path/to/build/directory
  cmake.generator = Eclipse CDT4 - Unix Makefiles

Your project build directory will then be
``/path/to/build/directory/build-<config>/<project-name>``.

.. code-block:: console

   $ cd QI_WORK_TREE
   $ qibuild configure

Then from within eclipse, go to "File -> Import" then choose
"General -> General Projects into Workspace" and select your build directory
as "root directory". Let the "Copy projects into workspace" box unchecked
and click "Finish".

Configuring qiBuild for QtCreator
++++++++++++++++++++++++++++++++++

on Unix
~~~~~~~

No specific configuration is needed, since QtCreator loads the CMakeList.txt
directly. Enjoy!

Just run ``qibuild configure`` by hand first, and choose the build directory
generated by ``qibuild`` when the CMake wizard asks for one.

on Windows
~~~~~~~~~~

The preferred way to use qibuild on Windows is with QtCreator, using the
mingw that comes with QtCreator.

* Get the latest qtcreator and install it. (you only need the qtcreator
  package, no need for the full-fledged Qt SDK)

* Add the MinGW’s path to your %PATH% so that QtCreator can find mingw32-make
  without running qmake

* Tell qibuild to use "MinGW Makefiles"

Here’s what a complete .qi/build.cfg would look like to use MinGW with QtCreator

.. code-block:: ini

  [general]
  env.path = C:\qtcreator\mingw\bin
  cmake.generator = "MinGW Makefiles"


.. warning:: qibuild never modify os.environ globally, so the executable you
   just built won't run unless you have mingw's DLLs in your PATH.

Configuring qiBuild for Visual Studio
+++++++++++++++++++++++++++++++++++++

You will have to make sure CMake uses the proper generator for qiBuild to work
with Visual Studio.

Here’s what a complete .qi/build.cfg would look like to use Visual Studio 2008

.. code-block:: ini

  [general]
  cmake.generator = "Visual Studio 9 2008"

For command line addicts (or people doing continuous integration who would like
a better build output), you can also:

* Use ``cmake_generator = "NMake Makefiles"`` and use qibuild from the Visual
  Studio command prompt.

* Or, if you do not want to use the Visual Studio command prompt, you can
  specify a ``.bat`` file to be ran by qibuild, like this

  .. code-block:: ini

     [general]
     env.bat_file = c:\Program Files\Microsoft Visual Studio 9.0\VC\vcvarsall.bat
     cmake.generator = 'NMake Makefiles'

  (the location of the ``.bat`` file depends on your setup)


Configuring qiBuild for MinGW with Msys
+++++++++++++++++++++++++++++++++++++++

You will have to do several things for qibuild to work with MinGW.

* Set PATH properly so that make.exe and gcc.exe are found

* Make sure CMake uses the correct generator

Here’s what a complete .qi/build.cfg would look like to use MinGW

.. code-block:: ini

  [general]
  env.path = C:\Mingw\bin;C:\MinGW\msys\1.0\bin;
  cmake.generator = "Unix Makefiles"

.. note:: here you have to setup a complete msys environnement before being
   able to use qibuild.
