#!/usr/bin/python 

from xml.parsers.xmlproc import dtdparser,xmldtd,utils

import sys
import os
import string
import re
import getopt
import glob

"""Creates a set of skeleton documentation files for XML Resume DTD elements and
maintains and checks those files"""

# This file is based on dtddoc.py, which is included in the Python xmlproc
# distribution

#------------------------------------------------------------------------------
# Utility functions
#------------------------------------------------------------------------------

def attrs_to_docbook(elem):
    """attrs_to_docbook(elem) -> string
    
    Returns a DocBook <informaltable> representation of an element's attributes"""

    attrs = elem.get_attr_list()
    attrs.sort()

    if len(attrs) == 0:
        return "<para>None</para>"

    table = """
<informaltable frame='all'>
  <tgroup cols='3' align='left' colsep='1' rowsep='1'>
    <colspec colname='name'/>
    <colspec colname='type'/>
    <colspec colname='default'/>
    <thead>
      <row>
      <entry>Name</entry>
      <entry>Type</entry>
      <entry>Default</entry>
      </row>
    </thead>
    <tbody>
"""

    for attr_name in attrs:
        table = table + "<row>"
        attr = elem.get_attr(attr_name)        

        # Name
        table = table + "<entry>%s</entry>" % attr_name
        # Type
        table = table + "<entry>%s</entry>" % attr.get_type()
        # Default
        if attr.get_default() == None:
            table = table + "<entry>None</entry>"
        else:
            table = table + "<entry>%s</entry>" % attr.get_default()

        table = table + "</row>"

    table = table + """
    </tbody>
  </tgroup>
</informaltable>
"""

    return table

#------------------------------------------------------------------------------
def parents_to_docbook(elem_name,parent_list,id_prefix):
    """parents_to_docbook(elem_name,parent_list,id_prefix) -> string
    
    Creates a DocBook representation of an element's parents, with parent
    elements linked to their entries.
    
    id_prefix is a string that is prepended to the DTD ENTITY name to form a
    DocBook id."""

    parents = parent_list[elem_name]

    if len(parents) == 0:
        return "None"

    formatted_parents = []

    for parent in parents:
        formatted_parents.append(
            '<member><link linkend="%s%s"><sgmltag class="element">%s</sgmltag></link></member>'
            % (id_prefix,parent,parent)
            )

    return (
        '<simplelist type="inline">\n' +
        string.join(formatted_parents, "\n") +
        '</simplelist>'
        )
#------------------------------------------------------------------------------
def content_model_to_docbook(model,id_prefix):
    """content_model_to_docbook(model,id_prefix) -> string
    
    Creates a DocBook representation of an element content model, with child
    elements linked to their entries.
    
    id_prefix is a string that is prepended to the DTD ENTITY name to form a
    DocBook id."""

    if model==None:
        return "ANY"
    elif model[1]==[]:
        return "EMPTY"
        
    (sep,contents,modifier)=model

    formatted_items = []

    for item in contents:
        # Actual element
        if len(item)==2:
            (item_name, item_modifier) = item

            # Don't link items starting with "#", like "#PCDATA"
            if item_name[0] == "#":
                formatted_items.append(item_name + item_modifier)
            else:
                formatted_items.append(
                    '<link linkend="%s%s">%s</link>%s'
                    % (id_prefix, item_name, item_name, item_modifier)
                    )
        # Sub-content model
        else:
            formatted_items.append(content_model_to_docbook(item,id_prefix))

    return "(" + string.join(formatted_items, sep) + ")" + modifier

#------------------------------------------------------------------------------
def traverse_cm(cur,cm,parents):
    """Helps determine the elements' parents"""
    if cm==None:
        return

    for item in cm[1]:
        if len(item)==2:
            try:
                parents[item[0]][cur]=1
            except KeyError:
                print "ERROR: Undeclared element '%s'" % item[0]
        else:
            traverse_cm(cur,item,parents)

def determine_parents(dtd):
    """determine_parents(dtd) -> parent_list
    
    Returns dictionary of lists. Dict keys are element names, values are lists
    of their parents."""

    parents={}

    parents["#PCDATA"]={}
    for elem_name in dtd.get_elements():
        parents[elem_name]={}    
        
    for elem_name in dtd.get_elements():
        elem=dtd.get_elem(elem_name)
        traverse_cm(elem_name,elem.get_content_model(),parents)

    # Convert parent lists from dicts to sorted lists
    for key in parents.keys():
        parents[key] = parents[key].keys()
        parents[key].sort()

    return parents
