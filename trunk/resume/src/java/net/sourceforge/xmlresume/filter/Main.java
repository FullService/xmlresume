// Copyright (c) 2002 Mark Miller for the XMLResume Project
// All rights reserved.
//
// Licensing information is available at
// http://xmlresume.sourceforge.net/license/index.html

package net.sourceforge.xmlresume.filter;

import java.io.File;
import java.io.FileOutputStream;
import java.io.PrintStream;
import java.io.UnsupportedEncodingException;
import java.util.Vector;
import java.util.StringTokenizer;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;
import org.xml.sax.helpers.DefaultHandler;

public class Main { 

    /**
     * Run the filter and output the data to an intermediate file.
     * @param argv Command-line arguments.
     * @throws Throwable if an error occurs.
     */

    public static void main(String[] argv) throws Throwable 
    {
	int debugLevel=9;
	int i=0;
	int nCats;
	Vector targetList = new Vector();
	File in = null;
	File outfile = null;
	PrintStream out = System.out;
	TargetFilter filter;
	FileWriterHandler writer;
	SAXParser parser;
	//these are used to recognize targets specified on CLI
	StringTokenizer stTarget;

	//process the commandline
	while (i < argv.length) {
	    if ("-v".equals(argv[i]) || "--verbose".equals(argv[i])) {
		debugLevel = 0;
		i++;
	    } else if ("-in".equals(argv[i])) {
		in = new File(argv[i+1]);
		i += 2;
	    } else if ("-out".equals(argv[i])) {
		outfile = new File(argv[i+1]);
		outfile.createNewFile();
		if (!outfile.canWrite()) {
		    throw new Error("Error: can't open file " + outfile + " for writing.");
		}
		i += 2;
		out = new PrintStream(
                    new FileOutputStream(outfile),
                    false // auto-flush data?
                );
	    } else {
		//We have to tokenize the argument string this way 
		//in case the Filter is not called from the command line.
		stTarget = new StringTokenizer(argv[i], " \t\n\r\f,");
		while (stTarget.hasMoreTokens()) {
		    targetList.addElement(stTarget.nextToken());
		}
		i++;
	    }
	}

	if (in == null || argv.length < 2 || "-h".equals(argv[0]) || "--help".equals(argv[0])) {
	    throw new Error("Filter -- preprocess an XMLResume to select for elements in a given target\n" + 
			       "Usage: java Main [-v|--verbose] -in <in_file> [-out <out_file>] [target1 [target2 [...]]\n" + 
			       "If -out <out_file> is not specified, output will be printed on STDOUT.");
	} else if (!in.canRead()) {
	    throw new Error("Error: can't open file " + in + " for reading.");
	} else {
	    parser = SAXParserFactory.newInstance().newSAXParser();
	    filter = new TargetFilter(parser.getXMLReader(), targetList.iterator(), debugLevel);
	    try {
		writer = new FileWriterHandler(out, debugLevel, "UTF-8");
	    } catch (UnsupportedEncodingException e) { 
		throw new Error("Your platform does not support the " +
		"UTF-8 encoding, which is required for using Filter\n");
	    }
	    filter.parse(in, writer);
	}
    }
}

