<?php
$pagetitle = "Resume Upload Confirmation";
include_once("../private/header.php");

require("orc-functions.php");

#Set some global variables
$time_stamp = time();
$dirname = "orc" . $time_stamp;
$pathdirname  = "./incoming/" . $dirname;

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

include_once("../private/footer.php");
?>
