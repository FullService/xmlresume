<?xml version="1.0" encoding="UTF-8"?>

<!--
it.xsl
Parameters for Italian resumes.

Copyright (c) 2001-2002 Stewart Evans
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

  <xsl:param name="resume.word">Curriculum Vitae</xsl:param>
  <xsl:param name="page.word">page</xsl:param>
  <xsl:param name="contact.word">Contatti</xsl:param>
  <xsl:param name="objective.word">Obiettivo</xsl:param>
  <xsl:param name="history.word">Esperienze Professionali</xsl:param>
  <xsl:param name="academics.word">Istruzione</xsl:param>
  <xsl:param name="publications.word">Documenti</xsl:param>
  <xsl:param name="miscellany.word">Varie</xsl:param>
  <xsl:param name="in.word">in</xsl:param>
  <xsl:param name="copyright.word">Copyright &#169;</xsl:param>
  <xsl:param name="by.word">di</xsl:param>
  <xsl:param name="present.word">presente</xsl:param>
  <xsl:param name="phone.word">Telefono</xsl:param>
  <xsl:param name="phone.home.phrase"><xsl:value-of select="$phone.word"/> in casa</xsl:param>
  <xsl:param name="email.word">Email</xsl:param>
  <xsl:param name="url.word">URL</xsl:param>
  <xsl:param name="achievements.word">Conseguimenti</xsl:param>
  <xsl:param name="projects.word">Progetti</xsl:param>
  <xsl:param name="referees.word">Riferimenti</xsl:param>

  <!-- default to Italian address formatting -->
  <xsl:param name="address.format">italian</xsl:param>

</xsl:stylesheet>
