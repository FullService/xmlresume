<?xml version="1.0"?>

<!--
params.xsl

Copyright (c) 2000-2001 Sean Kelly
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

  <!-- Word to use for "resume" -->
  <xsl:param name="resume.word">R&#x00e9;sum&#x00e9;</xsl:param>

  <!-- Word to use for "page" -->
  <xsl:param name="page.word">page</xsl:param>

  <!-- Word to use for "Contact Information" -->
  <xsl:param name="contact.word">Contact Information</xsl:param>

  <!-- Word to use for "Professional Objective" -->
  <xsl:param name="objective.word">Professional Objective</xsl:param>

  <!-- Word to use for "Employment History" -->
  <xsl:param name="history.word">Employment History</xsl:param>

  <!-- Word to use for "Academics" -->
  <xsl:param name="academics.word">Academics</xsl:param>

  <!-- Word to use for "Publications" -->
  <xsl:param name="publications.word">Publications</xsl:param>

  <!-- Word to use for "Miscellany" -->
  <xsl:param name="miscellany.word">Miscellany</xsl:param>

  <!-- Word to use for "in", as in "bachelor degree *in* political science" -->
  <xsl:param name="in.word">in</xsl:param>

  <!-- Word to use for "Copyright (c)" -->
  <xsl:param name="copyright.word">Copyright &#169;</xsl:param>

  <!-- Word to use for "by", as in "Copyright by Joe Doom" -->
  <xsl:param name="by.word">by</xsl:param>

  <!-- Word to use for "present", as in "Period worked: August 1999-Present" -->
  <xsl:param name="present.word">Present</xsl:param>

  <!-- Word to use for phone, email, and URL for contact information. -->
  <xsl:param name="phone.word">Phone</xsl:param>
  <xsl:param name="email.word">Email</xsl:param>
  <xsl:param name="url.word">URL</xsl:param>

  <!-- Default separator between authors in publication details.  -->
  <xsl:param name="pub.author.separator">, </xsl:param>

  <!-- Default separator between items in publication details.  -->
  <xsl:param name="pub.item.separator">. </xsl:param>

  <!-- Default page size -->
  <xsl:param name="page.height">11in</xsl:param>
  <xsl:param name="page.width">8.5in</xsl:param>

  <!-- Default page margins -->
  <xsl:param name="margin.top">1in</xsl:param>
  <xsl:param name="margin.left">1in</xsl:param>
  <xsl:param name="margin.right">1in</xsl:param>
  <xsl:param name="margin.bottom">1in</xsl:param>

  <!-- Space betwixt paragraphs -->
  <xsl:param name="para.break.space">10pt</xsl:param>

  <!-- Body text indent -->
  <xsl:param name="body.indent">2in</xsl:param>

  <!-- Heading text indent -->
  <xsl:param name="heading.indent">0in</xsl:param>

  <!-- Bullet symbol -->
  <xsl:param name="bullet.glyph">&#x2022;</xsl:param>

  <!-- Text to use to indicate start and end of emphasis in plain text -->
  <xsl:param name="text.emphasis.start">*</xsl:param>
  <xsl:param name="text.emphasis.end">*</xsl:param>

  <!-- Space between bullet and its text in bulleted item -->
  <xsl:param name="bullet.space">10pt</xsl:param>

  <!-- Fonts --> 
  <xsl:param name="footer.font.size">8pt</xsl:param>
  <xsl:param name="footer.font.family">serif</xsl:param>
  <xsl:param name="body.font.size">10pt</xsl:param>
  <xsl:param name="body.font.family">serif</xsl:param>
  <xsl:param name="heading.font.size">10pt</xsl:param>
  <xsl:param name="heading.font.family">sans-serif</xsl:param>
  <xsl:param name="heading.font.weight">bold</xsl:param>
  <xsl:param name="header.name.font.weight">bold</xsl:param>
  <xsl:param name="header.item.font.style">italic</xsl:param>
  <xsl:param name="emphasis.font.weight">bold</xsl:param>
  <xsl:param name="citation.font.style">italic</xsl:param>
  <xsl:param name="url.font.family">monospace</xsl:param>

</xsl:stylesheet>