#------------------------------------------------------------------------------
def usage(exit_code=1):
    sys.stderr.write(
"""Syntax: %s [operation] [options]

Operations:

    --list-unknown              Lists all files matching <pattern> that don't
                                have a corresponding element in the DTD.
    --list-missing              Lists DTD elements for which there is no DocBook
                                file matching <pattern>
    --create-missing            Creates files for DTD elements don't have a
                                DocBook file matching <pattern>
    --check                     Same as --list-unknown --list-missing
    --filter                    Copies all files matching <pattern> to
                                <build-dir> (which must already exist), then
                                replaces "<$CONTENT_MODEL$>",
                                "<$ATTRIBUTES_TABLE$>", and "<$PARENTS$>" tokens
                                with generated data

Options:

    --dtd <filename>            The DTD file location. Optional; default is
                                ../../../www/dtd/resume.dtd
    --pattern <glob>            A filesystem-type glob pattern containing a
                                single "*" that specifies files to work with.
                                See Operation descriptions above for specifics.
                                Don't forget to quote this option so that the
                                shell doesn't expand the "*". Defaults to
                                "../en/elementref/element.*.xml".
    --build-dir <dirname>       Where to place generated files; used in
                                conjuction with --filter. Optional; defaults to
                                "../../../../build/doc/manual".
    --template <filename>       The template file to use when creating new
                                refentry files with --create-missing. Optional;
                                default is "./refentry.template.xml".
    --verbose                   Prints extra information on program
                                configuration.
    --help                      Prints this message and exits.
""" % os.path.basename(sys.argv[0]))

    sys.exit(exit_code)
#------------------------------------------------------------------------------
def find_missing_elements(elems, pattern):
    """find_missing_elements(elems, patter) -> elem_name_list
    
    Finds elements in elems for which there is no corresponding file matching
    pattern.
    
    pattern is a filesystem-type glob string (e.g. "/usr/doc/docbook.*.xml")
    containing a single star ("*"). The star is replaced with the entity name
    when matching.
    """

    missing_elements = []
    for elem_name in elems:
        if not os.path.isfile(re.sub(r"\*", elem_name, pattern)):
            missing_elements.append(elem_name)
    return missing_elements
#------------------------------------------------------------------------------
def find_unknown_files(elems, pattern):
    """find_unknown_files(elems, pattern) -> filename_list
    
    Finds files matching pattern for which there is no corresponding element in
    elems.
    
    pattern is a filesystem-type glob string (e.g. "/usr/doc/docbook.*.xml")
    containing a single star ("*"). The star is replaced with the entity name
    when matching.
    """

    unknown_files = []

    # Create an re that will match just the "*" portion of the glob
    entity_pattern = re.escape(pattern)
    entity_pattern = (
        "^"
        + re.sub(
            re.escape(re.escape("*")),
            "(.*)",
            entity_pattern,
            )
        + "$"
        )
    entity_re = re.compile(entity_pattern)

    for file in glob.glob(pattern):
        # Ignore directories
        if os.path.isfile(file):

            matches = entity_re.match(file)
            assert len(matches.groups()) == 1, \
                "There should be only one star in the glob"

            entity_name = matches.groups()[0]

            if entity_name not in elems:
                unknown_files.append(file)

    return unknown_files

#------------------------------------------------------------------------------
# Main program
#------------------------------------------------------------------------------

id_prefix = "element."

# Get command line options
try:
    opts, leftovers = getopt.getopt(
        args        = sys.argv[1:],
        shortopts   = "",
        longopts    = [
            "list-unknown",
            "list-missing",
            "create-missing",
            "check",
            "filter",
            "dtd=",
            "pattern=",
            "build-dir=",
            "template=",
            "verbose",
            "help",
            ],
        )
except getopt.GetoptError, e:
    print "***** Error: %s\n" % str(e)
    usage()

mydir = os.path.abspath(os.path.dirname(sys.argv[0]))

