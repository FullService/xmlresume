<?xml version="1.0" encoding="UTF-8"?>

<!--
uk.xsl
Parameters for UK resumes.

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

  <!-- In the UK, it's a CV (curricula vita).  And perhaps it's a
  "Telephone", not a "Phone". -->

  <xsl:param name="resume.word">CV</xsl:param>
  <xsl:param name="referees.word">Referees</xsl:param>

  <xsl:param name="academics.word">Qualifications</xsl:param>
  <xsl:param name="achievements.word">Achievements</xsl:param>
  <xsl:param name="and.word">and</xsl:param>
  <xsl:param name="awards.word">Awards</xsl:param>
  <xsl:param name="by.word">by</xsl:param>
  <xsl:param name="contact.word">Contact details</xsl:param>
  <xsl:param name="copyright.word">Copyright &#169;</xsl:param>
  <xsl:param name="email.word">e-mail</xsl:param>
  <xsl:param name="fax.word">Fax</xsl:param>
  <xsl:param name="fax.home.phrase"><xsl:value-of select="$fax.word"/>number, home</xsl:param>
  <xsl:param name="fax.work.phrase"><xsl:value-of select="$fax.word"/>number, work</xsl:param>
  <xsl:param name="history.word">Employment History</xsl:param>
  <xsl:param name="im.aim.service">AIM</xsl:param>
  <xsl:param name="im.icq.service">ICQ</xsl:param>
  <xsl:param name="im.irc.service">IRC</xsl:param>
  <xsl:param name="im.jabber.service">Jabber</xsl:param>
  <xsl:param name="im.msn.service">MSN</xsl:param>
  <xsl:param name="im.yahoo.service">Yahoo IM</xsl:param>
  <xsl:param name="in.word">in</xsl:param>
  <xsl:param name="interests.word">Extra curricular interests</xsl:param>
  <xsl:param name="last-modified.phrase">Last modified</xsl:param>
  <xsl:param name="major-gpa.word">Major GPA</xsl:param>
  <xsl:param name="minor.word">minor</xsl:param>
  <xsl:param name="minors.word">minors</xsl:param>
  <xsl:param name="miscellany.word">Miscellany </xsl:param>
  <xsl:param name="objective.word">Type of work sought</xsl:param>
  <xsl:param name="out-of.word"> out of </xsl:param>
  <xsl:param name="overall-gpa.word">Overall GPA</xsl:param>
  <xsl:param name="page.word">page</xsl:param>
  <xsl:param name="pager.word">pager</xsl:param>
  <xsl:param name="phone.word">Telephone</xsl:param>
  <xsl:param name="phone.home.phrase">Home <xsl:value-of select="$phone.word"/></xsl:param>
  <xsl:param name="phone.mobile.phrase">Mobile <xsl:value-of select="$phone.word"/></xsl:param>
  <xsl:param name="phone.work.phrase">Work <xsl:value-of select="$phone.word"/></xsl:param>
  <xsl:param name="present.word">present</xsl:param>
  <xsl:param name="projects.word">Projects</xsl:param>
  <xsl:param name="publications.word">Publications</xsl:param>
  <xsl:param name="security-clearances.word">Security clearance</xsl:param>
  <xsl:param name="url.word">Website</xsl:param>
  <xsl:param name="training.word">Training</xsl:param>
  <xsl:param name="certification.word">Certifying Body</xsl:param>

  <!-- Format for address; available values are: -->
  <!-- 'standard' for US/Canadian/UK style addresses -->
  <!-- 'european' for European format (with postal code preceding city). -->
  <!-- 'italian' for Italian format (postal code city (province) ). -->
  <xsl:param name="address.format">standard</xsl:param>

</xsl:stylesheet>
