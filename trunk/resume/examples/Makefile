# Makefile
#
# Makefile for resumes
#
# Copyright (c) 2000-2001 Sean Kelly
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
# 
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the
#    distribution.
# 
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#------------------------------------------------------------------------
# Replace this with the basename (no .xml extension) of your resume
# source file.  In this example, my resume is in "example.xml", so I
# put "example" here.
#
RESUME = example1
#
# Replace this with the country and paper size stylesheets you 
# wish to use.  Current choices for FO (which gives you PDF)
# are us-letter.xsl or uk-a4.xsl.  For HTML, choices include
# us-html.xsl or uk-html.xsl.  And for plain text, choose
# either us-text.xsl or uk-text.xsl.
#
FO_STYLE = http://xmlresume.sourceforge.net/xsl/us-letter.xsl
HTML_STYLE = http://xmlresume.sourceforge.net/xsl/us-html.xsl
TXT_STYLE = http://xmlresume.sourceforge.net/xsl/us-text.xsl
#
#------------------------------------------------------------------------

# End of configurable parameters.

.PHONY: all clean
.SUFFIXES: .html .fo .pdf .xml .xsl .txt

all:	$(RESUME).html $(RESUME).pdf $(RESUME).txt

clean:
	-rm -f $(RESUME).html $(RESUME).pdf $(RESUME).fo $(RESUME).txt *~

$(RESUME).html: $(RESUME).xml
	java org.apache.xalan.xslt.Process $(XSLFLAGS) -in $(RESUME).xml -xsl $(HTML_STYLE) -out $(RESUME).html

$(RESUME).txt: $(RESUME).xml
	java org.apache.xalan.xslt.Process $(XSLFLAGS) -in $(RESUME).xml -xsl $(TXT_STYLE) -out $(RESUME).txt

$(RESUME).fo: $(RESUME).xml
	java org.apache.xalan.xslt.Process $(XSLFLAGS) -in $(RESUME).xml -xsl $(FO_STYLE) -out $(RESUME).fo

$(RESUME).pdf: $(RESUME).fo
	java org.apache.fop.apps.Fop $(FOFLAGS) $(RESUME).fo $(RESUME).pdf

# The stylesheet also works great with XEP; uncomment and modify the
# below line for your XEP installation to give it a try.
#	java -cp "/xep/lib/JimiProClasses.zip;/xep/lib/xep.jar;/xep/lib/xerces-1.2.3.jar" -Dcom.renderx.FO2PDF.ROOT=/xep com.renderx.FO2PDF.Driver $(RESUME).fo
