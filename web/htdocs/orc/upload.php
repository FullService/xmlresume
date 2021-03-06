<?php
$pagetitle="ORC - The Online R&eacute;sum&eacute; Converter";
include_once("../private/header.php");
?>

<h1>
Online R&eacute;sum&eacute; Converter (ORC)
</h1>

<p><b>Note:</b> be sure your XML R&eacute;sum&eacute; file specifies
http://xmlresume.sourceforge.net/dtd/resume.dtd in the DOCTYPE
declaration.  If it does not your r&eacute;sum&eacute; cannot be
converted.</p>

  <form action="./process-upload.php" method="post" enctype="multipart/form-data">

    <!-- Allow uploads of up to 100K in size -->
    <input type="hidden" name="MAX_FILE_SIZE" value="100000"/>
    Click browse to upload your XML R&eacute;sum&eacute; file.<br/>
    <input type="file" name="resume" size="50"/>

    </br><br/>
    <p>Your Email Address (used to notify you of a successful build):</p>
    <input type="text" name="email" size="50" maxlength="255"/>

    <h2>R&eacute;sum&eacute; Output Options</h2>
    <table>
      <tr><td class="orc_desc">Country:</td>
        <td class="orc_value">
          <select name="opt_country">
            <option value="br"> Brazil </option>
            <option value="fr"> France </option>
            <option value="de"> Germany </option>
            <option value="it"> Italy </option>
            <option value="nl"> Netherlands </option>
            <option value="es"> Spain/Mexico </option>
            <option value="uk"> United Kingdom </option>
            <option selected value="us"> United States </option>
          </select>
        </td></tr>
        <tr><td class="orc_desc">Papersize:</td>
	<td class="orc_value">
	  <select name="opt_papersize">
            <option value="letter"> Letter </option>
            <option value="a4"> A4 </option>
	  </select>
	</td></tr>
      <tr><td class="orc_desc">Use R&eacute;sum&eacute; Filter:
	  <input type="checkbox" name="opt_useFilter" value="1" checked/>
	</td><td class="orc_value">
        Include Targets (separated by spaces):<br/>
          <input type="text" name="opt_includeTargets" size="40" maxlength="400"/><br/>
        Exclude Elements (separated by spaces):<br/>
          <input type="text" name="opt_excludeElements" size="40" maxlength="400"/><br/>
        Exclude Attributes (separated by spaces):<br/>
          <input type="text" name="opt_excludeAttributes" size="40" maxlength="400"/><br/>
	</td>
      </tr>

      <tr><td class="orc_desc">Generate Plain Text Output</td>
	<td class="orc_value">
          <input type="checkbox" name="opt_txt" value="1" checked/>
	</td></tr>
      <tr><td class="orc_desc">Generate HTML Output</td>
	<td class="orc_value">
          <input type="checkbox" name="opt_html" value="1" checked/>
	</td></tr>
      <tr><td class="orc_desc">Generate PDF Output</td>
	<td class="orc_value">
          <input type="checkbox" name="opt_pdf" value="1" checked/>
	</td></tr>
      <tr><td class="orc_desc">Archive Format (used to compress output)</td>
	<td class="orc_value">
	  <select name="opt_archive">
            <option value="tgz"> .tgz (tar-gzip, Unix) </option>
            <option value="zip"> .zip (Winzip, MS Windows) </option>
	  </select>
	</td></tr>
    </table>

    </br><br/>

    <p>Click browse to upload your customized params.xsl file:<p/>
    <input type="file" name="params" size="50"/>

    </br><br/>

    <p>Click browse to upload your customized CSS file (your 
params.xsl file must refer to "./resume.css" to use it)</p>
    <input type="file" name="css" size="50"/>

    <br/><br/>

    <input TYPE="SUBMIT" NAME="SUBMIT" VALUE="Submit R&eacute;sum&eacute;">
  </form>

<?php
include_once("../private/footer.php");;
?>
