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
         xmlns:r="http://xmlresume.sourceforge.net/resume/0.0"
	 xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="text" omit-xml-declaration="yes" indent="no"
    encoding="UTF-8"/>
  <xsl:output doctype-public="-//W3C//DTD HTML 4.0//EN"/>
  <xsl:strip-space elements="*"/>

  <xsl:include href="params.xsl"/>
  <xsl:include href="address.xsl"/>
  <xsl:include href="pubs.xsl"/>

  <xsl:include href="string.xsl"/>

  <xsl:template match="/">
	  <xsl:apply-templates select="r:resume"/>
	  <xsl:call-template name="NewLine"/>
  </xsl:template>

  <!-- Suppress the keywords in the main body of the document -->
  <xsl:template match="r:keywords"/>
  <xsl:template match="r:docpath"/>

  <xsl:template match="r:keyword">
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
          <xsl:value-of select="r:uri"/>
        </xsl:attribute>
        <xsl:value-of select="r:label"/>
      </a>
      <xsl:text> > </xsl:text>
    </span>
  </xsl:template>

  <xsl:template match="r:head">
    <xsl:call-template name="pathItem">
      <xsl:with-param name="style">navHome</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="r:node">
    <xsl:call-template name="pathItem">
      <xsl:with-param name="style">navItem</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="r:tail">
    <span class="navTerminal">
      <xsl:value-of select="."/>
    </span>
  </xsl:template>

  <xsl:template match="r:header">
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
	<xsl:apply-templates select="r:name"/>
      </xsl:with-param>
    </xsl:call-template>

    <xsl:call-template name="CenterBlock">
      <xsl:with-param name="Text">
        <xsl:apply-templates select="r:address"/>
      </xsl:with-param>
    </xsl:call-template>

    <xsl:if test="contact/phone">
      <xsl:call-template name="Center">
      <xsl:with-param name="Text">
        <xsl:value-of select="$phone.word"/><xsl:text>: </xsl:text>
	<xsl:value-of select="r:contact/r:phone"/>
      </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="r:contact/r:email">
      <xsl:call-template name="Center">
      <xsl:with-param name="Text">
        <xsl:value-of select="$email.word"/><xsl:text>: </xsl:text> 
	<xsl:value-of select="r:contact/r:email"/>
      </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="r:contact/r:url">
      <xsl:call-template name="Center">
      <xsl:with-param name="Text">
        <xsl:value-of select="$url.word"/><xsl:text>: </xsl:text> 
	<xsl:value-of select="r:contact/r:url"/>
      </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="standard.header">
    <!-- Your name, address, and stuff. -->
   <xsl:call-template name="Center">
   <xsl:with-param name="Text">
      <xsl:apply-templates select="r:name"/>
      <xsl:text>  - </xsl:text>
      <xsl:value-of select="$resume.word"/>
   </xsl:with-param>
   </xsl:call-template>
