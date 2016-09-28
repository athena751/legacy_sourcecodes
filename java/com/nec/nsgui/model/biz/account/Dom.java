/*
 *      Copyright (c) 2004 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.model.biz.account;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.apache.xml.serialize.OutputFormat;
import org.apache.xml.serialize.XMLSerializer;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.w3c.dom.Text;

import com.nec.nsgui.model.biz.base.CmdExecBase;
import com.nec.nsgui.model.biz.base.NSException;

public class Dom {
    public static final String cvsid =
        "@(#) $Id: Dom.java,v 1.3 2005/08/24 04:33:19 wangli Exp $";
    private final String CODE = "euc-jp";
    private final String CMD_SYNC_FILE ="/home/nsadmin/bin/nsgui_syncwrite";
    public Document getDocument(String srcFile) throws NSException {
        Document document;
        try {
            DocumentBuilderFactory factory =
                DocumentBuilderFactory.newInstance();
            factory.setCoalescing(true);
            DocumentBuilder db = factory.newDocumentBuilder();
            document = db.parse(srcFile);
        } catch (Exception e) {
            NSException nse = new NSException(e.getClass().getName());
            nse.setDetail(e.getMessage());
            throw nse;
        }
        return document;
    }
    public void write(Document doc, String srcFile) throws Exception {
        Writer out = null;
        try {
            File file = new File(srcFile);
            doc.normalize();
            OutputFormat of = new OutputFormat(doc);
            of.setIndenting(true);
            of.setEncoding(CODE);
            FileOutputStream fos = new FileOutputStream(file);
            OutputStreamWriter osw = new OutputStreamWriter(fos, CODE);
            out = new BufferedWriter(osw);
            XMLSerializer xs = new XMLSerializer(out, of);
            xs.asDOMSerializer();
            xs.serialize(doc.getDocumentElement());
        } catch (Exception e) {
            NSException nse = new NSException(e.getClass().getName());
            nse.setDetail(e.getMessage());
            throw nse;
        } finally {
            out.close();
            String[] cmds = { CmdExecBase.CMD_SUDO, CMD_SYNC_FILE, "--fsync",
                    srcFile };
            CmdExecBase.localExecCmd(cmds, null);
        }
    }
    public Node getNodeByTag(Element root, String tag) {
        NodeList list = root.getElementsByTagName(tag);
        return (list == null ? null : list.item(0));
    }
    public String getNodeValue(Element root, String tag) {
        Node node = getNodeByTag(root, tag);
        return getText(node);
    }
    public String getText(Node node) {
        if (node == null)
            return "";
        StringBuffer sbuf = new StringBuffer();
        for (Node child = node.getFirstChild();
            child != null;
            child = child.getNextSibling()) {
            if (child.getNodeType() == Node.TEXT_NODE) {
                sbuf.append(child.getNodeValue());
            }
        }
        return new String(sbuf);
    }
    public Node searchNode(NodeList list, String attr, String val) {
        int len = list.getLength();
        Element el = null;
        for (int i = 0; i < len; i++) {
            Node child = list.item(i);
            if (child.getNodeType() == Node.ELEMENT_NODE) {
                el = (Element) child;
                if (el.hasAttribute(attr) && el.getAttribute(attr).equals(val))
                    return el;
            }
        }
        return null;
    }
    public void addText(Element parent, String text) {
        Document doc = parent.getOwnerDocument();
        Text txt = doc.createTextNode(text);
        parent.appendChild(txt);
    }
    public Node addNode(Element parent, String tagname, String text, Map attr)
        throws Exception {
        Document doc = parent.getOwnerDocument();
        Element work = doc.createElement(tagname);
        /** add text */
        if (text != null)
            addText(work, text);

        /** add attribute
         *  Mapkey = AttributeName
         *  Mapval = AttributeValue
         */
        if (attr != null) {
            Set set = attr.keySet();
            Iterator it = set.iterator();
            while (it.hasNext()) {
                String key = (String) it.next();
                work.setAttribute(key, (String) attr.get(key));
            }
        }

        /** add element */
        parent.appendChild(work);

        return work;
    }
}
