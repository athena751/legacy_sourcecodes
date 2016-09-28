/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.framework;

import java.io.File;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.StringTokenizer;
import java.util.Vector;

import javax.servlet.http.HttpSession;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public class NSMessageDriver {
    private static final String cvsid = "@(#) $Id: NSMessageDriver.java,v 1.2301 2005/06/13 07:25:58 liuyq Exp $";

    public static final String KEY_PREFIX = "MSG_KEY_START_";

    public static final String KEY_SUFFIX = "_MSG_KEY_END";

    public static final String SESSION_KEY_STRUTS_LOCALE = "org.apache.struts.action.LOCALE";

    protected NSMessageDriver() {
        langmsgs = null;
        currentLang = "default";
    }

    public static NSMessageDriver getInstance() {
        if (_instance == null)
            _instance = new NSMessageDriver();
        return _instance;
    }

    public void init() {
        langmsgs = new HashMap();
        try {
            String MessageDir = NSConstant.HomeDirectory + "/etc/messages/";
            String[] dirs = { "ja", "en", "default" };
            for (int d = 0; d < dirs.length; ++d) {
                File dir = new File(MessageDir + dirs[d]);
                File[] ls = dir.listFiles();
                Map msgs = new HashMap();
                for (int l = 0; l < ls.length; ++l) {
                    parseMessageXML(dirs[d], ls[l], msgs);
                }
            }
        } catch (Exception ex) {
            NSReporter.getInstance().report(NSReporter.ERROR, ex.getMessage());
        }
    }

    public void parseMessageXML(String lang, File file, Map msgs)
            throws Exception {
        String xml = file.getPath();
        if (!xml.endsWith(".xml"))
            return;
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        DocumentBuilder builder = factory.newDocumentBuilder();
        Document doc = builder.parse(xml);
        doc.normalize();
        Node root = doc.getDocumentElement();
        NodeList children = root.getChildNodes();
        Map map = new HashMap();
        // st must have ".", because xml endWith(".xml");
        StringTokenizer st = new StringTokenizer(file.getName(), ".");
        String facility = st.nextToken();
        NSReporter.getInstance().report(NSReporter.DEBUG,
                "message facility: " + facility);
        for (int i = 0; i < children.getLength(); ++i) {
            Node node = children.item(i);
            if (node.getNodeType() != Node.ELEMENT_NODE)
                continue;
            NSMessage msg = setNSMessageFromNode(node);
            map.put(msg.getKey(), msg);
        }
        NSMessage each = new NSMessage();
        each.setChildren(map);
        msgs.put(facility, each);
        langmsgs.put(lang, msgs);
    }

    protected NSMessage setNSMessageFromNode(Node node) {
        String type = ((Element) node).getTagName();
        if (!type.equalsIgnoreCase(NSMessage.MESSAGE))
            return null;
        NSMessage msginfo = new NSMessage();
        if (msginfo.setInfoFromNode(node) == null)
            return null;
        NSReporter.getInstance().report(NSReporter.DEBUG,
                msginfo.getKey() + ":" + msginfo.getMessage());
        return msginfo;
    }

    /**
     * Get the message from xml according to id, and replace the %n with
     * replacements. If the separate = true, the result message will be
     * separated with '+' before %n and after %n. for example: message = "The
     * export root[%1] has deleted." key = "export"; replacements = new
     * Vector(); replacements.add("/export/root"); result =
     * getMessage(sess,key,alt,replacements,false); The result is "The export
     * root[/export/root] has deleted." resultSep =
     * getMessage(sess,key,alt,replacements,true); The resultSep is "\"The
     * export root[\"+/export/root+\"] has deleted."
     * 
     * @param sess
     *            HttpSession
     * @param id
     *            the message key in the xml
     * @param alt
     *            alt message
     * @param replacements
     *            the replacements vector
     * @param separate
     *            whether separate the result message with "+"
     * @return result message
     */
    public String getMessage(HttpSession sess, String id, String alt,
            Vector replacements, boolean separate) {
        return getMessageByLang(getLang(sess), id, alt, replacements, separate);
    }

    /**
     * modified by changhs 2005/05/18 for multiple user login.
     */
    private String getMessageByLang(String lang, String id, String alt,
            Vector replacements, boolean separate) {
        StringTokenizer st = new StringTokenizer(id, "/");
        if (st.countTokens() <= 1)
            return alt;
        String facility = st.nextToken();
        Map msgs = (Map) langmsgs.get(lang);
        NSMessage msg = (NSMessage) msgs.get(facility);
        if (msg == null)
            return alt;
        Map children = msg.getChildren();
        while (st.hasMoreTokens()) {
            String key = st.nextToken();
            msg = (NSMessage) children.get(key);
            if (msg == null)
                break;
            children = msg.getChildren();
        }
        return msg == null ? alt : replaceMessage(msg.getMessage(),
                replacements, separate);
    }

    public String getMessage(HttpSession sess, String id, String alt) {
        return getMessage(sess, id, alt, null, false);
    }

    public String getMessage(HttpSession sess, String key) {
        return getMessage(sess, key, "unknown message(" + key + ")");
    }

    public String getMessage(String key, Vector replacements, boolean separate) {
        return getMessage(null, key, "unknown message(" + key + ")",
                replacements, separate);
    }

    public String getMessage(String key, Vector replacements) {
        return getMessage(key, replacements, false);
    }

    public String getMessage(String key, String[] replacements, boolean separate) {
        Vector replaceVector = null;
        for (int i = 0; i < replacements.length; i++) {
            if (replaceVector == null) {
                replaceVector = new Vector();
            }

            replaceVector.add(replacements[i]);
        }
        return getMessage(key, replaceVector, separate);
    }

    public String getMessage(String key, String[] replacements) {
        return getMessage(key, replacements, false);
    }

    public String getMessage(String key) {
        return getMessage(null, key);
        /**
         * in the future , replace the code above with the follows: return
         * KEY_PREFIX + key + KEY_SUFFIX;
         */
    }

    /**
     * Replace the messages with the elements in the vector replacements
     * 
     * @param message
     *            the orignal message
     * @param replacements
     *            the vection which contains the replacement string
     * @param separate
     *            whether separate the result message with "+"
     * @return the result message
     * @see getMessage
     */
    private String replaceMessage(String message, Vector replacements,
            boolean separate) {

        if (replacements == null) {
            return message;
        }

        StringBuffer buffer = new StringBuffer(message.length());
        int status = COMMON_STATUS; // START
        int pos = 0;
        int replaceStart = 0;
        int replaceEnd = 0;
        int start = 0;
        boolean plusAppended = false;
        char ch = '\0';
        int len = message.length();
        do {
            ch = pos < len ? message.charAt(pos) : 0;

            switch (status) {
            case COMMON_STATUS: // common
                if (ch == 0) {
                    if (start < len) {
                        if (plusAppended) {
                            buffer.append("\"")
                                    .append(message.substring(start)).append(
                                            "\"");
                            ;
                        } else {
                            buffer.append(message.substring(start));
                        }
                    }
                    status = END_STATUS;
                } else if (ch == '%') {
                    status = PERCENT_STATUS; // % status
                    replaceStart = pos;
                    pos++;
                } else {
                    pos++;
                }
                break;

            case PERCENT_STATUS: // %status
                if (Character.isDigit(ch)) {
                    pos++;
                } else {
                    replaceEnd = pos;
                    status = REPLACE_STATUS;
                }
                break;

            case REPLACE_STATUS: // replace

                if (replaceEnd == (replaceStart + 1)) { // just one %
                    status = COMMON_STATUS;
                } else {

                    String subStr = message.substring(replaceStart + 1,
                            replaceEnd);

                    int replacePos = Integer.parseInt(subStr) - 1;
                    if ((replacePos >= replacements.size()) || (replacePos < 0)) {
                        status = COMMON_STATUS;
                        replaceStart = replaceEnd = start;
                    } else {

                        if (replaceStart > start) {
                            subStr = message.substring(start, replaceStart);
                            if (separate) {
                                buffer.append("\"").append(subStr).append("\"");
                            } else {
                                buffer.append(subStr);
                            }

                            if (separate) {
                                buffer.append("+");
                            }
                        }

                        buffer.append((String) replacements.get(replacePos));

                        // Not the last characeter
                        if ((separate) && (pos < len)) {
                            buffer.append("+");
                            plusAppended = true;
                        }

                        status = COMMON_STATUS;
                        start = replaceStart = replaceEnd;

                    }
                }

                break;
            } // end of switch

        } while (status != END_STATUS);

        return buffer.toString();

    }

    /**
     * added by changhs 2005/05/18 for multiple user login.
     */
    public String getLang(HttpSession sess) {
        if (sess != null
                && sess.getAttribute(SESSION_KEY_STRUTS_LOCALE) != null) {
            Locale locale = (Locale) sess
                    .getAttribute(SESSION_KEY_STRUTS_LOCALE);
            return locale.getLanguage().equals(
                    (new Locale("ja", "", "")).getLanguage()) ? "ja" : "en";
        } else {
            return currentLang; // for old component that not yet been strutsed.
        }
    }

    public String getMessage(HttpSession sess, String key, Vector replacements,
            boolean separate) {
        return getMessage(sess, key, "unknown message(" + key + ")",
                replacements, separate);
    }

    public String getMessage(HttpSession sess, String key, Vector replacements) {
        return getMessage(sess, key, "unknown message(" + key + ")",
                replacements, false);
    }

    public String getMessage(HttpSession sess, String key,
            String[] replacements, boolean separate) {
        Vector tmpVector = null;
        if (replacements != null) {
            tmpVector = new Vector();
            for (int i = 0; i < replacements.length; i++) {
                tmpVector.add(replacements[i]);
            }
        }
        return getMessage(sess, key, "unknown message(" + key + ")", tmpVector,
                separate);
    }

    public String getMessage(HttpSession sess, String key, String[] replacements) {
        return getMessage(sess, key, replacements, false);
    }

    public String reformMessage(String msg, String lang) {
        if (msg != null && !msg.equals("")) {
            int i = msg.indexOf(KEY_PREFIX);
            int j = msg.indexOf(KEY_SUFFIX);
            if (i < 0 || j < 0 || i >= j)
                return msg;
            String key = msg.substring(i, j).replaceAll(KEY_PREFIX, "");
            String newMsg = getMessageByLang(lang, key, "unknown message("
                    + key + ")", null, false);
            return msg.replaceAll(KEY_PREFIX + key + KEY_SUFFIX, newMsg);
        }
        return msg;
    }

    public String reformMessage(String msg, HttpSession sess) {
        return reformMessage(msg, getLang(sess));
    }
    
    public String reformMessage(Throwable e, HttpSession sess) {
        StringWriter    sw = new StringWriter();
        PrintWriter writer = new PrintWriter(sw);
        e.printStackTrace(writer);
        return reformMessage(sw.toString(),sess);
    }
    /**
     * end add by changhs 2005/05/18
     * */

    public void setCurrentLang(String l) {
        currentLang = l;
    }

    public String getCurrentLang() {
        return currentLang;
    }

    protected static NSMessageDriver _instance;

    protected Map langmsgs;

    private String currentLang;

    /** The status is used for parsing the message */

    /** parse over */
    private static final int END_STATUS = 0;

    /** common character status */
    private static final int COMMON_STATUS = 1;

    /** enter the %n status */
    private static final int PERCENT_STATUS = 2;

    /** replacing the message status */
    private static final int REPLACE_STATUS = 3;

}