# Option defaults
ops = []
dtd_filename = mydir + re.sub("/", os.sep, "/../../../www/dtd/resume.dtd")
pattern = mydir + re.sub("/", os.sep, "/../en/elementref/element.*.xml")
build_dir = mydir + re.sub("/", os.sep, "/../../../../build/doc/manual")
template_file = mydir + re.sub("/", os.sep, "/refentry.template.xml")
verbose = 0
help = 0

for name,val in opts:
    if name[2:] in (
        "list-unknown","list-missing","create-missing","filter",
        ):
        ops.append(name[2:])
    elif "--check" == name:
        ops.append("list-unknown")
        ops.append("list-missing")
    elif "--dtd" == name:
        dtd_filename = val
    elif "--pattern" == name:
        pattern = val
    elif "--build-dir" == name:
        build_dir = val
    elif "--template" == name:
        template_file = val
    elif "--verbose" == name:
        verbose = 1
    elif "--help" == name:
        help = 1

# Normalize paths (follow ..'s, remove trailing /'s , etc)
dtd_filename = os.path.normpath(dtd_filename)
pattern = os.path.normpath(pattern)
build_dir = os.path.normpath(build_dir)
template_file = os.path.normpath(template_file)

if verbose:
    print 'dtd: %s' % `dtd_filename`
    print 'pattern: %s' % `pattern`
    print 'build-dir: %s' % `build_dir`
    print 'template: %s' % `template_file`

if help:
    usage(0)

# Parse the DTD
dp=dtdparser.DTDParser()
dp.set_error_handler(utils.ErrorPrinter(dp))
dtd=xmldtd.CompleteDTD(dp)
dp.set_dtd_consumer(dtd)
dp.parse_resource(dtd_filename)

# Determine element parents
parents = determine_parents(dtd)

elems=dtd.get_elements()
elems.sort()


#------------------------------------------------------------------------------
# Now we actually do what was requested of us :)
#------------------------------------------------------------------------------

if ops == []:
    print "***** Error: no operation specified\n"
    usage()

for op in ops:
    if "list-missing" == op:

        print "Elements in %s for which this is no file matching %s:" % (
            dtd_filename, pattern)

        missing_file_elements = find_missing_elements(elems, pattern)

        if len(missing_file_elements):
            for elem in missing_file_elements:
                print elem
        else:
            print "(None)"

    elif "create-missing" == op:
        template_text = open(template_file, "r").read()

        missing_elems = find_missing_elements(elems, pattern)

        for elem_name in missing_elems:
            out_file = re.sub(r"\*", elem_name, pattern)
            if os.path.exists(out_file):
                print "***** Error: %s already exists" % (out_file)
                sys.exit(1)

            out = open(out_file, "w")
            print "Writing " + out_file
            output_text = template_text

            elem = dtd.get_elem(elem_name)

            replacements = {}
            # Filename minus ancestry and extension
            replacements["ID"] = re.sub(
                r"\.[^.]*$",
                "",
                os.path.basename(out_file),
                )
            replacements["ELEMENT_NAME"] = elem_name

            for token in replacements.keys():
                output_text = re.sub(
                    r"<\$"+token+r"\$>",
                    replacements[token],
                    output_text,
                    )

            out.write(output_text)

            out.close()

    elif "list-unknown" == op:

        print "Files matching %s for which there is no element in %s:" % (
            pattern, dtd_filename)

        unknown_files = find_unknown_files(elems, pattern)

        if len(unknown_files):
            for file in unknown_files:
                print file
        else:
            print "(None)"

    elif "filter" == op:
        for elem_name in elems:
            in_file = re.sub(r"\*", elem_name, pattern)
            out_file = build_dir + os.sep + os.path.basename(in_file)

            elem = dtd.get_elem(elem_name)

            replacements = {}
            replacements["CONTENT_MODEL"] = content_model_to_docbook(
                elem.get_content_model(),
                id_prefix,
                )
            replacements["ATTRIBUTES_TABLE"] = attrs_to_docbook(elem)
            replacements["PARENTS"] = parents_to_docbook(
                elem_name,
                parents,
                id_prefix,
                )

            in_text = open(in_file, "r").read()

            out_text = in_text
            for token in replacements.keys():
                out_text = re.sub(
                    r"<\$"+token+r"\$>",
                    replacements[token],
                    out_text,
                    )

            out = open(out_file, "w")
            out.write(out_text)
            out.close()
