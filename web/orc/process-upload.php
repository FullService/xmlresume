<?php
require("orc-functions.php");

#Set some global variables
$time_stamp = time();
$dirname = "orc" . $time_stamp;
$pathdirname  = "./incoming/" . $dirname;
$lockfile = "./incoming/.UPLOAD." . $dirname;

touch( $lockfile);	
  $arrReturn = process_upload(); 
unlink( $lockfile);

# report success
if ($arrReturn[0] == 0) {
  $pagetitle = "Resume Upload Confirmation";
  $meta_redirect_to = $arrReturn[2];
  $meta_redirect_delay = 2 * 60; // 2 minutes
  include_once("../private/header.php");
?>

<h1>Success!</h1> 

<p>Congratulations, your r&eacute;sum&eacute; was successfully uploaded
and is now being converted.  This process can take as long as 2 minutes
(the converting process is run infrequently at a very low priority to keep
SourceForge happy), so please consider using this time to
  <ul>
    <li>grab a cup of coffee</li>
    <li>take a walk</li>
    <li><a href="http://www.aclu.org/">become a more active participant 
        in democracy</a> (U.S. only for this link)</a></li>
    <li><a href="http://www.eff.org/">help the fight for online freedom</a></li>
    <li>browse the developer's <a 
href="javascript:void 
window.open('http://www.amazon.com/exec/obidos/search-handle-url/104-3869407-3127140?ix=us-xml-wishlist&pg=1&sz=50&rank=-valuesort&fqp=email%01joup%40bnet.org')"
        >online wishlist</a></li>        
  </ul>
</p>

<p>You should be automatically redirected to the output directory in 2
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
?>

<h2>Feedback</h2>

<p>This is important-- if your r&eacute;sum&eacute; didn't turn out the 
way you wanted it to, tell us about it!  What did you expect to happen, and 
what went wrong?  Constructive criticism and words of praise are always 
helpful and appreciated.</p>

<form method="post" action="process-feedback.php" target="feedback" onsubmit="window.open('','feedback','width=400,height=400')">
  <textarea name="comments" rows="10" cols="80">Please type your comments here</textarea><br/>
  <input type="submit" name="Submit Comments"/>
  <input type="hidden" name="errorMsg" value="<?php echo $arrReturn[1]; ?>"/>
  <input type="hidden" name="buildLocation" value="<?php echo $arrReturn[2]; ?>"/>
</form>

<?php include_once("../private/footer.php"); ?>
