<?xml version="1.0" encoding="UTF-8"?>

<!--
common.xsl
Defines some common templates shared by all the stylesheets. 

Copyright (c) 2002 Sean Kelley and contributors
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

  <!-- Call header template in appropriate mode -->
  <xsl:template match="r:header">
    <xsl:choose>
      <xsl:when test="$header.format = 'centered'">
        <xsl:apply-templates select="." mode="centered"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="." mode="standard"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Format a major -->
  <xsl:template match="r:major">
    <xsl:apply-templates/>

    <xsl:choose>
      <xsl:when test="count(following-sibling::r:major) > 1">
        <xsl:text>, </xsl:text>
      </xsl:when>
      <xsl:when test="count(following-sibling::r:major) = 1">
        <xsl:if test="count(preceding-sibling::r:major) > 1">
          <xsl:text>,</xsl:text>
        </xsl:if>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$and.word"/>
        <xsl:text> </xsl:text>
      </xsl:when>
    </xsl:choose>

  </xsl:template>

  <!-- Format a minor -->
  <xsl:template match="r:minor">
    <xsl:if test="position() = 1">
      <xsl:choose>
        <xsl:when test="count(following-sibling::r:minor) > 0">
          <xsl:text> (</xsl:text>
          <xsl:value-of select="$minors.word"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text> (</xsl:text>
          <xsl:value-of select="$minor.word"/>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:text> </xsl:text>
      <xsl:value-of select="$in.word"/>
      <xsl:text> </xsl:text>
    </xsl:if>

    <xsl:apply-templates/>

    <xsl:choose>
      <xsl:when test="count(following-sibling::r:minor) > 1">
        <xsl:text>, </xsl:text>
      </xsl:when>
      <xsl:when test="count(following-sibling::r:minor) = 1">
        <xsl:if test="count(preceding-sibling::r:minor) > 1">
          <xsl:text>,</xsl:text>
        </xsl:if>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$and.word"/>
        <xsl:text> </xsl:text>
      </xsl:when>
      <xsl:when test="count(following-sibling::r:minor) = 0">
        <xsl:text>)</xsl:text>
      </xsl:when>
    </xsl:choose>

  </xsl:template>

</xsl:stylesheet>
