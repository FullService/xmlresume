#!/usr/local/bin/python

import os, sys, re
import fileinput

#------------------------------------------------------------------------------
def replace_changelog(filename, new_changelog):
    """Replaces a changelog in file with name filename with string
    new_changelog.

    new_changelog should already be HTML-escaped.

    The changelog in file should be delimited by:
    <!-- BEGIN CHANGELOG (do not remove this line) -->
    ... changelog here ...
    <!-- END CHANGELOG (do not remove this line) -->
    """

    changelog_re = re.compile(
        (
            "(.*<!-- BEGIN CHANGELOG \\(do not remove this line\\) -->\n)"
            + ".*"
            + "(<!-- END CHANGELOG \\(do not remove this line\\) -->.*)"
            ),
        re.DOTALL
        )

    file_data = open(filename, "r").read()

    match = changelog_re.match(file_data)

    if (match):
        new_data = match.group(1) + new_changelog + match.group(2)
        open(filename, "w").write(new_data)
    else:
        raise ValueError, filename + ": missing changelog begin and end markers"

#------------------------------------------------------------------------------

if __name__ == "__main__":
    new_changelog = ""
    for line in fileinput.input():
        new_changelog = new_changelog + line

    mydir = os.path.abspath(os.path.dirname(sys.argv[0]))
    changelog_filename = (
        mydir
        + re.sub("/", os.sep, "/../src/doc/release/changelog/index.html")
        )

    replace_changelog(changelog_filename, new_changelog)
