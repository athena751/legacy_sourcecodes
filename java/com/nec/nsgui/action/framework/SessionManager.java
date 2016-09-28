/*
 *      Copyright (c) 2001-2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.action.framework;

import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.account.UserManager;
import com.nec.nsgui.model.biz.base.NSReporter;
import com.nec.nsgui.model.biz.framework.LoginHandler;
import com.nec.nsgui.model.entity.account.NSUser;
/**
 *
 */
public class SessionManager {
    private static final String cvsid = "@(#) $Id: SessionManager.java,v 1.3 2005/10/19 01:40:54 fengmh Exp $";
    
    private static String NSVIEW = "nsview";
    
    public static SessionManager    getInstance() {
        if (_instance == null) {
            _instance = new SessionManager();
        }
        return _instance;
    }
    
    /**
     * @param userName
     * @return
     * @throws Exception
     */
    public int getMaxSession(String userName) throws Exception {
        int maxSession = 1;
        LoginHandler loginHandler = LoginHandler.getInstance();
        if(userName.equals(NSVIEW)){
            maxSession = loginHandler.getNsviewMaxSession();
        }else{
            NSUser user = UserManager.getInstance().getNSUserByUserName(userName);
            if(user != null){
                try{
                    maxSession = Integer.parseInt(user.getSession());
                    if (maxSession <= 0) maxSession = 1;
                }catch(Exception e){}
            }
        }
        return maxSession;
    }
    
    public boolean  checkMaxSessions(String name, boolean isSuperManager, HttpSession session) throws Exception {
        NSSessionCount sc = (NSSessionCount)nSessions.get(name);
        if (sc == null) {
            NSReporter.getInstance().report(NSReporter.DEBUG, name + " is 1st login");
            sc = new NSSessionCount();
        }
        
        int n = getMaxSession(name);
        sc.setMaxCount(n);
        NSReporter.getInstance().report(NSReporter.DEBUG,name + ": " + n + " users ok");
        
        if (isSuperManager) {
            sc.getCurrentCount();
            sc.increase(session);
            NSReporter.getInstance().report(NSReporter.DEBUG, name + ": login as SuperManager");
            nSessions.put(name, sc);
            return true;
        }
        if (sc.canIncrease()) {
            n = sc.increase(session);
            NSReporter.getInstance().report(NSReporter.DEBUG, name + ": " + n + " user(s) login.");
            nSessions.put(name, sc);
            return true;
        }
        NSReporter.getInstance().report(NSReporter.ERROR, name + ": Cannot login" );
        return false;
    }
    
    protected SessionManager() { 
        activeSessions = new HashSet();
        nSessions = new HashMap();
        return; 
    }
    
    /**
     * @param userName
     * @return
     */
    public List  getUserActiveSessions(String userName) {
        NSSessionCount sc = (NSSessionCount)nSessions.get(userName);
        if(sc != null) {
            sc.getCurrentCount();
            return sc.getSessions();
        } else {
            Vector vec = new Vector();
            return vec;
        }
    }
  
    public Map getActiveSessionsInfo(HttpServletRequest request)throws Exception{
           Map map = new HashMap();

           Locale locale = request.getLocale();
           if (!(locale.getLanguage().equals(new Locale("ja", "", "").getLanguage()))){
               locale = Locale.ENGLISH;
           }
           
           if(nSessions == null ){
               return map;
           }
           Iterator it = nSessions.keySet().iterator();
           while(it.hasNext()){
               String userName = (String)it.next();
               Vector sessVec = (Vector)(getUserActiveSessions(userName));
               Vector ciVec = new Vector();
               for (int i = 0; i<sessVec.size();i++ ){
                   HttpSession session = (HttpSession)(sessVec.get(i));
                   String from = (String)(session.getAttribute(NSActionConst.SESSION_REMOTEADDR));
                   Date loginDate = (Date)(session.getAttribute(NSActionConst.SESSION_LOGINTIME));
                   Date lastAccessDate = new Date(session.getLastAccessedTime());
                   long idleTime = System.currentTimeMillis() - session.getLastAccessedTime();
                   idleTime = idleTime / 60000;
                   ClientInfoBean ci = new ClientInfoBean(userName, 
                                                          from , 
                                                          NSActionUtil.date2Str(loginDate, locale), 
                                                          NSActionUtil.date2Str(lastAccessDate, locale),
                                                          (session.getMaxInactiveInterval()<0?-1:session.getMaxInactiveInterval()/60) + "",
                                                          idleTime + "", 
                                                          session.getId());
                   ciVec.add(ci);
               }
               map.put(userName,ciVec);
           }
           return map;
      }
    
    public boolean isExistSession(String sessId){
        if(nSessions == null){
            return false;
        }
        Iterator itUser = nSessions.keySet().iterator();
        
        while(itUser.hasNext()){
            Iterator itSession = getUserActiveSessions(
                                 (String)(itUser.next()))
                                 .iterator();
         
            HttpSession session;
            while(itSession.hasNext()){
                session = (HttpSession)(itSession.next());
                if(sessId.equals(session.getId())){
                    return true;
                }
            }
         }
         return false;
    }
    
    public void changeSessionTimeout(String timeout, String userName) throws Exception {
        if(nSessions == null ){
            return ;
        }
        Vector sessVec = (Vector)(getUserActiveSessions(userName));
        if(sessVec == null || sessVec.isEmpty()) {
            return ;
        }
        for (int i = 0; i<sessVec.size();i++ ){
            HttpSession session = (HttpSession)(sessVec.get(i));
            session.setMaxInactiveInterval(timeout.startsWith("-")?-1:Integer.parseInt(timeout)*60);
        }
    }
    
    public void disconnect(String[] sessionIds) throws Exception {
        if(nSessions == null ){
            return ;
        }
        if(sessionIds == null || sessionIds.length < 1) {
            return ;
        }
        Vector sessVec = (Vector)(getUserActiveSessions(NSActionConst.NSUSER_NSVIEW));
        if(sessVec == null || sessVec.isEmpty()) {
            return ;
        }
        for (int i = 0; i < sessVec.size(); i++ ){
            HttpSession session = (HttpSession)(sessVec.get(i));
            for(int j=0; j < sessionIds.length; j++) {
                if(session.getId().equals(sessionIds[j])) {
                    session.removeAttribute(NSActionConst.SESSION_AUTHENTICATED);
                    session.removeAttribute(NSActionConst.SESSION_USERINFO);
                    session.invalidate();
                }
            }
        }
    }
 
    private static SessionManager   _instance = null;
    protected Map     nSessions = null;
    private Set activeSessions;
}
