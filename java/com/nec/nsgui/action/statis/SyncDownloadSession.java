/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.statis;

import java.util.HashMap;

import javax.servlet.http.HttpSession;

/**
 *
 */
public class SyncDownloadSession implements StatisActionConst {
    private static final String cvsid =
        "@(#) $Id: SyncDownloadSession.java,v 1.1 2005/10/18 16:24:27 het Exp $";
    /** 
     *
     */

    static void putInfoHashToSession(
        HttpSession session,
        String sessionKey,
        String downloadWinKey,
        Object info) {
        synchronized (session) {
            HashMap downloadHash = getFromSession(session, sessionKey);
            downloadHash.put(downloadWinKey, info);
            session.setAttribute(sessionKey, downloadHash);
        }
    }

    public static Object getInfoHashFromSession(
        HttpSession session,
        String sessionKey,
        String downloadWinKey) {
        synchronized (session) {
            HashMap downloadHash = (HashMap) session.getAttribute(sessionKey);
            if (downloadHash != null) {
                return downloadHash.get(downloadWinKey);
            } else {
                return null;
            }
        }
    }

    static HashMap getFromSession(HttpSession session, String sessionKey) {
        synchronized (session) {
            if (session.getAttribute(sessionKey) == null) {
                HashMap downloadHash = new HashMap();
                session.setAttribute(sessionKey, downloadHash);
                return downloadHash;
            } else {
                return (HashMap) session.getAttribute(sessionKey);
            }
        }
    }

    public static void removeHashInfoFromSession(
        HttpSession session,
        String sessionKey,
        String downloadWinKey) {
        synchronized (session) {
            HashMap downloadHash = (HashMap) session.getAttribute(sessionKey);
            if (downloadHash == null) {
                return;
            }
            downloadHash.remove(downloadWinKey);
            if (downloadHash.isEmpty()) {
                session.setAttribute(sessionKey, null);
            } else {
                session.setAttribute(sessionKey, downloadHash);
            }
        }
    }

}
