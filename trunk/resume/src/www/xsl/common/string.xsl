<?xml version="1.0"?>

<!--
string.xsl
Library of string helper templates.

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
    <xsl:param name="Length" select="$text.indent"/>
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

  <!-- Removes leading and trailing space -->
  <xsl:template name="Trim">
    <xsl:param name="Text"/>

    <xsl:variable name="LeadingSpace">
      <xsl:call-template name="LeadingSpace">
        <xsl:with-param name="Text" select="$Text"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="LeadingLen" select="string-length($LeadingSpace)"/>

    <xsl:variable name="TrailingSpace">
      <xsl:call-template name="TrailingSpace">
        <xsl:with-param name="Text" select="$Text"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="TrailingLen" select="string-length($TrailingSpace)"/>

    <xsl:value-of
      select="substring(
        $Text,
        1+$LeadingLen,
        string-length($Text) - $LeadingLen - $TrailingLen
        )"/>
  </xsl:template>

  <!-- Like normalize-space(), but leaves leading and trailing space intact -->
  <xsl:template name="NormalizeInternalSpace">
    <xsl:param name="Text"/>

    <xsl:call-template name="LeadingSpace">
      <xsl:with-param name="Text" select="$Text"/>
    </xsl:call-template>

    <xsl:value-of select="normalize-space($Text)"/>

    <xsl:call-template name="TrailingSpace">
      <xsl:with-param name="Text" select="$Text"/>
    </xsl:call-template>

  </xsl:template>

  <!-- Returns the leading whitespace of a string -->
  <xsl:template name="LeadingSpace">
    <xsl:param name="Text"/>

    <xsl:variable name="Whitespace">
      <xsl:text>&#x20;&#x9;&#xD;&#xA;</xsl:text>
    </xsl:variable>

    <xsl:if test="string-length($Text) &gt; 0">
      <xsl:variable name="First" select="substring($Text, 1, 1)"/>
      <xsl:variable name="Following" select="substring($Text, 2)"/>

      <xsl:if test="contains($Whitespace, $First)">
        <xsl:value-of select="$First"/>
        <xsl:call-template name="LeadingSpace">
          <xsl:with-param name="Text" select="$Following"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:if>

  </xsl:template>

  <!-- Returns the trailing whitespace of a string -->
  <xsl:template name="TrailingSpace">
    <xsl:param name="Text"/>

    <xsl:variable name="Whitespace">
      <xsl:text>&#x20;&#x9;&#xD;&#xA;</xsl:text>
    </xsl:variable>

    <xsl:if test="string-length($Text) > 0">
      <xsl:variable name="Last"
        select="substring($Text, string-length($Text))"/>
      <xsl:variable name="Preceding"
        select="substring($Text, 1, string-length($Text) -1)"/>

      <xsl:if test="contains($Whitespace, $Last)">
        <xsl:call-template name="TrailingSpace">
          <xsl:with-param name="Text" select="$Preceding"/>
        </xsl:call-template>
        <xsl:value-of select="$Last"/>
      </xsl:if>
    </xsl:if>

  </xsl:template>

</xsl:stylesheet>
