<?xml version="1.0"?>

<!--
html.xsl

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

  <xsl:template match="/">
    <html>
      <head>
	<title>
	  <xsl:apply-templates select="resume/header/name"/>'s Resume
	</title>
        <!-- This is just used on my website; ignore it. -->
        <link rel="stylesheet" type="text/css" href="../../../std.css"/>
        <xsl:apply-templates select="resume/keywords" mode="header"/>
      </head>
      <body>
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

  <!-- Output your name and the word "Resume" with acute accents. -->
  <xsl:template match="header">
    <h1><xsl:apply-templates select="name"/>'s 
      <xsl:text disable-output-escaping="yes">
        R&amp;eacute;sum&amp;eacute;
      </xsl:text>
    </h1>
      
    <!-- Your name, address, and stuff. -->
    <h2>Contact Information</h2>
    <p>
      <xsl:apply-templates select="name"/><br/>
      <xsl:value-of select="address/street"/><br/>
      <xsl:value-of select="address/city"/>
      <xsl:text>, </xsl:text>
      <xsl:value-of select="address/state"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="address/zip"/><br/>
      Telephone: <xsl:value-of select="contact/phone"/><br/>
      Email: <a>
        <xsl:attribute name="href">
          <xsl:text>mailto:</xsl:text>
          <xsl:value-of select="contact/email"/>
        </xsl:attribute>
        <xsl:value-of select="contact/email"/>
      </a>
    </p>
  </xsl:template>

  <!-- Objective, with level 2 heading. -->
  <xsl:template match="objective">
    <h2>Professional Objective</h2>
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Past jobs, with level 2 heading. -->
  <xsl:template match="history">
    <h2>Employment History</h2>
    <xsl:apply-templates select="job"/>
  </xsl:template>

  <!-- Format each job -->
  <xsl:template match="job">
    <p>
      <span class="jobTitle">
        <xsl:value-of select="jobtitle"/>
      </span>
      <br/>
      <xsl:value-of select="employer"/>
      <br/>
      <xsl:apply-templates select="period"/>
    </p>
    <xsl:apply-templates select="description"/>
  </xsl:template>
		
  <xsl:template match="period">
    <xsl:apply-templates select="from"/>-<xsl:apply-templates select="to"/>
  </xsl:template>

  <xsl:template match="date">
    <xsl:value-of select="month"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="year"/>
  </xsl:template>

  <xsl:template match="present">Present</xsl:template>

  <!-- Degrees and stuff -->
  <xsl:template match="academics">
    <h2>Academics</h2>
    <xsl:apply-templates select="degrees"/>
    <xsl:apply-templates select="note"/>
  </xsl:template>

  <xsl:template match="degrees">
    <ul>
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
    <li>
      <acronym>
        <xsl:value-of select="level"/>
      </acronym>
      <xsl:text> in </xsl:text>
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
  <xsl:template match="skillarea">
    <h2><xsl:value-of select="title"/></h2>
    <xsl:apply-templates select="skillset"/>
  </xsl:template>

  <xsl:template match="skillset">
    <xsl:apply-templates select="title"/>
    <xsl:apply-templates select="skills"/>
  </xsl:template>

  <xsl:template match="skillset/title">
    <h3><xsl:value-of select="."/></h3>
  </xsl:template>

  <xsl:template match="skills">
    <ul>
      <xsl:apply-templates select="skill"/>
    </ul>
  </xsl:template>

  <xsl:template match="skill">
    <li><xsl:value-of select="."/></li>
  </xsl:template>

  <!-- Format publications -->
  <xsl:template match="pubs">
    <h2>Publications</h2>
    <ul>
      <xsl:apply-templates select="pub"/>
    </ul>
  </xsl:template>

  <xsl:template match="pub">
    <li>
      <xsl:apply-templates/>
    </li>
  </xsl:template>

  <!-- Format the misc info -->
  <xsl:template match="misc">
    <h2>Miscellany</h2>
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Format the legalese -->
  <xsl:template match="copyright">
    <address>
      Copyright 
      <xsl:text disable-output-escaping="yes">&amp;copy; </xsl:text>
      <xsl:value-of select="year"/> by
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
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <!-- emphasis -> strong -->
  <xsl:template match="emphasis">
    <strong><xsl:value-of select="."/></strong>
  </xsl:template>

  <!-- url -> monospace along with href -->
  <xsl:template match="url">
    <code>
      <a>
        <xsl:attribute name="href">
          <xsl:value-of select="."/>
	</xsl:attribute>
        <xsl:value-of select="."/>
      </a>
    </code>
  </xsl:template>

  <!-- citation -> cite -->
  <xsl:template match="citation">
    <cite><xsl:value-of select="."/></cite>
  </xsl:template>

</xsl:stylesheet>
