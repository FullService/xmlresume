<?xml version="1.0"?>

<!--
text.xsl
Transform XML resume into plain text.

Copyright (c) 2001 Vlad Korolev
Copyright (c) 2000 Sean Kelly

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
	 xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="text" omit-xml-declaration="yes" indent="no"/>
  <xsl:output doctype-public="-//W3C//DTD HTML 4.0//EN"/>
  <xsl:strip-space elements="*"/>
  <xsl:preserve-space elements="address break"/>

  <xsl:include href="params.xsl"/>

  <xsl:template match="/">
          <xsl:apply-templates select="resume/header/name" mode="title"/>
	  <xsl:apply-templates select="resume"/>
  </xsl:template>

  <!-- Some miscelaneous Templates that I need -->
  <xsl:template name="NewLine">
<xsl:text>
</xsl:text>
  </xsl:template>
  
  <xsl:template name="NSpace">
    <xsl:param name="n" select="0"/>
    <xsl:if test="$n &gt; 0">
    <xsl:text> </xsl:text>
    <xsl:call-template name="NSpace">
    <xsl:with-param name="n" select="$n - 1" />
    </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="Indent">
    <xsl:param name="Length" select="4"/>
    <xsl:param name="Text"/>

    <!-- Put Space -->
    <xsl:call-template name="NSpace">
	<xsl:with-param name="n" select="$Length"/>
    </xsl:call-template>

    <!-- Display One Line -->
    <xsl:choose>
    <xsl:when test="contains($Text,'&#xA;')">
      <xsl:value-of select="substring-before($Text,'&#xA;')"/>
      <xsl:call-template name="NewLine"/>
      <xsl:call-template name="Indent">
	  <xsl:with-param name="Length" select="$Length"/>
	  <xsl:with-param name="Text" select="substring-after($Text,'&#xA;')"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$Text"/>
    </xsl:otherwise>
    </xsl:choose>

    <!-- Continue with the rest -->
  </xsl:template>
  
  <xsl:template name="Center">
    <xsl:call-template name="NewLine"/>
    <xsl:param name="Width" select="80"/>
    <xsl:param name="Text" />
    <xsl:call-template name="NSpace">
    <xsl:with-param name="n" select="($Width - string-length($Text)) div 2" />
    </xsl:call-template>
    <xsl:value-of select="$Text"/>
    <xsl:call-template name="NewLine"/>
  </xsl:template>

  <xsl:template name="FormatParagraph" >
    <xsl:param name="Text"  />
    <xsl:param name="Width" select="20"/>
    <xsl:param name="CPos"  select="0" />

    <!-- Put as many words on the line as possible -->
    <!-- Do it till we run out of things -->
   <xsl:if test="$CPos=0">
    <xsl:call-template name="NewLine"/>
   </xsl:if>
   <xsl:if test="string-length($Text) > 0">
    <xsl:choose>
        <xsl:when test="contains($Text,' ')">
	    <xsl:variable name="Word" select="substring-before($Text,' ')"/>
               <xsl:value-of select="$Word"/>
	      <xsl:if test="(1 + $CPos + string-length($Word)) &gt; $Width">
                  <xsl:call-template name="FormatParagraph">
	            <xsl:with-param name="Text" select="substring-after($Text,' ')"/>
	            <xsl:with-param name="Width" select="$Width"/>
	            <xsl:with-param name="CPos" select="0"/>
	          </xsl:call-template>
              </xsl:if> 
	      <xsl:if test="($CPos + string-length($Word)) &lt; $Width">
                  <xsl:text> </xsl:text>  
                  <xsl:call-template name="FormatParagraph">
	            <xsl:with-param name="Text" select="substring-after($Text,' ')"/>
	            <xsl:with-param name="Width" select="$Width"/>
	            <xsl:with-param name="CPos" select="$CPos + string-length($Word) + 1"/>
	          </xsl:call-template>
	      </xsl:if>
	</xsl:when>
        <xsl:otherwise><xsl:value-of select="$Text"/></xsl:otherwise>
    </xsl:choose>
   </xsl:if>
 </xsl:template>


  <!-- Suppress the keywords in the main body of the document -->
  <xsl:template match="keywords"/>
  <xsl:template match="docpath"/>

  <xsl:template match="keyword">
    <xsl:value-of select="."/>
  <!--
    <xsl:if test="position() != last()">
      <xsl:text>, </xsl:text>
    </xsl:if> -->
  </xsl:template>

  <xsl:template name="pathItem">
    <xsl:param name="style">unknown</xsl:param>
    <span class="{$style}">
      <a>
        <xsl:attribute name="href">
          <xsl:value-of select="uri"/>
        </xsl:attribute>
        <xsl:value-of select="label"/>
      </a>
      <xsl:text> > </xsl:text>
    </span>
  </xsl:template>

  <xsl:template match="head">
    <xsl:call-template name="pathItem">
      <xsl:with-param name="style">navHome</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="node">
    <xsl:call-template name="pathItem">
      <xsl:with-param name="style">navItem</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="tail">
    <span class="navTerminal">
      <xsl:value-of select="."/>
    </span>
  </xsl:template>

  <xsl:template match="header">
    <!-- Your name, address, and stuff. -->
