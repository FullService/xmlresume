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
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Stack;
import java.util.StringTokenizer;
import java.util.Vector;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;
import org.apache.xml.utils.StringVector;
import org.xml.sax.Attributes;
import org.xml.sax.ContentHandler;
import org.xml.sax.ErrorHandler;
import org.xml.sax.InputSource;
import org.xml.sax.Locator;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.AttributesImpl;
import org.xml.sax.helpers.DefaultHandler;
import org.xml.sax.helpers.XMLFilterImpl;

/**
 * Filter XMLResume elements based on the <code>categories</code> attribute.  
 * "Categories," in the meaningful sense, can be anything that the user decides 
 * makes sense.
 *
 * <p><code>Categories</code>Can be a simple comma-seperated list (whitespace 
 * discouraged), or a more complex boolean statement in disjunctive form:
 * eg, the element with the attribute 
 * <code>categories="A:B|C"</code> would be included in resumes for which 
 * (A and B) OR C are defined as categories.
 * Commas (,) are functionally equivalent to pipes (|), but are included
 * because the common case is that of a list of categories for which
 * the element should be included.  Categories are case-insensitive.
 * 
 * Instances of this class should be placed <i>between</i> an 
 * {@link org.xml.sax.XMLReader} and a {@link org.xml.sax.helpers.DefaultHandler}.
 *
 * <p> For example, consider a former Enron executive named Eric who is 
 * looking for a new job.  Eric has skills in somewhat disparate 
 * fields and wants to maintain a single source file to generate resumes 
 * for each field.  He creates a "management" category for management
 * experience, a "accounting" category for his finance skills, and an "outdated"
 * category for skills which have lost relevance to his career. 
 * His "skills" section might look like this:
 * <ul>
 *  <li><code>&#60;skill categories="management|accounting"&#62;Leadership&#60;/skill&#62;</code>
 *  <li><code>&#60;skill categories="accounting"&#62;Financial modeling&#60;/skill&#62;</code>
 *  <li><code>&#60;skill categories="management"&#62;Vision&#60;/skill&#62;</code>
 *  <li><code>&#60;skill categories="accounting"&#62;Audit&#60;/skill&#62;</code>
 *  <li><code>&#60;skill categories="management:outdated"&#62;Ethics&#60;/skill&#62;</code>
 * </ul>
 *
 * If he wants to make a resume to apply for a management job, he would
 * simple filter on the "management" category.  Note that "Leadership" will
 * be included in both accounting and management resumes.  "Ethics" will be
 * included only in management resumes that are outdated.  

 * @author Mark Miller <joup@bigfoot.com>
 */
public class CategoryFilter extends XMLFilterImpl {
    Stack elements;
    //Ignore all events while this is non-null
    String excludedElement;
    StringVector categories;
    XMLReader parent;
    DefaultHandler dh;
    Locator locator;
    Hashtable availableCats = null;

    private static final int ERROR = 10;
    private static final int WARN = 5;
    private static final int DEBUG = 1;

    int debugLevel = ERROR;

    public static final String CATEGORIES_ATTR = "targets";
    public static final String OR_OP_CHARS = "|,";
    public static final String AND_OP_CHARS = "+";

    /** 
     * Create a new CategoryFilter object, which passes elements matching 
     * {@link categories} (as well as elements that have no explicitly 
     * defined categories) to its {@link DefaultHandler}.
     * @param parent the XMLReader that is parsing the input, or another XMLFilter.
     * @param categories an array of categories to match on
     */

    public CategoryFilter(XMLReader parent, Iterator categories) {
	super(parent);
	this.parent = parent;
      	parent.setContentHandler(this);
	parent.setErrorHandler(this);
	parent.setDTDHandler(this);
	parent.setEntityResolver(this);
	this.elements = new Stack();

	this.categories = new StringVector();
	this.availableCats = new Hashtable();
	while (categories.hasNext()) {
	    this.categories.push((String) categories.next());
	}
    }

