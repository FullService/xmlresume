#!/bin/sh
# convert.sh
# Contributed 2002 by Mark Miller (brandondoyle)
#
# A simple shell script (should be run on a cron)
# to convert each incoming resume and report back.  
# It's primarily a wrapper for Ant which takes care
# of setting the classpath and running Ant from each
# ./incoming/orc* directory.
# Ant isn't any good at loading classes itself.
#
# Should be run from ORC's root directory
#
########################################################

# You may need to change the following variables:
support_home="/home/groups/x/xm/xmlresume/resume-support"
ant_cmd="$supporthome/ant/ant"

# Ant's ClassLoader is... frail.  We set the classpath
# outside of Ant, save ourselves some heartache.
cp=""
cp="$cp:$support_home/fop.jar"
cp="$cp:$support_home/xerces.jar"
cp="$cp:$support_home/xalan.jar"
cp="$cp:$support_home/avalon-framework-cvs-20020315.jar"
cp="$cp:$support_home/batik.jar"
cp="$cp:$support_home/xmlresume-filter.jar"
export CLASSPATH=$cp

cd incoming
for resume in `ls -1 orc*`; 
do
  cd $resume
  $ant_cmd -verbose -propertyfile user.props \
	-find build.xml dispatch >> ./antlog.txt
  cd ..
done
