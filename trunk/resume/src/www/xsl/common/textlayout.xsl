<?xml version="1.0"?>

<!--
textlayout.xsl
Library of plain-text layout helper templates.

 - This library differs from text.xsl in that it has no XML Resume-specific
   code.
 - This library differs from string.xsl in that string.xsl provides templates
   that are useful to any application that may need to do text processing; this
   library is likely to be useful only when doing plain text output.
 - This library could forseeably be used in a different project that needs to do
   text layout in XSLT.

Copyright (c) 2000-2002 by Vlad Korolev, Sean Kelly, and Bruce Christensen

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

  <xsl:template name="NewLine">
    <xsl:text>&#xA;</xsl:text>
  </xsl:template>
  
  <!-- Create a heading. Add a colon to the level ("1:") to output one -->
  <xsl:template name="Heading">
    <xsl:param name="Text"/>

    <xsl:call-template name="NewLine"/>
    <xsl:call-template name="NewLine"/>
    <xsl:value-of select="$Text"/><xsl:text>:</xsl:text>
    <xsl:call-template name="NewLine"/>
    <xsl:call-template name="NewLine"/>
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
    <xsl:param name="Length" select="$text.indent.width"/>
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
    <xsl:param name="Width" select="$text.width"/>
    <xsl:param name="Text" />
    <xsl:choose>
      <xsl:when test="contains($Text,'&#xA;')">
        <xsl:call-template name="Center">
          <xsl:with-param name="Text" select="substring-before($Text,'&#xA;')"/>
          <xsl:with-param name="Width" select="$Width"/>
        </xsl:call-template>
        <xsl:call-template name="NewLine"/>
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
    <xsl:param name="Width" select="$text.width"/>
    <xsl:param name="Text" />

    <xsl:if test="string-length($Text) &gt; 0">
      <xsl:call-template name="NSpace">
        <xsl:with-param
          name="n"
          select="($Width - string-length($Text)) div 2" />
      </xsl:call-template>
      <xsl:value-of select="$Text"/>
    </xsl:if>
  </xsl:template>

  <!-- Wraps $Text to $Width characters. Whitespace is normalized, with the
  exception of newlines if $KeepNewlines is true.  -->
  <xsl:template name="Wrap" >
    <!-- Text to wrap -->
    <xsl:param name="Text"  />
    <!-- Maximum line length; lines longer than this get wrapped -->
    <xsl:param name="Width" select="20"/>
    <!-- Whether newlines in $Text should be kept. -->
    <xsl:param name="KeepNewlines" select="0"/>

    <!-- Number of characters outputted so far on the current line -->
    <xsl:param name="CPos" select="0" />
    <!-- Whether it's OK to output a newline if CPos = 0 -->
    <xsl:param name="NewlineOK" select="0"/>
    <!-- Has text been normalized yet? -->
    <xsl:param name="IsNormalized" select="0"/>

    <!-- Output a newline if we're in column zero and we're allowed to
    (not allowed when the template is first called by another template) -->
    <xsl:if test="$CPos=0 and $NewlineOK">
      <xsl:call-template name="NewLine"/>
    </xsl:if>

    <!-- Put as many words on the line as possible -->
    <!-- Do it till we run out of things -->

    <xsl:choose>

      <!-- If there's no input text, we're done -->
      <xsl:when test="string-length($Text) = 0">
      </xsl:when>

      <!-- If we want to preserve newlines and the text contains a newline,
      format everything before the newline. Then format everything after, with
      $CPos reset to zero (since that's the column you're in after a newline has
      been outputted). -->
      <xsl:when test="$KeepNewlines and contains($Text, '&#xA;')">
        <xsl:call-template name="Wrap">
          <xsl:with-param name="Text" select="substring-before($Text, '&#xA;')"/>
          <xsl:with-param name="Width" select="$Width"/>
          <xsl:with-param name="KeepNewlines" select="$KeepNewlines"/>
          <xsl:with-param name="CPos" select="$CPos"/>
          <xsl:with-param name="NewlineOK" select="0"/>
          <xsl:with-param name="IsNormalized" select="$IsNormalized"/>
        </xsl:call-template>

        <xsl:call-template name="Wrap">
          <xsl:with-param name="Text" select="substring-after($Text, '&#xA;')"/>
          <xsl:with-param name="Width" select="$Width"/>
          <xsl:with-param name="KeepNewlines" select="$KeepNewlines"/>
          <xsl:with-param name="CPos" select="0"/>
          <xsl:with-param name="NewlineOK" select="1"/>
          <xsl:with-param name="IsNormalized" select="$IsNormalized"/>
        </xsl:call-template>
      </xsl:when>

      <!-- Normalize whitespace in input text if it hasn't been done yet -->
      <xsl:when test="not($IsNormalized)">
        <xsl:call-template name="Wrap">
          <xsl:with-param name="Text" select="normalize-space($Text)"/>
          <xsl:with-param name="Width" select="$Width"/>
          <xsl:with-param name="KeepNewlines" select="$KeepNewlines"/>
          <xsl:with-param name="CPos" select="$CPos"/>
          <xsl:with-param name="NewlineOK" select="$NewlineOK"/>
          <xsl:with-param name="IsNormalized" select="1"/>
        </xsl:call-template>
      </xsl:when>

      <!-- Pre-processing is complete; actually wrap the text -->
      <xsl:otherwise>

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
            <xsl:call-template name="Wrap">
              <xsl:with-param name="Text" select="$Text"/>
              <xsl:with-param name="Width" select="$Width"/>
              <xsl:with-param name="KeepNewlines" select="$KeepNewlines"/>
              <xsl:with-param name="CPos" select="0"/>
              <xsl:with-param name="NewlineOK" select="1"/>
              <xsl:with-param name="IsNormalized" select="$IsNormalized"/>
            </xsl:call-template>
          </xsl:when> 
          <!-- otherwise, there's room on the current line -->
          <xsl:otherwise>

            <xsl:if test="$CPos &gt; 0">
              <xsl:text> </xsl:text>  
            </xsl:if>
            <xsl:variable name="SpaceWidth">
              <xsl:choose>
                <xsl:when test="$CPos &gt; 0">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
              </xsl:choose>
            </xsl:variable>

            <xsl:value-of select="$Word"/>
            <xsl:call-template name="Wrap">
              <xsl:with-param name="Text" select="substring-after($Text,' ')"/>
              <xsl:with-param name="Width" select="$Width"/>
              <xsl:with-param name="KeepNewlines" select="$KeepNewlines"/>
              <xsl:with-param name="CPos" select="$CPos + string-length($Word) + $SpaceWidth"/>
              <xsl:with-param name="NewlineOK" select="1"/>
              <xsl:with-param name="IsNormalized" select="$IsNormalized"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>

      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Named template for formatting a generic bullet list item *SE* -->
  <!-- Heavily modified by Bruce to call other templates to do the hard work. It
  was pretty much a copy of Wrap before; now it calls Wrap
  and Indent to do the work. -->
  <xsl:template name="FormatBulletListItem" >
    <xsl:param name="Text"/>
    <!-- Note: This is the max width of the lines outputted, *including the
    bullet* -->
    <xsl:param name="Width" select="20"/>

    <!-- Get the wrapped text -->
    <xsl:variable name="FormattedText">
      <xsl:call-template name="Wrap">
        <xsl:with-param name="Text" select="$Text"/>
        <xsl:with-param name="Width"
          select="$Width - string-length($text.bullet.character) - 1"/>
        <xsl:with-param name="KeepNewlines" select="1"/>
      </xsl:call-template>
    </xsl:variable>

    <!-- Output bullet character and a space -->
    <xsl:value-of select="$text.bullet.character"/>
    <xsl:text> </xsl:text>

    <xsl:choose>
      <xsl:when test="contains($FormattedText, '&#xA;')">

        <!-- Output the first line of the formatted text -->
        <xsl:value-of select="substring-before($FormattedText, '&#xA;')"/>
        <xsl:call-template name="NewLine"/>

        <!-- Output the rest of the lines, indented to line up properly -->
        <xsl:call-template name="Indent">
          <xsl:with-param name="Text" select="substring-after($FormattedText, '&#xA;')"/>
          <xsl:with-param name="Length">
            <!-- The +1 is for the space outputted after the bullet char -->
            <xsl:value-of select="string-length($text.bullet.character) + 1"/>
          </xsl:with-param>
        </xsl:call-template>

      </xsl:when>

      <xsl:otherwise>
        <xsl:value-of select="$FormattedText"/>
      </xsl:otherwise>

    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
