/*
 *      Copyright (c) 2009 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.entity.snapshot;

public class SnapshotAreaBean {
    private static final String cvsid =
            "@(#) $Id: SnapshotAreaBean.java,v 1.1 2009/01/13 11:27:23 xingyh Exp $";
    
    private String limitArea = "";
    private String usedArea = "";
    
	public String getLimitArea() {
		return limitArea;
	}
	public void setLimitArea(String limitArea) {
		this.limitArea = limitArea;
	}

	public String getUsedArea() {
		return usedArea;
	}
	public void setUsedArea(String usedArea) {
		this.usedArea = usedArea;
	}

}