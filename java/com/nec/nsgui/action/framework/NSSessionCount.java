/*
 *      Copyright (c) 2001-2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.action.framework;

import  java.util.*;
import  javax.servlet.http.*;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.model.biz.base.NSReporter;

public class NSSessionCount {
    private static final String cvsid = "@(#) $Id: NSSessionCount.java,v 1.3 2005/10/19 01:40:54 fengmh Exp $";
    public NSSessionCount() {
        sessions = new Vector();
        max = -1;   
    }
    public int  getCurrentCount()   {
        /* clean up invavalid sessions */
        int TIMEOUT_INTERVAL = 1000*10;
        synchronized(sessions){
            for(int i = sessions.size()-1; i >= 0 ; i--){
                HttpSession sess = (HttpSession)sessions.get(i);
                try {
                    NSReporter.getInstance().report(
                        NSReporter.DEBUG, "check session: "+sess.getId());
                    sess.getAttributeNames();
                    String user = (String)sess.getAttribute(NSActionConst.SESSION_USERINFO);

                    NSReporter.getInstance().report(
                        NSReporter.DEBUG, "current user: "+user);
                    int maxInactiveInterval = sess.getMaxInactiveInterval();
                    if (user == null || user.equals("")){
                         sessions.remove(i);
                    }else if(maxInactiveInterval < 0){
                        continue;
                    }else if(System.currentTimeMillis() - sess.getLastAccessedTime() > TIMEOUT_INTERVAL + maxInactiveInterval * 1000){
                        NSReporter.getInstance().report(
                            NSReporter.INFO, "session expired: " + " "+ maxInactiveInterval);    
                        sess.invalidate();
                        sessions.remove(i);   
                    }
                } catch (Exception ex) {
                    /* the session has been already invalid */
                    NSReporter.getInstance().report(
                        NSReporter.INFO, "found invalid session");
                    sessions.remove(i);
                }             
            }
        }
        int n = sessions.size();
        return n;
    }
    public boolean  canIncrease() {
        if (getCurrentCount() + 1 > max) {
            return false;
        }
        return true;
    }
    public int  increase(HttpSession sess) {
        synchronized(sessions){
            sessions.add(sess);
        }
        return sessions.size();
    }
    public List getSessions() {
        return sessions;
    }
    public void setMaxCount(int n)  { max = n; }
    private List    sessions;
    private int max;
}
