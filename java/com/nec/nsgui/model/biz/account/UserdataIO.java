/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.model.biz.account;

import java.util.HashMap;
import java.util.Map;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.w3c.dom.Text;

import com.nec.nsgui.model.biz.base.ClusterUtil;
import com.nec.nsgui.model.biz.base.CmdExecBase;
import com.nec.nsgui.model.biz.base.NSReporter;
import com.nec.nsgui.model.entity.account.NSUser;
import com.nec.nsgui.model.entity.account.RoleInfo;
import com.nec.nsgui.model.entity.account.StringDefine;

public class UserdataIO implements StringDefine {
    private static final String cvsid =
        "@(#) UserdataIO.java,v 1.2 2004/12/14 04:37:05 k-nishi Exp";
    private final String CONF = "/home/nsadmin/etc/nsusers.xml";
    private Dom dom;

    public UserdataIO() {
        dom = new Dom();
    }
    public Map makeMap() throws Exception {
        Map map = new HashMap();
        Document doc = dom.getDocument(CONF);
        NodeList list = doc.getElementsByTagName(TAG_NSUSER);
        for (int i = 0; i < list.getLength(); i++) {
            NSUser usr = new NSUser();
            Element work = (Element) list.item(i);
            usr.setName(((Element) work).getAttribute(AT_ID));
            usr.setPasswd(dom.getNodeValue(work, TAG_PASSWD));
            usr.setFullName(dom.getNodeValue(work, TAG_FULLNAME));
            usr.setMailAddress(dom.getNodeValue(work, TAG_MAILADDRESS));
            usr.setSession(dom.getNodeValue(work, TAG_SESSION));
            usr.setOrganization(dom.getNodeValue(work, TAG_ORGANIZATION));
            usr.setTel(dom.getNodeValue(work, TAG_TEL));

            NodeList rlist = ((Element) work).getElementsByTagName(TAG_ROLE);
            for (int j = 0; j < rlist.getLength(); j++) {
                RoleInfo rlinfo = readRoleInfo(rlist.item(j));
                usr.setRoleInfo(rlinfo);
            }
            map.put(usr.getName(), usr);
        }
        return map;
    }
    private RoleInfo readRoleInfo(Node parent) {
        String rl = ((Element) parent).getAttribute(AT_ID);
        RoleInfo rlinfo = new RoleInfo();
        rlinfo.setRole(rl);

        NodeList list = ((Element) parent).getElementsByTagName(TAG_TARGET);
        for (int i = 0; i < list.getLength(); i++) {
            Node work = list.item(i);
            String tg = dom.getText(work);
            String tp = ((Element) work).getAttribute(AT_TYPE);
            rlinfo.setTarget(tg, tp);
        }
        return rlinfo;
    }
    protected Node getUserRoot(Document doc, String uname) {
        NodeList list = doc.getElementsByTagName(TAG_NSUSER);
        return dom.searchNode(list, AT_ID, uname);
    }
    public void checkout() throws Exception {
        commit("checkout", CONF);
    }
    public void checkin() throws Exception {
        commit("checkin", CONF);
    }
    public void rollback() throws Exception {
        commit("rollback", CONF);
    }
    public void commit(String cvsCmd, String file) throws Exception {
        String[] cmd = { "/home/nsadmin/bin/" + cvsCmd, file };
        CmdExecBase.localExecCmd(cmd, null);
    }

    public void setPasswd(String user, String passwd) throws Exception {
        NSReporter.getInstance().report(
            NSReporter.DEBUG,
            "write the password to " + CONF);
        Document doc = dom.getDocument(CONF);
        Element userElm = (Element) getUserRoot(doc, user);
        Element passwdElm = (Element) dom.getNodeByTag(userElm, TAG_PASSWD);
        Text newPasswd = doc.createTextNode(passwd);
        Node oldPasswd = passwdElm.getFirstChild();
        if (oldPasswd != null) {
            passwdElm.replaceChild(newPasswd, oldPasswd);
        } else {
            passwdElm.appendChild(newPasswd);
        }
        dom.write(doc, CONF);
        NSReporter.getInstance().report(
            NSReporter.DEBUG,
            "writed successfully");

    }

    public void delete(String user) throws Exception {
        NSReporter.getInstance().report(NSReporter.DEBUG, "delete" + user);
        dom = new Dom();
        Document doc = dom.getDocument(CONF);

        Element userElm = (Element) getUserRoot(doc, user);
        doc.getDocumentElement().removeChild(userElm);
        dom.write(doc, CONF);

        NSReporter.getInstance().report(
            NSReporter.DEBUG,
            "delete successfully.");
    }
    public void addnsview(String password) throws Exception {
        NSReporter.getInstance().report(NSReporter.DEBUG, "add nsview.");
        dom = new Dom();
        Document doc = dom.getDocument(CONF);

        Element user = doc.createElement("user");
        user.setAttribute("id", "nsview");
        Element info = doc.createElement("info");
        Element gecos = doc.createElement("gecos");
        gecos.appendChild(doc.createTextNode("System Viewer"));
        Element passwd = doc.createElement("passwd");
        passwd.appendChild(doc.createTextNode(password));
        Element mail = doc.createElement("mail");
        mail.appendChild(doc.createTextNode("root"));
        Element max = doc.createElement("max");
        max.appendChild(doc.createTextNode("8"));
        Element organization = doc.createElement("organization");
        organization.appendChild(doc.createTextNode("NEC"));
        Element tel = doc.createElement("tel");
        tel.appendChild(doc.createTextNode(""));
        info.appendChild(gecos);
        info.appendChild(passwd);
        info.appendChild(mail);
        info.appendChild(max);
        info.appendChild(organization);
        info.appendChild(tel);
        user.appendChild(info);
        Element role = doc.createElement("role");
        role.setAttribute("id", "SystemViewer");
        user.appendChild(role);
        doc.getDocumentElement().appendChild(user);

        dom.write(doc, CONF);
        NSReporter.getInstance().report(
            NSReporter.DEBUG,
            "add nsview successfully.");
    }

    public void clusterSync() throws Exception {
        ClusterUtil util = ClusterUtil.getInstance();
        if (util.isCluster()) {
            NSReporter.getInstance().report(
                NSReporter.INFO,
                "synchronized my friend.");
            int myFriendNo = (util.getMyNodeNo() == 0) ? 1 : 0;
            String[] files = { CONF };
            util.remoteSync(files, myFriendNo);
            NSReporter.getInstance().report(
                NSReporter.INFO,
                "synchronized successfully");
        }
    }

}
