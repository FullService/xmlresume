<?xml version="1.0"?>

<!--
html.xsl
Transform XML resume into HTML.

Copyright (c) 2000-2002 Sean Kelly
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

  <xsl:output method="html" omit-xml-declaration="yes" indent="yes"
    encoding="UTF-8" doctype-public="-//W3C//DTD HTML 4.0//EN"/>
  <xsl:strip-space elements="*"/>

  <xsl:include href="params.xsl"/>
  <xsl:include href="address.xsl"/>
  <xsl:include href="pubs.xsl"/>

  <xsl:template match="/">
    <html>
      <head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<title>
	  <xsl:apply-templates select="resume/header/name"/>
	  <xsl:text> - </xsl:text>
	  <xsl:value-of select="$resume.word"/>
	</title>
        <link rel="stylesheet" type="text/css">
	  <xsl:attribute name="href">
	    <xsl:value-of select="$css.href"/>
	  </xsl:attribute>
	</link>
        <xsl:apply-templates select="resume/keywords" mode="header"/>
      </head>
      <body class="resume">
	<xsl:apply-templates select="resume"/>
      </body>
    </html>
  </xsl:template>

  <!-- Suppress the keywords in the main body of the document -->
  <xsl:template match="keywords"/>

  <!-- But put them into the HTML header. -->
  <xsl:template match="keywords" mode="header">
    <meta name="keywords">
      <xsl:attribute name="content">
	<xsl:apply-templates select="keyword"/>
      </xsl:attribute>
    </meta>
  </xsl:template>

  <xsl:template match="keyword">
    <xsl:value-of select="."/>
    <xsl:if test="position() != last()">
      <xsl:text>, </xsl:text>
    </xsl:if>
  </xsl:template>

  <!-- The "docpath" is used on my website.  Just ignore it.  -->
  <xsl:template match="docpath">
    <div class="navbar">
      <xsl:apply-templates select="head"/>
      <xsl:apply-templates select="node"/>
      <xsl:apply-templates select="tail"/>
    </div>
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

  <!-- Output your name and the word "Resume". -->
  <xsl:template name="standard.header">
    <h1 class="nameHeading"><xsl:apply-templates select="name"/></h1>
    <p>
      <xsl:apply-templates select="address"/><br/>
      
      <!-- Don't print the label if the field value is empty *SE* -->
      <xsl:if test="contact/phone">
        <xsl:value-of select="$phone.word"/>: <xsl:value-of select="contact/phone"/><br/>
      </xsl:if>
      <xsl:if test="contact/email">
        <xsl:value-of select="$email.word"/>: <a>
          <xsl:attribute name="href">
            <xsl:text>mailto:</xsl:text>
            <xsl:value-of select="contact/email"/>
          </xsl:attribute>
          <xsl:value-of select="contact/email"/>
        </a><br/>
      </xsl:if>
      <xsl:if test="contact/url">
        <xsl:value-of select="$url.word"/>: <a>
          <xsl:attribute name="href">
            <xsl:value-of select="contact/url"/>
          </xsl:attribute>
          <xsl:value-of select="contact/url"/>
        </a>
      </xsl:if>
    </p>
  </xsl:template>

  <!-- Alternate formatting for the page header. -->
  <!-- Display the name and contact information in a single centered block. -->
  <!-- Since the 'align' attribute is deprecated, we rely on a CSS -->
  <!-- stylesheet to center the headerBlock. -->
  <xsl:template name="centered.header">
    <div class="headerBlock">
      <h1 class="nameHeading"><xsl:apply-templates select="name"/></h1>
      <xsl:apply-templates select="address"/><br/>
      <xsl:if test="contact/phone">
        <xsl:value-of select="$phone.word"/>: <xsl:value-of select="contact/phone"/><br/>
      </xsl:if>
      <xsl:if test="contact/email">
        <xsl:value-of select="$email.word"/>: <a>
          <xsl:attribute name="href">
            <xsl:text>mailto:</xsl:text>
            <xsl:value-of select="contact/email"/>
          </xsl:attribute>
          <xsl:value-of select="contact/email"/>
        </a><br/>
      </xsl:if>
      <xsl:if test="contact/url">
        <xsl:value-of select="$url.word"/>: <a>
          <xsl:attribute name="href">
            <xsl:value-of select="contact/url"/>
          </xsl:attribute>
          <xsl:value-of select="contact/url"/>
        </a>
      </xsl:if>
      </div>
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

     <xsl:value-of select="street"/><br/> 
     <xsl:if test="street2">
       <xsl:value-of select="street2"/><br/>
     </xsl:if>
     <xsl:if test="string-length($CityDivision) &gt; 0">
       <xsl:value-of select="$CityDivision"/><br/>
     </xsl:if>
     <xsl:value-of select="city"/>
     <xsl:if test="string-length($AdminDivision) &gt; 0">
       <xsl:text>, </xsl:text><xsl:value-of select="$AdminDivision"/>
     </xsl:if>
     <xsl:if test="string-length($PostCode) &gt; 0">
       <xsl:text> </xsl:text><xsl:value-of select="$PostCode"/> 
     </xsl:if>
     <xsl:if test="country">
       <br/><xsl:value-of select="country"/>
     </xsl:if>
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

     <xsl:value-of select="street"/><br/> 
     <xsl:if test="street2">
       <xsl:value-of select="street2"/><br/>
     </xsl:if>
     <xsl:if test="string-length($CityDivision) &gt; 0">
       <xsl:value-of select="$CityDivision"/><br/>
     </xsl:if>
     <xsl:if test="string-length($PostCode) &gt; 0">
       <xsl:value-of select="$PostCode"/><xsl:text> </xsl:text> 
     </xsl:if>
     <xsl:value-of select="city"/>
     <xsl:if test="string-length($AdminDivision) &gt; 0">
       <br/><xsl:value-of select="$AdminDivision"/>
     </xsl:if>
     <xsl:if test="country">
       <br/><xsl:value-of select="country"/>
     </xsl:if>
  </xsl:template>

  <xsl:template match="address" mode="italian">

     <xsl:value-of select="street"/><br/> 
     <xsl:if test="street2">
       <xsl:value-of select="street2"/><br/>
     </xsl:if>
     <xsl:if test="postalCode">
       <xsl:value-of select="postalCode"/><xsl:text> </xsl:text> 
     </xsl:if>
     <xsl:value-of select="city"/>
     <xsl:if test="province">
       <xsl:text> (</xsl:text><xsl:value-of select="province"/><xsl:text>)</xsl:text>
     </xsl:if>
     <xsl:if test="country">
       <br/><xsl:value-of select="country"/>
     </xsl:if>
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
	 <br/>
	 <xsl:call-template name="PreserveLinebreaks">
	   <xsl:with-param name="Text" select="substring-after($Text, '&#xA;')"/>
	 </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
         <xsl:value-of select="$Text"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Objective, with level 2 heading. -->
  <xsl:template match="objective">
    <h2 class="objectiveHeading"><xsl:value-of select="$objective.word"/></h2>
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Past jobs, with level 2 heading. -->
  <xsl:template match="history">
    <h2 class="historyHeading"><xsl:value-of select="$history.word"/></h2>
    <xsl:apply-templates select="job"/>
  </xsl:template>

  <!-- Format each job -->
  <xsl:template match="job">
    <p class="job">
      <span class="jobTitle">
        <xsl:value-of select="jobtitle"/>
      </span>
      <br/>
      <span class="employer">
        <xsl:value-of select="employer"/>
      </span>
      <br/>
      <xsl:apply-templates select="period"/>
    </p>
    <xsl:apply-templates select="description"/>
    <xsl:if test="projects/project">
      <xsl:value-of select="$projects.word"/>
      <xsl:apply-templates select="projects"/>
    </xsl:if>
    <xsl:if test="achievements/achievement">
      <xsl:value-of select="$achievements.word"/>
      <xsl:apply-templates select="achievements"/>
    </xsl:if>
  </xsl:template>
		
  <!-- Format the projects section as a bullet list -->
  <xsl:template match="projects">
    <ul>
      <xsl:for-each select="project">
        <li class="skill">
          <xsl:apply-templates/>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:template>

  <xsl:template match="period">
    <xsl:apply-templates select="from"/>-<xsl:apply-templates select="to"/>
  </xsl:template>

  <xsl:template match="date">
    <xsl:value-of select="month"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="year"/>
  </xsl:template>

  <xsl:template match="present"><xsl:value-of select="$present.word"/></xsl:template>

  <!-- Format the achievements section as a bullet list *SE* -->
  <xsl:template match="achievements">
    <ul>
      <xsl:for-each select="achievement">
        <li class="skill">
          <xsl:apply-templates/>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:template>

  <!-- Degrees and stuff -->
  <xsl:template match="academics">
    <h2 class="academicsHeading"><xsl:value-of select="$academics.word"/></h2>
    <xsl:apply-templates select="degrees"/>
    <xsl:apply-templates select="note"/>
  </xsl:template>

  <xsl:template match="degrees">
    <ul class="degrees">
      <xsl:apply-templates select="degree"/>
    </ul>
    <xsl:apply-templates select="note"/>
  </xsl:template>

  <xsl:template match="note">
    <div class="note">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="degree">
    <li class="degree">
      <acronym class="level">
        <xsl:value-of select="level"/>
      </acronym>
      <xsl:text> </xsl:text>
      <xsl:value-of select="$in.word"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="major"/>
      <xsl:text>, </xsl:text>
      <xsl:if test="date">
	<xsl:apply-templates select="date"/>
	<xsl:text>, </xsl:text>
      </xsl:if>
      <xsl:value-of select="institution"/>
      <xsl:text>.</xsl:text>     
      <xsl:if test="subjects/subject">
        <xsl:apply-templates select="subjects"/>
      </xsl:if>
      <xsl:apply-templates select="annotation"/>
    </li>
  </xsl:template>

  <!-- Format the subjects -->
  <xsl:template match="subjects">
    <table>
      <xsl:for-each select="subject">
        <tr>
          <td width="100"></td>
	  <td>
            <xsl:value-of select="title"/>
	  </td>
          <td width="10"></td>
	  <td>
            <xsl:value-of select="result"/>
	  </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <!-- Format the open-ended skills -->

  <xsl:template match="skillareas">
    <xsl:apply-templates select="skillarea"/>
  </xsl:template>

  <xsl:template match="skillarea">
    <h2 class="skillareaHeading"><xsl:value-of select="title"/></h2>
    <xsl:apply-templates select="skillset"/>
  </xsl:template>

  <xsl:template match="skillset">
    <xsl:choose>
      <xsl:when test="$skills.format = 'comma'">
	<p>
        <xsl:apply-templates select="title" mode="comma"/>
        <xsl:apply-templates select="skills" mode="comma"/>
	</p>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="title" mode="bullet"/>
        <xsl:apply-templates select="skills" mode="bullet"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="skillset/title" mode="comma">
    <span class="skillsetTitle">
      <xsl:value-of select="."/><xsl:text>: </xsl:text>
    </span>
  </xsl:template>

  <xsl:template match="skillset/title" mode="bullet">
    <h3 class="skillsetTitle"><xsl:value-of select="."/></h3>
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

        <!-- format as a bullet list -->
  <xsl:template match="skills" mode="bullet">
     <ul class="skills">
     <xsl:for-each select="skill">
        <li class="skill">
          <xsl:apply-templates/>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:template>


  <!-- Format publications -->
  <xsl:template match="pubs">
    <h2 class="pubsHeading"><xsl:value-of select="$publications.word"/></h2>
    <ul class="pubs">
      <xsl:apply-templates select="pub"/>
    </ul>
  </xsl:template>

  <!-- Format a single publication -->
  <xsl:template match="pub">
    <li class="pub">
      <xsl:call-template name="formatPub"/>
    </li>
  </xsl:template>

  <!-- Memberships, with level 2 heading. -->
  <xsl:template match="memberships">
    <h2 class="membershipsHeading"><xsl:value-of select="title"/></h2>
    <ul>
      <xsl:apply-templates select="membership"/>
    </ul>
  </xsl:template>

  <!-- A single membership. -->
  <xsl:template match="membership">
    <li>
      <xsl:if test="title">
        <span class="membershipTitle"><xsl:value-of select="title"/></span><br/>
      </xsl:if>
      <xsl:if test="organization">
        <span class="organization"><xsl:value-of select="organization"/></span><br/>
      </xsl:if>
      <xsl:if test="period">
	<xsl:apply-templates select="period"/><br/>
      </xsl:if>
      <xsl:apply-templates select="description"/>
    </li>
  </xsl:template>

  <!-- Format the misc info -->
  <xsl:template match="misc">
    <h2 class="miscHeading"><xsl:value-of select="$miscellany.word"/></h2>
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Format the legalese -->
  <xsl:template match="copyright">
    <address class="copyright">
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
    </address>
  </xsl:template>

  <!-- Put a space between first and last name -->
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

  <!-- para -> p -->
  <xsl:template match="para">
    <p class="para">
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <!-- emphasis -> strong -->
  <xsl:template match="emphasis">
    <strong class="emphasis"><xsl:value-of select="."/></strong>
  </xsl:template>

  <!-- url -> monospace along with href -->
  <xsl:template match="url">
    <code class="urlCode">
      <a class="urlA">
        <xsl:attribute name="href">
          <xsl:value-of select="."/>
	</xsl:attribute>
        <xsl:value-of select="."/>
      </a>
    </code>
  </xsl:template>

  <!-- citation -> cite -->
  <xsl:template match="citation">
    <cite class="citation"><xsl:value-of select="."/></cite>
  </xsl:template>

  <!-- Format the referees -->
  <xsl:template match="referees">
    <h2 class="refereesHeading"><xsl:value-of select="$referees.word"/></h2>
    <xsl:apply-templates select="referee"/>
  </xsl:template>

  <xsl:template match="referee">
    <h3 class="refereeHeading"><xsl:apply-templates select="name"/></h3>
    <p>
      <xsl:apply-templates select="address"/><br/>
      
      <!-- Don't print the label if the field value is empty *SE* -->
      <xsl:if test="contact/phone">
        <xsl:value-of select="$phone.word"/>: <xsl:value-of select="contact/phone"/><br/>
      </xsl:if>
      <xsl:if test="contact/email">
        <xsl:value-of select="$email.word"/>: <a>
          <xsl:attribute name="href">
            <xsl:text>mailto:</xsl:text>
            <xsl:value-of select="contact/email"/>
          </xsl:attribute>
          <xsl:value-of select="contact/email"/>
        </a><br/>
      </xsl:if>
      <xsl:if test="contact/url">
        <xsl:value-of select="$url.word"/>: <a>
          <xsl:attribute name="href">
            <xsl:value-of select="contact/url"/>
          </xsl:attribute>
          <xsl:value-of select="contact/url"/>
        </a>
      </xsl:if>
    </p>
  </xsl:template>

</xsl:stylesheet>
