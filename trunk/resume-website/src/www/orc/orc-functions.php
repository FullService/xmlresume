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
  global $WWW_ROOT, $ORC_ROOT, $XSL_ROOT, 
	 $absdirname, $time_stamp, $javaClassPath;

# Give rwx permission to EVERYONE, because otherwise the web server will
# create files that the build system can't delete
  umask(0000); 
  if( !mkdir($absdirname, 0770)) return array(1, "Couldn't create directory $absdirname");
  chmod($absdirname, 0770);

# Add a .htaccess file that forbids directory listing (just a privacy thing)
  if( !$fpHtaccess = fopen( $absdirname . "/.htaccess", 'w'))
    return( array( 1, "Can't create .htaccess file"));
  fwrite( $fpHtaccess, "Options -indexes\n");

# Sanity Checks (feel free to add more, eg validity checks)
  if( $_FILES['resume'] == "") return( array( 1, "File not uploaded"));
  if( $_FILES['resume']['error'] != "") print ($_FILES['resume']['error']);
  if( !is_uploaded_file($_FILES['resume']['tmp_name']))
    return( array( 1, "No XML R&eacute;sum&eacute; file uploaded"));
  if( $_FILES['resume']['size'] <= 0 || $_FILES['resume']['size'] > 100000)
    return( array( 1, "Your r&eacute;sum&eacute; must be between 1 and 100K"));

# Move resume.xml file into place
  if( !move_uploaded_file( $_FILES["resume"]["tmp_name"], $absdirname."/resume.xml"))
    return( array( 1, "Internal: could not move file " . $_FILES['resume']['tmp_name'] ." to $absdirname"));

# Move params.xsl file into place
  if( is_uploaded_file($_FILES['params']['tmp_name'])) {
    if( !move_uploaded_file( $_FILES['params']['tmp_name'], $absdirname."/params.xsl"))
      return( array( 1, "Internal: could not move file " . $_FILES['params']['tmp_name'] . " to $absdirname"));
  } else {
    if( !copy( "$WWW_ROOT/xsl/params.xsl", $absdirname."/params.xsl"))
      return( array( 1, "Internal: could not copy file $WWW_ROOT/xsl/params.xsl to $absdirname"));
  }

  # Create user.props file
  if( !$fpProps = fopen( $absdirname . "/user.props", 'w'))
    return( array( 1, "Internal: could not create user.props file"));
  fwrite($fpProps, "basedir = .\n");
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
  # This is REQUIRED because of the structure of the th
  # xsl directory and its files.  For example, output/*.xsl
  # refers to "../country/*.xsl", and format/*.xsl refers
  # to ../params.xsl . 
  symlink( $XSL_ROOT . "/country", $absdirname . "/country");
  symlink( $XSL_ROOT . "/format", $absdirname . "/format");
  symlink( $XSL_ROOT . "/lib", $absdirname . "/lib");
  symlink( $XSL_ROOT . "/output", $absdirname . "/output");
  symlink( $XSL_ROOT . "/paper", $absdirname . "/paper");

  # Ant's ClassLoader is... frail.  Set your classpath
  # outside of Ant, save yourself some heartache.
  putenv("CLASSPATH=". $javaClassPath);

  # Now call ant to convert the resume.  Cross your fingers!
  system("cd $absdirname && ant -verbose -l antlog.txt \
	  -propertyfile user.props -find build.xml dispatch >> /dev/null", 
	 $status);
  if( $status != 0) return( array( 2, 
			"ORC Failed during r&eacute;sum&eacute; conversion process",
			"./incoming/$time_stamp/antlog.txt"));
    return( array( 0, "R&eacute;sum&eacute; converted successfully",
		"./incoming/" . $time_stamp . "/antlog.txt",
		"./incoming/" . $time_stamp . "/out/resume." . $_POST["opt_archive"]));
}

?>