<xsl:value-of select="$contact.word"/><xsl:text>: </xsl:text>
<xsl:call-template name="NewLine"/>
      <xsl:apply-templates select="r:name"/><xsl:call-template name="NewLine"/>
      <xsl:apply-templates select="r:address"/> 
      <xsl:call-template name="NewLine"/>

      <!-- Don't print phone/email labels if fields are empty. *SE -->
      <xsl:if test="contact/phone">
        <xsl:value-of select="$phone.word"/><xsl:text>: </xsl:text>
	<xsl:value-of select="r:contact/r:phone"/>
	<xsl:call-template name="NewLine"/>
      </xsl:if>
      <xsl:if test="r:contact/r:email">
        <xsl:value-of select="$email.word"/><xsl:text>: </xsl:text> 
	<xsl:value-of select="r:contact/r:email"/>
	<xsl:call-template name="NewLine"/>
      </xsl:if>
      <xsl:if test="r:contact/r:url">
        <xsl:value-of select="$url.word"/><xsl:text>: </xsl:text> 
	<xsl:value-of select="r:contact/r:url"/>
	<xsl:call-template name="NewLine"/>
      </xsl:if>
  </xsl:template>

    <!-- Objective, with level 2 heading. -->
    <xsl:template match="r:objective">
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

  <xsl:template match="r:address" mode="standard">
     <xsl:variable name="AdminDivision">
       <xsl:call-template name="AdminDivision"/>
     </xsl:variable>
     <xsl:variable name="CityDivision">
       <xsl:call-template name="CityDivision"/>
     </xsl:variable>
     <xsl:variable name="PostCode">
       <xsl:call-template name="PostCode"/>
     </xsl:variable>

     <xsl:for-each select="r:street">
       <xsl:value-of select="normalize-space(.)"/>
       <xsl:call-template name="NewLine"/>
     </xsl:for-each>
     <xsl:if test="r:street2">
       <xsl:value-of select="normalize-space(r:street2)"/>
       <xsl:call-template name="NewLine"/>
     </xsl:if>
     <xsl:if test="string-length($CityDivision) &gt; 0">
       <xsl:value-of select="$CityDivision"/>
       <xsl:call-template name="NewLine"/>
     </xsl:if>
     <xsl:value-of select="normalize-space(r:city)"/>
     <xsl:if test="string-length($AdminDivision) &gt; 0">
       <xsl:text>, </xsl:text><xsl:value-of select="$AdminDivision"/>
     </xsl:if>
     <xsl:if test="string-length($PostCode) &gt; 0">
       <xsl:text> </xsl:text>
       <xsl:value-of select="$PostCode"/>
     </xsl:if> 
     <xsl:call-template name="NewLine"/>
     <xsl:if test="r:country">
       <xsl:value-of select="normalize-space(r:country)"/>
       <xsl:call-template name="NewLine"/>
     </xsl:if>
  </xsl:template>

  <xsl:template match="r:address" mode="european">

     <xsl:variable name="AdminDivision">
       <xsl:call-template name="AdminDivision"/>
     </xsl:variable>
     <xsl:variable name="CityDivision">
       <xsl:call-template name="CityDivision"/>
     </xsl:variable>
     <xsl:variable name="PostCode">
       <xsl:call-template name="PostCode"/>
     </xsl:variable>

     <xsl:for-each select="r:street">
       <xsl:value-of select="normalize-space(.)"/>
       <xsl:call-template name="NewLine"/>
     </xsl:for-each>
     <xsl:if test="r:street2">
       <xsl:value-of select="normalize-space(r:street2)"/>
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
     <xsl:value-of select="normalize-space(r:city)"/>
     <xsl:if test="string-length($AdminDivision) &gt; 0">
       <xsl:call-template name="NewLine"/>
       <xsl:value-of select="$AdminDivision"/>
     </xsl:if>
     <xsl:call-template name="NewLine"/>
     <xsl:if test="r:country">
       <xsl:value-of select="normalize-space(r:country)"/>
       <xsl:call-template name="NewLine"/>
     </xsl:if>
  </xsl:template>

  <xsl:template match="r:address" mode="italian">
     <xsl:for-each select="r:street">
       <xsl:value-of select="normalize-space(.)"/>
       <xsl:call-template name="NewLine"/>
     </xsl:for-each>
     <xsl:if test="r:street2">
       <xsl:value-of select="normalize-space(r:street2)"/>
       <xsl:call-template name="NewLine"/>
     </xsl:if>
     <xsl:if test="r:postalCode">
       <xsl:value-of select="normalize-space(r:postalCode)"/>
       <xsl:text> </xsl:text>
     </xsl:if>
     <xsl:value-of select="normalize-space(r:city)"/>
     <xsl:if test="r:province">
       <xsl:text> (</xsl:text><xsl:value-of select="r:province"/><xsl:text>)</xsl:text>
     </xsl:if>
     <xsl:call-template name="NewLine"/>
     <xsl:if test="r:country">
       <xsl:value-of select="normalize-space(r:country)"/>
       <xsl:call-template name="NewLine"/>
     </xsl:if>
  </xsl:template>

  <!-- Past jobs, with level 2 heading. -->
  <xsl:template match="r:history">
    <xsl:call-template name="NewLine"/>
    <xsl:call-template name="NewLine"/>
    <xsl:value-of select="$history.word"/>
    <xsl:text>:</xsl:text>
    <xsl:call-template name="NewLine"/>
    <xsl:call-template name="Indent">
       <xsl:with-param name="Text">
          <xsl:apply-templates select="r:job"/>
       </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- Format each job -->
  <xsl:template match="r:job">
      <xsl:call-template name="NewLine"/>
      <xsl:apply-templates select="r:jobtitle"/>
      <xsl:call-template name="NewLine"/>
      <xsl:apply-templates select="r:employer"/>
      <xsl:call-template name="NewLine"/>
      <xsl:apply-templates select="r:period"/>
      <xsl:call-template name="NewLine"/>
      <xsl:apply-templates select="r:description"/>
      <xsl:if test="r:projects/r:project">
        <xsl:apply-templates select="r:projects"/>
      </xsl:if>
      <xsl:if test="r:achievements/r:achievement">
        <xsl:apply-templates select="r:achievements"/>
      </xsl:if>
      <xsl:call-template name="NewLine"/>
      <xsl:call-template name="NewLine"/>
  </xsl:template>

  <!-- format the job description -->
  <xsl:template match="r:description">
      <xsl:apply-templates/>
      <xsl:call-template name="NewLine"/>
  </xsl:template>

  <!-- Format the projects section as a bullet list -->
  <xsl:template match="r:projects">
     <xsl:call-template name="NewLine"/><xsl:value-of select="$projects.word"/>
     <xsl:call-template name="NewLine"/>
     <xsl:apply-templates select="r:project"/>
  </xsl:template>

  <xsl:template match="r:project">
    <xsl:variable name="Text">
      <xsl:apply-templates/>
    </xsl:variable>
    <xsl:call-template name="FormatBulletListItem">
      <xsl:with-param name="Text">
        <xsl:value-of select="normalize-space($Text)"/>
      </xsl:with-param>
      <xsl:with-param name="Width" select="64"/>
    </xsl:call-template>
  </xsl:template>

  <!-- Format the achievements section as a bullet list *SE* -->
  <xsl:template match="r:achievements">
     <xsl:if test="string-length($achievements.word) > 0">
       <xsl:call-template name="NewLine"/><xsl:value-of select="$achievements.word"/>
     </xsl:if>
     <xsl:call-template name="NewLine"/>
     <xsl:apply-templates select="r:achievement"/>
  </xsl:template>

  <xsl:template match="r:achievement">
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
		
  <xsl:template match="r:period">
    <xsl:apply-templates select="r:from"/>-<xsl:apply-templates select="r:to"/>
  </xsl:template>

  <xsl:template match="r:date">
    <xsl:apply-templates select="r:month"/>
    <xsl:text> </xsl:text>
    <xsl:apply-templates select="r:year"/>
  </xsl:template>

  <xsl:template match="r:present"><xsl:value-of select="$present.word"/></xsl:template>

  <xsl:template match="r:year | r:month | r:jobtitle | r:employer | r:title |
                       r:skill">
	<xsl:value-of select="."/>
  </xsl:template>

  <!-- Degrees and stuff -->
  <xsl:template match="r:academics">
    <xsl:call-template name="NewLine"/>
    <xsl:call-template name="NewLine"/>
    <xsl:value-of select="$academics.word"/>
    <xsl:text>:</xsl:text>
    <xsl:call-template name="NewLine"/>
    <xsl:call-template name="NewLine"/>
    <xsl:call-template name="Indent">
       <xsl:with-param name="Text">
         <xsl:apply-templates select="r:degrees"/>
         <xsl:apply-templates select="r:note"/>
       </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="r:degrees">
      <xsl:apply-templates select="r:degree"/>
      <xsl:apply-templates select="r:note"/>
  </xsl:template>

  <xsl:template match="r:note">
      <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="r:degree">
      <xsl:value-of select="r:level"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="$in.word"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="r:major"/>
      <xsl:if test="r:date">     
         <xsl:text>, </xsl:text>
         <xsl:apply-templates select="r:date"/>
      </xsl:if>
      <xsl:if test="r:institution">
        <xsl:text>, </xsl:text>
        <xsl:value-of select="r:institution"/>
      </xsl:if>
      <xsl:call-template name="NewLine"/>
      <xsl:apply-templates select="r:annotation"/>
      <xsl:call-template name="NewLine"/>
      <xsl:call-template name="NewLine"/>
  </xsl:template>

  <xsl:template match="r:institution">
	<xsl:text>    </xsl:text><xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="r:annotation">
	<xsl:text>-    </xsl:text><xsl:value-of select="normalize-space(.)"/>
  </xsl:template>

  <!-- Format the open-ended skills -->
  <xsl:template match="r:skillareas">
      <xsl:call-template name="NewLine"/>
      <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="r:skillarea">
      <xsl:call-template name="NewLine"/>
    <xsl:if test="r:title">
      <xsl:apply-templates select="r:title"/><xsl:text>:</xsl:text>
      <xsl:call-template name="NewLine"/>
    </xsl:if>
    <xsl:call-template name="Indent">
      <xsl:with-param name="Text">
               <xsl:apply-templates select="r:skillset"/>
      </xsl:with-param>
      <xsl:with-param name="Length" select="2"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="r:skillset">
    <xsl:choose>
      <xsl:when test="$skills.format = 'comma'">
        <xsl:apply-templates select="." mode="comma"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="." mode="bullet"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

    <!-- format a skillset as comma-separated lists.  Need to use -->
    <!-- FormatParagraph so long lists wrap onto multiple lines.  -->
  <xsl:template match="r:skillset" mode="comma">
    <xsl:call-template name="Indent">
      <xsl:with-param name="Text">
	<xsl:call-template name="FormatParagraph">
          <xsl:with-param name="Text">
        <xsl:if test="r:title">
          <xsl:apply-templates select="r:title"/>
          <xsl:text>: </xsl:text>
        </xsl:if>
        <xsl:apply-templates select="r:skills" mode="comma"/>
       </xsl:with-param>
      <xsl:with-param name="Width" select="72"/>
      </xsl:call-template>
      </xsl:with-param>
      <xsl:with-param name="Length" select="2"/>
    </xsl:call-template>
    <xsl:call-template name="NewLine"/>
  </xsl:template>

  <xsl:template match="r:skillset" mode="bullet">
    <xsl:if test="r:title">
      <xsl:call-template name="NewLine"/>
      <xsl:apply-templates select="r:title"/>
      <xsl:call-template name="NewLine"/>
    </xsl:if>
    <xsl:call-template name="Indent">
      <xsl:with-param name="Text">
        <xsl:apply-templates select="r:skills" mode="bullet"/>
       </xsl:with-param>
      <xsl:with-param name="Length" select="2"/>
    </xsl:call-template>
    <xsl:call-template name="NewLine"/>
  </xsl:template>

  <!-- Format individual skill as a bullet list -->
  <xsl:template match="r:skill" mode="bullet">
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
  <xsl:template match="r:skills" mode="comma">
    <span class="skills">
      <xsl:for-each select="r:skill[position() != last()]">
        <xsl:apply-templates/><xsl:text>, </xsl:text>
      </xsl:for-each>
      <xsl:apply-templates select="r:skill[position() = last()]"/>
    </span>
  </xsl:template>


  <!-- Format publications -->
  <xsl:template match="r:pubs">
    <xsl:call-template name="NewLine"/>
    <xsl:value-of select="$publications.word"/>
    <xsl:text>:</xsl:text>
    <xsl:call-template name="NewLine"/>
    <xsl:apply-templates select="r:pub"/>
    <xsl:call-template name="NewLine"/>
  </xsl:template>

  <xsl:template match="r:pub">
    <xsl:variable name="text">   
      <xsl:call-template name="r:formatPub"/>
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
  <xsl:template match="r:artTitle">
      <!-- having the &quot; encodings outside of <xsl:text> instructions 
      caused odd formatting with extra newlines inserted. Not sure why
      but this fixes it. *SE* -->
    <xsl:text>&quot;</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>&quot;</xsl:text>
    <xsl:value-of select="$pub.item.separator"/>
    
  </xsl:template>

  <!-- Title of book -->
  <xsl:template match="r:bookTitle">
    <xsl:value-of select="."/><xsl:value-of select="$pub.item.separator"/>
  </xsl:template>

  <!-- Format memberships. -->
  <xsl:template match="r:memberships">
    <xsl:call-template name="NewLine"/>
    <xsl:value-of select="r:title"/>
    <xsl:text>:</xsl:text>
    <xsl:call-template name="NewLine"/>
    <xsl:call-template name="NewLine"/>
    <xsl:apply-templates select="r:membership"/>
  </xsl:template>

  <xsl:template match="r:membership">
    <xsl:call-template name="Indent">
      <xsl:with-param name="Text">
	<xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="NewLine"/>
    <xsl:call-template name="NewLine"/>
  </xsl:template>

  <xsl:template match="r:membership/r:title">
    <xsl:value-of select="."/>
    <xsl:if test="following-sibling::*">
      <xsl:text>, </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="r:membership/r:organization">
    <xsl:value-of select="."/>
    <xsl:if test="following-sibling::*">
      <xsl:text>, </xsl:text>
    </xsl:if>
  </xsl:template>

  <!-- Format the misc info -->
  <xsl:template match="r:misc">
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
  <xsl:template match="r:copyright">
      <xsl:value-of select="$copyright.word"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="r:year"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="$by.word"/>
      <xsl:text> </xsl:text>
      <xsl:if test="r:name">
        <xsl:apply-templates select="r:name"/>
      </xsl:if>
      <xsl:if test="not(r:name)">
        <xsl:apply-templates select="/r:resume/r:header/r:name"/>
      </xsl:if>
      <xsl:text>. </xsl:text>
      <xsl:value-of select="r:legalnotice"/>
  </xsl:template>

  <!-- Center the Name on the first line -->
  <xsl:template match="r:name" mode="title">
   <xsl:call-template name="Center">
   <xsl:with-param name="Text">
        <xsl:apply-templates/>
        <xsl:text>  - </xsl:text>
        <xsl:value-of select="$resume.word"/>
  </xsl:with-param>
   </xsl:call-template>
  </xsl:template>

  <xsl:template match="r:name">
    <xsl:apply-templates select="r:firstname"/>
    <xsl:text> </xsl:text>
    <xsl:if test="r:middlenames">
      <xsl:value-of select="r:middlenames"/>
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:apply-templates select="r:surname"/>
    <xsl:if test="r:suffix">
      <xsl:text> </xsl:text>
      <xsl:value-of select="r:suffix"/>
    </xsl:if>
  </xsl:template>
  

  <!-- para -> p -->
  <xsl:template match="r:para">
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
  <xsl:template match="r:emphasis">
  <xsl:value-of select="$text.emphasis.start"/>
  <xsl:value-of select="."/> 
  <xsl:value-of select="$text.emphasis.end"/>
  </xsl:template>

  <!-- url -> monospace along with href -->
  <xsl:template match="r:url">
        <xsl:value-of select="."/>
  </xsl:template>

  <!-- citation -> cite -->
  <xsl:template match="r:citation">
    <xsl:value-of select="."/>
  </xsl:template>

  <!-- Format the referees -->
  <xsl:template match="r:referees">
    <xsl:call-template name="NewLine"/>
    <xsl:call-template name="NewLine"/>
    <xsl:value-of select="$referees.word"/>
    <xsl:text>:</xsl:text>
    <xsl:call-template name="NewLine"/>
    <xsl:call-template name="NewLine"/>
    <xsl:call-template name="Indent">
       <xsl:with-param name="Text">
         <xsl:apply-templates select="r:referee"/>
       </xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="NewLine"/>
  </xsl:template>

  <xsl:template match="r:referee">
    <!-- Your name, address, and stuff. -->
      <xsl:apply-templates select="r:name"/><xsl:call-template name="NewLine"/>
      <xsl:apply-templates select="r:address"/><xsl:call-template name="NewLine"/>

      <!-- Don't print phone/email labels if fields are empty. *SE -->
      <xsl:if test="r:contact/r:phone">
        <xsl:value-of select="$phone.word"/><xsl:text>: </xsl:text>
	<xsl:value-of select="r:contact/r:phone"/>
	<xsl:call-template name="NewLine"/>
      </xsl:if>
      <xsl:if test="r:contact/r:email">
        <xsl:value-of select="$email.word"/><xsl:text>: </xsl:text> 
	<xsl:value-of select="r:contact/r:email"/>
	<xsl:call-template name="NewLine"/>
      </xsl:if>
      <xsl:if test="r:contact/r:url">
        <xsl:value-of select="$url.word"/><xsl:text>: </xsl:text> 
	<xsl:value-of select="r:contact/r:url"/>
	<xsl:call-template name="NewLine"/>
      </xsl:if>
      <xsl:call-template name="NewLine"/>
   </xsl:template>

</xsl:stylesheet>
