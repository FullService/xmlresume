@echo off
REM Launch script for XML Resume
REM Copyright (c) 2002 Payam Mirrashidi
REM All rights reserved.
REM 
REM Redistribution and use in source and binary forms, with or without
REM modification, are permitted provided that the following conditions are
REM met:
REM 
REM 1. Redistributions of source code must retain the above copyright
REM    notice, this list of conditions and the following disclaimer.
REM 2. Redistributions in binary form must reproduce the above copyright
REM    notice, this list of conditions and the following disclaimer in the
REM    documentation and/or other materials provided with the
REM    distribution.
REM 
REM THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
REM ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
REM IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
REM PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS
REM BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
REM CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
REM SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
REM BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
REM WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
REM OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
REM IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
REM

REM 
REM Set environment variables
REM

if not defined JAVA_HOME goto nojavahome

SET FOP_HOME=D:\java\fop-0.20.3
SET RESUME_HOME=D:/java/resume-1_3_3

SET CP=%FOP_HOME%\lib\xerces-1.2.3.jar
SET CP=%CP%;%FOP_HOME%\lib\xalan-2.0.0.jar
SET CP=%CP%;%FOP_HOME%\lib\batik.jar
SET CP=%CP%;%FOP_HOME%\lib\logkit-1.0.jar
SET CP=%CP%;%FOP_HOME%\lib\avalon-framework-4.0.jar
SET CP=%CP%;%FOP_HOME%\build\fop.jar

SET JAVA_OPTIONS=   

REM
REM PARSE COMMAND LINE ARGS
REM

if "%1" == "" goto usage
if "%2" == "" goto usage

if "txt" == "%1"  goto txt
if "html" == "%1" goto html 
if "pdf" == "%1"  goto pdf
goto usage

:txt
SET IN_FILE="%2.xml"
SET OUT_FILE="%2.txt"
SET XSL_FILE="file:///%RESUME_HOME%/xsl/us-text.xsl"
goto launch

:html
SET IN_FILE="%2.xml"
SET OUT_FILE="%2.html"
SET XSL_FILE="file:///%RESUME_HOME%/xsl/us-html.xsl"
goto launch

:pdf
SET IN_FILE="%2.xml"
SET OUT_FILE="%2.fo"
SET PDF_FILE="%2.pdf"
SET XSL_FILE="file:///%RESUME_HOME%/xsl/us-letter.xsl"
goto launch

REM
REM Launch program and perform transformation
REM

:launch
"%JAVA_HOME%\bin\java" %JAVA_OPTIONS% -classpath %CP% org.apache.xalan.xslt.Process -in %IN_FILE% -xsl %XSL_FILE% -out %OUT_FILE%

if "%1" == "pdf" goto fo

goto end

REM
REM Generate .pdf file, if necessary, as second pass
REM

:fo
"%JAVA_HOME%\bin\java" %JAVA_OPTIONS% -classpath %CP% org.apache.fop.apps.Fop %OUT_FILE% %PDF_FILE%

goto end

:nojavahome
echo JAVA_HOME not defined

goto end

:usage
echo "Usage: resume.bat txt|html|pdf filename_prefix"

:end
