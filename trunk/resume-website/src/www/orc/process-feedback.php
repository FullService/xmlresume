<?php
require("orc-functions.php");
  $pagetitle = "Feedback Submitted";
  include_once("../private/header.php");

if( strlen( $_POST['comments']) < 10000) {	// fear comments over 10k in length
  $fpComments = fopen( "./incoming/comments", 'a');
  fwrite( $fpComments, "\n\n******************************************************\n");
  fwrite( $fpComments, "\nMessage: " . $_POST['errorMsg']);
  fwrite( $fpComments, "\nURL: " . $_POST['buildLocation']);
  fwrite( $fpComments, "\nComments: " . $_POST['comments']);
  fclose( $fpComments);
}
?>

<h1>Thank You!</h1> 

<p>Your comments are appreciated.</p>

<center>
  <a href="javascript:void window.close()">CLOSE</a>
</center>

<?php include_once("../private/footer.php"); ?>
