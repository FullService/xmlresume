import os
import re
import string

"""Contains various helper functions for XML Resume Project documentation
generation
"""

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
#------------------------------------------------------------------------------
