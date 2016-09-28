/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.atom.admin.exportroot;

public class ExportGroupInfo{
    private static final String cvsid = "@(#) $Id: ExportGroupInfo.java,v 1.2 2004/08/24 09:58:36 xiaocx Exp $";
    
    private String exportGroupName;
    private String encoding;
    private String userDB;
    private String ntDomain;
    private String netBios;
    private String mounted;
    
    public ExportGroupInfo(){
	exportGroupName = "";
	encoding = "";
	userDB = "";
	ntDomain = "";
	netBios = "";
	mounted = "";
    }

    public void setExportGroupName(String exportGroupName){
	this.exportGroupName = exportGroupName;
    }
    
    public String getExportGroupName(){
        return exportGroupName;
    }

    public void setEncoding(String encoding){
        this.encoding = encoding; 
    }

    public String getEncoding(){
        return encoding;
    }

    public void setUserDB(String userDB){
        this.userDB = userDB; 
    }

    public String getUserDB(){
        return userDB;
    }

    public void setNtDomain(String ntDomain){
        this.ntDomain = ntDomain; 
    }

    public String getNtDomain(){
        return ntDomain;
    }

    public void setNetBios(String netBios){
        this.netBios = netBios; 
    }

    public String getNetBios(){
        return netBios;
    }

    public void setMounted(String mounted){
        this.mounted = mounted; 
    }

    public String getMounted(){
        return mounted;
    }
    
}
