// Copyright (c) 2002 Mark Miller for the XMLResume Project 
// All rights reserved.
//
// <http://xmlresume.sourceforge.net>
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
// 
// 1. Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
// 2. Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in the
//    documentation and/or other materials provided with the
//    distribution.
// 
// THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
// PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS
// BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
// WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
// OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
// IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

package net.sourceforge.xmlresume.filter;

import java.io.File;
import java.io.PrintStream;
import java.util.Stack;
import java.util.Vector;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;
import org.apache.xml.utils.StringVector;
import org.xml.sax.Attributes;
import org.xml.sax.ContentHandler;
import org.xml.sax.ErrorHandler;
import org.xml.sax.Locator;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.DefaultHandler;
import org.xml.sax.helpers.XMLFilterImpl;

/**
 * Handles events produced by an XMLFilter and
 * writes the elements to a file.
 *
 * @author Mark Miller
 */
public class FileWriterHandler extends DefaultHandler {
    private static final int ERROR = 10;
    private static final int WARN = 5;
    private static final int DEBUG = 1;
    // The level of debugging desired.  
    public int debugLevel = 9;
    private PrintStream output;
    private Locator locator;

    //The indent for the output data
    private String indent;
    
    /** 
     *	Handle the startDocument event.  
     */

    public void startDocument() throws SAXException { 
	debug("Received startDocument event");
	output.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
	output.println("<!DOCTYPE resume PUBLIC \"-//Sean Kelly//DTD Resume 1.3.1//EN\" \"http://xmlresume.sourceforge.net/dtd/resume.dtd\">");
	output.println("<!-- THIS FILE WAS GENERATED AUTOMATICALLY BY XMLResume's CategoryFilter. -->");
	indent = "";
    }
	   
    /**
     * Handle the endDocument event
     */

    public void endDocument () throws SAXException { 
	debug("Received endDocument event");
	output.println("<!-- END OF DOCUMENT -->");
	output.flush();
    }

    /** 
     * Print {@link qName} and {@link attributes} to {@link this.output}
     * {@link uri} and {@link localName} are ignored.
     * @param qName The name of the element
     * @param attributes A list of attributes associated with the element
     */

    public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException {
	debug("Received startElement event:\t" + qName);
	//output.print("\n" + indent + "<" + qName);
	output.print("<" + qName);
	int nAttr = attributes.getLength();
	for (int i=0; i < nAttr; i++) {
	    output.print(" " + attributes.getQName(i) + "=\"" + attributes.getValue(i) + "\"");
	}
	output.print(">");
	//indent = indent + "  ";

    }

    /** 
     * Close the element.
     */

    public void endElement (String uri, String localName, String qName) throws SAXException {
	debug("Received endElement event:" + qName);
	//indent = indent.substring(0, indent.length() - 2);
	output.print("</" + qName + ">");
    }

    /**
     * Print the data to {@link this.output}
     */

    public void characters(char[] ch, int start, int length) throws SAXException {
	String data = new String(ch, start, length);
	debug("Received characters event: " + data);

        // Escape all characters that aren't US-ASCII with hex entities
        for (int i = start; i < start+length; i++) {
            if (ch[i] >= 128) {
                output.print("&#x");
                output.print(Integer.toHexString(ch[i]));
                output.print(";");
            } else {
                output.print(ch[i]);
            }
        }
    }
    
    /** 
     * This method currently does nothing
     */ 
    public void startPrefixMapping(String prefix, String uri) throws SAXException {
	debug("Received startPrefixMapping event: prefix=" + prefix + " uri=" + uri);
    }

    /** 
     * This method currently does nothing
     */ 
    public void endPrefixMapping(String prefix) {
	debug("Received endPrefixMapping event: prefix=" + prefix);
    }

    /** 
     * Print whitespace to {@link this.output}.
     */ 
    public void ignorableWhitespace(char[] ch, int start, int length) throws SAXException {
	String data = new String(ch, start, length);
	debug("Received ignorableWhitespace event.");

        output.print(data);
    }

    /** 
     * Record the locator of the <code>parent</code> XMLReader.
     * @param l The Document Locator
     */ 
    public void setDocumentLocator(Locator l) {
	debug("Received setDocumentLocator event");
	this.locator = l;
    }

    /** 
     * This method currently does nothing
     */ 
    public void skippedEntity(String name) throws SAXException {
	debug("Received skippedEntity event: " + name);
    }

    /** 
     * Print a warning message (if debugging is enabled)
     */ 
    public void warning(SAXParseException e) {
	debug("Received warning " + e, WARN);
    }

    /** 
     * Print a fatal error message
     */ 
    public void fatalError(SAXParseException e) {
	debug("Received fatalError " + e, ERROR);
    }

    /** 
     * Print a fatal error message
     */ 
    public void error(SAXParseException e) {
	debug("Received error " + e, ERROR);
    }

    /**
     * Print a debug message if verbose logging is enabled
     * @param msg Debug message
     */
    private void debug(String msg) {
	debug(msg, DEBUG);
    }

    /**
     * Print a debug message if {@link severity} is greater than the logging level
     * @param msg Debug message
     * @param severity The importance of the message
     */
    private void debug(String msg, int severity) {
	if (severity >= debugLevel) { System.err.println(msg); }
    }

    /**
     * Create a new instance that will write its data to {@link output}
     * @param output the output file
     */

    public FileWriterHandler(PrintStream output) {
	this.output = output;
    }	

    /**
     * Create a new instance that will write its data to {@link output}
     * @param output the output file
     */

    public FileWriterHandler(PrintStream output, int debugLevel) {
	this.debugLevel = debugLevel;
	this.output = output;
    }	
}

