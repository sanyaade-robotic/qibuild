#!/usr/bin/env python

"""This script install qibuild properly

"""
import os
import sys
import stat
import posixpath

CUR_DIR = os.path.abspath(os.path.dirname(__file__))

def chmod_755(path):
    """Fix permission of a script"""
    os.chmod(path,
        stat.S_IRUSR | stat.S_IWUSR | stat.S_IXUSR |
        stat.S_IRGRP | stat.S_IXGRP |
        stat.S_IROTH | stat.S_IXOTH)

def install(script_name, on_win=False):
    python_path = os.path.join(CUR_DIR, "..", "python")
    python_path = os.path.abspath(python_path)
    script_path = os.path.join(python_path, "bin", script_name)
    with open(script_path, "r") as fp:
        script_contents = fp.read()

    script_contents = script_contents.replace("# sys.path", """import sys
sys.path.insert(0, r"%s")""" % python_path)

    if on_win:
        dest_dir = os.path.join(os.path.dirname(sys.executable), "Scripts")
    else:
        dest_dir = "/usr/local/bin"
    if not os.path.exists(dest_dir):
        os.makedirs(dest_dir)
    out_path = posixpath.join(dest_dir, script_name + ".py")
    with open(out_path, "w") as fp:
        fp.write(script_contents)
    print "Script installed in ", out_path

    chmod_755(out_path)
    if not on_win:
        without_ext = out_path[:-3]
        if os.path.exists(without_ext):
            os.remove(without_ext)
        os.link(out_path, without_ext)

if __name__ == "__main__":
    if "--windows" in sys.argv:
        on_win = True
    else:
        on_win = False
    install("qitoolchain", on_win=on_win)
    install("qibuild", on_win=on_win)
    install("qisrc", on_win=on_win)


