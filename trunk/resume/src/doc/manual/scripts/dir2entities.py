#!/usr/bin/python

import os.path
import sys
import getopt
import glob
import re
import string

#------------------------------------------------------------------------------
class Entity:
    def __init__(self, name, path):
        self.name = name
        self.path = path

#------------------------------------------------------------------------------
def make_relative_path(from_dir, to_dir):
    """make_relative_path(from_dir, to_dir) -> relative_path
    
    Returns a string listing the shortest possible relative path from directory
    from_dir to directory to_dir.
    
    For example, make_relative_path("/usr/share/doc", "/usr/lib") would return
    "../../lib". Returned values never have a leading or trailing slash.
    
    (Note that although this text uses slashes as examples, this function
    actually uses the portable os.sep string instead.)"""

    if from_dir == "" or to_dir == "":
        raise ValueError, "from_dir and to_dir cannot be empty"

    # Normalize paths and make them absolute
    from_dir = os.path.abspath(os.path.normpath(from_dir))
    to_dir = os.path.abspath(os.path.normpath(to_dir))
    if from_dir == "/": from_dir = ""
    if to_dir == "/": to_dir = ""

    # Split dirs on path separator to make an array of dir components
    sep_re = re.compile(re.escape(os.sep))
    from_dirs = sep_re.split(from_dir)
    to_dirs = sep_re.split(to_dir)

    common_dirs = []

    # Find longest common prefix
    for i in range(min(len(from_dirs), len(to_dirs))):
        if from_dirs[i] == to_dirs[i]:
            common_dirs.append(from_dirs[i])
        else:
            break

    # Remove common dirs
    from_dirs = from_dirs[len(common_dirs):]
    to_dirs = to_dirs[len(common_dirs):]

    return os.path.normpath(
        (os.pardir + os.sep) * len(from_dirs) + string.join(to_dirs, os.sep)
        )

def get_entities(pattern, relative_to):
    """get_entities(pattern, relative_to) -> list_of_tuples
    
    Returns a list of (entity_name,file_path) tuples, one for each file that
    matches glob pattern. file_path is relative to directory relative_to.
    """

    files = glob.glob(pattern)
    files.sort()

    # relative_to should always be specified, unless the path will just be
    # discarded later on
    if relative_to != None:
        # Make paths relative
        for i in range(len(files)):
            files[i] = make_relative_path(
                from_dir = relative_to,
                to_dir = files[i],
                )

    entities = []

    # Determine entity names and then create Entity objects
    for file in files:
        # Strip leading directories
        name = os.path.basename(file)
        # Strip extension
        name = re.sub(r"\.[^.]+$", "", name)

        # Create Entity object
        entities.append(Entity(name, file))

    return entities

#------------------------------------------------------------------------------
def usage(errormsg=None, exitcode=1):
    """Prints usage information to stdout and exits"""

    if errormsg!=None:
        print "***** Error: %s\n" % errormsg

    sys.stderr.writelines(
"""Syntax: %s [--defs --rel=<dir>|--uses] glob

Prints a list of SGML entity definitions (<!ENTITY [name] SYSTEM [location]>) or
uses/citations (&[name];), one for each file that matches glob. The entity
[name] will the file's basename, minus the extension. Entity [location] will be
a path relative to the directory specified by --rel; --rel is required with
--defs, ignored with --uses.
""" % os.path.basename(sys.argv[0]))

    sys.exit(exitcode)

#------------------------------------------------------------------------------
# Main program
#------------------------------------------------------------------------------

if __name__ == "__main__":

    mydir = os.path.abspath(os.path.dirname(sys.argv[0]))

    # Get command line options
    try:
        opts, leftovers = getopt.getopt(
            args        = sys.argv[1:],
            shortopts   = "",
            longopts    = [
                "defs",
                "uses",
                "rel=",
                "verbose",
                ],
            )
    except getopt.GetoptError, e:
        usage(str(e))

    if len(leftovers) < 1:
        usage("no glob found")
    elif len(leftovers) > 1:
        usage("too many globs found (did you forget to quote the glob?)")

    # Option defaults
    op = None
    relative_to = None
    pattern = leftovers[0]
    verbose = 0

    # Override defaults
    for name,val in opts:
        if name[2:] in ("defs","uses"):
            op = name[2:]
        elif "--rel" == name:
            relative_to = val
        elif "--verbose" == name:
            verbose = 1

    if op == None:
        usage("no operation specified")
    elif op == "defs" and relative_to == None:
        usage("--rel not specified; it is required with --defs")

    entities = get_entities(pattern, relative_to)

    if verbose:
        sys.stderr.writelines("Options:")
        sys.stderr.writelines("relative_to: " + `relative_to`)
        sys.stderr.writelines("pattern: " + `pattern`)
        sys.stderr.writelines("number of entities found: " + `len(entities)`)

    if "defs" == op:
        for entity in entities:
            print """<!ENTITY %s SYSTEM "%s">""" % (entity.name, entity.path)
        
    elif "uses" == op:
        for entity in entities:
            print """&%s;""" % entity.name
