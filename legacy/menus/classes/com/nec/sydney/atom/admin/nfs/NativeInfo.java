/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */


/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */


package com.nec.sydney.atom.admin.nfs;
import  com.nec.sydney.atom.admin.base.*; 

public class NativeInfo implements NSExceptionMsg,NasConstants
{

    private static final String     cvsid = "@(#) $Id: NativeInfo.java,v 1.2303 2004/11/12 02:35:37 caoyh Exp $";


    private String netBios;
    private String type;
    private String effcNetwork;
    private String domain;
    private String nisdomain;
    private String server;
    private String path;
    private String group;
    private String ExportRoot;
    private String region;
    private String ludb="";
    private String dnsDomain = "";
    private String kdcServer = "";

    private String username="";
    private String password="";

    private String utoa="n";

    public String getUtoa(){
        return utoa;
    }
    public void setUtoa(String utoa){
        this. utoa = utoa;
    }
    
    public String getNetBios() {
        return netBios;
    }
    public void setNetBios(String x) {
        netBios = x;
    }

    public String getLUDB() {
        return ludb;
    }
    public void setLUDB(String x) {
        ludb = x;
    }

    public String getUsername() {
        return username;
    }
    public void setUsername(String i_username) {
        username = i_username;
    }
    public String getPassword() {
        return password;
    }
    public void setPassword(String i_password) {
        password = i_password;
    }

    public NativeInfo() {
        type = NFS_NATIVETYPE_NIS;
        effcNetwork = "";
        domain = "";
        server = "";
        path = "";
        group = "";
    }
    public String getType() {
        return type;
    }
    public String getEffcNetwork() {
        return effcNetwork;
    }
    public String getDomain() {
        return domain;
    }
    public String getNisDomain() {
        return nisdomain;
    }
    public String getServer() {
        return server;
    }
    public String getPath() {
        return path;
    }
    public String getGroup() {
        return group;
    }
    public String getExportRoot() {
        return ExportRoot;
    }
    public String getRegion() {
        return region;
    }
    public void setType(String i_type) {
        type = i_type;
    }
    public void setDomain(String i_domain) {
        domain = i_domain;
    }
    public void setNisDomain(String i_domain) {
        nisdomain = i_domain;
    }
    public void setEffcNetwork(String i_effcNetwork) {
        effcNetwork = i_effcNetwork;
    }
    public void setServer(String i_server) {
        server = i_server;
    }
    public void setPath(String i_path) {
        path = i_path;
    }
    public void setGroup(String i_group) {
        group = i_group;
    }
    public void setExportRoot(String i_ExportRoot){
        ExportRoot = i_ExportRoot;
    }
    public void setRegion(String i_region) {
        region = i_region;
    }

    //==============================================
    private String serverName = "";
    private String distinguishedName = "";
    private String authenticateType = "";
    private String TLS = "";
    private String authenticateID = "";
    private String authenticatePasswd = "";
    private String CA = "";
    private String CAType = "no";
    private String userFilter = "";
    private String groupFilter = "";

    public final static String TYPE_SIMPLE = "SIMPLE";
    public final static String TYPE_MD5 = "DIGEST-MD5";
    public final static String TLS_YES = "yes";
    public final static String TLS_NO  = "no";
    public final static String CATYPE_NOSPECIFY = "no";
    public final static String CATYPE_FILE = "file";
    public final static String CATYPE_DIR = "dir";

    public String getUserFilter(){
        return userFilter;
    }
    
    public void setUserFilter(String userFilter){
        this.userFilter = userFilter;
    }

    public String getGroupFilter(){
        return groupFilter;
    }
    
    public void setGroupFilter(String groupFilter){
        this. groupFilter = groupFilter;
    }

    public void setServerName(String name){
	serverName = name;
    }
    public void setDistinguishedName(String name){
	distinguishedName = name;
    }
    public void setAuthenticateType(String type){
	authenticateType = type;
    }
    public void setTLS(String tls){
	TLS = tls;
    }
    public void setAuthenticateID(String id){
	authenticateID = id;
    }
    public void setAuthenticatePasswd(String passwd){
	authenticatePasswd = passwd;
    }
    public void setCA(String ca){
	CA = ca;
    }
    public void setCAType(String type){
        this.CAType = type;
    }
    public String getServerName(){
	return serverName;
    }
    public String getDistinguishedName(){
	return distinguishedName;
    }
    public String getAuthenticateType(){
	return authenticateType;
    }
    public String getTLS(){
	return TLS;
    }
    public String getAuthenticateID(){
	return authenticateID;
    }
    public String getAuthenticatePasswd(){
	return authenticatePasswd;
    }
    public String getCA(){
	return CA;
    }
    public String getCAType(){
        return CAType;
    }

    public void setDNSDomain(String dom){
        dnsDomain = dom;
    }

    public String getDNSDomain(){
        return dnsDomain;
    }

    public void setKDCServer(String svr){
        kdcServer = svr;
    }

    public String getKDCServer(){ 
        return kdcServer; 
    }
        //==============================================
}
