<?xml version="1.0"?>

<!--
text.xsl
Transform XML resume into plain text.

Copyright (c) 2000-2002 by Vlad Korolev and Sean Kelly

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

  <xsl:output method="text" omit-xml-declaration="yes" indent="no"
    encoding="UTF-8"/>
  <xsl:output doctype-public="-//W3C//DTD HTML 4.0//EN"/>
  <xsl:strip-space elements="*"/>

  <xsl:include href="params.xsl"/>
  <xsl:include href="address.xsl"/>
  <xsl:include href="pubs.xsl"/>

  <xsl:template match="/">
	  <xsl:apply-templates select="resume"/>
	  <xsl:call-template name="NewLine"/>
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
  
  <!-- Center a multi-line block of text -->
  <xsl:template name="CenterBlock">
    <xsl:param name="Width" select="80"/>
    <xsl:param name="Text" />
     <xsl:choose>
        <xsl:when test="contains($Text,'&#xA;')">
	  <xsl:call-template name="Center">
            <xsl:with-param name="Text" select="substring-before($Text,'&#xA;')"/>
	    <xsl:with-param name="Width" select="$Width"/>
	  </xsl:call-template>
          <xsl:call-template name="CenterBlock">
	     <xsl:with-param name="Width" select="$Width"/>
	     <xsl:with-param name="Text" select="substring-after($Text,'&#xA;')"/>
          </xsl:call-template>
       </xsl:when>
       <xsl:otherwise>
	  <xsl:call-template name="Center">
            <xsl:with-param name="Text" select="$Text"/>
	    <xsl:with-param name="Width" select="$Width"/>
          </xsl:call-template>
       </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Center a single line of text -->
  <xsl:template name="Center">
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
     <xsl:variable name="Word">
       <xsl:choose>
          <xsl:when test="contains($Text,' ')">
	    <xsl:value-of select="substring-before($Text,' ')"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="$Text"/>
	  </xsl:otherwise>
       </xsl:choose>
     </xsl:variable>

     <xsl:choose>
             <!-- If this word would cause the line to exceed $Width, -->
             <!-- start a new line instead.                           -->
       <xsl:when test="(1 + $CPos + string-length($Word)) &gt; $Width">
         <xsl:call-template name="FormatParagraph">
            <xsl:with-param name="Text" select="$Text"/>
            <xsl:with-param name="Width" select="$Width"/>
            <xsl:with-param name="CPos" select="0"/>
         </xsl:call-template>
       </xsl:when> 
	      <!-- otherwise, there's room on the current line -->
       <xsl:otherwise>
	 <xsl:if test="$CPos &gt; 0">
           <xsl:text> </xsl:text>  
	 </xsl:if>
         <xsl:value-of select="$Word"/>
         <xsl:call-template name="FormatParagraph">
	   <xsl:with-param name="Text" select="substring-after($Text,' ')"/>
	   <xsl:with-param name="Width" select="$Width"/>
	   <xsl:with-param name="CPos" select="$CPos + string-length($Word) + 1"/>
	 </xsl:call-template>
       </xsl:otherwise>
     </xsl:choose>
   </xsl:if>
 </xsl:template>

  <!-- Named template for formatting a generic bullet list item *SE* -->
  <xsl:template name="FormatBulletListItem" >
    <xsl:param name="Text"  />
    <xsl:param name="Width" select="20"/>
    <xsl:param name="CPos" select="0"/>

    <xsl:if test="$CPos=0">
      <xsl:call-template name="NewLine"/>
      <xsl:value-of select="$text.bullet.character"/>
      <xsl:text> </xsl:text>
    </xsl:if>

    <!-- Put as many words on the line as possible -->
    <!-- Do it till we run out of things -->
   <xsl:if test="string-length($Text) > 0">

     <xsl:variable name="Word">
       <xsl:choose>
          <xsl:when test="contains($Text,' ')">
            <xsl:value-of select="substring-before($Text,' ')"/>
          </xsl:when>
	     <!-- otherwise, this is the last word. -->
          <xsl:otherwise>
	    <xsl:value-of select="$Text"/>
          </xsl:otherwise>
       </xsl:choose>
     </xsl:variable>
     <xsl:choose>
	   <!-- If this word would exceed $Width, start a new line. -->
	<xsl:when test="(1 + $CPos + string-length($Word)) &gt; $Width">
           <xsl:call-template name="NewLine"/>
	   <xsl:text>  </xsl:text>
	   <xsl:call-template name="FormatBulletListItem">
	      <xsl:with-param name="Text" select="$Text"/>
	      <xsl:with-param name="Width" select="$Width"/>
	      <xsl:with-param name="CPos" select="2"/>
	   </xsl:call-template>
        </xsl:when> 
	      <!-- otherwise, there's room on the current line -->
	<xsl:otherwise>
	   <xsl:if test="$CPos &gt; 2">
              <xsl:text> </xsl:text>  
	   </xsl:if>
           <xsl:value-of select="$Word"/>
	   <xsl:variable name="NewPos" select="$CPos + string-length($Word) + 1"/>
	   <xsl:call-template name="FormatBulletListItem">
	      <xsl:with-param name="Text" select="substring-after($Text,' ')"/>
	      <xsl:with-param name="Width" select="$Width"/>
	      <xsl:with-param name="CPos" select="$NewPos"/>
	   </xsl:call-template>
        </xsl:otherwise>
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
    <xsl:choose>
    <xsl:when test="$header.format = 'centered'">
       <xsl:call-template name="centered.header"/>
    </xsl:when>
    <xsl:otherwise>
       <xsl:call-template name="standard.header"/>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="centered.header">
    <xsl:call-template name="Center">
      <xsl:with-param name="Text">
	<xsl:apply-templates select="name"/>
      </xsl:with-param>
    </xsl:call-template>

    <xsl:call-template name="CenterBlock">
      <xsl:with-param name="Text">
        <xsl:apply-templates select="address"/>
      </xsl:with-param>
    </xsl:call-template>

    <xsl:if test="contact/phone">
      <xsl:call-template name="Center">
      <xsl:with-param name="Text">
        <xsl:value-of select="$phone.word"/><xsl:text>: </xsl:text>
	<xsl:value-of select="contact/phone"/>
      </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="contact/email">
      <xsl:call-template name="Center">
      <xsl:with-param name="Text">
        <xsl:value-of select="$email.word"/><xsl:text>: </xsl:text> 
	<xsl:value-of select="contact/email"/>
      </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="contact/url">
      <xsl:call-template name="Center">
      <xsl:with-param name="Text">
        <xsl:value-of select="$url.word"/><xsl:text>: </xsl:text> 
	<xsl:value-of select="contact/url"/>
      </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="standard.header">
    <!-- Your name, address, and stuff. -->
   <xsl:call-template name="Center">
   <xsl:with-param name="Text">
      <xsl:apply-templates select="name"/>
      <xsl:text>  - </xsl:text>
      <xsl:value-of select="$resume.word"/>
   </xsl:with-param>
   </xsl:call-template>
