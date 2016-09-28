/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.atom.admin.nfs;

public class ExportsInfo{

    private static final String     cvsid = "@(#) $Id: ExportsInfo.java,v 1.2302 2004/02/13 00:34:03 key Exp $";


    String        path;        //    String    Path being export
    String        host;        //    String    Host information
    int        accessMode;    //    int    1:read only; 0:read and write
    int        subtreeCheck;    //    int    1:subtreeCheck; 0:no subtree check
    int        trustRemoteUser;//    int     1:trust everyone except root ;0:trust nobody
    int        trustRoot;       //   int     0:trust root; 1: not trust root
    int        anonymousuid;    //    int     anonymous uid;default :-2
    int        anonymousgid;    //    int     anonymous gid;default:-2
    int        hide;        //    int    1:hide, 0:no hide
    int        map;        //    int    1:no map,  0; map
    int     absIndex;    //    index in /etc/exports
    int     relIndex;    //    index in export infos which have the same path
    int     number;        //    number of export infos which have the same path
    int     anon;       // if 1, not write; else write "anon";
    int     secure;     // if 1, not write; else write "insecure";
    int     secureLocks;    // if 1, not write; else write "insecure_locks";

    int	profile = 0;
    int	accesslog = 0;
    String nisDomain;

    public ExportsInfo(){//    constructor.
    //set default value for all properties
        path=new String();
        host=new String();
        accessMode=1;
        subtreeCheck=1;
        trustRemoteUser=1;
        trustRoot = 1;
        anonymousuid=-2;
        anonymousgid=-2;
        hide=1;
        map=1;
        anon=1;
        secure=1;
        secureLocks=1;
        absIndex=-1;
        relIndex=-1;
        number=0;
        String nisDomain="";
    }
    public void setAbsIndex(int i){
        absIndex=i;
    }
    public void setRelIndex(int i){
        relIndex=i;
    }
    public void setNumber(int i){
        number=i;
    }
    public void setPath(String dir){//    set value of path
        path=dir;
    }
    public void setHost(String sHost){//    set value of host
        host=sHost;
    }
    public void setAccessMode(int flag){//    set value of accessMode
        accessMode=flag;
    }
    public void setSubtreeCheck(int flag){//    set value of subtreeCheck
        subtreeCheck=flag;
    }
    public void setTrustRemoteUser(int flag){//    set value of trustRemoteUser
        trustRemoteUser=flag;
    }
    public void setAnonymousuid(int flag){//    set value of anonymousuid
        anonymousuid=flag;
    }
    public void setAnonymousgid(int flag){//    set value of anonymousgid
        anonymousgid=flag;
    }
    public void setHide(int flag){//        set value of hide
        hide=flag;
    }
    public void setMap(int flag){//    set value of map
        map=flag;
    }
    public int getAbsIndex(){
        return absIndex;
    }
    public int getRelIndex(){
        return relIndex;
    }
    public int getNumber(){
        return number;
    }    
    public String getPath(){
        return path;
    }
    public String getHost(){
        return host;
    }
    public int getAccessMode(){
        return accessMode;
    }
    public int getSubtreeCheck(){
        return subtreeCheck;
    }
    public int getTrustRemoteUser(){
        return trustRemoteUser;
    }
    public int getAnonymousuid(){
        return anonymousuid;
    }
    public int getAnonymousgid(){
        return anonymousgid;
    }
    public int getHide(){
        return hide;
    }
    public int getMap(){
        return map;
    }

    public int getAnon(){
        return anon;
    }
    public void setAnon(int flag){
        anon=flag;
    }

    public int getTrustRoot(){
        return trustRoot;
    }
    public void setTrustRoot(int i_trustRoot){
        trustRoot = i_trustRoot;
    }

    public int getSecure(){
        return secure;
    }
    public void setSecure(int i_secure){
        secure = i_secure;
    }
    public int getSecureLocks(){
        return secureLocks;
    }
    public void setSecureLocks(int i_secureLocks){
        secureLocks = i_secureLocks;
    }

    public int getProfile(){
        return profile;
    }
    public void setProfile(int i){
        profile = i;
    }
    public int getAccesslog(){
        return accesslog;
    }
    public void setAccesslog(int i){
        accesslog = i;
    }
    public String getNISDomain(){
        return nisDomain;
    }
    public void setNISDomain(String nis){
        nisDomain = nis;
    }
}
