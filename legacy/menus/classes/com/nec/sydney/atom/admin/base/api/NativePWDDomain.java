/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */



package com.nec.sydney.atom.admin.base.api;

import java.util.*;

public class NativePWDDomain extends NativeDomain{
    private static final String	cvsid = "@(#) NativePWDDomain.java,v 1.7 2003/01/14 09:25:09 k-nishi Exp";
    
    private String passwd;
    private String group;
    private final String DELIM = ":";
    
    public NativePWDDomain(){
	setType(TYPE_PWD);
    }

    public void setPasswd(byte[] passwd){
        this.passwd = byte2HexStr(passwd);
    }
    public byte[] getPasswd(){
        return hexStr2byte(passwd);
    }
    public String getPasswdStr(){
        return this.passwd;
    }
    public void setGroup(byte[] group){
        this.group = byte2HexStr(group);
    }
    public byte[] getGroup(){
        return hexStr2byte(group);
    }
    public String getGroupStr(){
        return this.group;
    }
    public String byte2HexStr(byte[] bt){
        StringBuffer sbuf = new StringBuffer();
        if(bt.length!=0){
            for(int i=0;i<bt.length;i++){
                int mt = bt[i] & 0xff;
                String hexStr = Integer.toHexString(mt);
                if(hexStr.length()<2){
                    sbuf.append("0").append(hexStr).append(DELIM);
                }else{
                    sbuf.append(hexStr).append(DELIM);
                }
            }
        }
        return new String(sbuf);
    }
    public byte[] hexStr2byte(String hexStr){
        StringTokenizer st = new StringTokenizer(hexStr,DELIM);
        Vector vec = new Vector();
        while(st.hasMoreTokens())
            vec.add(st.nextToken());
        byte[] bt = new byte[vec.size()];
        for(int i=0;i<bt.length;i++)
            bt[i] = (byte)Integer.parseInt((String)vec.get(i),16);
            
        return bt;
    }
    /** new add */
    public boolean compare(Object obj){
	if(!super.compare(obj))
            return false;
        
        NativePWDDomain pwd = (NativePWDDomain)obj;
	//        if(!passwd.equals(pwd.getPasswdStr()))
	//            return false;
	//        if(!group.equals(pwd.getGroupStr()))
	//            return false;
        if(!network.equals(pwd.getNetwork()))
	    return false;
        return true;

    }
    /** old */
    public void setPath(String path){
    }
    public String getPath(){
	return null;
    }
}

