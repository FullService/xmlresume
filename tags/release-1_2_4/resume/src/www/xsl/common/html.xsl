<?xml version="1.0"?>

<!--
html.xsl
Transform XML resume into HTML.

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
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>
  <xsl:output doctype-public="-//W3C//DTD HTML 4.0//EN"/>
  <xsl:strip-space elements="*"/>
  <xsl:preserve-space elements="address"/>

  <xsl:include href="params.xsl"/>

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
  <xsl:template match="header">
    <h1 class="nameHeading"><xsl:apply-templates select="name"/>
      <xsl:text> - </xsl:text>
      <xsl:value-of select="$resume.word"/>
    </h1>
      
    <!-- Your name, address, and stuff. -->
    <h2 class="contactHeading"><xsl:value-of select="$contact.word"/></h2>
    <p>
      <xsl:apply-templates select="name"/><br/>
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

  <xsl:template match="address">
    <xsl:choose>
      <!-- Compatibility with older resumes using US address schema -->
      <xsl:when test="street[following-sibling::*[1][self::city]]">
	<xsl:value-of select="street"/><br/> 
	<xsl:value-of select="city"/><xsl:text>, </xsl:text> 
	<xsl:value-of select="state"/><xsl:text> </xsl:text>
	<xsl:value-of select="zip"/> 
      </xsl:when>
      <!-- International (including US) addresses -->
      <xsl:otherwise>
	<xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Line break in an address -->
  <xsl:template match="break">
    <br/>
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
    <xsl:apply-templates select="achievements"/>
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
      <xsl:value-of select="subject"/>
      <xsl:text>, </xsl:text>
      <xsl:apply-templates select="date"/>
      <xsl:text>, </xsl:text>
      <xsl:value-of select="institution"/>
      <xsl:text>.</xsl:text>     
      <xsl:apply-templates select="annotation"/>
    </li>
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
    <xsl:apply-templates select="title"/>
    <xsl:apply-templates select="skills"/>
  </xsl:template>

  <xsl:template match="skillset/title">
    <h3 class="skillsetTitle"><xsl:value-of select="."/></h3>
  </xsl:template>

  <xsl:template match="skills">
    <ul class="skills">
      <xsl:apply-templates select="skill"/>
    </ul>
  </xsl:template>

  <xsl:template match="skill">
    <li class="skill">
      <xsl:apply-templates/>
    </li>
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
    </li>
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
    <cite class="bookTitle"><xsl:value-of select="."/></cite><xsl:value-of select="$pub.item.separator"/>
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
      <xsl:apply-templates select="name"/>.
      <xsl:value-of select="legalnotice"/>
    </address>
  </xsl:template>

  <!-- Put a space between first and last name -->
  <xsl:template match="name">
    <xsl:value-of select="firstname"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="surname"/>
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

</xsl:stylesheet>
