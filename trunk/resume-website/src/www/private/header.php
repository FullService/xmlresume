<!-- 
Include this file by setting the $pagetitle variable and then
calling include_once("private/header.php") in PHP tags at the top
of your HTML document.  It includes header declarations, the CSS
stylesheet, the quicklinks sidebar, and a table element.  Use
include_once("private/footer.php") at the end of your HTML file to
close the table and take care of other loose ends. 
-->

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
  <head>
    <title>XML R&eacute;sum&eacute; Library:: <?php echo $pagetitle?> </title>
    <meta name="keywords" content="XML, resume, curricula, vitae, DTD,
    schema, XSL, B2B, metadata, HTML, XHTML, SGML, CSS">
    <link rel="stylesheet" href="./site.css" type="text/css">
  </head>
  <body>
    <h1 class="pageTitle">
      <a href="/" class="pageTitle"
      ><span style="color: red;">XML</span
      ><span style="font-weight: bold;">R&eacute;sum&eacute;</span
      ><span style="color: red;">Library</span></a>
    </h1>
    <table cellpadding="4">
      <tbody>
	<tr valign="top">
	  <td class="quicklinks">
            <?php include("./private/quicklinks.html"); ?>
	  </td>
	  <td>
