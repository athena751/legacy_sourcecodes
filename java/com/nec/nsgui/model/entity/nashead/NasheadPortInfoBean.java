/*
 *      Copyright (c) 2004 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.model.entity.nashead;


//port information entity of HBA card
public class NasheadPortInfoBean {

	private static final String cvsid = "@(#) $Id: NasheadPortInfoBean.java,v 1.1 2004/11/12 03:12:06 jiangfx Exp $";
	
	private String portNo   = "";   // port No of HBA card
	private String nodeName = "";   // node-name of WWN 
	private String portName = "";   // port-name of WWN
	
    public void setPortNo(String portNo) {
     	this.portNo = portNo;	
    }
        
    public void setNodeName(String nodeName) {
      	this.nodeName = nodeName;
    }
        
    public void setPortName(String portName) {
       	this.portName = portName;
    }
        
    public String getPortNo() {
      	return portNo;
    }
        
    public String getNodeName() {
       	return nodeName;
    }
        
    public String getPortName() {
    	return portName;
    }
}
