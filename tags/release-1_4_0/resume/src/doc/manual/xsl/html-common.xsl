<?xml version="1.0" encoding="UTF-8"?>

<!--
html-common.xsl
Common settings for HTML XSL files.

Copyright (c) 2002 Bruce Christensen.
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
-->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Customizations -->
  <xsl:param name="html.stylesheet">manual.css</xsl:param>

  <!-- <xsl:param name="shade.verbatim">1</xsl:param>
  <xsl:attribute-set name="shade.verbatim.style">
    <xsl:attribute name="border">1</xsl:attribute>
    <xsl:attribute name="bgcolor">#E0E0E0</xsl:attribute>
  </xsl:attribute-set>
  -->

  <!-- This override puts the refclass in parenthesis after refentry's in the
  toc. It makes "Deprecated" class messages show up there. -->
  <xsl:template match="refentry" mode="toc">
    <xsl:variable name="refmeta" select=".//refmeta"/>
    <xsl:variable name="refentrytitle" select="$refmeta//refentrytitle"/>
    <xsl:variable name="refnamediv" select=".//refnamediv"/>
    <xsl:variable name="refname" select="$refnamediv//refname"/>
    <xsl:variable name="title">
      <xsl:choose>
        <xsl:when test="$refentrytitle">
          <xsl:apply-templates select="$refentrytitle[1]" mode="title.markup"/>
        </xsl:when>
        <xsl:when test="$refname">
          <xsl:apply-templates select="$refname[1]" mode="title.markup"/>
        </xsl:when>
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:element name="{$toc.listitem.type}">
      <a>
        <xsl:attribute name="href">
          <xsl:call-template name="href.target"/>
        </xsl:attribute>
        <xsl:copy-of select="$title"/>
      </a>
      <xsl:if test="$annotate.toc != 0">
        <xsl:text> - </xsl:text>
        <xsl:value-of select="refnamediv/refpurpose"/>
        <!-- Begin added code -->
        <xsl:if test="refnamediv/refclass">
          <b>
            <xsl:text> (</xsl:text>
            <xsl:value-of select="refnamediv/refclass"/>
            <xsl:text>)</xsl:text>
          </b>
        </xsl:if>
        <!-- End added code -->
      </xsl:if>
    </xsl:element>
  </xsl:template>


</xsl:stylesheet>
