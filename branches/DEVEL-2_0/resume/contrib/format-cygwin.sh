#!/bin/sh
#
# This is a cygwin-compatible shell script for formatting resumes
# contributed by Will Sargent <will_sargent@yahoo.com>
#

XALANDIR=D:/usr/xalan-j_2_3_1/bin

# Note that you need to download the FOP source code to have all the
# libraries.
FOPDIR=D:/usr/fop-0.20.3

CLASSPATH="$XALANDIR/xalan.jar;$XALANDIR/xercesImpl.jar;$FOPDIR/build/fop.jar;$FOPDIR/lib/batik.jar;$FOPDIR/lib/logkit-1.0.jar;$FOPDIR/lib/avalon-framework-4.0.jar"

java -cp $CLASSPATH org.apache.xalan.xslt.Process -in $1.xml -xsl http://xmlresume.sourceforge.net/xsl/us-html.xsl -out $1.html

java -cp $CLASSPATH org.apache.xalan.xslt.Process -in $1.xml -xsl http://xmlresume.sourceforge.net/xsl/us-letter.xsl -out $1.fo
java -cp $CLASSPATH org.apache.fop.apps.Fop $1.fo $1.pdf

