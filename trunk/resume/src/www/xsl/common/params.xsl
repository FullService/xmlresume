<?xml version="1.0" encoding="UTF-8"?>

<!--
params.xsl
Default XML resume transformation parameters.

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
  xmlns:r="http://xmlresume.sourceforge.net/resume/0.0"
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
  <xsl:param name="academics.word">Education</xsl:param>

  <!-- Word to use for "Publications" -->
  <xsl:param name="publications.word">Publications</xsl:param>

  <!-- Word to use for "Interests" -->
  <xsl:param name="interests.word">Interests</xsl:param>

  <!-- Word to use for "Awards" -->
  <xsl:param name="awards.word">Awards</xsl:param>

  <!-- Word to use for "Miscellany" -->
  <xsl:param name="miscellany.word">Miscellany</xsl:param>

  <!-- Word to use for "in", as in "bachelor degree *in* political science" -->
  <xsl:param name="in.word">in</xsl:param>

  <!-- Word to use for "and", as in "Minors in political science, English, *and*
  business" -->
  <xsl:param name="and.word">and</xsl:param>

  <!-- Word to use for "Copyright (c)" -->
  <xsl:param name="copyright.word">Copyright &#169;</xsl:param>

  <!-- Word to use for "by", as in "Copyright by Joe Doom" -->
  <xsl:param name="by.word">by</xsl:param>

  <!-- Word to use for "present", as in "Period worked: August 1999-Present" -->
  <xsl:param name="present.word">Present</xsl:param>

  <!-- Word to use for phone, email, and URL for contact information. -->
  <xsl:param name="phone.word">Phone</xsl:param>
  <xsl:param name="fax.word">Fax</xsl:param>
  <xsl:param name="pager.word">Pager</xsl:param>
  <xsl:param name="email.word">Email</xsl:param>
  <xsl:param name="url.word">URL</xsl:param>

  <!-- Instant messenger service names -->
  <!-- (When you add or remove a service here, don't forget to update
  contact.xsl in this dir, and element.instantMessage.xml in the user guide.)
  -->
  <xsl:param name="im.aim.service">AIM</xsl:param>
  <xsl:param name="im.icq.service">ICQ</xsl:param>
  <xsl:param name="im.irc.service">IRC</xsl:param>
  <xsl:param name="im.jabber.service">Jabber</xsl:param>
  <xsl:param name="im.msn.service">MSN Messenger</xsl:param>
  <xsl:param name="im.yahoo.service">Yahoo! Messenger</xsl:param>

  <!-- Words for phone and fax locations, as in "Home Phone", or "Work Fax" -->
  <xsl:param name="home.word">Home</xsl:param>
  <xsl:param name="work.word">Work</xsl:param>
  <xsl:param name="mobile.word">Mobile</xsl:param>

  <!-- Word to use for the "Achievements:" heading in a job. -->
  <xsl:param name="achievements.word">Achievements:</xsl:param>

  <!-- Word to use for the "Projects:" heading in a job. -->
  <xsl:param name="projects.word">Projects:</xsl:param>

  <!-- Word to use for Minor (lesser area of study), singluar and plural. -->
  <xsl:param name="minor.word">minor</xsl:param>
  <xsl:param name="minors.word">minors</xsl:param>

  <!-- Word to use for referees. -->
  <xsl:param name="referees.word">References</xsl:param>

  <!-- Should referees be displayed when formatting? -->
  <!-- '1' to display referees -->
  <!-- '0' to display referees.hidden.phrase instead. -->
  <xsl:param name="referees.display">1</xsl:param>
  <xsl:param name="referees.hidden.phrase">Available upon request.</xsl:param>

  <!-- Phrase to use for "Last modified". -->
  <xsl:param name="last-modified.phrase">Last modified</xsl:param>

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
  <xsl:param name="para.break.space">1.0em</xsl:param>

  <!-- Half space; for anywhere line spacing is needed but should be less -->
  <!-- than a full paragraph break; between comma-separated skills lists, -->
  <!-- between job header and description/achievements. -->
  <xsl:param name="half.space">0.5em</xsl:param>

  <!-- Body text indent -->
  <xsl:param name="body.indent">1in</xsl:param>

  <!-- Heading text indent -->
  <xsl:param name="heading.indent">0in</xsl:param>

  <!-- Bullet symbol -->
  <xsl:param name="bullet.glyph">&#x2022;</xsl:param>

  <!-- Bullet equivalent in plain text *SE* -->
  <xsl:param name="text.bullet.prefix">* </xsl:param>

  <!-- Text to use to indicate start and end of emphasis in plain text -->
  <xsl:param name="text.emphasis.start">*</xsl:param>
  <xsl:param name="text.emphasis.end">*</xsl:param>

  <!-- Max chars allowed on a line in plain text -->
  <xsl:param name="text.width">80</xsl:param>

  <!-- Number of characters to indent in plain text -->
  <xsl:param name="text.indent.width">4</xsl:param>

  <!-- Space between bullet and its text in bulleted item -->
  <xsl:param name="bullet.space">1.0em</xsl:param>

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

  <xsl:param name="jobtitle.font.style">normal</xsl:param>
  <xsl:param name="jobtitle.font.weight">bold</xsl:param>

  <!-- Used on degree major and level -->
  <xsl:param name="degree.font.style">normal</xsl:param>
  <xsl:param name="degree.font.weight">bold</xsl:param>

  <xsl:param name="referee-name.font.style">italic</xsl:param>
  <xsl:param name="referee-name.font.weight">normal</xsl:param>

  <xsl:param name="employer.font.style">italic</xsl:param>
  <xsl:param name="employer.font.weight">normal</xsl:param>

  <xsl:param name="job-period.font.style">italic</xsl:param>
  <xsl:param name="job-period.font.weight">normal</xsl:param>

  <!-- Used for "Projects" and "Achievements" -->
  <xsl:param name="job-subheading.font.style">italic</xsl:param>
  <xsl:param name="job-subheading.font.weight">normal</xsl:param>

  <xsl:param name="skillset-title.font.style">italic</xsl:param>
  <xsl:param name="skillset-title.font.weight">normal</xsl:param>

  <xsl:param name="degrees-note.font.style">italic</xsl:param>
  <xsl:param name="degrees-note.font.weight">normal</xsl:param>

  <!-- Cascading stylesheet to use -->
  <xsl:param name="css.href">resume.css</xsl:param>

  <!-- Format for name/contact header: 'standard' or 'centered' *SE* -->
  <!-- Set here or override on command line -->
  <xsl:param name="header.format">standard</xsl:param>

  <!-- Format for address; available values are: -->
  <!-- 'standard' for US/Canadian/UK style addresses -->
  <!-- 'european' for European format (with postal code preceding city). -->
  <!-- 'italian' for Italian format (postal code city (province) ). -->
  <xsl:param name="address.format">standard</xsl:param>

  <!-- Format for skills lists; available values are: -->
  <!-- 'bullet' for bulleted lists -->
  <!-- 'comma' for comma-separated lists -->
  <xsl:param name="skills.format">comma</xsl:param>

  <!-- Should skill <level> elements be displayed when formatting? -->
  <xsl:param name="skills.level.display">1</xsl:param>

  <!-- Text to use to indicate start and end of skill level in all formats -->
  <xsl:param name="skills.level.start"> (</xsl:param>
  <xsl:param name="skills.level.end">)</xsl:param>

  <!-- Settings for lines around the header of the print resume -->
  <xsl:param name="header.line.pattern">rule</xsl:param>
  <xsl:param name="header.line.thickness">0.2em</xsl:param>

  <!-- Margins for the header box. It would be nice to just specify a width
  attribute for the header block, but neither FOP nor XEP use it. Instead, we
  force the width using these two properties. To center the header box, they
  should each be:
    ($page.width - $margin.left - $margin.right - [desired header width]) div 2
  We can't do that using an XPath expression because the numbers have associated
  units. Grrr. There has to be a better way to do this.
  -->
  <xsl:param name="header.margin-left">1.75in</xsl:param>
  <xsl:param name="header.margin-right" select="$header.margin-left"/>

  <!-- Format of interest descriptions. Available values are: -->
  <!-- 'single-line' for <para>s on same line as title, separated by dashes -->
  <!-- 'block' for typical block-style paragraphs -->
  <xsl:param name="interest.description.format">single-line</xsl:param>

  <!-- Separator between <para>s in a description formatted as a single line -->
  <!-- &#x2014; == em-dash -->
  <xsl:param name="description.para.separator.text"> &#x2014; </xsl:param>

</xsl:stylesheet>