    /** 
     * Create a new CategoryFilter object, which passes elements matching 
     * {@link categories} (as well as elements that have no explicitly 
     * defined categories) to its {@link DefaultHandler}.
     * @param parent the XMLReader that is parsing the input, or another XMLFilter.
     * @param categories an array of categories to match on
     * @param debugLevel the debug message level. Messages with a severity
     *   equal to or greater than {@link debugLevel} will be printed.
     */

    public CategoryFilter(XMLReader parent, Iterator categories, int debugLevel) {
        this(parent, categories);
        this.debugLevel = debugLevel;
    }

    /**
     * Parse the content of the file specified as XML using the
     * specified <code>org.xml.sax.helpers.DefaultHandler</code>.
     *
     * @param f The file containing the XML to parse
     * @param dh The SAX DefaultHandler to use.
     * @exception IOException If any IO errors occur.
     * @exception IllegalArgumentException If the File object is null.
     * @see org.xml.sax.DocumentHandler
     */

    public void parse(File f, DefaultHandler dh) throws SAXException, IOException
    {
        if (f == null) {
            throw new IllegalArgumentException("File cannot be null");
        }
	if (dh == null) {
	    throw new IllegalArgumentException("DefaultHandler cannot be null");
	}
        String uri = "file:" + f.getAbsolutePath();
        if (File.separatorChar == '\\') {
            uri = uri.replace('\\', '/');
        }
        InputSource input = new InputSource(uri);
	this.dh = dh;
	this.setContentHandler(dh);
	this.setErrorHandler(dh);
	this.setDTDHandler(dh);
	this.setEntityResolver(dh);
        parent.parse(input);
    }

    /**
     * Filter the startDocument event.
     * 
     */

    public void startDocument() throws SAXException 
    { 
	debug("Received startdocument event");
	dh.startDocument();
    }
	
    /** 
     * Filter the endDocument event.
     * @exception SAXException If there are any remaining open tags
     */

    public void endDocument () throws SAXException { 
	String s;
	Enumeration e;
	if (!elements.isEmpty()) {
	    while (!elements.isEmpty()) {
		throw new SAXException("Element " + (String) elements.pop() 
				       + " was not closed");
	    }
	}
	s = "\n\n<!-- AVAILABLE CATEGORIES:";
	e = availableCats.elements();
	while (e.hasMoreElements()) 
	    s = s + " " + (String) e.nextElement();
	s = s + " -->\n<!-- ACCEPTED CATEGORIES:";
	for (int i=0; i < categories.size(); i++)
	    s = s + " " + categories.elementAt(i);
	s = s + " -->\n";
	dh.characters(s.toCharArray(), 0, s.length());
	dh.endDocument();
    }

    /**
     * Filter the startElement event.  Ignore this event if the tag is inside 
     * an excluded element.  <p>If there is no parent element that has been excluded,
     * pass the event on to the <code>DefaultHandler</code> iff
     * <ul>
     * <li>there is no <code>categories</code> attribute list, OR
     * <li>the <code>categories</code> attribute matches one of the accepted ones
     *
     * @param uri The Uniform Resource Indicator of the element
     * @param localName The local name of the element
     * @param qName The qualified XML 1.0 name of the element
     * @param attributes The attributes associated with the element
     */

