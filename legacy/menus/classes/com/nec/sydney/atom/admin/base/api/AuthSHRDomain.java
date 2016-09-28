/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */



package com.nec.sydney.atom.admin.base.api;

public class AuthSHRDomain extends AuthDomain{
    private static final String	cvsid = "@(#) AuthSHRDomain.java,v 1.5 2002/03/06 06:37:16 k-nishi Exp";
    
    private String path  = "";
    private String uid   = "";
    private String uname = "";
    private String gid   = "";
    private String gname = "";
    
    public AuthSHRDomain(){
       	setType(TYPE_SHR);
    }

    public void setPath(String path){
	this.path = path;
    }
    public String getPath(){
	return path;
    }
    public void setUid(String uid){
	this.uid = uid;
    }
    public String getUid(){
	return uid;
    }
    public void setUname(String uname){
	this.uname = uname;
    }
    public String getUname(){
	return uname;
    }
    public void setGid(String gid){
	this.gid = gid;
    }
    public String getGid(){
	return gid;
    }
    public void setGname(String gname){
	this.gname = gname;
    }
    public String getGname(){
	return gname;
    }
}
