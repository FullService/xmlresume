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

<p>Congratulations, your r&eacute;sum&eacute; was uploaded successfully.  
It will be processed shortly.  Please check 
<?php print "<a href=\"$arrReturn[2]\">$arrReturn[2]</a>"; ?>
periodically to download your converted r&eacute;sum&eacute;.

<?php
# report upload failure
} else {
  print "<h1>ERROR</h1>\n";
  print "<p> $arrReturn[1] </p>";
}

include_once("../private/footer.php");
?>
