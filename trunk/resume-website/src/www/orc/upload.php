<html>

<head>
  <title>ORC - The Online R&eacute;sum&eacute; Converter</title>
  <link href="../site.css" rel="STYLESHEET" type="text/css"/>
</head>
<table>
  <tr><td class="quicklinks">
    <?php include("../private/quicklinks.html"); ?>
  </td>
<td>

<h1>
 The XML R&eacute;sum&eacute; Library's
Online R&eacute;sum&eacute; Converter (ORC)
</h1>

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
      <tr><td class="options.desc">Country:</td>
        <td class="options.value">
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
        <tr><td class="options.desc">Papersize:</td>
	<td class="options.value">
	  <select name="opt_papersize">
            <option value="letter"> Letter </option>
            <option value="a4"> A4 </option>
	  </select>
	</td></tr>
      <tr><td class="options.desc">Use Targeting Filter:</td>
	<td class="options.value">
	  <input type="checkbox" name="opt_filter" value="1" checked/>
	</td></tr>
      <tr><td class="options.desc">Filter Targets (separated by spaces):</td>
	<td class="options.value">
          <input type="text" name="opt_targets" size="40" maxlength="400"/>
	</td></tr>
      <tr><td class="options.desc">Generate Plain Text Output</td>
	<td class="options.value">
          <input type="checkbox" name="opt_txt" value="1" checked/>
	</td></tr>
      <tr><td class="options.desc">Generate HTML Output</td>
	<td class="options.value">
          <input type="checkbox" name="opt_html" value="1" checked/>
	</td></tr>
      <tr><td class="options.desc">Generate PDF Output</td>
	<td class="options.value">
          <input type="checkbox" name="opt_pdf" value="1" checked/>
	</td></tr>
      <tr><td class="options.desc">Archive Format (used to compress output)</td>
	<td class="options.value">
	  <select name="opt_archive">
            <option value="tgz"> .tgz (tar-gzip, Unix) </option>
            <option value="zip"> .zip (Winzip, MS Windows) </option>
	  </select>
	</td></tr>
    </table>

    </br><br/>

    <p>Click browse to upload your params.xsl file:<p/>
    <input type="file" name="params" size="50"/>

    <br/><br/>
    <input TYPE="SUBMIT" NAME="SUBMIT" VALUE="Submit R&eacute;sum&eacute;">
  </form>

</td></tr>
</table>
</html>
