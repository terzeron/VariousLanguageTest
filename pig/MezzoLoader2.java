package org.apache.pig.builtin;

import java.io.IOException;
import java.nio.charset.Charset;

import org.apache.pig.LoadFunc;
import org.apache.pig.data.DataMap;
import org.apache.pig.data.DefaultDataBag;
import org.apache.pig.data.DataAtom;
import org.apache.pig.data.Tuple;
import org.apache.pig.impl.io.BufferedPositionedInputStream;


public class MezzoLoader implements LoadFunc{
    BufferedPositionedInputStream in;
    final private static Charset utf8 = Charset.forName("UTF8");
    long                end;
    final static String fieldDelim = ">(?=<[A-Z] |$)";
    final static String attrDelim = " (?=[a-z]+=\")";
    final static String keyValueDelim = "(?:=\"|\"$)";

    public void bindTo(String fileName, BufferedPositionedInputStream in, 
		       long offset, long end) throws IOException {
        this.in = in;
        this.end = end;
        // Since we are not block aligned we throw away the first
        // record and could on a different instance to read it
        if (offset != 0)
            getNext();
    }

    private Tuple makeTagTuple(String tag) {
	String [] attrs = tag.split(attrDelim);
	if (attrs.length > 0) {
	    Tuple attrList = new Tuple(attrs.length);
	    for (int j = 0; j < attrs.length; ++j) {
		String [] keyValues = attrs[j].split(keyValueDelim);
		if (keyValues.length > 1) {
		    DataMap attrKeyValue = new DataMap();
		    attrKeyValue.put(keyValues[0], keyValues[1]);
		    attrList.setField(j, attrKeyValue);
		} else {
		    attrList.setField(j, new DataAtom(attrs[j]));
		}
	    }
	    
	    return attrList;
	}
	return null;
    }

    public Tuple getNext() throws IOException {
        String line = "";
	Tuple tuple = null;

        if (in == null || in.getPosition() > end)
            return null;

        if ((line = in.readLine(utf8, (byte)'\n')) != null) {
	    String [] tags = line.split(fieldDelim);
            Tuple userSequences = new Tuple(2);
	    for (int i = 0; i < tags.length; ++i) {
		tags[i] = tags[i].replaceFirst("^<", "");
	    }

	    // B tag
	    if ((tuple = makeTagTuple(tags[0])) != null) {
		userSequences.setField(0, tuple);
	    }
	    
	    DefaultDataBag tupleList = new DefaultDataBag();
	    // N tags or C tags
	    for (int i = 1; i < tags.length; ++i) {
		if ((tuple = makeTagTuple(tags[i])) != null) {
		    tupleList.add(tuple);
		}
	    }
	    userSequences.setField(1, tupleList);
            return userSequences;
        }
        return null;
    }

}
