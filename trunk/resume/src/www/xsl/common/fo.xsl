<?xml version="1.0" encoding="UTF-8"?>

<!--
fo.xsl
Transform XML resume into XSL-FO, for formatting into PDF.

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

  <xsl:include href="params.xsl"/>
  <xsl:include href="address.xsl"/>

  <!-- Format the document. -->
  <xsl:template match="/">
    <fo:root>
      <fo:layout-master-set>
        <fo:simple-page-master master-name="resume-page"
	  margin-top="{$margin.top}"
	  margin-left="{$margin.left}"
	  margin-right="{$margin.right}"
	  margin-bottom="0in"
	  page-height="{$page.height}"
	  page-width="{$page.width}">
	  <fo:region-body overflow="error-if-overflow"
	    margin-bottom="{$margin.bottom}"/>
	  <fo:region-after overflow="error-if-overflow"
	    extent="{$margin.bottom}"/>
        </fo:simple-page-master>
      </fo:layout-master-set>
      <fo:page-sequence master-name="resume-page">
        <!-- Running footer with person's name and page number. -->
	<fo:static-content flow-name="xsl-region-after">
	  <fo:block text-align="start" font-size="{$footer.font.size}"
	    font-family="{$footer.font.family}">
	    <xsl:apply-templates select="resume/header/name"/>
	    <xsl:text> - </xsl:text>
	    <xsl:value-of select="$resume.word"/>
	    <xsl:text> - </xsl:text>
	    <xsl:value-of select="$page.word"/>
	    <xsl:text> </xsl:text>
	    <fo:page-number/>
          </fo:block>
        </fo:static-content>

        <fo:flow flow-name="xsl-region-body">
	  <!-- Main text is indented from start side. -->
          <fo:block start-indent="{$body.indent}"
	    font-family="{$body.font.family}"
	    font-size="{$body.font.size}">
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
    <fo:block start-indent="{$heading.indent}"
      font-family="{$heading.font.family}"
      font-weight="{$heading.font.weight}"
      space-before="{$para.break.space}"
      space-after="{$para.break.space}"
      keep-with-next="always">
      <xsl:value-of select="$text"/>
    </fo:block>
  </xsl:template>

  <!-- Header information -->
  <xsl:template match="header">
    <fo:block>
      <fo:block font-weight="{$header.name.font.weight}">
	<xsl:apply-templates select="name"/>
      </fo:block>
      <xsl:apply-templates select="address"/>
      <xsl:apply-templates select="contact"/>
    </fo:block>
  </xsl:template>

  <!-- Format a name in Western style, given then surname  -->
  <!-- (plus middle and suffix if defined).                -->
  <xsl:template match="name">
    <xsl:value-of select="firstname"/>
    <xsl:text> </xsl:text>
    <xsl:if test="middlenames">
      <xsl:value-of select="middlenames"/>
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:value-of select="surname"/>
    <xsl:if test="suffix">
      <xsl:text> </xsl:text>
      <xsl:value-of select="suffix"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="address" mode="standard">

     <!-- templates defined in address.xsl for setting standard fields -->
     <xsl:variable name="AdminDivision">
       <xsl:call-template name="AdminDivision"/>
     </xsl:variable>
     <xsl:variable name="CityDivision">
       <xsl:call-template name="CityDivision"/>
     </xsl:variable>
     <xsl:variable name="PostCode">
       <xsl:call-template name="PostCode"/>
     </xsl:variable>

     <fo:block>
       <fo:block><xsl:value-of select="street"/></fo:block>
       <xsl:if test="street2">
         <fo:block><xsl:value-of select="street2"/></fo:block>
       </xsl:if>
       <xsl:if test="string-length($CityDivision) &gt; 0">
         <fo:block><xsl:value-of select="$CityDivision"/></fo:block>
       </xsl:if>
       <fo:block>
         <xsl:value-of select="city"/>
	 <xsl:if test="string-length($AdminDivision) &gt; 0">
	    <xsl:text>, </xsl:text><xsl:value-of select="$AdminDivision"/>
	 </xsl:if>
	 <xsl:if test="string-length($PostCode) &gt; 0">
	    <xsl:text> </xsl:text><xsl:value-of select="$PostCode"/>
	 </xsl:if>
	</fo:block>
	<xsl:if test="country">
	   <fo:block>
	   <xsl:value-of select="country"/>
	   </fo:block>
	</xsl:if>
      </fo:block>
   </xsl:template>

  <xsl:template match="address" mode="european">

     <!-- templates defined in address.xsl for setting standard fields -->
     <xsl:variable name="AdminDivision">
       <xsl:call-template name="AdminDivision"/>
     </xsl:variable>
     <xsl:variable name="CityDivision">
       <xsl:call-template name="CityDivision"/>
     </xsl:variable>
     <xsl:variable name="PostCode">
       <xsl:call-template name="PostCode"/>
     </xsl:variable>

     <fo:block>
       <fo:block><xsl:value-of select="street"/></fo:block>
       <xsl:if test="street2">
         <fo:block><xsl:value-of select="street2"/></fo:block>
       </xsl:if>
       <xsl:if test="string-length($CityDivision) &gt; 0">
         <fo:block><xsl:value-of select="$CityDivision"/></fo:block>
       </xsl:if>
       <fo:block>
	 <xsl:if test="string-length($PostCode) &gt; 0">
	    <xsl:value-of select="$PostCode"/><xsl:text> </xsl:text>
	 </xsl:if>
         <xsl:value-of select="city"/>
	</fo:block>
	 <xsl:if test="string-length($AdminDivision) &gt; 0">
	    <fo:block>
	    <xsl:value-of select="$AdminDivision"/>
	    </fo:block>
	 </xsl:if>
	 <xsl:if test="country">
	    <fo:block>
	    <xsl:value-of select="country"/>
	    </fo:block>
	 </xsl:if>
      </fo:block>
   </xsl:template>

  <xsl:template match="address" mode="italian">

     <fo:block>
       <fo:block><xsl:value-of select="street"/></fo:block>
       <xsl:if test="street2">
         <fo:block><xsl:value-of select="street2"/></fo:block>
       </xsl:if>
       <fo:block>
	 <xsl:if test="postalCode">
	    <xsl:value-of select="postalCode"/><xsl:text> </xsl:text>
	 </xsl:if>
         <xsl:value-of select="city"/>
	 <xsl:if test="province">
	    <xsl:text> (</xsl:text><xsl:value-of select="province"/>
	    <xsl:text>)</xsl:text>
	 </xsl:if>
	</fo:block>
	 <xsl:if test="country">
	    <fo:block>
	    <xsl:value-of select="country"/>
	    </fo:block>
	 </xsl:if>
      </fo:block>
   </xsl:template>

  <!-- Preserve line breaks within a free format address -->
  <xsl:template match="address//text()">
    <xsl:call-template name="PreserveLinebreaks">
      <xsl:with-param name="Text" select="."/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="PreserveLinebreaks">
    <xsl:param name="Text"/>
    <xsl:choose>
      <xsl:when test="contains($Text, '&#xA;')">
         <xsl:value-of select="substring-before($Text, '&#xA;')"/>
	 <fo:block/>
	 <xsl:call-template name="PreserveLinebreaks">
	   <xsl:with-param name="Text" select="substring-after($Text, '&#xA;')"/>
	 </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
         <xsl:value-of select="$Text"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>



  <!-- Named template to format a single contact field *SE* -->
  <!-- Don't print the label if the field value is empty *SE* -->
  <xsl:template name="contact">
      <xsl:param name="label"/>
      <xsl:param name="field"/>
      <xsl:if test="string-length($field) > 0">
        <fo:block>
	  <fo:inline font-style="{$header.item.font.style}"><xsl:value-of select="$label"/>:</fo:inline>
	  <xsl:text> </xsl:text>
	  <xsl:value-of select="$field"/>
        </fo:block>
      </xsl:if>
  </xsl:template>

  <!-- Format contact information. -->

  <xsl:template match="contact">
    <fo:block space-after="{$para.break.space}">
      <xsl:call-template name="contact">
         <xsl:with-param name="field" select="phone"/>
         <xsl:with-param name="label" select="$phone.word"/>
      </xsl:call-template>
      <xsl:call-template name="contact">
         <xsl:with-param name="field" select="email"/>
         <xsl:with-param name="label" select="$email.word"/>
      </xsl:call-template>
      <xsl:call-template name="contact">
         <xsl:with-param name="field" select="url"/>
         <xsl:with-param name="label" select="$url.word"/>
      </xsl:call-template>
    </fo:block>
  </xsl:template>

  <!-- Format the objective with the heading "Professional Objective." -->
  <xsl:template match="objective">
    <xsl:call-template name="heading">
      <xsl:with-param name="text"><xsl:value-of select="$objective.word"/></xsl:with-param>
    </xsl:call-template>
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Format the history with the heading "Employment History". -->
  <xsl:template match="history">
    <xsl:call-template name="heading">
      <xsl:with-param name="text"><xsl:value-of select="$history.word"/></xsl:with-param>
    </xsl:call-template>
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Format a single job. -->
  <xsl:template match="job">
    <fo:block>
      <fo:inline font-weight="bold"><xsl:value-of select="jobtitle"/></fo:inline>
      <xsl:text> </xsl:text><xsl:value-of select="$bullet.glyph"/><xsl:text> </xsl:text>
      <fo:inline font-style="italic"><xsl:value-of select="employer"/></fo:inline>
      <xsl:text> </xsl:text><xsl:value-of select="$bullet.glyph"/><xsl:text> </xsl:text>
      <fo:inline font-style="italic"><xsl:apply-templates select="period"/></fo:inline>
      <xsl:if test="description">
        <fo:block>
          <xsl:apply-templates select="description"/>
        </fo:block>
      </xsl:if>
      <xsl:if test="achievements/achievement">
        <fo:block>
          <xsl:apply-templates select="achievements"/>
        </fo:block>
      </xsl:if>
    </fo:block>
  </xsl:template>

  <!-- Format the achievements section as a bullet list *SE* -->
  <xsl:template match="achievements">
    <fo:list-block space-after="{$para.break.space}"
      provisional-distance-between-starts="{$para.break.space}"
      provisional-label-separation="{$bullet.space}">
      <xsl:for-each select="achievement">
        <xsl:call-template name="bulletListItem"/>
      </xsl:for-each>
    </fo:list-block>
  </xsl:template>

  <!-- Format academics -->
  <xsl:template match="academics">
    <xsl:call-template name="heading">
      <xsl:with-param name="text"><xsl:value-of select="$academics.word"/></xsl:with-param>
    </xsl:call-template>
    <xsl:apply-templates select="degrees"/>
    <fo:block font-style="italic">
      <xsl:apply-templates select="note"/>
    </fo:block>
  </xsl:template>

  <!-- Format a single degree -->
  <xsl:template match="degree">
    <fo:block keep-with-next="always">
      <fo:inline font-weight="bold"><xsl:value-of select="level"/>
	<xsl:text> </xsl:text><xsl:value-of select="$in.word"/>
	<xsl:text> </xsl:text>
        <xsl:value-of select="subject"/></fo:inline>,
      <xsl:apply-templates select="date"/>,
      <xsl:apply-templates select="annotation"/>
    </fo:block>
    <fo:block>
      <xsl:value-of select="institution"/>
    </fo:block>
  </xsl:template>

  <!-- Format a skill area's title and the skillsets underneath it. -->
  <xsl:template match="skillareas">
    <xsl:apply-templates select="skillarea"/>
  </xsl:template>

  <xsl:template match="skillarea">
    <xsl:call-template name="heading">
      <xsl:with-param name="text"><xsl:value-of select="title"/></xsl:with-param>
    </xsl:call-template>
    <xsl:apply-templates select="skillset"/>
  </xsl:template>

  <!-- Format a skillset's title (if any) and then the skils underneath it. -->
  <xsl:template match="skillset">
    <xsl:choose>
      <xsl:when test="$skills.format = 'comma'">
        <fo:block space-after="{$para.break.space}">
        <xsl:apply-templates select="title" mode="comma"/>
        <xsl:apply-templates select="skills" mode="comma"/>
	</fo:block>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="title" mode="bullet"/>
        <xsl:apply-templates select="skills" mode="bullet"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="skillset/title" mode="comma">
    <fo:inline font-style="italic">
      <xsl:value-of select="."/><xsl:text>: </xsl:text>
    </fo:inline>
  </xsl:template>

  <!-- Format skills as a comma separated list. -->
  <xsl:template match="skills" mode="comma">
    <xsl:for-each select="skill[position() != last()]">
      <xsl:apply-templates/><xsl:text>, </xsl:text>
    </xsl:for-each>
    <xsl:apply-templates select="skill[position() = last()]"/>
  </xsl:template>

  <!-- Format the title of a set of skills in italics. -->
  <xsl:template match="skillset/title" mode="bullet">
    <fo:block font-style="italic">
      <xsl:value-of select="."/>
    </fo:block>
  </xsl:template>

  <!-- Format skills as a bullet list. -->
  <xsl:template match="skills" mode="bullet">
    <fo:list-block space-after="{$para.break.space}"
      provisional-distance-between-starts="{$para.break.space}"
      provisional-label-separation="{$bullet.space}">
      <xsl:apply-templates select="skill" mode="bullet"/>
    </fo:list-block>
  </xsl:template>

  <!-- Format a single bullet and its text -->
  <xsl:template name="bulletListItem">
    <fo:list-item>
      <fo:list-item-label start-indent="{$body.indent}"
	end-indent="label-end()">
        <fo:block><xsl:value-of select="$bullet.glyph"/></fo:block>
      </fo:list-item-label>
      <fo:list-item-body start-indent="body-start()">
        <fo:block>
          <xsl:apply-templates/>
        </fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>

  <!-- Format a single skill as a bullet item. -->
  <xsl:template match="skill" mode="bullet">
    <xsl:call-template name="bulletListItem"/>
  </xsl:template>

  <!-- Format the publications section. -->
  <xsl:template match="pubs">
    <xsl:call-template name="heading">
      <xsl:with-param name="text"><xsl:value-of select="$publications.word"/></xsl:with-param>
    </xsl:call-template>
    <fo:list-block space-after="{$para.break.space}"
      provisional-distance-between-starts="{$para.break.space}"
      provisional-label-separation="{$bullet.space}">
      <xsl:apply-templates select="pub"/>
    </fo:list-block>
  </xsl:template>
  
  <!-- Format a single publication -->
  <xsl:template match="pub">
    <fo:list-item>
      <fo:list-item-label start-indent="{$body.indent}"
	end-indent="label-end()">
	<fo:block><xsl:value-of select="$bullet.glyph"/></fo:block>
      </fo:list-item-label>
      <fo:list-item-body start-indent="body-start()">
	<fo:block>
	  <!-- Format each author, putting separator characters betwixt. -->
	  <xsl:apply-templates select="author[position() != last()]" mode="internal"/>
	  <xsl:apply-templates select="author[position() = last()]" mode="final"/>
	  <!-- Format the other components of a publication. -->
	  <xsl:apply-templates select="artTitle"/>
	  <xsl:apply-templates select="bookTitle"/>
	  <xsl:apply-templates select="publisher"/>
	  <xsl:apply-templates select="pubDate"/>
	  <xsl:apply-templates select="pageNums"/>
	  <!-- And for those using free-form paragraphs, format those, too. -->
	  <xsl:apply-templates select="para"/>
	</fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>

  <!-- Format the all but the last author -->
  <xsl:template match="author" mode="internal">
    <xsl:value-of select="."/><xsl:value-of select="$pub.author.separator"/>
  </xsl:template>

  <!-- Format the last author whose name doesn't end in a period.
  NOTE: This prevents a format like "Fish, X.." from appearing, but
  only when the pub.item.separator is a ".", otherwise it just leaves
  out the pub.item.separator.  Does anyone know how we can test for
  $pub.item.separator instead of '.'? -->
  <xsl:template match="author[substring(text(), string-length(text()))='.']" mode="final">
    <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>

  <!-- Format the last author -->
  <xsl:template match="author" mode="final">
    <xsl:value-of select="."/><xsl:value-of select="$pub.item.separator"/>
  </xsl:template>

  <!-- Title of article -->
  <xsl:template match="artTitle">
    <xsl:value-of select="."/><xsl:value-of select="$pub.item.separator"/>
  </xsl:template>

  <!-- Title of book -->
  <xsl:template match="bookTitle">
    <fo:inline font-style="italic"><xsl:value-of select="."/></fo:inline><xsl:value-of select="$pub.item.separator"/>
  </xsl:template>

  <!-- Publisher with a following publication date. -->
  <xsl:template match="publisher[following-sibling::pubDate]">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Publisher without pub date -->
  <xsl:template match="publisher">
    <xsl:apply-templates/><xsl:value-of select="$pub.item.separator"/>
  </xsl:template>

  <!-- Format the publication date -->
  <xsl:template match="pubDate">
    <xsl:value-of select="month"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="year"/>
    <xsl:value-of select="$pub.item.separator"/>
  </xsl:template>

  <!-- Format the page numbers of the journal in which the article appeared -->
  <xsl:template match="pageNums">
    <xsl:value-of select="."/><xsl:value-of select="$pub.item.separator"/>
  </xsl:template>

  <!-- Format miscellaneous information with "Miscellany" as the heading. -->
  <xsl:template match="misc">
    <xsl:call-template name="heading">
      <xsl:with-param name="text"><xsl:value-of select="$miscellany.word"/></xsl:with-param>
    </xsl:call-template>
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Format legalese. -->
  <xsl:template match="copyright">
    <fo:block>
      <xsl:value-of select="$copyright.word"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="year"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="$by.word"/>
      <xsl:text> </xsl:text>
      <xsl:if test="name">
        <xsl:apply-templates select="name"/>
      </xsl:if>
      <xsl:if test="not(name)">
        <xsl:apply-templates select="/resume/header/name"/>
      </xsl:if>
      <xsl:text>. </xsl:text>
      <xsl:apply-templates select="legalnotice"/>
    </fo:block>
  </xsl:template>

  <!-- Format para's as block objects with 10pt space after them. -->
  <xsl:template match="para">
    <fo:block space-after="{$para.break.space}">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <!-- Format emphasized words in bold. -->
  <xsl:template match="emphasis">
    <fo:inline font-weight="{$emphasis.font.weight}">
      <xsl:value-of select="."/>
    </fo:inline>
  </xsl:template>

  <!-- Format citations to other works in italics. -->
  <xsl:template match="citation">
    <fo:inline font-style="{$citation.font.style}">
      <xsl:value-of select="."/>
    </fo:inline>
  </xsl:template>

  <!-- Format a URL. -->
  <xsl:template match="url">
    <fo:inline font-family="{$url.font.family}">
      <xsl:value-of select="."/>
    </fo:inline>
  </xsl:template>

  <!-- Format a period. -->
  <xsl:template match="period">
    <xsl:apply-templates select="from"/>&#x2013;<xsl:apply-templates select="to"/>
  </xsl:template>

  <!-- Format a date. -->
  <xsl:template match="date">
    <xsl:value-of select="month"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="year"/>
  </xsl:template>

  <!-- In a date with just "present", format it as the word "present". -->
  <xsl:template match="present"><xsl:value-of select="$present.word"/></xsl:template>

  <!-- Suppress items not needed for print presentation -->
  <xsl:template match="docpath"/>
  <xsl:template match="keywords"/>
</xsl:stylesheet>
