#!/usr/bin/python

import sys
import os
import getopt
import glob
import re

#------------------------------------------------------------------------------
def usage(exit_code=1):
    sys.stderr.write(
"""Syntax: %s [options]

This program trims leading and trailing whitespace from the contents of
"<![CDATA[ ... ]]>" sections in files.

Options:

    --dir <dirname>             The directory to process.
    --pattern <glob>            A filesystem-type glob pattern that matches
                                files to fix. Should not contain path
                                information; that should be specified with
                                --dir. Optional; default is "*.xml".
    --recursive                 If specified, all files in <dir> and its
                                subdirectories will be processed. Optional;
                                default is non-recursive.
    --help                      Prints this message and exits.
""" % os.path.basename(sys.argv[0]))

    sys.exit(exit_code)
#------------------------------------------------------------------------------
def fix_cdata(pattern, dir, files=None):
    """fix_cdata(pattern, dir) -> None
    
    Removes all leading space from CDATA end-tokens in files in dir matching
    glob pattern.  files is unused, but needed so this func can be called by
    os.path.walk.
    """

    filenames = glob.glob(dir + os.sep + pattern)

    # The (?<= ... ) is a lookbehind assertion
    start_re = re.compile(
        r"(?<=%s)\s+" %
        re.escape("<![CDATA[")
        )
    # The (?= ... ) is a lookahead assertion
    end_re = re.compile(
        r"\s+(?=%s)"
        % re.escape("]]>")
        )

    for filename in filenames:
        if os.path.isfile(filename):
            text = open(filename, "r").read()
            if (start_re.search(text) or end_re.search(text)):
                text = start_re.sub("", text)
                text = end_re.sub("", text)
                open(filename, "w").write(text)
                print "%s fixed" % filename

#------------------------------------------------------------------------------

if __name__ == "__main__":
    # Get command line options
    try:
        opts, leftovers = getopt.getopt(
            args        = sys.argv[1:],
            shortopts   = "",
            longopts    = [
                "dir=",
                "pattern=",
                "recursive",
                "help",
                ],
            )
    except getopt.GetoptError, e:
        print "***** Error: %s\n" % str(e)
        usage()

    mydir = os.path.abspath(os.path.dirname(sys.argv[0]))

    # Option defaults
    ops = []
    dir = None
    pattern = "*.xml"
    recursive = 0
    help = 0

    for name,val in opts:
        if "--dir" == name:
            dir = val
        elif "--pattern" == name:
            pattern = val
        elif "--recursive" == name:
            recursive = 1
        elif "--help" == name:
            help = 1

    if dir == None:
        print "***** Error: --dir not specified; it is required\n"
        usage()
        
    # Normalize paths (follow ..'s, remove trailing /'s , etc)
    dir = os.path.normpath(dir)

    if recursive:
        os.path.walk(top=dir, func=fix_cdata, arg=pattern)
    else:
        fix_cdata(pattern=pattern, dir=dir)
