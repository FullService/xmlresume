#!/bin/bash
# clean.sh
# Contributed 2002 by Mark Miller (brandondoyle)
#
# A simple shell script (should be run on a cron)
# to clean out the incoming directory.
# It's primarily a wrapper for Ant which takes care
# of setting the classpath.
# Ant isn't any good at loading classes itself.
#
# Should be run from ORC's root directory
#
########################################################

# You may need to change the following variables:
SUPPORT_HOME="@SUPPORT_HOME@"
JAVACMD=java

# Ant's ClassLoader is... frail.  We set the classpath
# outside of Ant, save ourselves some heartache.
cp="${SUPPORT_HOME}/fop.jar"
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

cd @WWW_ROOT_FS@/orc/
${JAVACMD} ${ANT_OPTS} org.apache.tools.ant.Main clean > cleanlog.txt
