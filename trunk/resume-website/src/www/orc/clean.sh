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
ANTCMD="${SUPPORT_HOME}/ant/ant"

# Load user-specific configuration
if [ -f "${HOME}/.antrc" ]; then 
	. "${HOME}/.antrc"
fi


# Ant's ClassLoader is... frail.  We set the classpath
# outside of Ant, save ourselves some heartache.
cp="${SUPPORT_HOME}/fop.jar"
for jarfile in `ls -1 ${SUPPORT_HOME} | grep .jar`; do
	cp="${cp}:${SUPPORT_HOME}/${jarfile}"
done
for jarfile in `ls -1 ${SUPPORT_HOME}/ant/lib | grep .jar`; do
	cp="${cp}:${SUPPORT_HOME}/${jarfile}"
done
export CLASSPATH=$cp

# Add option for the CLASSPATH
ANT_OPTS="${ANT_OPTS} -classpath ${LOCALCLASSPATH}"

cd @WWW_ROOT_FS@/orc/
${ANTCMD} clean > cleanlog.txt
