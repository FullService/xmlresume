#!/bin/bash
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
SUPPORT_HOME="@SUPPORT_HOME@"
JAVACMD=java
MD5CMD=md5sum

# Ant's ClassLoader is... frail.  We set the classpath
# outside of Ant, save ourselves some heartache.
cp="/usr/java/j2sdk1.4.0_01/lib/tools.jar"
for jarfile in `ls -1 ${SUPPORT_HOME} | grep .jar`; do
	cp="${cp}:${SUPPORT_HOME}/${jarfile}"
done
for jarfile in `ls -1 ${SUPPORT_HOME}/ant/lib | grep .jar`; do
	cp="${cp}:${SUPPORT_HOME}/ant/lib/${jarfile}"
done
export CLASSPATH=$cp

# Add option for the CLASSPATH
ANT_OPTS="${ANT_OPTS} -cp ${CLASSPATH}"
ANT_OPTS="${ANT_OPTS} -Dant.home=${SUPPORT_HOME}/ant"

cd @WWW_ROOT_FS@/orc/incoming
for resume in `ls -1 | grep '^orc'`; 
do
   # If no lockfiles exist, create the .convert lockfile and convert
   if [ ! -e .UPLOAD.$resume -a ! -e .CONVERT.$resume ]; then

      # in case something goes wrong with the build, start a clean-start process
      (sleep 120 && rm -f .CONVERT.$resume) &
      touch .CONVERT.$resume
	cd $resume
	grep '^email =' user.props | cut -f 3 -d" " | ${MD5CMD} >> ../../users.md5
	(${JAVACMD} ${ANT_OPTS} org.apache.tools.ant.Main \
	-verbose -propertyfile user.props \
	-find build.xml dispatch >& ./out/antlog.txt \
	&& cd .. && mv $resume DONE/$resume && rm -f .CONVERT.$resume) &
    fi
done
