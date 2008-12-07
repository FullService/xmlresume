<?xml version="1.0" encoding="UTF-8"?>

<!--
html-multiple.xsl
Convert DocBook sources into multiple HTML files.

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

  <xsl:import href="@DOCBOOK_XSL_HTML_MULTIPLE@"/>

  <!-- Customizations ===================================================== -->
  <xsl:import href="html-common.xsl"/>

  <!-- New params -->
  <xsl:param name="xmlresume.index.href">../../index.html</xsl:param>
  <xsl:param name="user-guide.index.href">index.html</xsl:param>

  <!-- Overridden params -->
  <xsl:param name="use.id.as.filename">1</xsl:param>
  <xsl:param name="refentry.separator">0</xsl:param>
  <xsl:param name="html.stylesheet">manual.css</xsl:param>

  <!-- Prettier navigation bar at the top of the page -->
  <xsl:template name="header.navigation">
    <xsl:param name="prev" select="/foo"/>
    <xsl:param name="next" select="/foo"/>
    <xsl:param name="suppress.pageTitle" select="0"/>
    <xsl:variable name="home" select="/*[1]"/>
    <xsl:variable name="up" select="parent::*"/>

    <xsl:if test="$suppress.pageTitle = '0'">
      <h1 class="pageTitle">
        <a href="{$xmlresume.index.href}">
        <span style="color: red;">XML</span>
        <span style="font-weight: bold;">
          <xsl:text
            disable-output-escaping="yes">R&amp;eacute;sum&amp;eacute;</xsl:text>
          </span>
        <span style="color: red;">Library</span></a>:
        <a href="{$user-guide.index.href}">User Guide</a>
      </h1>
    </xsl:if>

    <xsl:if test="$suppress.navigation = '0'">
      <div class="navheader">
        <table width="100%" summary="Navigation header">
          <tr>
            <!-- Previous -->
            <td align="left" width="33%">
              <xsl:if test="count($prev)>0">
                <a accesskey="p">
                  <xsl:attribute name="href">
                    <xsl:call-template name="href.target">
                      <xsl:with-param name="object" select="$prev"/>
                    </xsl:call-template>
                  </xsl:attribute>

                  <img src="caret-l.gif" width="11" height="7" border="0" alt="Previous"/>
                  <xsl:apply-templates select="$prev" mode="object.title.markup">
                    <!-- Don't output division type (e.g. "Chapter 1.") before
                    division title -->
                    <xsl:with-param name="autolabel">0</xsl:with-param>
                  </xsl:apply-templates>
                </a>
              </xsl:if>
              <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
            </td>
            <!-- Up -->
            <td align="center" width="34%">
              <xsl:choose>
                <xsl:when test="count($up) > 0">
                  <a accesskey="u">
                    <xsl:attribute name="href">
                      <xsl:call-template name="href.target">
                        <xsl:with-param name="object" select="$up"/>
                      </xsl:call-template>
                    </xsl:attribute>

                    <img src="caret-u.gif" width="11" height="7" border="0" alt="Up"/>
                    <xsl:apply-templates select="$up" mode="object.title.markup">
                      <!-- Don't output division type (e.g. "Chapter 1.") before
                      division title -->
                      <xsl:with-param name="autolabel">0</xsl:with-param>
                    </xsl:apply-templates>
                  </a>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <!-- Next -->
            <td align="right" width="33%">
              <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
              <xsl:if test="count($next)>0">
                <a accesskey="n">
                  <xsl:attribute name="href">
                    <xsl:call-template name="href.target">
                      <xsl:with-param name="object" select="$next"/>
                    </xsl:call-template>
                  </xsl:attribute>

                  <xsl:apply-templates select="$next" mode="object.title.markup">
                    <!-- Don't output division type (e.g. "Chapter 1.") before
                    division title -->
                    <xsl:with-param name="autolabel">0</xsl:with-param>
                  </xsl:apply-templates>
                  <img src="caret-r.gif" width="11" height="7" border="0" alt="Next"/>
                </a>
              </xsl:if>
            </td>
          </tr>
        </table>
      </div>
    </xsl:if>
  </xsl:template>

  <!-- Footer is the same as header -->
  <xsl:template name="footer.navigation">
    <xsl:param name="prev" select="/foo"/>
    <xsl:param name="next" select="/foo"/>

    <xsl:call-template name="header.navigation">
      <xsl:with-param name="prev" select="$prev"/>
      <xsl:with-param name="next" select="$next"/>
      <xsl:with-param name="suppress.pageTitle">1</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- Added autolabel parameter passing -->
  <xsl:template match="*" mode="object.title.markup">
    <xsl:param name="allow-anchors" select="0"/>
    <xsl:param name="autolabel"/>

    <xsl:variable name="template">
      <xsl:choose>
        <xsl:when test="$autolabel">
          <xsl:apply-templates select="." mode="object.title.template">
            <xsl:with-param name="autolabel" select="$autolabel"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="." mode="object.title.template"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:call-template name="substitute-markup">
      <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      <xsl:with-param name="template" select="$template"/>
    </xsl:call-template>
  </xsl:template>

  <!-- Added autolabel parameter passing -->
  <xsl:template match="chapter" mode="object.title.template">
    <xsl:param name="autolabel" select="$chapter.autolabel"/> <!-- BC -->
    <xsl:choose>
      <xsl:when test="$autolabel != 0"> <!-- BC -->
        <xsl:call-template name="gentext.template">
          <xsl:with-param name="context" select="'title-numbered'"/>
          <xsl:with-param name="name" select="local-name(.)"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="gentext.template">
          <xsl:with-param name="context" select="'title-unnumbered'"/>
          <xsl:with-param name="name" select="local-name(.)"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Added autolabel parameter passing -->
  <xsl:template match="appendix" mode="object.title.template">
    <xsl:param name="autolabel" select="$chapter.autolabel"/> <!-- BC -->
    <xsl:choose>
      <xsl:when test="$autolabel != 0"> <!-- BC -->
        <xsl:call-template name="gentext.template">
          <xsl:with-param name="context" select="'title-numbered'"/>
          <xsl:with-param name="name" select="local-name(.)"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="gentext.template">
          <xsl:with-param name="context" select="'title-unnumbered'"/>
          <xsl:with-param name="name" select="local-name(.)"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Added autolabel parameter passing -->
  <xsl:template match="section|sect1|sect2|sect3|sect4|sect5|simplesect
                       |bridgehead"
                mode="object.title.template">
    <xsl:param name="autolabel" select="$section.autolabel"/> <!-- BC -->
    <xsl:choose>
      <xsl:when test="$autolabel != 0"> <!-- BC -->
        <xsl:call-template name="gentext.template">
          <xsl:with-param name="context" select="'title-numbered'"/>
          <xsl:with-param name="name" select="local-name(.)"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="gentext.template">
          <xsl:with-param name="context" select="'title-unnumbered'"/>
          <xsl:with-param name="name" select="local-name(.)"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
