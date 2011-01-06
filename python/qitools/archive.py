##
## Copyright (C) 2009 Aldebaran Robotics
##

"""This module contains function to
manipulate archives
"""

import os
import posixpath
import sys
import logging
import tarfile
import zipfile

import qitools



LOGGER = logging.getLogger("buildtool.archive")

class InvalidArchive(Exception):
    """Just a custom exception """
    def __init__(self, message):
        self.message = message
        Exception.__init__(self)

    def __str__(self):
        return self.message

def extract_tar(archive_path, dest_dir):
    """Extract a .tar.gz archive"""
    LOGGER.info("Extracting %s to %s", archive_path, dest_dir)
    archive = tarfile.open(archive_path)
    members = archive.getmembers()
    size = len(members)
    res = None
    topdir = members[0].name.split(posixpath.sep)[0]
    for (i, member) in enumerate(members):
        member_top_dir = member.name.split(posixpath.sep)[0]
        if i !=0 and topdir != member_top_dir:
            # something wrong: members do not have the
            # same basename
            mess  = "Invalid member %s in archive:\n" % member.name
            mess += "Every files sould be in the same top dir (%s != %s)" %\
                 (topdir, member_top_dir)
            raise InvalidArchive(mess)

        # Do not use archive.extract(member)
        # See: http://docs.python.org/library/tarfile.html#tarfile.TarFile.extract
        archive.extractall(members=[member], path=dest_dir)
        percent = float(i) / size * 100
        sys.stdout.write("Done: %.0f%%\r" % percent)
        sys.stdout.flush()
    archive.close()
    LOGGER.info("%s extracted to %s", archive_path, dest_dir)
    res = os.path.join(dest_dir, topdir)
    return res


def extract_zip(archive_path, dest_dir):
    """Extract a zip archive"""
    LOGGER.info("Extracting %s to %s", archive_path, dest_dir)
    archive = zipfile.ZipFile(archive_path)
    members = archive.infolist()
    # There is always the top dir as the first element of the archive
    # (or so we hope)
    topdir = members[0].filename.split(posixpath.sep)[0]
    size = len(members)
    for (i, member) in enumerate(members):
        member_top_dir = member.filename.split(posixpath.sep)[0]
        if i !=0 and topdir != member_top_dir:
            # something wrong: members do not have the
            # same basename
            mess  = "Invalid member %s in archive:\n" % member.filename
            mess += "Every files sould be in the same top dir (%s != %s)" %\
                 (topdir, member_top_dir)
            raise InvalidArchive(mess)
        archive.extract(member, path=dest_dir)
        percent = float(i) / size * 100
        sys.stdout.write("Done: %.0f%%\r" % percent)
        sys.stdout.flush()
    archive.close()
    LOGGER.info("%s extracted to %s", archive_path, dest_dir)
    res = os.path.join(dest_dir, topdir)
    return res


def zip_win(directory):
    """
    Call 7zip.exe on a directory

    """
    archive_name = directory + ".zip"
    # Convert to DOS path just to be sure:
    directory    = os.path.normpath(directory)
    archive_name = os.path.normpath(archive_name)
    cmd = ["7zip.exe", "a", archive_name, directory]
    qitools.command.check_call(cmd)
    return archive_name


def zip_unix(directory):
    """
    Call tar cvfz on a directory

    """
    base_dir = os.path.basename(directory)
    work_dir = os.path.abspath(os.path.join(directory, ".."))
    base_archive_name = base_dir + ".tar.gz"
    cmd = ["tar", "cvfz", base_archive_name, base_dir]
    qitools.command.check_call(cmd, cwd=work_dir)
    full_archive_name = os.path.join(work_dir, base_archive_name)
    return full_archive_name