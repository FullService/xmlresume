<?php
/*******************************************************************
Include this file by setting the $pagetitle variable and then
calling include_once("private/header.php") in PHP tags at the top
of your HTML document.  It includes header declarations, the CSS
stylesheet, the quicklinks sidebar, and a table element.  Use
include_once("private/footer.php") at the end of your HTML file to
close the table and take care of other loose ends. 

OTHER VARIABLES (optional):
$meta_redirect_to : a href to the page to redirect this page to
$meta_redirect_delay : the delay prior to redirection (in seconds)
*********************************************************************/
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
  <head>
    <title>XML R&eacute;sum&eacute; Library:: <?php echo $pagetitle?> </title>
    <meta name="keywords" content="XML, resume, curricula, vitae, DTD, schema, 
		XSL, B2B, metadata, HTML, XHTML, SGML, CSS"/>
    <meta 
	<?php if( isset( $meta_redirect_to)) {
		if( !isset( $meta_redirect_delay)) $meta_redirect_delay = "0";
		print "http-equiv=\"refresh\" content=\"";
		print $meta_redirect_delay . ";URL=" . $meta_redirect_to . "\"";
	}
	?>
    />
    <link rel="stylesheet" href="@WWW_ROOT@/site.css" type="text/css">
  </head>
  <body>
    <h1 class="pageTitle">
      <a href="/" class="pageTitle"
      ><span style="color: red;">XML</span
      ><span style="font-weight: bold;">R&eacute;sum&eacute;</span
      ><span style="color: red;">Library</span></a>
    </h1>
    <table>
      <tbody>
	<tr valign="top">
	  <td class="quicklinks">

<!-- The quicklinks sidebar -->
<h2><span style="font-weight: normal; color: red;">Quick</span><span style="font-weight: bold;">Links</span></h2>
<p>Current Version: <span style="font-weight: bold">@VERSION_DOTS@</span></p>

<p><a href="http://prdownloads.sourceforge.net/xmlresume/@RELEASE_ZIP_NAME@">Download ZIP</a></p>
<p><a href="http://prdownloads.sourceforge.net/xmlresume/@RELEASE_TGZ_NAME@">Download GZIP TAR</a></p>
<p><a href="@WWW_ROOT@/orc">Online R&eacute;sum&eacute; Converter</a></p>
<p>User Guide <br/>
  (<a href="@WWW_ROOT@/user-guide/index.html">HTML,</a>
   <a href="@WWW_ROOT@/user-guide.pdf">PDF</a>)</p>
<p><a href="@WWW_ROOT@/examples/index.html">Examples</a></p>
<p><a href="@WWW_ROOT@/people">People</a></p>
<p><a href="http://sourceforge.net/projects/xmlresume">Project Page</a></p>
<p><a href="@WWW_ROOT@/license/index.html">License</a></p>
<p><a href="@WWW_ROOT@/dtd/resume.dtd">The DTD</a></p>
<p><a href="http://sourceforge.net/forum/forum.php?forum_id=92731">Help Forum</a></p>
<p><a href="http://sourceforge.net/forum/forum.php?forum_id=92730">General Chat</a></p>
<p><a href="http://sourceforge.net/tracker/?func=add&amp;group_id=29512&amp;atid=396335">Report Bug</a></p>
<p><a href="http://sourceforge.net/tracker/?func=add&amp;group_id=29512&amp;atid=396338">Request Feature</a></p>
<p align="center"><a href="http://sourceforge.net"><img
    src="http://sourceforge.net/sflogo.php?group_id=29512"
    width="88" height="31" border="0" alt="SourceForge Logo"></a>
</p>

	  </td>
	  <td>

