<?php
require("orc-functions.php");

#Set some global variables
$time_stamp = time();
$dirname = "orc" . $time_stamp;
$WWW_ROOT = "/usr/home/mjm/www";
$ORC_ROOT = $WWW_ROOT . "/orc";
$XSL_ROOT = $WWW_ROOT . "/xsl";
$absdirname  = $ORC_ROOT . "/incoming/" . $dirname;

$cp = "/usr/home/mjm/xmlresume/jar/fop.jar";
$cp = $cp . ":/usr/home/mjm/xmlresume/jar/xerces.jar";
$cp = $cp . ":/usr/home/mjm/xmlresume/jar/xalan.jar";
$cp = $cp . ":/usr/home/mjm/xmlresume/jar/avalon-framework-cvs-20020315.jar";
$cp = $cp . ":/usr/home/mjm/xmlresume/resume/src/java/";
$javaClassPath = $cp;

?>
<html>

<head>
  <title>The XML R&eacute;sum&eacute; Online R&eacute;sum&eacute; Converter</title>
</head>

<body>
<?php 

  $arrReturn = process_upload(); 

# report success
  if ($arrReturn[0] == 0) {
?>

<h1>Success!</h1>
<p>Congratulations, your r&eacute;sum&eacute; was uploaded and 
converted successfully.</p>

<?php
  print "<p>Your compressed archive can be downloaded "
 	. "<a href=\"" . $arrReturn[3] . "\">here</a>.</p>\n";
  print "<p>A logfile of the build process is available "
	. "<a href=\"" . $arrReturn[2] . "\">here</a>.</p>\n";

# report pre-build failure
} else if ($arrReturn[0] == 1) {
  unlink ($absdirname . "/params.xml");
  unlink ($absdirname . "/resume.xml");
  unlink ($absdirname . "/user.props");
  unlink ($absdirname . "/country");
  unlink ($absdirname . "/format");
  unlink ($absdirname . "/lib");
  unlink ($absdirname . "/output");
  unlink ($absdirname . "/paper");
  rmdir ($absdirname);
  print "<h1>ERROR</h1>\n";
  print "<p> $arrReturn[1] </p>";

# report build-time failure
} else {
  print "<h1>BUILD ERROR</h1>\n";
  print "<p> $arrReturn[1] </p>";
  print "<p>A logfile of the build process is available "
	. "<a href=\"" . $arrReturn[2] . "\">here</a>.</p>\n";
}

?>

</body></html>

