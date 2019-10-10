package org.apache.pig.builtin;

import java.io.IOException;
import java.nio.charset.Charset;

import org.apache.pig.LoadFunc;
import org.apache.pig.data.DataMap;
import org.apache.pig.data.DataAtom;
import org.apache.pig.data.Tuple;
import org.apache.pig.impl.io.BufferedPositionedInputStream;


public class MezzoLoader implements LoadFunc{
    BufferedPositionedInputStream in;
    final private static Charset utf8 = Charset.forName("UTF8");
    long                end;

    public void bindTo(String fileName, BufferedPositionedInputStream in, 
		       long offset, long end) throws IOException {
        this.in = in;
        this.end = end;
        // Since we are not block aligned we throw away the first
        // record and could on a different instance to read it
        if (offset != 0)
            getNext();
    }

    public Tuple getNext() throws IOException {
        String line;
	String fieldDelim = ">(?=<[A-Z] |$)";
	String attrDelim = " (?=[a-z]+=\")";
	String keyValueDelim = "(?:=\"|\"$)";

        if (in == null || in.getPosition() > end)
            return null;

        if ((line = in.readLine(utf8, (byte)'\n')) != null) {
	    String [] tokens = line.split(fieldDelim);
            Tuple t = new Tuple(tokens.length);
	    for (int i = 0; i < tokens.length; ++i) {
		tokens[i] = tokens[i].replaceFirst("^<", "");
		String [] attrs = tokens[i].split(attrDelim);
		Tuple x = new Tuple(attrs.length);
		for (int j = 0; j < attrs.length; ++j) {
		    String [] keyValues = attrs[j].split(keyValueDelim);
		    if (keyValues.length > 1) {
			DataMap y = new DataMap();
			y.put(keyValues[0], keyValues[1]);
			/*
			  Tuple y = new Tuple(2);
			  y.setField(0, keyValues[0]);
			  y.setField(1, keyValues[1]);
			*/

			x.setField(j, y);
		    } else {
			x.setField(j, new DataAtom(attrs[j]));
		    }
		}
		t.setField(i, x);
	    }
            return t;
        }
        return null;
    }

}
