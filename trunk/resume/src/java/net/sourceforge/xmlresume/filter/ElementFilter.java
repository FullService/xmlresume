// Copyright (c) 2002 Mark Miller for the XMLResume Project 
// All rights reserved.
//
// Licensing information is available at 
// http://xmlresume.sourceforge.net/license/index.html

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
import org.xml.sax.helpers.XMLFilterImpl;

/**
 * Filter (exclude) XMLResume elements based on their name.
 * 
 * This filter is markedly different from the TargetFilter in that it 
 * excludes/denies elements if they match its input list.
 *
 * @author Mark Miller <joup@bnet.org>
 */
public class ElementFilter extends XMLResumeFilter {

    Stack elements;

    //Ignore all events while this is non-null
    String excludedElement;

    StringVector blacklist;

    /** 
     * Create a new ElementFilter object, which passes elements NOT included in the
     * blacklist to its {@link ContentHandler}.
     * @param reader the XMLReader that is parsing the input, or another XMLFilter.
     * @param blacklist an Iterator of elements to exclude from the output
     */

    public ElementFilter(XMLReader reader, Iterator blacklist) {
       this(reader, blacklist, 9);
    }

    /** 
     * Create a new ElementFilter object, which passes elements NOT included in the
     * blacklist to its {@link ContentHandler}.
     * @param reader the XMLReader that is parsing the input, or another XMLFilter.
     * @param blacklist an Iterator of elements to exclude from the output
     * @param debugLevel the debug message level. Messages with a severity
     *   equal to or greater than debugLevel will be printed.
     */

    public ElementFilter(XMLReader reader, Iterator blacklist, int debugLevel) {
       super(reader, debugLevel);
       elements = new Stack();
       this.blacklist = new StringVector();
       while (blacklist.hasNext()) {
           this.blacklist.push((String) blacklist.next());
       }
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
	s = "\n\n<!-- EXCLUDED ELEMENTS:";
	for (int i=0; i < blacklist.size(); i++)
	    s = s + " " + blacklist.elementAt(i);
	s = s + " -->\n";
	this.getContentHandler().characters(s.toCharArray(), 0, s.length());
	this.getContentHandler().endDocument();
    }

    /**
     * Filter the startElement event.  Ignore this event if the element is inside 
     * an excluded element.  <p>If there is no parent element that has been excluded,
     * pass the event on to the <code>ContentHandler</code> 
     *
     * @param uri The Uniform Resource Indicator of the element
     * @param localName The local name of the element
     * @param qName The qualified XML 1.0 name of the element
     * @param attributes The attributes associated with the element
     */

    public void startElement(String uri, String localName, String qName, 
				Attributes attributes) throws SAXException {
	// if this is a child of an excludedElement, we're done.
	if (excludedElement != null) { 
	    return;
        } 
        else if ( blacklist.containsIgnoreCase(qName)) {
	    excludedElement = qName;
        } 
        else {
            elements.push(qName);
            this.getContentHandler().startElement(uri, localName, qName, attributes);
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
	//If the tag associated with this event closes 
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
		this.getContentHandler().endElement(uri, localName, qName);
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
                this.getErrorHandler().warning(new SAXParseException("Data appears outside tags: \n"
                                                 + data
                                                 + "\n\tThey will be ignored.",
                                                 locator));
            } else {
                this.getContentHandler().characters(ch, start, length);
            }
        }
    }



}
