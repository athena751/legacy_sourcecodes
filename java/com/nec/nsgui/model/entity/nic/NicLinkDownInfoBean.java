/*
 *      Copyright (c) 2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *      $Id: NicLinkDownInfoBean.java,v 1.1 2007/08/24 01:25:02 wanghui Exp $
 */

package com.nec.nsgui.model.entity.nic;

import org.apache.struts.action.ActionForm;

public class NicLinkDownInfoBean extends ActionForm{
    
    private static final String cvsid = "@(#) $Id: NicLinkDownInfoBean.java,v 1.0 2006/02/21 05:26:33 wanghui Exp";    
    public String takeOver = "no";
    public String bondDown = "all";
    public String checkInterval = "30";
    public String ignoreList = "";
    
    public String getBondDown() {
        return bondDown;
    }
    public void setBondDown(String bondDown) {
        this.bondDown = bondDown;
    }
    public String getCheckInterval() {
        return checkInterval;
    }
    public void setCheckInterval(String checkInterval) {
        this.checkInterval = checkInterval;
    }
    public String getIgnoreList() {
        return ignoreList;
    }
    public void setIgnoreList(String ignoreList) {
        this.ignoreList = ignoreList;
    }
    public String getTakeOver() {
        return takeOver;
    }
    public void setTakeOver(String takeOver) {
        this.takeOver = takeOver;
    } 
    
    
}