<xsl:value-of select="$contact.word"/><xsl:text>: </xsl:text>
<xsl:call-template name="NewLine"/>
      <xsl:apply-templates select="name"/><xsl:call-template name="NewLine"/>
      <xsl:apply-templates select="address"/><xsl:call-template name="NewLine"/>
<xsl:value-of select="$phone.word"/>: <xsl:value-of select="contact/phone"/><xsl:call-template name="NewLine"/>
<xsl:value-of select="$email.word"/>: <xsl:value-of select="contact/email"/><xsl:call-template name="NewLine"/>
  </xsl:template>
    <!-- Objective, with level 2 heading. -->
    <xsl:template match="objective">
    <xsl:call-template name="NewLine"/>
  <xsl:value-of select="$objective.word"/>
  <xsl:text>:</xsl:text>
  <xsl:call-template name="NewLine"/>
  <xsl:call-template name="Indent">
     <xsl:with-param name="Text">
      <xsl:apply-templates/>
     </xsl:with-param>
  </xsl:call-template>
  </xsl:template>

  <xsl:template match="address">
    <xsl:choose>
      <!-- Compatibility with older resumes using US address schema -->
      <xsl:when test="street[following-sibling::*[1][self::city]]">
	<xsl:value-of select="normalize-space(street)"/><xsl:call-template name="NewLine"/>
	<xsl:value-of select="normalize-space(city)"/>
	<xsl:text>, </xsl:text><xsl:value-of select="normalize-space(state)"/>
	<xsl:text> </xsl:text>
	<xsl:value-of select="normalize-space(zip)"/><xsl:call-template name="NewLine"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:variable name="text">
	  <xsl:apply-templates/>
	</xsl:variable>
	<xsl:value-of select="normalize-space($text)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="break">
    <xsl:text> / </xsl:text>
  </xsl:template>

  <!-- Past jobs, with level 2 heading. -->
  <xsl:template match="history">
    <xsl:call-template name="NewLine"/>
    <xsl:call-template name="NewLine"/>
    <xsl:value-of select="$history.word"/>
    <xsl:text>:</xsl:text>
    <xsl:call-template name="NewLine"/>
    <xsl:call-template name="Indent">
       <xsl:with-param name="Text">
          <xsl:apply-templates select="job"/>
       </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- Format each job -->
  <xsl:template match="job">
      <xsl:call-template name="NewLine"/>
      <xsl:apply-templates select="jobtitle"/>
      <xsl:call-template name="NewLine"/>
      <xsl:apply-templates select="employer"/>
      <xsl:call-template name="NewLine"/>
      <xsl:apply-templates select="period"/>
      <xsl:call-template name="NewLine"/>
      <xsl:apply-templates select="description"/>
      <xsl:call-template name="NewLine"/>
      <xsl:call-template name="NewLine"/>
  </xsl:template>
		
  <xsl:template match="period">
    <xsl:apply-templates select="from"/>-<xsl:apply-templates select="to"/>
  </xsl:template>

  <xsl:template match="date">
    <xsl:apply-templates select="month"/>
    <xsl:text> </xsl:text>
    <xsl:apply-templates select="year"/>
  </xsl:template>

  <xsl:template match="present"><xsl:value-of select="$present.word"/></xsl:template>

  <xsl:template match="year | month | jobtitle | employer | firstname | surname | title |
                       skill">
	<xsl:value-of select="."/>
  </xsl:template>

  <!-- Degrees and stuff -->
  <xsl:template match="academics">
    <xsl:call-template name="NewLine"/>
    <xsl:call-template name="NewLine"/>
    <xsl:value-of select="$academics.word"/>
    <xsl:text>:</xsl:text>
    <xsl:call-template name="NewLine"/>
    <xsl:call-template name="NewLine"/>
    <xsl:call-template name="Indent">
       <xsl:with-param name="Text">
         <xsl:apply-templates select="degrees"/>
         <xsl:apply-templates select="note"/>
       </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="degrees">
      <xsl:apply-templates select="degree"/>
      <xsl:apply-templates select="note"/>
  </xsl:template>

  <xsl:template match="note">
      <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="degree">
      <xsl:value-of select="level"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="$in.word"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="subject"/>
      <xsl:text>, </xsl:text>
      <xsl:apply-templates select="date"/>
      <xsl:text>, </xsl:text><xsl:call-template name="NewLine"/>
      <xsl:value-of select="institution"/>
      <xsl:text>.</xsl:text>
      <xsl:call-template name="NewLine"/>
      <xsl:apply-templates select="annotation"/>
      <xsl:call-template name="NewLine"/>
      <xsl:call-template name="NewLine"/>
  </xsl:template>

  <xsl:template match="institution">
	<xsl:text>    </xsl:text><xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="annotation">
	<xsl:text>-    </xsl:text><xsl:value-of select="normalize-space(.)"/>
  </xsl:template>

  <!-- Format the open-ended skills -->
  <xsl:template match="skillarea">
    <xsl:call-template name="NewLine"/>
    <xsl:call-template name="NewLine"/>
    <xsl:apply-templates select="title"/><xsl:text>:</xsl:text>
    <xsl:call-template name="NewLine"/>
    <xsl:call-template name="Indent">
      <xsl:with-param name="Text">
               <xsl:apply-templates select="skillset"/>
    	       <xsl:call-template name="NewLine"/>
      </xsl:with-param>
      <xsl:with-param name="Length" select="2"/>
    </xsl:call-template>
    <xsl:call-template name="NewLine"/>
    <xsl:call-template name="NewLine"/>
  </xsl:template>

  <xsl:template match="skillset">
    <xsl:call-template name="NewLine"/>
    <xsl:apply-templates select="title"/>
    <xsl:call-template name="Indent">
      <xsl:with-param name="Text">
        <xsl:call-template name="FormatParagraph">
            <xsl:with-param name="Text" >
        	<xsl:apply-templates select="skills"/>
            </xsl:with-param>
      	    <xsl:with-param name="Width" select="45"/>
        </xsl:call-template>     
       </xsl:with-param>
      <xsl:with-param name="Length" select="2"/>
    </xsl:call-template>
    <xsl:call-template name="NewLine"/>
    <xsl:call-template name="NewLine"/>
  </xsl:template>


  <xsl:template match="skills">
     <xsl:for-each select="skill">
      <xsl:value-of select="normalize-space(.)"/>
      <xsl:if test="not(position()=last())"><xsl:text>, </xsl:text></xsl:if>
     </xsl:for-each>
  </xsl:template>


  <!-- Format publications -->
  <xsl:template match="pubs">
    <xsl:call-template name="NewLine"/>
    <xsl:value-of select="$publications.word"/>
    <xsl:text>:</xsl:text>
    <xsl:call-template name="NewLine"/>
    <xsl:apply-templates select="pub"/>
    <xsl:call-template name="NewLine"/>
  </xsl:template>

  <xsl:template match="pub">
    <xsl:call-template name="Indent">
      <xsl:with-param name="Text">
        <xsl:call-template name="FormatParagraph">
	  <xsl:with-param name="Text">
	    <xsl:apply-templates select="author[position() != last()]" mode="internal"/>
	    <xsl:apply-templates select="author[position() = last()]" mode="final"/>
	    <xsl:apply-templates select="artTitle"/>
	    <xsl:apply-templates select="bookTitle"/>
	    <xsl:apply-templates select="publisher"/>
	    <xsl:apply-templates select="pubDate"/>
	    <xsl:apply-templates select="pageNums"/>
	    <xsl:apply-templates select="para"/>
	  </xsl:with-param>
	  <xsl:with-param name="Width" select="60"/>
	</xsl:call-template>
      </xsl:with-param>
      <xsl:with-param name="Length" select="4"/>
    </xsl:call-template>
    <xsl:call-template name="NewLine"/>
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

  <!-- Title of article -->
  <xsl:template match="artTitle">
    &quot;<xsl:value-of select="."/>&quot;<xsl:value-of select="$pub.item.separator"/>
  </xsl:template>

  <!-- Title of book -->
  <xsl:template match="bookTitle">
    <xsl:value-of select="."/><xsl:value-of select="$pub.item.separator"/>
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

  <!-- Format the misc info -->
  <xsl:template match="misc">
    <xsl:value-of select="$miscellany.word"/>:
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Format the legalese -->
  <xsl:template match="copyright">
      <xsl:value-of select="$copyright.word"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="year"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="$by.word"/>
      <xsl:text> </xsl:text>
      <xsl:apply-templates select="name"/>.
      <xsl:value-of select="legalnotice"/>
  </xsl:template>

  <!-- Center the Name on the first line -->
  <xsl:template match="name" mode="title">
   <xsl:call-template name="Center">
   <xsl:with-param name="Text">
    <xsl:value-of select="firstname"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="surname"/>
    <xsl:text>  - </xsl:text>
    <xsl:value-of select="$resume.word"/>
  </xsl:with-param>
   </xsl:call-template>
  </xsl:template>

  <xsl:template match="name">
    <xsl:apply-templates select="firstname"/>
    <xsl:text> </xsl:text>
    <xsl:apply-templates select="surname"/>
  </xsl:template>
  

  <!-- para -> p -->
  <xsl:template match="para">
      <!-- Format Paragraph -->
    <xsl:variable name="Text">
         <xsl:apply-templates/>
    </xsl:variable>
    <xsl:call-template name="FormatParagraph">
        <xsl:with-param name="Width" select="64"/>
        <xsl:with-param name="Text">
	   <xsl:value-of select="normalize-space($Text)"/>
        </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- emphasis -> strong -->
  <xsl:template match="emphasis">
  <xsl:value-of select="$text.emphasis.start"/>
  <xsl:value-of select="."/> 
  <xsl:value-of select="$text.emphasis.end"/>
  </xsl:template>

  <!-- url -> monospace along with href -->
  <xsl:template match="url">
        <xsl:value-of select="."/>
  </xsl:template>

  <!-- citation -> cite -->
  <xsl:template match="citation">
    <xsl:value-of select="."/>
  </xsl:template>

</xsl:stylesheet>
