<?xml version="1.0" encoding="UTF-8"?>

<!--
usletter.xsl

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

$Id$
-->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="fo.xsl"/>

  <!-- In the UK, it's a CV (curricula vita).  And perhaps it's a
  "Telephone", not a "Phone".  And the measurements are for A4-sized
  paper. -->

  <xsl:param name="resume.word">CV</xsl:param>
  <xsl:param name="phone.word">Telephone</xsl:param>
  <xsl:param name="page.height">297mm</xsl:param>
  <xsl:param name="page.width">210mm</xsl:param>
  <xsl:param name="margin.top">20mm</xsl:param>
  <xsl:param name="margin.left">33mm</xsl:param>
  <xsl:param name="margin.right">20mm</xsl:param>
  <xsl:param name="margin.bottom">20mm</xsl:param>
  <xsl:param name="body.indent">20mm</xsl:param>

</xsl:stylesheet>
