# Makefile
#
# Makefile for resumes
#
# Copyright (c) 2002, 2006 Bruce Christensen and Nicholas Shectman
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

#------------------------------------------------------------------------------
# To create example.html, example.txt, example.fo, and example.pdf from
# example.xml, with Italian localization and a4 paper size, use this command:
#
# 	gmake resume=example country=it papersize=a4
#
# To generate just the html version of cv.xml with UK localization, use this
# command:
#
# 	gmake cv.html country=uk
#
# To remove all generated files, run:
#
# 	gmake clean
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Basename (filename minus .xml extension) of resume to process
# For example, put "myresume" here to process "myresume.xml".
#------------------------------------------------------------------------------
resume ?= resume

#------------------------------------------------------------------------------
# Stylesheets
#------------------------------------------------------------------------------
# Options: br de fr it nl uk us es
country ?= us
# Options: letter for country=us, a4 for others
papersize ?= letter

xsl_base ?= http://xmlresume.sourceforge.net/xsl
#xsl_base = ../xsl
#xsl_base = ../src/www/xsl

html_style = $(xsl_base)/output/$(country)-html.xsl
text_style = $(xsl_base)/output/$(country)-text.xsl
fo_style = $(xsl_base)/output/$(country)-$(papersize).xsl
upgrade_13x_140_style = $(xsl_base)/misc/13x-140.xsl

#------------------------------------------------------------------------------
# Processing software
#------------------------------------------------------------------------------

xsl_proc = java org.apache.xalan.xslt.Process $(xsl_flags) -in $< -out $@ -xsl
#xsl_proc = java com.icl.saxon.StyleSheet $(xsl_flags) -o $@ $<

pdf_proc = java org.apache.fop.apps.Fop -fo $(fo_flags) $< -pdf $@ -q
#pdf_proc = ~/bin/xep/run.sh $(fo_flags) $< $@

# RTF generation currently requires you download a separate, closed source jar 
# file and add it to your java classpath: 	
# http://www.xmlmind.com/foconverter/downloadperso.shtml
rtf_proc = java com.xmlmind.fo.converter.Driver $< $@
#rtf_proc = java ch.codeconsult.jfor.main.CmdLineConverter $< $@

# Target filtering allows you to create targeted resumes.  
# You can create your own targets; just specify them in your resume.xml 
# file with the "targets" attribute.  In this example, the foodservice
# AND carpentry elements will be included in the output, but not the 
# elements targeted to other jobs.  Untargeted elements (those with no 
# "targets" attribute) are always included.  
# Take a look at example2.xml and try changing the filter targets to get a 
# feel for how the filter works.
includeTargets = "foodservice carpentry"

# Element and Attribute filtering allows you to REMOVE some parts of your
# resume.xml file prior to formatting-- in this example, all email addresses
# and references will hidden.  Attributes can be filtered out in the same way.
excludeElements = "email referees"
excludeAttributes = ""

# '-cp $(CLASSPATH)' looks redundant but is needed for cygwin
filter_proc = java -cp $(CLASSPATH) net.sourceforge.xmlresume.filter.Filter \
	-in $< -out $@ \
	-includeTargets $(includeTargets) \
	-excludeElements $(excludeElements) \
	-excludeAttributes $(excludeAttributes)

#------------------------------------------------------------------------------
# End configurable parameters
#------------------------------------------------------------------------------

# don't delete intermediate targets:
.SECONDARY:

all: $(resume).all
#%.all: %.html %.txt %.pdf %.rtf
%.all: %.html %.txt %.pdf
	
13x-140: $(resume).13x-140
%.13x-140: %-140.all
	
filter: $(resume).filter
%.filter: %-filtered.all
	
clean:
	$(RM) *.html *.txt *.fo *.rtf *.pdf *-filtered.xml *-140.xml

%.html: %.xml
	$(xsl_proc) $(html_style)

%.txt: %.xml
	$(xsl_proc) $(text_style)

%.fo: %.xml
	$(xsl_proc) $(fo_style)

%.pdf: %.fo
	$(pdf_proc)

%.rtf: %.fo
	$(rtf_proc)

%-140.xml: %.xml
	$(xsl_proc) $(upgrade_13x_140_style)

%-filtered.xml: %.xml
	$(filter_proc)
