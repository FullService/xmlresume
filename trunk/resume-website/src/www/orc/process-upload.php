<?php
require("orc-functions.php");

#Set some global variables
$time_stamp = time();
$dirname = "orc" . $time_stamp;
$pathdirname  = "./incoming/" . $dirname;

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

<p>Congratulations, your r&eacute;sum&eacute; was uploaded successfully.  You
will be emailed with a link to the results of your r&eacute;sum&eacute;'s 
conversion shortly.</p>

<?php
# report upload failure
} else {
  print "<h1>ERROR</h1>\n";
  print "<p> $arrReturn[1] </p>";
}
?>

</body></html>

