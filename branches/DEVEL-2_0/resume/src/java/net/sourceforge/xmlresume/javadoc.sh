#!/bin/sh
#
# Run javadoc with the specified command line options

mkdir ./doc
#javadoc -sourcepath ./\
#                -overview ./overview.html\
#                -d ./doc        \
#                -use                          \
#                -windowtitle 'XMLResume Category Filter API Specification'\
#                -doctitle 'XMLResume<sup><font size="-2">C</font>\
#                   </sup> API Specification'\
#                -header '<b>XMLResume </b><br>\
#                -bottom '<font size="-1">     \
#                <a href="http://xmlresume.sourceforge.net">\
#		http://xmlresume.sourceforge.net</a>'\
#                -J-Xmx180m                    \
#                @filelist

javadoc -sourcepath ./ -d ./doc \
	 -private \
	-windowtitle 'XMLResume Internal Java API Specification' \
         -doctitle 'XMLResume<sup><font size="-2">C</font>\
          </sup> API Specification'\
	*/*.java
echo "Creating compressed documentation file doc.tgz..."
tar zcf doc.tgz doc
echo "done."
