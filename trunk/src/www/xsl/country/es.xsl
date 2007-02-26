<?xml version="1.0" encoding="UTF-8"?>

<!--
es.xsl
Parameters for Spanish resumes.

MAINTAINER: Miguel Coca <mcoca@gnu.org>
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
  <xsl:param name="page.word">página</xsl:param>
  <!-- Word to use for "Contact Information" -->
  <xsl:param name="contact.word">Información de contacto</xsl:param>
  <xsl:param name="objective.word">Objetivo</xsl:param>
  <!-- Word to use for "Employment History" -->
  <xsl:param name="history.word">Experiencia</xsl:param>
  <xsl:param name="academics.word">Formación</xsl:param>
  <xsl:param name="publications.word">Publicaciones</xsl:param>
  <xsl:param name="interests.word">Intereses</xsl:param>
  <xsl:param name="security-clearances.word">Autorizaciones de seguridad</xsl:param>
  <xsl:param name="awards.word">Premios</xsl:param>
  <xsl:param name="miscellany.word">Otros</xsl:param>
  <!-- Word to use for "in", as in "bachelor degree *in* political science" -->
  <xsl:param name="in.word">en</xsl:param>
  <!-- Word to use for "and", as in "Minors in political science, English, *and*
  business" -->
  <xsl:param name="and.word">y</xsl:param>
  <!-- Word to use for "Copyright (c)" -->
  <xsl:param name="copyright.word">Copyright &#169;</xsl:param>
  <!-- Word to use for "by", as in "Copyright by Joe Doom" -->
  <xsl:param name="by.word">por</xsl:param>
  <!-- Word to use for "present", as in "Period worked: August 1999-Present" -->
  <xsl:param name="present.word">Actualidad</xsl:param>
  <xsl:param name="achievements.word">Logros:</xsl:param>
  <xsl:param name="projects.word">Proyectos:</xsl:param>
  <!-- Word to use for "minor" (lesser area of study), singluar and plural. -->
  <xsl:param name="minor.word">TRANSLATION NEEDED</xsl:param>
  <xsl:param name="minors.word">TRANSLATION NEEDED</xsl:param>
  <xsl:param name="referees.word">Referencias</xsl:param>
  <!-- Word to use for "Overall GPA", as in "*Overall GPA*: 3.3" -->
  <xsl:param name="overall-gpa.word">Nota media</xsl:param>
  <!-- Word to use for "GPA in Major", as in "*GPA in Major*: 3.3" -->
  <xsl:param name="major-gpa.word">Nota media en la especialidad</xsl:param>
  <!-- Text to use for "out of", as in "GPA: 3.71* out of *4.00" -->
  <xsl:param name="out-of.word"> sobre </xsl:param>
  <xsl:param name="last-modified.phrase">Última modificación</xsl:param>

  <xsl:param name="phone.word">Teléfono</xsl:param>
  <xsl:param name="fax.word">Fax</xsl:param>
  <xsl:param name="phone.home.phrase"><xsl:value-of select="$phone.word"/></xsl:param>
  <xsl:param name="phone.work.phrase"><xsl:value-of select="$phone.word"/> del trabajo</xsl:param>
  <xsl:param name="phone.mobile.phrase"><xsl:value-of select="$phone.word"/> móvil</xsl:param>
  <xsl:param name="fax.home.phrase"><xsl:value-of select="$fax.word"/></xsl:param>
  <xsl:param name="fax.work.phrase"><xsl:value-of select="$fax.word"/> del trabajo</xsl:param>

  <xsl:param name="pager.word">Buscapersonas</xsl:param>
  <xsl:param name="email.word">Email</xsl:param>
  <xsl:param name="url.word">URL</xsl:param>

  <!-- Format for address; available values are: -->
  <!-- 'standard' for US/Canadian/UK style addresses -->
  <!-- 'european' for European format (with postal code preceding city). -->
  <!-- 'italian' for Italian format (postal code city (province) ). -->
  <xsl:param name="address.format">european</xsl:param>

  <!-- Instant messenger service names -->
  <xsl:param name="im.aim.service">AIM</xsl:param>
  <xsl:param name="im.icq.service">ICQ</xsl:param>
  <xsl:param name="im.irc.service">IRC</xsl:param>
  <xsl:param name="im.jabber.service">Jabber</xsl:param>
  <xsl:param name="im.msn.service">MSN Messenger</xsl:param>
  <xsl:param name="im.yahoo.service">Yahoo! Messenger</xsl:param>

</xsl:stylesheet>
