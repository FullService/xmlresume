<?xml version="1.0" encoding="US-ASCII"?>
<!--This file was created automatically by html2xhtml-->
<!--from the HTML stylesheets. Do not edit this file.-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:doc="http://nwalsh.com/xsl/documentation/1.0" version="1.0" exclude-result-prefixes="doc">

<!-- This stylesheet works with Saxon and Xalan; for XT use xtchunk.xsl -->
<!-- This stylesheet should also work for any processor that supports   -->
<!-- exslt:document() (see http://www.exslt.org/)                       -->

<xsl:import href="chunk.xsl"/>

<!-- ==================================================================== -->
<!-- What's a chunk?

     The root element (that's it in this version)
                                                                          -->
<!-- ==================================================================== -->

<xsl:template name="chunk">
  <xsl:param name="node" select="."/>

  <xsl:choose>
    <xsl:when test="not($node/parent::*)">1</xsl:when>
    <xsl:otherwise>0</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="set|book|part|preface|chapter|appendix                      |article                      |reference|refentry                      |book/glossary|article/glossary                      |book/bibliography|article/bibliography                      |sect1|/section|section                      |setindex|book/index|article/index                      |colophon" priority="2">
  <xsl:variable name="ischunk">
    <xsl:call-template name="chunk"/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$ischunk = 1">
      <xsl:call-template name="process-chunk-element"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-imports/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

</xsl:stylesheet>
