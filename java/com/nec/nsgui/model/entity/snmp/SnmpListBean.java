/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.snmp;

import java.util.ArrayList;

/**
 *
 */
public class SnmpListBean {
    private static final String cvsid =
            "@(#) $Id: SnmpListBean.java,v 1.1 2005/08/21 04:45:14 zhangj Exp $";
    private String nodeNo = "";   
    private String contact = "";
    private String location = "";
    private ArrayList communityList;
    private ArrayList userList;
    
    /**
     * @return
     */
    public String getNodeNo() {
        return nodeNo;
    }
    /**
     * @return
     */
    public String getContact() {
        return contact;
    }
    
    /**
     * @return
     */
    public String getLocation() {
        return location;
    }
    
    /**
     * @return
     */
    public ArrayList getCommunityList() {
        return communityList;
    }
    
    /**
     * @return
     */
    public ArrayList getUserList() {
        return userList;
    }
    
    /**
     * @return
     */
    public void setNodeNo(String string) {
        nodeNo = string;
    }
    /**
     * @param string
     */
    public void setContact(String string) {
        contact = string;
    }

    /**
     * @param string
     */
    public void setLocation(String string) {
        location = string;
    }

    /**
     * @param CommunityList
     */
    public void setCommunityList(ArrayList CommunityList) {
        communityList = CommunityList;
    }

    /**
     * @param UserList
     */
    public void setUserList(ArrayList UserList) {
        userList = UserList;
    }

}