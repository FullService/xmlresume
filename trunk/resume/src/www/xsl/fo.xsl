<?xml version="1.0" encoding="UTF-8"?>

<!--
pdf.xsl

Copyright (c) 2000-2001 Sean Kelly
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the
   distribution.

THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS
BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

$Id$
-->

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format">
  <xsl:output method="xml" omit-xml-declaration="no" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <!-- Format the document. -->
  <xsl:template match="/">
    <fo:root>
      <fo:layout-master-set>
	<!-- US Letter size paper. -->
        <fo:simple-page-master master-name="resume-page"
			       margin-top="1in"
			       margin-left="1in"
			       margin-right="1in"
			       margin-bottom="0in"
                               page-height="11in"
	                       page-width="8.5in">
	  <fo:region-body overflow="error-if-overflow"
			  margin-bottom="1in"/>
	  <fo:region-after overflow="error-if-overflow"
			   extent="1in"/>
        </fo:simple-page-master>
      </fo:layout-master-set>
      <fo:page-sequence master-name="resume-page">
        <!-- Running footer with person's name and page number. -->
	<fo:static-content flow-name="xsl-region-after">
	  <fo:block text-align="start" font-size="8pt"
		    font-family="serif">
	    <xsl:apply-templates select="resume/header/name"/>'s
	    R&#x00e9;sum&#x00e9; - page <fo:page-number/>
          </fo:block>
        </fo:static-content>

        <fo:flow flow-name="xsl-region-body">
	  <!-- Main text is indented 2in in from start side. -->
          <fo:block start-indent="2in"
		    font-family="serif"
		    font-size="10pt">
            <xsl:apply-templates select="resume"/>
          </fo:block>
        </fo:flow>
      </fo:page-sequence>
    </fo:root>
  </xsl:template>

  <!-- Callable template to format a heading: -->
  <!-- Call "heading" with parameter "text" being the text of the heading. -->
  <xsl:template name="heading">
    <xsl:param name="text">Heading Not Defined</xsl:param>
    <fo:block start-indent="0in"
	      font-family="sans-serif"
	      font-weight="bold"
	      space-after="10pt"
	      keep-with-next="always">
      <xsl:value-of select="$text"/>
    </fo:block>
  </xsl:template>

  <!-- Header information -->
  <xsl:template match="header">
    <fo:block>
      <fo:block font-weight="bold">
	<xsl:apply-templates select="name"/>
      </fo:block>
      <xsl:apply-templates select="address"/>
      <xsl:apply-templates select="contact"/>
    </fo:block>
  </xsl:template>

  <!-- Format a name in Western style, given then surname. -->
  <xsl:template match="name">
    <xsl:value-of select="firstname"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="surname"/>
  </xsl:template>

  <!-- Format US-style address. -->
  <xsl:template match="address">
    <fo:block>
      <fo:block><xsl:value-of select="street"/></fo:block>
      <fo:block>
	<xsl:value-of select="city"/>,
        <xsl:value-of select="state"/><xsl:text> </xsl:text><xsl:value-of select="zip"/>
      </fo:block>
    </fo:block>
  </xsl:template>

  <!-- Format contact information. -->
  <xsl:template match="contact">
    <fo:block>
      <fo:block>
	<fo:inline font-style="italic">Phone:</fo:inline>
	<xsl:text> </xsl:text>
	<xsl:value-of select="phone"/>
      </fo:block>
      <fo:block>
	<fo:inline font-style="italic">Email:</fo:inline>
	<xsl:text> </xsl:text>
	<xsl:value-of select="email"/>
      </fo:block>
      <fo:block>
	<fo:inline font-style="italic">URL:</fo:inline>
	<xsl:text> </xsl:text>
	<xsl:apply-templates select="url"/>
      </fo:block>
    </fo:block>
  </xsl:template>

  <!-- Format the objective with the heading "Professional Objective." -->
  <xsl:template match="objective">
    <xsl:call-template name="heading">
      <xsl:with-param name="text">Professional Objective</xsl:with-param>
    </xsl:call-template>
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Format the history with the heading "Employment History". -->
  <xsl:template match="history">
    <xsl:call-template name="heading">
      <xsl:with-param name="text">Employment History</xsl:with-param>
    </xsl:call-template>
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Format a single job. -->
  <xsl:template match="job">
    <fo:block>
      <fo:inline font-weight="bold"><xsl:value-of select="jobtitle"/></fo:inline>
      -
      <fo:inline font-style="italic"><xsl:value-of select="employer"/></fo:inline>
      -
      <fo:inline font-style="italic"><xsl:apply-templates select="period"/></fo:inline>
      <fo:block>
        <xsl:apply-templates select="description"/>
      </fo:block>
    </fo:block>
  </xsl:template>

  <!-- Format academics -->
  <xsl:template match="academics">
    <xsl:call-template name="heading">
      <xsl:with-param name="text">Academics</xsl:with-param>
    </xsl:call-template>
    <xsl:apply-templates select="degrees"/>
    <fo:block font-style="italic">
      <xsl:apply-templates select="note"/>
    </fo:block>
  </xsl:template>

  <!-- Format a single degree -->
  <xsl:template match="degree">
    <fo:block keep-with-next="always">
      <fo:inline font-weight="bold"><xsl:value-of select="level"/> in
        <xsl:value-of select="subject"/></fo:inline>,
      <xsl:apply-templates select="date"/>,
      <xsl:apply-templates select="annotation"/>
    </fo:block>
    <fo:block>
      <xsl:value-of select="institution"/>
    </fo:block>
  </xsl:template>

  <!-- Format a skill area's title and the skillsets underneath it. -->
  <xsl:template match="skillarea">
    <xsl:call-template name="heading">
      <xsl:with-param name="text"><xsl:value-of select="title"/></xsl:with-param>
    </xsl:call-template>
    <xsl:apply-templates select="skillset"/>
  </xsl:template>

  <!-- Format a skillset's title (if any) and then the skils underneath it. -->
  <xsl:template match="skillset">
    <xsl:apply-templates select="title"/>
    <xsl:apply-templates select="skills"/>
  </xsl:template>

  <!-- Format the title of a set of skills in italics. -->
  <xsl:template match="skillset/title">
    <fo:block font-style="italic">
      <xsl:value-of select="."/>
    </fo:block>
  </xsl:template>

  <!-- Format skills as a list of items. -->
  <xsl:template match="skills">
    <fo:list-block space-after="10pt"
		   provisional-distance-between-starts="10pt"
		   provisional-label-separation="10pt">
      <xsl:apply-templates select="skill"/>
    </fo:list-block>
  </xsl:template>

  <!-- Format a single skill as a bullet item. -->
  <xsl:template match="skill">
    <fo:list-item>
      <fo:list-item-label start-indent="2in"
			  end-indent="label-end()">
        <fo:block>&#x2022;</fo:block>
      </fo:list-item-label>
      <fo:list-item-body start-indent="body-start()">
        <fo:block>
          <xsl:value-of select="."/>
        </fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>

  <!-- Format the publications section. -->
  <xsl:template match="pubs">
    <xsl:call-template name="heading">
      <xsl:with-param name="text">Publications</xsl:with-param>
    </xsl:call-template>
    <xsl:apply-templates/>
  </xsl:template>
  
  <!-- Format miscellaneous information with "Miscellany" as the heading. -->
  <xsl:template match="misc">
    <xsl:call-template name="heading">
      <xsl:with-param name="text">Miscellany</xsl:with-param>
    </xsl:call-template>
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Format legalese. -->
  <xsl:template match="copyright">
    <fo:block>
      Copyright &#169; <xsl:value-of select="year"/>
      by <xsl:apply-templates select="/resume/header/name"/>.
      <xsl:apply-templates select="legalnotice"/>
    </fo:block>
  </xsl:template>

  <!-- Format para's as block objects with 10pt space after them. -->
  <xsl:template match="para">
    <fo:block space-after="10pt">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <!-- Format emphasized words in bold. -->
  <xsl:template match="emphasis">
    <fo:inline font-weight="bold">
      <xsl:value-of select="."/>
    </fo:inline>
  </xsl:template>

  <!-- Format citations to other works in italics. -->
  <xsl:template match="citation">
    <fo:inline font-style="italic">
      <xsl:value-of select="."/>
    </fo:inline>
  </xsl:template>

  <!-- Format a URL. -->
  <xsl:template match="url">
    <fo:inline font-family="monospace">
      <xsl:value-of select="."/>
    </fo:inline>
  </xsl:template>

  <!-- Format a period. -->
  <xsl:template match="period">
    <xsl:apply-templates select="from"/>-<xsl:apply-templates select="to"/>
  </xsl:template>

  <!-- Format a date. -->
  <xsl:template match="date">
    <xsl:value-of select="month"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="year"/>
  </xsl:template>

  <!-- In a date with just "present", format it as the word "present". -->
  <xsl:template match="present">Present</xsl:template>

  <!-- Suppress items not needed for print presentation -->
  <xsl:template match="docpath"/>
  <xsl:template match="keywords"/>
</xsl:stylesheet>
