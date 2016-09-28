/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.atom.admin.exportroot;

import java.util.List;

public class EntryInfoBean {
    private static final String cvsid =
        "@(#) $Id: EntryInfoBean.java,v 1.1 2004/09/01 04:13:55 xiaocx Exp $";

    private String directory;
    private List clients;
    private int clientNum;
    private boolean isNormal;

    public EntryInfoBean() {
    }


    /**
     * @return
     */
    public int getClientNum() {
        return clientNum;
    }

    /**
     * @return
     */
    public List getClients() {
        return clients;
    }

    /**
     * @return
     */
    public String getDirectory() {
        return directory;
    }

    /**
     * @return
     */
    public boolean getIsNormal() {
        return isNormal;
    }

    /**
     * @param i
     */
    public void setClientNum(int i) {
        clientNum = i;
    }

    /**
     * @param list
     */
    public void setClients(List list) {
        clients = list;
    }

    /**
     * @param string
     */
    public void setDirectory(String string) {
        directory = string;
    }

    /**
     * @param b
     */
    public void setIsNormal(boolean b) {
        isNormal = b;
    }

}