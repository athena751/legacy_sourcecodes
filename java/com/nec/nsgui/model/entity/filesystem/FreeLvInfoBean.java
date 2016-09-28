/*
 *      Copyright (c) 2005-2006 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.model.entity.filesystem;

public class FreeLvInfoBean{
	private static final String cvsid =
        "@(#) $Id: FreeLvInfoBean.java,v 1.2 2006/06/08 10:17:46 jiangfx Exp $";
	private String lvPath = "";
	private String lvSize = "";
	private String lvNickName = "";
	private String value4Show = "";
    private String vgPairFlag = "1";
	
	public String getLvPath(){
		return lvPath;
	}
	public String getLvSize(){
		return lvSize;
	}
	public String getLvNickName(){
		return lvNickName;
	}
	public String getValue4Show() {
		return value4Show;
	}	
	
	public void setLvPath(String string){
		lvPath = string;
	}
	public void setLvSize(String string){
		lvSize = string;
	}
	public void setLvNickName(String string){
		lvNickName = string;
	}
	public void setValue4Show(String string) {
		value4Show = string;
	}

    public String getVgPairFlag() {
        return vgPairFlag;
    }
    public void setVgPairFlag(String vgPairFlag) {
        this.vgPairFlag = vgPairFlag;
    }
}