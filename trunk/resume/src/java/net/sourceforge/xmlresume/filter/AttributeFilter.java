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
 * Filter (exclude) XMLResume attributes based on their name.
 * 
 * This filter is markedly different from the TargetFilter in that it 
 * excludes/denies elements if they match its input list.
 *
 * @author Mark Miller <joup@bnet.org>
 */
public class AttributeFilter extends XMLResumeFilter {

    StringVector blacklist;

    /** 
     * Create a new AttributeFilter object, which passes attributes NOT included in the
     * blacklist to its {@link ContentHandler}.
     * @param reader the XMLReader that is parsing the input, or another XMLFilter.
     * @param blacklist an Iterator of elements to exclude from the output
     */

    public AttributeFilter(XMLReader reader, Iterator blacklist) {
       this(reader, blacklist, 9);
    }

    /** 
     * Create a new AttributeFilter object, which passes elements NOT included in the
     * blacklist to its {@link ContentHandler}.
     * @param reader the XMLReader that is parsing the input, or another XMLFilter.
     * @param blacklist an Iterator of elements to exclude from the output
     * @param debugLevel the debug message level. Messages with a severity
     *   equal to or greater than debugLevel will be printed.
     */

    public AttributeFilter(XMLReader reader, Iterator blacklist, int debugLevel) {
       super(reader, debugLevel);
       this.blacklist = new StringVector();
       while (blacklist.hasNext()) {
           this.blacklist.push( (String) blacklist.next());
       }
    }

    /** 
     * Filter the endDocument event.
     * @exception SAXException If there are any remaining open tags
     */

    public void endDocument () throws SAXException { 
	String s = "\n\n<!-- EXCLUDED ATTRIBUTES:";
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

        // we need the removeAttribute() method of AttributesImpl
        AttributesImpl attr = new AttributesImpl(attributes);	

	int index = -1;
	for (int i=0; i < blacklist.size(); i++) {
	    index = attr.getIndex(blacklist.elementAt(i));
            if (index != -1) attr.removeAttribute(index);
        }
        this.getContentHandler().startElement(uri, localName, qName, attr);
    }
}
