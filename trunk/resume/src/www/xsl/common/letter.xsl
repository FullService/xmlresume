<?xml version="1.0" encoding="UTF-8"?>

<!--
usletter.xsl
Parameters for US-Letter size paper.

Copyright (c) 2001 Sean Kelly
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

$ I d: usletter.xsl,v 1.2 2002/03/28 00:45:38  b may Exp $
-->

<xsl:stylesheet version="1.0"
  xmlns:r="http://xmlresume.sourceforge.net/resume/0.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Measurements for USLetter-sized paper. -->
  <!--
       Ghostscript references http://www.twics.com/~eds/paper/index.html
       as a source of info on paper sizes.  The minimum margin for US
       Letter paper is 1/8" (all sides).
       GH: 2002/05/05
    -->

  <xsl:param name="page.height">11.0in</xsl:param>
  <xsl:param name="page.width">8.5in</xsl:param>
  <xsl:param name="margin.top">1.0in</xsl:param>
  <xsl:param name="margin.left">1.0in</xsl:param>
  <xsl:param name="margin.right">1.0in</xsl:param>
  <xsl:param name="margin.bottom">1.0in</xsl:param>
  <xsl:param name="body.indent">2.0in</xsl:param>

</xsl:stylesheet>
