<?xml version="1.0" encoding="UTF-8"?>

<!--
contact.xsl
Defines some common templates for formatting contact information

Copyright (c) 2002 Bruce Christensen
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

  <!-- Outputs the word for a contact location ("Home", "Work", etc.), followed
  by a space. -->
  <xsl:template match="r:contact/r:phone/@location | r:contact/r:fax/@location">
    <xsl:choose>
      <xsl:when test=". = 'home'">
        <xsl:value-of select="$home.word"/>
        <xsl:text> </xsl:text>
      </xsl:when>
      <xsl:when test=". = 'work'">
        <xsl:value-of select="$work.word"/>
        <xsl:text> </xsl:text>
      </xsl:when>
      <xsl:when test=". = 'mobile'">
        <xsl:value-of select="$mobile.word"/>
        <xsl:text> </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>***UNKNOWN CONTACT LOCATION: '</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>'*** </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="IMServiceName">
    <xsl:param name="Service"/>

    <xsl:choose>
      <xsl:when test="$Service = 'aim'">
        <xsl:value-of select="$im.aim.service"/>
      </xsl:when>
      <xsl:when test="$Service = 'icq'">
        <xsl:value-of select="$im.icq.service"/>
      </xsl:when>
      <xsl:when test="$Service = 'irc'">
        <xsl:value-of select="$im.irc.service"/>
      </xsl:when>
      <xsl:when test="$Service = 'jabber'">
        <xsl:value-of select="$im.jabber.service"/>
      </xsl:when>
      <xsl:when test="$Service = 'msn'">
        <xsl:value-of select="$im.msn.service"/>
      </xsl:when>
      <xsl:when test="$Service = 'yahoo'">
        <xsl:value-of select="$im.yahoo.service"/>
      </xsl:when>
      <xsl:when test="string-length($Service) > 0">
        <xsl:message>
          <xsl:text>***** WARNING: Unknown instantMessage service: '</xsl:text>
          <xsl:value-of select="$Service"/>
          <xsl:text>' (inserting literally into output)</xsl:text>
        </xsl:message>
        <xsl:value-of select="$Service"/>
      </xsl:when>
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
