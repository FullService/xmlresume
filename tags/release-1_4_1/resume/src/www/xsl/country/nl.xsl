<?xml version="1.0" encoding="UTF-8"?>

<!--
nl-params.xsl
Parameters for Dutch resumes courtesy of Andre van Dijk
<andre@unseen.demon.nl>

Copyright (c) 2002 Sean Kelly
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
  <xsl:param name="page.word">bladzijde</xsl:param>
  <xsl:param name="contact.word">Contactinformatie</xsl:param>
  <xsl:param name="objective.word">Profesionele Doelstelling</xsl:param>
  <xsl:param name="history.word">Werkervaring</xsl:param>
  <xsl:param name="academics.word">Studies</xsl:param>
  <xsl:param name="publications.word">Publicaties</xsl:param>
  <xsl:param name="miscellany.word">Overigen</xsl:param>
  <xsl:param name="in.word">in</xsl:param>
  <xsl:param name="copyright.word">Copyright &#169;</xsl:param>
  <xsl:param name="by.word">door</xsl:param>
  <xsl:param name="present.word">heden</xsl:param>
  <xsl:param name="phone.word">Telefoon</xsl:param>
  <xsl:param name="email.word">E-mail</xsl:param>
  <xsl:param name="url.word">URL</xsl:param>
  <xsl:param name="achievements.word">Prestaties:</xsl:param>
  <xsl:param name="projects.word">Projecten:</xsl:param>
  <xsl:param name="referees.word">Referenties</xsl:param>

  <!-- default is European address formatting.  For countries other -->
  <!-- than France (e.g. Canada) "standard" formatting may be more correct. -->
  <xsl:param name="address.format">european</xsl:param>

</xsl:stylesheet>
