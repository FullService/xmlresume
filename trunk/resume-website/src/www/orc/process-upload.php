<?php
require("orc-functions.php");

#Set some global variables
$time_stamp = time();
$dirname = "orc" . $time_stamp;
$pathdirname  = "./incoming/" . $dirname;
$lockfile = "./incoming/." . $dirname;

touch( $lockfile);	
  $arrReturn = process_upload(); 
unlink( $lockfile);

# report success
if ($arrReturn[0] == 0) {
  $pagetitle = "Resume Upload Confirmation";
  $meta_redirect_to = $arrReturn[2];
  $meta_redirect_delay = 5 * 60; // 5 minutes
  include_once("../private/header.php");
?>

<h1>Success!</h1> 

<p>Congratulations, your r&eacute;sum&eacute; was successfully uploaded
and is now being converted.  This process can take as long as 5 minutes
(the converting process is run infrequently at a very low priority to keep
SourceForge happy), so please consider using this time to
  <ul>
    <li>grab a cup of coffee</li>
    <li>take a walk</li>
    <li><a href="http://www.aclu.org/">become a more active participant 
        in democracy</a> (U.S. only for this link)</a></li>
    <li><a href="http://www.eff.org/">help the fight for online freedom</a></li>
  </ul>
</p>

<p>You should be automatically redirected to the output directory in 5
minutes.  If not, please check <?php print "<a 
href=\"$arrReturn[2]\">$arrReturn[2]</a>"; ?> periodically until your 
r&eacute;sum&eacute; appears.</p>


<?php
# report upload failure
} else {
  $pagetitle = "Resume Upload Confirmation";
  include_once("../private/header.php");
  print "<h1>ERROR</h1>\n";
  print "<p> $arrReturn[1] </p>";
}

include_once("../private/footer.php");
?>
