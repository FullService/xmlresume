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
 * XMLResumeFilter-- base class for various filters.  
 * 
 * <p>In reality there is little that this class does that XMLFilterImpl 
 * does not.  It does, however, allow us to insert debugging statements easily
 * to figure out what's going on.</p>
 * 
 * <p>XMLResumeFilters can be separated into two groups-- include (allow) filters
 * and exclude (deny) filters, i.e., those that filter out everything not in 
 * their whitelist and those that filter out everything that is in their blacklist.</p>
 * TargetFilter is an include filter, while ElementFilter and AttributeFilter
 * are exclude filters.</p>
 *
 * <p>XMLResumeFilter does not itself filter anything-- it just passes on events.
 * The logic of filtering is left to its derived classes.</p>
 *
 * @author Mark Miller <joup@bnet.org>
 */
public class XMLResumeFilter extends XMLFilterImpl {

    Stack elements;
    XMLReader reader;
    Locator locator;

    static final int ERROR = 10;
    static final int WARN = 5;
    static final int DEBUG = 1;
    int debugLevel;

///////////////////////////////////
// Constructors
///////////////////////////////////  
    /** 
     * Create a new XMLResumeFilter object, which passes all events to its {@link ContentHandler}.
     * @param reader the XMLReader that is parsing the input, or another XMLFilter.
     */
    public XMLResumeFilter(XMLReader reader) {
	this(reader, ERROR);
    }

    /** 
     * Create a new XMLResumeFilter object, which passes all events to its {@link ContentHandler}.
     * @param reader the XMLReader that is parsing the input, or another XMLFilter.
     * @param debugLevel the debug message level. Messages with a severity
     *   equal to or greater than debugLevel will be printed.
     */
    public XMLResumeFilter(XMLReader reader, int debugLevel) {
	super(reader);
        this.debugLevel = debugLevel;
      	reader.setContentHandler(this);
	reader.setErrorHandler(this);
	reader.setDTDHandler(this);
//	reader.setEntityResolver(this);
    }

///////////////////////////////////
// ContentHandler section
// The following methods are not here.  Perhaps they should be:
//
// startPrefixMapping, endPrefixMapping
// processingInstruction
// skippedEntity
///////////////////////////////////  
    /**
     * Filter the startDocument event.
     */
    public void startDocument() throws SAXException 
    { 
	debug("Received startdocument event");
	getContentHandler().startDocument();
    }
	
    /** 
     * Filter the endDocument event.
     * @exception SAXException If there are any remaining open tags
     */
    public void endDocument () throws SAXException { 
	getContentHandler().endDocument();
    }

    /**
     * Filter the startElement event.  This method should probably be overidden by subclasses
     *
     * @param uri The Uniform Resource Indicator of the element
     * @param localName The local name of the element
     * @param qName The qualified XML 1.0 name of the element
     * @param attributes The attributes associated with the element
     */
    public void startElement(String uri, String localName, String qName, 
			     Attributes attributes) throws SAXException {
	getContentHandler().startElement(uri, localName, qName, attributes);
    }

    /** 
     * Filter the endElement event.  This method should probably be overidden by subclasses
     * 
     * @exception SAXParseException If this close tag is mismatched with an open tag.
     */
    public void endElement (String uri, String localName, String qName) 
	throws SAXException {		
        getContentHandler().endElement(uri, localName, qName);
    }

    /** 
     * Filter the characters event.  Replaces all occurences of the XML's predefined
     * entities (less-than, greater-than, ampersand, apostrophe, quote) with their
     * character code equivalent.
     * 
     * @exception SAXParseException If this data appears outside all tags
     */
    public void characters(char[] ch, int start, int length) throws SAXException {
        String data = new String(ch, start, length);
        debug("Received characters event: " + data);
        getContentHandler().characters(ch, start, length);
    }
    
    /** 
     * Filters the ignorableWhitespace event. Ignore this event if it is inside
     * an excluded tag.
     */ 
    public void ignorableWhitespace(char[] ch, int start, int length) throws SAXException {
        getContentHandler().ignorableWhitespace(ch, start, length);
    }

    /** 
     * Record the locator for this Filter's <code>XMLReader</code>.
     */     
    public void setDocumentLocator(Locator locator) {
	this.locator = locator;
	getContentHandler().setDocumentLocator(locator);
    }

///////////////////////////////////
// EntityResolver section
///////////////////////////////////  
    /**
     * Resolve an entity.  An entity is one of those odd strings 
     * such as &eacute; (accented 'e') or &amp; (ampersand).  Because
     * the filter framework creates only intermediate data, we should
     * not, for example, convert '&amp;' to '&'; it's up to the XSLT
     * processor to do that.
     * @param publicId
     * @param systemId
     */
    public InputSource resolveEntity(String publicId, String systemId)
		throws SAXException, IOException {
	System.out.println("Received entity request, publicId: " + publicId +
			   ", systemId: " + systemId);
        return null;
    }

///////////////////////////////////
// DTDHandler section
///////////////////////////////////  
    /**
     * Handle the DTD Declaration
     */
    public void notationDecl(String name, String publicId, String systemId)
                  throws SAXException {
	debug("Received notationDecl Event:"
		+ "\n\tname: " + name
		+ "\n\tpublicId: " + publicId
		+" \n\tsystemId: " + systemId);
        getDTDHandler().notationDecl(name, publicId, systemId);
    }

    /**
     * Handle an unparsedEntity Declaration.  I'm not sure what that is though.
     */
    public void unparsedEntityDecl(String name, String publicId, 
				String systemId, String notationName)
                        throws SAXException {
	debug("Received unparsedEntityDecl Event:"
		+ "\n\tname: " + name + "\n\tpublicId: " + publicId
		+ "\n\tsystemId: " + systemId
		+ "\n\tnotationName: " + notationName);
        getDTDHandler().unparsedEntityDecl(name, publicId, systemId, notationName);
    }


///////////////////////////////////
// Helper Methods
///////////////////////////////////
    /**
     * Parse the content of the file specified as XML. 
     *
     * @param f The file containing the XML to parse
     * @exception IOException If any IO errors occur.
     * @exception IllegalArgumentException If the File object is null.
     * @see org.xml.sax.DocumentHandler
     */
    public void parse(File f) throws SAXException, IOException
    {
        if (f == null) throw new IllegalArgumentException("File cannot be null");
	
        String uri = "file:" + f.getAbsolutePath();
        if (File.separatorChar == '\\') {
            uri = uri.replace('\\', '/');
        }
        InputSource input = new InputSource(uri);
        parse(input);
    }
    
    protected void debug(String msg) { 
	debug(msg, DEBUG);
    }

    protected void debug(String msg, int severity) { 
	if (severity >= this.debugLevel) {
	   System.err.println(this.getClass().getName() + ": " + msg);
	}
    }
}
