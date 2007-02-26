// Copyright (c) 2002 Mark Miller for the XMLResume Project
// All rights reserved.
//
// Licensing information is available at
// http://xmlresume.sourceforge.net/license/index.html

package net.sourceforge.xmlresume.filter;

import java.io.File;
import java.io.PrintStream;
import java.io.BufferedWriter;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.util.Stack;
import java.util.StringTokenizer;
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
public class FileWriterHandler extends XMLResumeFilter {

    private PrintWriter output;
    private Locator locator;

    //The indent for the output data
    private String indent;
    
    /** 
     *	Handle the startDocument event.  
     */

    public void startDocument() throws SAXException { 
	debug("Received startDocument event");
	output.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
	output.println("<!DOCTYPE resume PUBLIC \"-//Sean Kelly//DTD Resume @VERSION_DOTS@//EN\" \"http://xmlresume.sourceforge.net/dtd/resume.dtd\">");
	output.println("<!-- THIS FILE WAS GENERATED AUTOMATICALLY BY XMLResume's Targeting Filter. -->");
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
     * Print qName and attributes to {@field output}
     * uri and localName are ignored.
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
     * Print the data to {@field output}.  Replaces all occurences of the XML's predefined
     * entities (less-than, greater-than, ampersand, apostrophe, quote) with their
     * character code equivalent.
     */

    public void characters(char[] ch, int start, int length) throws SAXException {
        
        // java.util.regex.Pattern objects would be nice to use here, but they
        // weren't introduced until 1.4

        String s;
        StringBuffer sb = new StringBuffer("");
        StringTokenizer st = new StringTokenizer(new String(ch, start, length), "<>&'\"", true);
        while (st.hasMoreTokens()) {
            s = st.nextToken();
            if (s.equals("<")) s = "&lt;"; 
            if (s.equals(">")) s = "&gt;";  
            if (s.equals("&")) s = "&amp;";  
            if (s.equals("'")) s = "&apos;"; 
            if (s.equals("\"")) s = "&quot;";
            sb.append(s);
        }
        output.print(sb.toString());
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
     * Print whitespace to {@field output}.
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
     * Create a new instance that will write its data to {@field output}
     * @param output the output file in the UTF-8 character encoding.
     * @throws UnsupportedEncodingException when the character encoding is unsupported
     */
    public FileWriterHandler(XMLReader reader, PrintStream output)
        throws UnsupportedEncodingException {
	this (reader, output, 9, "UTF-8");
    }	

    /**
     * Create a new instance that will write its data to {@field output}
     * @param output the output file
     * @param debugLevel low values == more debug messages
     * @param enc the character encoding to use
     * @throws UnsupportedEncodingException when the character encoding is unsupported
     */
    public FileWriterHandler(XMLReader reader, PrintStream output, int debugLevel, String enc) 
	throws UnsupportedEncodingException {
	super(reader, debugLevel);
	this.output = new PrintWriter(new BufferedWriter(new OutputStreamWriter(output, enc)));
    }	
}

