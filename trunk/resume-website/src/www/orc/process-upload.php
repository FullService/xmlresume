<?php
require("orc-functions.php");

#Set some global variables
$time_stamp = time();
$dirname = "orc" . $time_stamp;
$pathdirname  = "./incoming/" . $dirname;

# Set the java classpath and the ant startup script location
# (after building, this file will be in $HOME/htdocs/orc)
$supporthome = "../../resume-support";
$cp = $supporthome . "/fop.jar";
$cp = $cp . ":" . $supporthome . "/xerces.jar";
$cp = $cp . ":" . $supporthome . "/xalan.jar";
$cp = $cp . ":" . $supporthome . "/batik.jar";
$cp = $cp . ":" . $supporthome . "/avalon-framework-cvs-20020315.jar";
$cp = $cp . ":" . $supporthome . "/xmlresume-filter.jar";
$javaClassPath = $cp;
$ant_cmd = $supporthome . "/ant/ant";

include("../private/quicklinks.html");
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
  unlink ($pathdirname . "/params.xml");
  unlink ($pathdirname . "/resume.xml");
  unlink ($pathdirname . "/user.props");
  unlink ($pathdirname . "/country");
  unlink ($pathdirname . "/format");
  unlink ($pathdirname . "/lib");
  unlink ($pathdirname . "/output");
  unlink ($pathdirname . "/paper");
  rmdir ($pathdirname);
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

