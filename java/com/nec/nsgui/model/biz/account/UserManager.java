/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.model.biz.account;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.Vector;

import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;

import com.nec.nsgui.model.biz.base.NSException;
import com.nec.nsgui.model.biz.base.NSReporter;
import com.nec.nsgui.model.entity.account.NSUser;
import com.nec.nsgui.model.entity.account.TargetInfo;

public class UserManager {
    private static final String cvsid =
        "@(#) UserManager.java,v 1.2 2004/12/14 04:36:45 k-nishi Exp";
    static private UserManager _instance = null;
    private UserdataIO userio = new UserdataIO();
    private final String ALGORITHM = "MD5";

    private UserManager() {
    }

    static public UserManager getInstance() {
        if (_instance == null) {
            _instance = new UserManager();
        }
        return _instance;
    }
    public Map getNsusers() throws Exception {
        Map map = userio.makeMap();
        return map;
    }
    public NSUser getNSUserByUserName(String name) throws Exception {
        Map map = getNsusers();
        if (map.isEmpty())
            return null;
        return (NSUser) map.get(name);
    }
    public NSUser getNSUserByServerId(String id) throws Exception {
        NSUser usr;
        Map map = getNsusers();
        Set set = map.entrySet();
        Iterator it = set.iterator();
        while (it.hasNext()) {
            Map.Entry mapentry = (Map.Entry) it.next();
            usr = (NSUser) mapentry.getValue();
            Vector targets = usr.getAllTarget();
            Iterator it2 = targets.iterator();
            while (it2.hasNext()) {
                TargetInfo tginfo = (TargetInfo) it2.next();
                if (tginfo.getTarget().indexOf(id) >= 0)
                    return usr;
            }
        }
        return null;
    }
    public boolean checkLogin(String name, String pass) throws Exception {
        NSUser usr = getNSUserByUserName(name);
        if (usr != null) {
            String encodedPasswd = usr.getPasswd();
            if (encodedPasswd == null || encodedPasswd.equals("")) {
                if (pass == null || pass.equals(""))
                    return true;
                else
                    return false;
            } else if (pass == null || pass.equals("")) {
                return false;
            }
            byte[] userpass;
            try {
                userpass = decode(usr.getPasswd());
            } catch (Exception e) {
                NSException nse = new NSException(e.getClass().getName());
                nse.setDetail(e.getMessage());
                throw nse;
            }
            try {
                MessageDigest md = MessageDigest.getInstance(ALGORITHM);
                byte[] inputpass = md.digest(pass.getBytes());
                if (MessageDigest.isEqual(userpass, inputpass))
                    return true;
            } catch (NoSuchAlgorithmException e) {
                NSException nse = new NSException(e.getClass().getName());
                nse.setDetail(e.getMessage());
                throw nse;
            }
        }
        return false;
    }
    public String encode(String str) {
        String ps = new String();
        try {
            MessageDigest md = MessageDigest.getInstance(ALGORITHM);
            byte[] w = md.digest(str.getBytes());
            ps = new BASE64Encoder().encode(w);
        } catch (NoSuchAlgorithmException e) {
            NSReporter.getInstance().report(
                NSReporter.ERROR,
                e.getClass().getName() + ":" + e.getMessage());
        }
        return ps;
    }
    public byte[] decode(String str) throws Exception {
        return (new BASE64Decoder().decodeBuffer(str));
    }
    public void setPasswd(String user, String passwd) throws Exception {
        NSReporter.getInstance().report(
            NSReporter.INFO,
            "Changing password for " + user);
        userio.checkout();
        try {
            String md5Str = encode(passwd);
            userio.setPasswd(user, md5Str);

            // for cluster
            userio.clusterSync();
            userio.checkin();
        } catch (Exception e) {
            NSReporter.getInstance().report(
                NSReporter.ERROR,
                e.getClass().getName() + ":" + e.getMessage());
            userio.rollback();
            throw e;
        }
        NSReporter.getInstance().report(
            NSReporter.INFO,
            "passwd:updated successfully.");
    }

    public void delete(String user) throws Exception {
        NSReporter.getInstance().report(NSReporter.INFO, "delete " + user);
        userio.checkout();
        try {
            userio.delete(user);
            // for cluster
            userio.clusterSync();
            userio.checkin();
        } catch (Exception e) {
            NSReporter.getInstance().report(
                NSReporter.ERROR,
                e.getClass().getName() + ":" + e.getMessage());
            userio.rollback();
            throw e;
        }
        NSReporter.getInstance().report(
            NSReporter.INFO,
            "delete successfully.");
    }

    public void addnsview(String user, String passwd) throws Exception {
        NSReporter.getInstance().report(NSReporter.INFO, "add nsview.");
        userio.checkout();
        try {
            String md5Str = encode(passwd);
            userio.addnsview(md5Str);

            // for cluster
            userio.clusterSync();
            userio.checkin();
        } catch (Exception e) {
            NSReporter.getInstance().report(
                NSReporter.ERROR,
                e.getClass().getName() + ":" + e.getMessage());
            userio.rollback();
            throw e;
        }
        NSReporter.getInstance().report(
            NSReporter.INFO,
            "add nsview successfully.");
    }
}
