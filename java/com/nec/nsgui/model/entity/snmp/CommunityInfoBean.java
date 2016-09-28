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

public class CommunityInfoBean {
    private static final String cvsid =
            "@(#) $Id: CommunityInfoBean.java,v 1.1 2005/08/21 04:45:14 zhangj Exp $";
    private String communityName = "";
    private ArrayList sourceList;
    
    /**
     * @return
     */
    public String getCommunityName() {
        return communityName;
    }
    
    /**
     * @return
     */
    public ArrayList getSourceList() {
        return sourceList;
    }
    
    /**
     * @param string
     */
    public void setCommunityName(String string) {
        communityName = string;
    }

    /**
     * @param list
     */
    public void setSourceList(ArrayList list) {
        sourceList = list;
    }
    

}