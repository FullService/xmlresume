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
 * Filter (include) XMLResume elements based on the <code>targets</code> attribute.  
 * "Targets," in the meaningful sense, can be anything that the user decides 
 * makes sense.
 *
 * <p><code>Targets</code>Can be a simple comma-seperated list (whitespace 
 * discouraged), or a more complex boolean statement in disjunctive form:
 * eg, the element with the attribute 
 * <code>targets="A:B|C"</code> would be included in resumes for which 
 * (A and B) OR C are defined as targets.
 * Commas (,) are functionally equivalent to pipes (|), but are included
 * because the common case is that of a list of targets for which
 * the element should be included.  Targets are case-insensitive.
 * 
 * Instances of this class should be placed between an 
 * {@link org.xml.sax.XMLReader} and a {@link org.xml.sax.ContentHandler}.
 *
 * <p> For example, consider a former Enron executive named Eric who is 
 * looking for a new job.  Eric has skills in somewhat disparate 
 * fields and wants to maintain a single source file to generate resumes 
 * for each field.  He creates a "management" target for management
 * experience, a "accounting" target for his finance skills, and an "outdated"
 * target for skills which have lost relevance to his career. 
 * His "skills" section might look like this:
 * <ul>
 *  <li><code>&#60;skill targets="management|accounting"&#62;Leadership&#60;/skill&#62;</code>
 *  <li><code>&#60;skill targets="accounting"&#62;Financial modeling&#60;/skill&#62;</code>
 *  <li><code>&#60;skill targets="management"&#62;Vision&#60;/skill&#62;</code>
 *  <li><code>&#60;skill targets="accounting"&#62;Audit&#60;/skill&#62;</code>
 *  <li><code>&#60;skill targets="management:outdated"&#62;Ethics&#60;/skill&#62;</code>
 * </ul>
 *
 * If he wants to make a resume to apply for a management job, he would
 * simply filter on the "management" target.  Note that "Leadership" will
 * be included in both accounting and management resumes.  "Ethics" will be
 * included only in management resumes that are outdated.  

 * @author Mark Miller <joup@bnet.org>
 */
public class TargetFilter extends XMLResumeFilter {

    Stack elements;

    //Ignore all events while this is non-null
    String excludedElement;

    StringVector whitelist;
    Hashtable availableTargets = null;

    public static final String TARGETS_ATTR = "targets";
    public static final String OR_OP_CHARS = "|,";
    public static final String AND_OP_CHARS = "+";

    /** 
     * Create a new TargetFilter object, which passes elements included in the
     * whitelist (as well as elements that have no explicitly 
     * defined targets) to its {@link ContentHandler}.
     * @param reader the XMLReader that is parsing the input, or another XMLFilter.
     * @param whitelist an Iterator of targets to include in the output
     */

    public TargetFilter(XMLReader reader, Iterator whitelist) {
	this(reader, whitelist, 9);
    }

    /** 
     * Create a new TargetFilter object, which passes elements included in the
     * whitelist (as well as elements that have no explicitly 
     * defined targets) to its {@link ContentHandler}.
     * @param reader the XMLReader that is parsing the input, or another XMLFilter.
     * @param whitelist an Iterator of targets to include in the output
     * @param debugLevel the debug message level. Messages with a severity
     *   equal to or greater than debugLevel will be printed.
     */

    public TargetFilter(XMLReader reader, Iterator whitelist, int debugLevel) {
        super(reader, debugLevel);
	elements = new Stack();
	this.whitelist = new StringVector();
	this.availableTargets = new Hashtable();
	while (whitelist.hasNext()) {
	    this.whitelist.push((String) whitelist.next());
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
	s = "\n\n<!-- AVAILABLE TARGETS:";
	e = availableTargets.elements();
	while (e.hasMoreElements()) 
	    s = s + " " + (String) e.nextElement();
	s = s + " -->\n<!-- ACCEPTED TARGETS:";
	for (int i=0; i < whitelist.size(); i++)
	    s = s + " " + whitelist.elementAt(i);
	s = s + " -->\n";
	this.getContentHandler().characters(s.toCharArray(), 0, s.length());
	this.getContentHandler().endDocument();
    }

    /**
     * Filter the startElement event.  Ignore this event if the element is inside 
     * an excluded element.  <p>If there is no parent element that has been excluded,
     * pass the event on to the <code>ContentHandler</code> iff
     * <ul>
     * <li>there is no <code>targets</code> attribute list, OR
     * <li>the <code>targets</code> attribute matches with one in the whitelist
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
        // XXX that compiles a list of available targets. It has to "see"
        // XXX EVERY SINGLE TARGET of EVERY SINGLE ELEMENT.

	String targetList = attributes.getValue(TARGETS_ATTR);

        // Determine whether the element should be accepted
        // (As a side effect, update the list of available targets)
        boolean accept = false;     // presume that the targetList won't be accepted
	if ( ! (targetList == null || targetList.equals(""))) {

	    StringTokenizer orTok = new StringTokenizer(targetList, OR_OP_CHARS);
	    while (orTok.hasMoreTokens()) {

		boolean acceptAndClause = true;

		StringTokenizer andTok = new StringTokenizer(orTok.nextToken(), AND_OP_CHARS);
                while (andTok.hasMoreTokens()) {
		    String s = andTok.nextToken();
		    availableTargets.put(s,s);
		    acceptAndClause = acceptAndClause && whitelist.containsIgnoreCase(s);
		    debug("string='" + s + "', acceptAndClause=" + acceptAndClause);
		}

		accept = accept || acceptAndClause;
	    }

            if (excludedElement == null && !accept) { this.excludedElement = qName; }

	}

        if (excludedElement == null) {
            elements.push(qName);

            // Create a new attributes list that doesn't include the
            // "targets" attribute.
            AttributesImpl attrsMinusTargets = new AttributesImpl(attributes);
            int targetsIdx = attrsMinusTargets.getIndex(TARGETS_ATTR);
            if (targetsIdx != -1) {
                attrsMinusTargets.removeAttribute(targetsIdx);
            }

            this.getContentHandler().startElement(uri, localName, qName, attrsMinusTargets);
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
    
    /** 
     * Filters the ignorableWhitespace event. Ignore this event if it is inside
     * an excluded tag.
     */ 
    public void ignorableWhitespace(char[] ch, int start, int length) throws SAXException {
	if (excludedElement == null) {
            this.getContentHandler().ignorableWhitespace(ch, start, length);
	}
    }
}
