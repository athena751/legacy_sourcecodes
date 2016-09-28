/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.framework;

import	java.util.*;

import  javax.xml.parsers.*;
import  org.w3c.dom.*;

public class NSMessage {
	private static final String	cvsid = "@(#) $Id: NSMessage.java,v 1.2300 2003/11/24 00:54:32 nsadmin Exp $";
	public	NSMessage() {
		subs = new HashMap();
	}
	public void	setChildren(Map m) {
		subs = m;
	}
	public Map	getChildren() {
		return subs;
	}
	public String	setInfoFromNode(Node node) {
		String	mykey = setInfoFromElement((Element)node);
		if (mykey == null) {
			return null;
		}
		NodeList	children = node.getChildNodes();
		int	size = children.getLength();
		for (int i = 0; i < size; ++i) {
			Node	child = children.item(i);
			NSMessage	sub;
			if (child.getNodeType() != Node.ELEMENT_NODE)
				continue;
			sub = NSMessageDriver.getInstance().setNSMessageFromNode(child);
			if (sub != null)
				subs.put(sub.getKey(), sub);
		}
		return mykey;
	}
	public String	getKey() {
		return key;
	}
	public String	getMessage() {
		return msg;
	}
	public void	setKey(String k) {
		key = k;
	}
	public void	setMessage(String m) {
		msg = m;
	}
        public String   setInfoFromElement(Element el) {
                Attr    attrkey = el.getAttributeNode(NSMessage.ATTR_KEY);
                Attr    attrvalue = el.getAttributeNode(NSMessage.ATTR_VALUE);
                if (attrkey == null || attrvalue == null)
                        return null;
                setKey(attrkey.getValue());
		setMessage(attrvalue.getValue());
                return attrkey.getValue();
        }
	private Map	subs;
	private String	key;
	private String	msg;
	public final static String	MESSAGE = "msg";
	public final static String	ATTR_KEY = "key";
	public final static String	ATTR_VALUE = "value";
}