<xsl:value-of select="$contact.word"/><xsl:text>: </xsl:text>
<xsl:call-template name="NewLine"/>
      <xsl:apply-templates select="name"/><xsl:call-template name="NewLine"/>
      <xsl:apply-templates select="address"/> 
      <xsl:call-template name="NewLine"/>

      <!-- Don't print phone/email labels if fields are empty. *SE -->
      <xsl:if test="contact/phone">
        <xsl:value-of select="$phone.word"/><xsl:text>: </xsl:text>
	<xsl:value-of select="contact/phone"/>
	<xsl:call-template name="NewLine"/>
      </xsl:if>
      <xsl:if test="contact/email">
        <xsl:value-of select="$email.word"/><xsl:text>: </xsl:text> 
	<xsl:value-of select="contact/email"/>
	<xsl:call-template name="NewLine"/>
      </xsl:if>
      <xsl:if test="contact/url">
        <xsl:value-of select="$url.word"/><xsl:text>: </xsl:text> 
	<xsl:value-of select="contact/url"/>
	<xsl:call-template name="NewLine"/>
      </xsl:if>
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
  <xsl:call-template name="NewLine"/>
  </xsl:template>

  <xsl:template match="address" mode="standard">
     <xsl:variable name="AdminDivision">
       <xsl:call-template name="AdminDivision"/>
     </xsl:variable>
     <xsl:variable name="CityDivision">
       <xsl:call-template name="CityDivision"/>
     </xsl:variable>
     <xsl:variable name="PostCode">
       <xsl:call-template name="PostCode"/>
     </xsl:variable>

     <xsl:value-of select="normalize-space(street)"/>
     <xsl:call-template name="NewLine"/>
     <xsl:if test="street2">
       <xsl:value-of select="normalize-space(street2)"/>
       <xsl:call-template name="NewLine"/>
     </xsl:if>
     <xsl:if test="string-length($CityDivision) &gt; 0">
       <xsl:value-of select="$CityDivision"/>
       <xsl:call-template name="NewLine"/>
     </xsl:if>
     <xsl:value-of select="normalize-space(city)"/>
     <xsl:if test="string-length($AdminDivision) &gt; 0">
       <xsl:text>, </xsl:text><xsl:value-of select="$AdminDivision"/>
     </xsl:if>
     <xsl:if test="string-length($PostCode) &gt; 0">
       <xsl:text> </xsl:text>
       <xsl:value-of select="$PostCode"/>
     </xsl:if> 
     <xsl:call-template name="NewLine"/>
     <xsl:if test="country">
       <xsl:value-of select="normalize-space(country)"/>
       <xsl:call-template name="NewLine"/>
     </xsl:if>
  </xsl:template>

  <xsl:template match="address" mode="european">

     <xsl:variable name="AdminDivision">
       <xsl:call-template name="AdminDivision"/>
     </xsl:variable>
     <xsl:variable name="CityDivision">
       <xsl:call-template name="CityDivision"/>
     </xsl:variable>
     <xsl:variable name="PostCode">
       <xsl:call-template name="PostCode"/>
     </xsl:variable>

     <xsl:value-of select="normalize-space(street)"/>
     <xsl:call-template name="NewLine"/>
     <xsl:if test="street2">
       <xsl:value-of select="normalize-space(street2)"/>
       <xsl:call-template name="NewLine"/>
     </xsl:if>
     <xsl:if test="string-length($CityDivision) &gt; 0">
       <xsl:value-of select="$CityDivision"/>
       <xsl:call-template name="NewLine"/>
     </xsl:if>
     <xsl:if test="string-length($PostCode) &gt; 0">
       <xsl:value-of select="$PostCode"/>
       <xsl:text> </xsl:text>
     </xsl:if>
     <xsl:value-of select="normalize-space(city)"/>
     <xsl:if test="string-length($AdminDivision) &gt; 0">
       <xsl:call-template name="NewLine"/>
       <xsl:value-of select="$AdminDivision"/>
     </xsl:if>
     <xsl:call-template name="NewLine"/>
     <xsl:if test="country">
       <xsl:value-of select="normalize-space(country)"/>
       <xsl:call-template name="NewLine"/>
     </xsl:if>
  </xsl:template>

  <xsl:template match="address" mode="italian">
     <xsl:value-of select="normalize-space(street)"/>
     <xsl:call-template name="NewLine"/>
     <xsl:if test="street2">
       <xsl:value-of select="normalize-space(street2)"/>
       <xsl:call-template name="NewLine"/>
     </xsl:if>
     <xsl:if test="postalCode">
       <xsl:value-of select="normalize-space(postalCode)"/>
       <xsl:text> </xsl:text>
     </xsl:if>
     <xsl:value-of select="normalize-space(city)"/>
     <xsl:if test="province">
       <xsl:text> (</xsl:text><xsl:value-of select="province"/><xsl:text>)</xsl:text>
     </xsl:if>
     <xsl:call-template name="NewLine"/>
     <xsl:if test="country">
       <xsl:value-of select="normalize-space(country)"/>
       <xsl:call-template name="NewLine"/>
     </xsl:if>
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
      <xsl:apply-templates select="achievements"/>
      <xsl:call-template name="NewLine"/>
      <xsl:call-template name="NewLine"/>
  </xsl:template>

  <!-- Format the achievements section as a bullet list *SE* -->
  <xsl:template match="achievements">
     <xsl:call-template name="NewLine"/>
     <xsl:apply-templates select="achievement"/>
  </xsl:template>

  <xsl:template match="achievement">
    <xsl:variable name="Text">
      <xsl:apply-templates/>
    </xsl:variable>
    <xsl:call-template name="FormatBulletListItem">
      <xsl:with-param name="Text">
        <xsl:value-of select="normalize-space($Text)"/>
      </xsl:with-param>
      <xsl:with-param name="Width" select="72"/>
    </xsl:call-template>
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

  <xsl:template match="year | month | jobtitle | employer | title |
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
  <xsl:template match="skillareas">
      <xsl:call-template name="NewLine"/>
      <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="skillarea">
      <xsl:call-template name="NewLine"/>
    <xsl:if test="title">
      <xsl:apply-templates select="title"/><xsl:text>:</xsl:text>
      <xsl:call-template name="NewLine"/>
    </xsl:if>
    <xsl:call-template name="Indent">
      <xsl:with-param name="Text">
               <xsl:apply-templates select="skillset"/>
      </xsl:with-param>
      <xsl:with-param name="Length" select="2"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="skillset">
    <xsl:choose>
      <xsl:when test="$skills.format = 'comma'">
        <xsl:apply-templates select="." mode="comma"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="." mode="comma"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="skillset" mode="comma">
    <xsl:call-template name="Indent">
      <xsl:with-param name="Text">
        <xsl:if test="title">
          <xsl:apply-templates select="title"/>
          <xsl:text>: </xsl:text>
        </xsl:if>
        <xsl:apply-templates select="skills" mode="comma"/>
       </xsl:with-param>
      <xsl:with-param name="Length" select="2"/>
    </xsl:call-template>
    <xsl:call-template name="NewLine"/>
  </xsl:template>

  <xsl:template match="skillset" mode="bullet">
    <xsl:if test="title">
      <xsl:call-template name="NewLine"/>
      <xsl:apply-templates select="title"/>
      <xsl:call-template name="NewLine"/>
    </xsl:if>
    <xsl:call-template name="Indent">
      <xsl:with-param name="Text">
        <xsl:apply-templates select="skills" mode="bullet"/>
       </xsl:with-param>
      <xsl:with-param name="Length" select="2"/>
    </xsl:call-template>
    <xsl:call-template name="NewLine"/>
  </xsl:template>

  <!-- Format individual skill as a bullet list -->
  <xsl:template match="skill" mode="bullet">
    <xsl:variable name="Text">
      <xsl:apply-templates/>
    </xsl:variable>
    <xsl:call-template name="FormatBulletListItem">
      <xsl:with-param name="Text">
        <xsl:value-of select="normalize-space($Text)"/>
      </xsl:with-param>
      <xsl:with-param name="Width" select="72"/>
    </xsl:call-template>
  </xsl:template>

	<!-- format as a comma-separated list -->
  <xsl:template match="skills" mode="comma">
    <span class="skills">
      <xsl:for-each select="skill[position() != last()]">
        <xsl:apply-templates/><xsl:text>, </xsl:text>
      </xsl:for-each>
      <xsl:apply-templates select="skill[position() = last()]"/>
    </span>
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
    <xsl:variable name="text">   
      <xsl:call-template name="formatPub"/>
    </xsl:variable>

    <xsl:call-template name="Indent">
      <xsl:with-param name="Text">
        <xsl:call-template name="FormatParagraph">
	  <xsl:with-param name="Text">
	     <xsl:value-of select="normalize-space($text)"/>
	  </xsl:with-param>
	  <xsl:with-param name="Width" select="72"/>
	</xsl:call-template>
      </xsl:with-param>
      <xsl:with-param name="Length" select="4"/>
    </xsl:call-template>
    <xsl:call-template name="NewLine"/>
  </xsl:template>

  <!-- Title of article -->
  <xsl:template match="artTitle">
      <!-- having the &quot; encodings outside of <xsl:text> instructions 
      caused odd formatting with extra newlines inserted. Not sure why
      but this fixes it. *SE* -->
    <xsl:text>&quot;</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>&quot;</xsl:text>
    <xsl:value-of select="$pub.item.separator"/>
    
  </xsl:template>

  <!-- Title of book -->
  <xsl:template match="bookTitle">
    <xsl:value-of select="."/><xsl:value-of select="$pub.item.separator"/>
  </xsl:template>

  <!-- Format memberships. -->
  <xsl:template match="memberships">
    <xsl:call-template name="NewLine"/>
    <xsl:value-of select="title"/>
    <xsl:text>:</xsl:text>
    <xsl:call-template name="NewLine"/>
    <xsl:call-template name="NewLine"/>
    <xsl:apply-templates select="membership"/>
  </xsl:template>

  <xsl:template match="membership">
    <xsl:call-template name="Indent">
      <xsl:with-param name="Text">
	<xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="NewLine"/>
    <xsl:call-template name="NewLine"/>
  </xsl:template>

  <xsl:template match="membership/title">
    <xsl:value-of select="."/>
    <xsl:if test="following-sibling::*">
      <xsl:text>, </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="membership/organization">
    <xsl:value-of select="."/>
    <xsl:if test="following-sibling::*">
      <xsl:text>, </xsl:text>
    </xsl:if>
  </xsl:template>

  <!-- Format the misc info -->
  <xsl:template match="misc">
    <xsl:call-template name="NewLine"/>
    <xsl:value-of select="$miscellany.word"/>:
    <xsl:variable name="Text">
         <xsl:apply-templates/>
    </xsl:variable>
    <xsl:call-template name="Indent">
       <xsl:with-param name="Text">
            <xsl:value-of select="$Text"/>
        </xsl:with-param>
     </xsl:call-template>
  </xsl:template>

  <!-- Format the legalese -->
  <xsl:template match="copyright">
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
      <xsl:value-of select="legalnotice"/>
  </xsl:template>

  <!-- Center the Name on the first line -->
  <xsl:template match="name" mode="title">
   <xsl:call-template name="Center">
   <xsl:with-param name="Text">
        <xsl:apply-templates/>
        <xsl:text>  - </xsl:text>
        <xsl:value-of select="$resume.word"/>
  </xsl:with-param>
   </xsl:call-template>
  </xsl:template>

  <xsl:template match="name">
    <xsl:apply-templates select="firstname"/>
    <xsl:text> </xsl:text>
    <xsl:if test="middlenames">
      <xsl:value-of select="middlenames"/>
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:apply-templates select="surname"/>
    <xsl:if test="suffix">
      <xsl:text> </xsl:text>
      <xsl:value-of select="suffix"/>
    </xsl:if>
  </xsl:template>
  

  <!-- para -> p -->
  <xsl:template match="para">
      <!-- Format Paragraph -->
    <xsl:variable name="Text">
         <xsl:apply-templates/>
    </xsl:variable>
    <xsl:call-template name="FormatParagraph">
        <xsl:with-param name="Width" select="72"/>
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