    public void startElement(String uri, String localName, String qName, 
			     Attributes attributes) throws SAXException {

        // XXX BEWARE!
        // XXX If you optimize this method (so that it doesn't check for
        // XXX acceptance if we're in an excluded element, or so that it uses
        // XXX short-circuit boolean logic), you'll break the part of the code
        // XXX that compiles a list of available categories. It has to "see"
        // XXX EVERY SINGLE CATEGORY of EVERY SINGLE ELEMENT.

	String categoryList = attributes.getValue(CATEGORIES_ATTR);

        // Determine whether the element should be accepted
        // (As a side effect, update the list of available categories)
        boolean accept = false;     // presume that the categoryList won't be accepted
	if ( ! (categoryList == null || categoryList.equals(""))) {

	    // This used to quit looping after the element was accepted:
            //   while (!accept && orTok.hasMoreTokens()) {
            // However, if the loop short-circuits, we can miss adding some
            // categories to availableCats.

	    StringTokenizer orTok = new StringTokenizer(categoryList, OR_OP_CHARS);
	    while (orTok.hasMoreTokens()) {

		boolean acceptAndClause = true;

		StringTokenizer andTok = new StringTokenizer(orTok.nextToken(), AND_OP_CHARS);
                while (andTok.hasMoreTokens()) {
		    String s = andTok.nextToken();
		    availableCats.put(s,s);
		    acceptAndClause = acceptAndClause && categories.containsIgnoreCase(s);
		    debug("string='" + s + "', acceptAndClause=" + acceptAndClause);
		}

		accept = accept || acceptAndClause;
	    }

            if (excludedElement == null && !accept) { this.excludedElement = qName; }

	}

        if (excludedElement == null) {
            elements.push(qName);

            // Create a new attributes list that doesn't include the
            // "categories" attribute.
            AttributesImpl attrsMinusCategories = new AttributesImpl(attributes);
            int categoriesIdx = attrsMinusCategories.getIndex(CATEGORIES_ATTR);
            if (categoriesIdx != -1) {
                attrsMinusCategories.removeAttribute(categoriesIdx);
            }

            dh.startElement(uri, localName, qName, attrsMinusCategories);
        }
    }

    /** 
     * Filter the endElement event.  Ignore this event if it is inside an
     * excluded tag.  
     * 
     * @exception SAXParseException If this close tag is mismatched with an open tag.
     */

    public void endElement (String uri, String localName, String qName) 
	throws SAXException {
	//If this tag associated with this event closes 
	//an excluded tag, reset excludedElement
	if (excludedElement != null) {
	    if (qName.equals(excludedElement))
		excludedElement = null;
	    return;
	} else {
 	    if (elements.isEmpty()) { 	
		throw new SAXParseException("Element " + qName 
					    + " has no corresponding open tag", 
					    this.locator);
	    }
	    else {
		String openTag = (String)elements.pop();
		if (!qName.equals(openTag)) {
		    throw new SAXException("Closing element " + qName 
					   + "is mismatched with open element " 
					   + openTag);
		}	
		dh.endElement(uri, localName, qName);
	    }
	}
    }

    /** 
     * Filter the characters event.  Ignore this event if it is inside an
     * excluded tag.
     * 
     * @exception SAXParseException If this data appears outside all tags
     */

    public void characters(char[] ch, int start, int length) throws SAXException {
	String data = new String(ch, start, length);
	if (excludedElement == null) {
	    if (elements.isEmpty()) {
		dh.warning(new SAXParseException("Data appears outside tags: \n" 
						 + data
						 + "\n\tThey will be ignored.", 
						 locator));
	    } else {
		dh.characters(ch, start, length);
	    }
	}
    }
    
    /** 
     * Filters the ignorableWhitespace event. Ignore this event if it is inside
     * an excluded tag.
     */ 
    public void ignorableWhitespace(char[] ch, int start, int length) throws SAXException {
	if (excludedElement == null) {
            dh.ignorableWhitespace(ch, start, length);
	}
    }

    /** 
     * Record the locator for this Filter's <code>parent</code>.
     */ 
    
    public void setDocumentLocator(Locator locator) {
	this.locator = locator;
	if (dh != null) { dh.setDocumentLocator(locator); }
    }
    
    private void debug(String msg) { 
	debug(msg, DEBUG);
    }

    private void debug(String msg, int severity) { 
	if (severity >= this.debugLevel) {
	   System.err.println(msg);
	}
    }
}
