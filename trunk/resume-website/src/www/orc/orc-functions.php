<?php

# Take the upload file, test it, set up the build directory, and
# convert it using ant.
# Returns an array:
#  $ret[0]: the status:
#		0: Success
#		1: Failure prior to build
#		2: Failure during build
#  $ret[1]: a descriptive error message
#  $ret[2]: the location of the build log file (only if $ret[0] == 0 or 2)
#  $ret[3]: the location of the converted compressed resume file
function process_upload() {   
  global $dirname, $pathdirname, $time_stamp;

# Give rwx permission to EVERYONE, because otherwise the web server will
# create files that the build system can't delete
  umask(0000); 

# Create the working directories
  if( !mkdir( $pathdirname, 0770)) return array(1, "Couldn't create directory $pathdirname");
  chmod( $pathdirname, 0777);
  touch( $pathdirname . "/index.html");
  if( !mkdir( $pathdirname . "/out", 0770)) return array(1, "Couldn't create directory " . $pathdirname . "/out");
  chmod( $pathdirname . "/out", 0777);

# Sanity Checks (feel free to add more, eg validity checks)
  if( $_FILES['resume'] == "") return( array( 1, "File not uploaded"));
  if( $_FILES['resume']['error'] != "") print ($_FILES['resume']['error']);
  if( !is_uploaded_file($_FILES['resume']['tmp_name']))
    return( array( 1, "No XML R&eacute;sum&eacute; file uploaded"));
  if( $_FILES['resume']['size'] <= 0 || $_FILES['resume']['size'] > 100000)
    return( array( 1, "Your r&eacute;sum&eacute; must be between 1 and 100K"));

# Move resume.xml file into place
  if( !move_uploaded_file( $_FILES["resume"]["tmp_name"], $pathdirname."/resume.xml"))
    return( array( 1, "Internal: could not move file " . $_FILES['resume']['tmp_name'] ." to $pathdirname"));

# Move params.xsl file into place
  if( is_uploaded_file($_FILES['params']['tmp_name'])) {
    if( !move_uploaded_file( $_FILES['params']['tmp_name'], $pathdirname."/params.xsl"))
      return( array( 1, "Internal: could not move file " . $_FILES['params']['tmp_name'] . " to $pathdirname"));
  } else {
    if( !copy( "../xsl/params.xsl", $pathdirname."/params.xsl"))
      return( array( 1, "Internal: could not copy file ../xsl/params.xsl to $pathdirname"));
  }

  # Create user.props file
  if( !$fpProps = fopen( $pathdirname . "/user.props", 'w'))
    return( array( 1, "Internal: could not create user.props file"));
  fwrite($fpProps, "basedir = .\n");
  fwrite($fpProps, "dirname = " . $dirname . "\n");
  fwrite($fpProps, "email = " . $_POST["email"] . "\n");
  fwrite($fpProps, "country = " . $_POST["opt_country"] . "\n");
  fwrite($fpProps, "papersize = " . $_POST["opt_papersize"] . "\n");
  fwrite($fpProps, "filter.targets = " . $_POST["opt_targets"] . "\n");
  if ($_POST["opt_filter"] == 1) fwrite($fpProps, "options.filter = 1\n");
  if ($_POST["opt_txt"] == 1) fwrite($fpProps, "options.txt = 1\n");
  if ($_POST["opt_html"] == 1) fwrite($fpProps, "options.html = 1\n");
  if ($_POST["opt_pdf"] == 1) fwrite($fpProps, "options.pdf = 1\n");
  if ( $_POST["opt_archive"] == "tgz") fwrite($fpProps, "options.tgz = 1\n");
  fclose($fpProps);

  # Create hard links to the stylesheet files.  
  # This is REQUIRED because of the structure of the
  # xsl directory and its files.  For example, output/*.xsl
  # refers to "../country/*.xsl", and format/*.xsl refers
  # to ../params.xsl . 
  symlink( "../../../xsl/country/", $pathdirname . "/country");
  symlink( "../../../xsl/format/", $pathdirname . "/format");
  symlink( "../../../xsl/lib/", $pathdirname . "/lib");
  symlink( "../../../xsl/output/", $pathdirname . "/output");
  symlink( "../../../xsl/paper/", $pathdirname . "/paper");

  #Create an email message body (to be sent later)
  if( !$fpEmail = fopen( $pathdirname . "/reply.email", 'w'))
    return( array( 1, "Internal: could not create reply.email file"));
  fwrite($fpEmail,
"To: " . $_POST["email"] . "
Subject: ORC: Your XML Resume has been processed
Hello,

This message is to notify you that the XML R&eacute;sum&eacute; you
submitted has been processed.  The results of this build, and a log
summary of the build process can be found at

http://sbap.org/orc/incoming/$dirname/out/

Please download your build results as soon as possible; they are deleted
on a regular basis.

If you discover a server error that the XMLResume developers should know 
about, please file a bug report at

http://sourceforge.net/tracker/?func=add&group_id=29512&atid=396335

Don't forget to include the log summary in the report!

Thanks for using the XMLResume Library.");
  fclose($fpEmail);

  return( array( 0, "R&eacute;sum&eacute; uploaded successfully."));
}

?>
