#!/bin/sh
# propogate-translations.sh
#
# By Mark Miller, but he's not proud of it.
#
# This is a quick and VERY DIRTY way to add any new params defined
# in us.xsl (or $SOURCE) to the rest of the country.xsl stylesheets
# with a "TRANSLATION NEEDED" message.  
#
# IMPORTANT: After running this script, you must manually edit each 
# .xsl file and make sure that all the xsl:param tags are INSIDE the
# <xsl:stylesheet> tags.  This script does NOT do that for you.
#
# WARNING: This script is by no means fool-proof, and only included
# to make it slightly easier on developers.  Please manually edit
# each .xsl file after running to be sure that the script has not
# screwed anything up.

SOURCE=us.xsl

for country in `ls -1 *.xsl`; do 
  for param in `grep param $SOURCE | \
   		perl -p -e 's/.*name=\"(.*)\"\>.*\<\/xsl:param\>/$1/g`; 
  do
    translated=`grep -c $param $country`
    if [ "0" = $translated ]; 
    then 
      echo "  <xsl:param name=\"$param\">TRANSLATION NEEDED</xsl:param>" >> $country
    fi
  done
done
