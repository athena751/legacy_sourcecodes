/*
 *      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */


package com.nec.sydney.service.admin;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.Arrays;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Vector;

import com.nec.sydney.atom.admin.base.NSExceptionMsg;
import com.nec.sydney.atom.admin.base.NSUtil;
import com.nec.sydney.atom.admin.base.NasConstants;
import com.nec.sydney.atom.admin.base.SoapRpsBoolean;
import com.nec.sydney.atom.admin.base.SoapRpsHashtable;
import com.nec.sydney.atom.admin.base.SoapRpsString;
import com.nec.sydney.atom.admin.base.SoapRpsVector;
import com.nec.sydney.atom.admin.base.api.AuthADSDomain;
import com.nec.sydney.atom.admin.base.api.AuthDMCDomain;
import com.nec.sydney.atom.admin.base.api.AuthDomain;
import com.nec.sydney.atom.admin.base.api.AuthLDAPUDomain;
import com.nec.sydney.atom.admin.base.api.AuthLDAPUDomain4Win;
import com.nec.sydney.atom.admin.base.api.AuthNISDomain;
import com.nec.sydney.atom.admin.base.api.AuthNISDomain4Win;
import com.nec.sydney.atom.admin.base.api.AuthPWDDomain;
import com.nec.sydney.atom.admin.base.api.AuthPWDDomain4Win;
import com.nec.sydney.atom.admin.base.api.AuthSHRDomain;
import com.nec.sydney.atom.admin.base.api.Domain;
import com.nec.sydney.atom.admin.base.api.ExportRoot;
import com.nec.sydney.atom.admin.base.api.LocalDomain;
import com.nec.sydney.atom.admin.base.api.NativeADSDomain;
import com.nec.sydney.atom.admin.base.api.NativeDMCDomain;
import com.nec.sydney.atom.admin.base.api.NativeDomain;
import com.nec.sydney.atom.admin.base.api.NativeLDAPUDomain;
import com.nec.sydney.atom.admin.base.api.NativeLDAPUDomain4Win;
import com.nec.sydney.atom.admin.base.api.NativeNISDomain;
import com.nec.sydney.atom.admin.base.api.NativeNISDomain4Win;
import com.nec.sydney.atom.admin.base.api.NativePWDDomain;
import com.nec.sydney.atom.admin.base.api.NativePWDDomain4Win;
import com.nec.sydney.atom.admin.base.api.NativeSHRDomain;
import com.nec.sydney.framework.NSException;
import com.nec.sydney.net.soap.SoapResponse;


public class APISOAPServer implements NSExceptionMsg,NasConstants
{

     private static final String     cvsid = "@(#) $Id: APISOAPServer.java,v 1.12 2007/04/27 03:22:13 liuyq Exp $";

     private static final String SCRIPT_API_GET_LOCALDOMAIN = "/bin/api_getLocalDomain.pl";
     private static final String SCRIPT_API_CHECK_NIS_DOMAIN = "/bin/api_getNisDomainServer.pl";
     private static final String SCRIPT_API_GET_ALL_EXPORTINFO = "/bin/api_getAllExportRootInfo.pl";
    private static final String PERL_SCRIPT_GET_EXPORT_GROUP = "/bin/api_getExportGroup.pl";
    private static final String PERL_SCRIPT_GET_ENCODING    = "/bin/api_getCodePage.pl";
    private static final String PERL_SCRIPT_GET_MOUNTPOINT  = "/bin/api_getMPAndSubMP.pl";
    
    //Wrote by hetao start:
     private static final String PERL_SCRIPT_HAS_UNIX_STYLE_NATIVE
                                                = "/bin/api_hasUnixStyleNative.pl";
     private static final String PERL_SCRIPT_GET_NATIVE_LIST
                                                = "/bin/api_getNativeList.pl";
     private static final String PERL_SCRIPT_CHECK_NATIVE_DOMAIN
                                                = "/bin/api_checkNativeDomain.pl";
     private static final String PERL_SCRIPT_GET_NATIVE_DOMAIN  
                                                = "/bin/api_getNativeDomain.pl"; 
     private static final String PERL_SCRIPT_GET_AUTH_DOMAIN_BY_KIND                                           
                                                = "/bin/api_getAuthDomainByKind.pl";
     private static final String PERL_SCRIPT_GET_AUTH_DOMAIN_BY_MP                                           
                                                = "/bin/api_getAuthDomainByMP.pl";
     private static final String PERL_SCRIPT_IS_USED_NIS_DOMAIN
                                                = "/bin/api_isUsedNISDomain.pl";                    
     //Wrote by hetao end;
    private static final String SCRIPT_GET_DIR_LIST = "/bin/cifs_getdirlist.pl";
    
    //write for filesystem: make all directory in partner node
    private static final String SCRIPT_FILESYSTEM_MAKE_ALLDIR = "/bin/filesystem_makeAllDir.pl";
    
      //constructor
    public void APISOAPServer(){}

    public LocalDomain getLocalDomain (String exportRootPath,String groupNo)throws Exception{
        LocalDomain trans = new LocalDomain();
        
        String origmyNumber = ClusterSOAPServer.getMyNumber();
        ClusterSOAPServer.setEtcPath(groupNo);
        ClusterSOAPServer.setMyNumber(groupNo);
        ClusterSOAPServer.setImsPath(groupNo);
        try{
            trans = getLocalDomain(exportRootPath);
        }catch(NSException e){
            throw e;
        }finally{
            ClusterSOAPServer.setEtcPath(origmyNumber);
            ClusterSOAPServer.setMyNumber(origmyNumber);
            ClusterSOAPServer.setImsPath(origmyNumber);
        }
        return trans;
    }
    
    public SoapRpsVector getDirList(String hexpath , String type) throws Exception {
        SoapRpsVector trans = new SoapRpsVector();
        String home  =  System.getProperty("user.home");
        String[] cmds = { COMMAND_SUDO , home+SCRIPT_GET_DIR_LIST , hexpath , type};

    CmdHandler cmdHandler = new CmdHandler(){
            public void cmdHandle(SoapResponse rps,Process proc,String[] cmds)throws Exception{
                SoapRpsVector trans=(SoapRpsVector)rps;
                BufferedReader inputStr= new BufferedReader(new InputStreamReader(proc.getInputStream()));
                
                Vector dirList = new Vector();
                String line=inputStr.readLine();
                while(line != null) {
                    dirList.add(line);
                    line = inputStr.readLine();
                }
                trans.setVector(dirList);
                trans.setSuccessful(true);
            }
        };
        SOAPServerBase.execCmd(cmds, trans, cmdHandler);
        return trans;                               
    }

     public LocalDomain getLocalDomain (String exportRootPath)
                                              throws Exception{
        LocalDomain trans = new LocalDomain();
        String home  =  System.getProperty("user.home");
        String cmds = SUDO_COMMAND+ " " +home
                      +SCRIPT_API_GET_LOCALDOMAIN+ " " 
                      +ClusterSOAPServer.getEtcPath()
                      +" "+ exportRootPath;
        CmdHandler cmdHandler = new CmdHandler(){
           public void cmdHandle(SoapResponse rps,Process proc,String[] cmds)throws Exception{
                LocalDomain trans=(LocalDomain)rps;
                InputStreamReader bufReader = new InputStreamReader(proc.getInputStream());
                BufferedReader buf = new BufferedReader(bufReader);
                String result=buf.readLine();
                if(result == null || result.trim().equals("")){
                    return;
                }
                String[] words = result.split(" ");
                trans.setLocalDomainName(words[1]);
                result = buf.readLine();
                words = result.split(" ");
                Vector v = new Vector(Arrays.asList(words));
                v.remove(0);
                for(int i=0; i<v.size(); i++){
                    trans.setNetbios((String)v.get(i));    
                }
                result = buf.readLine();
                words = result.split(" ");
                trans.setSecurity(words.length == 1?"":words[1]);
                return;
            }
        };       
        SOAPServerBase.execCmd(cmds,trans,cmdHandler);
        return trans;
    }

    public SoapRpsBoolean checkNisDomain (Domain nisDomain) throws Exception{
        SoapRpsBoolean trans = new SoapRpsBoolean();
        String home  =  System.getProperty("user.home");
        String domainName ;
        final String domainServer;
        if(nisDomain instanceof AuthNISDomain){
            domainName = ((AuthNISDomain)nisDomain).getDomainName();
            domainServer = ((AuthNISDomain)nisDomain).getDomainServer();
        }else{
            domainName = ((NativeNISDomain)nisDomain).getDomainName();
            domainServer = ((NativeNISDomain)nisDomain).getDomainServer();
        }
        String cmds = SUDO_COMMAND + " " + home 
                      + SCRIPT_API_CHECK_NIS_DOMAIN + " " 
                      + domainName;
        final String domainServerCmd;
        CmdHandler cmdHandler = new CmdHandler(){
           public void cmdHandle(SoapResponse rps,Process proc,String[] cmds)throws Exception{
                SoapRpsBoolean trans=(SoapRpsBoolean)rps;
                InputStreamReader bufReader = new InputStreamReader(proc.getInputStream());
                BufferedReader buf = new BufferedReader(bufReader);
                String result=buf.readLine();
                if (result != null 
                    && (result.trim().equals("") 
                    || result.trim().equals(domainServer.trim()))){
                        trans.setBoolean(true);
                }else{
                    trans.setBoolean(false);
                }
            }
        };
        SOAPServerBase.execCmd(cmds,trans,cmdHandler);
        return trans;
    }

    public SoapRpsString getNisDomainServer(String nisDomain) throws Exception{
                
        SoapRpsString trans = new SoapRpsString();
        if((nisDomain == null) || (nisDomain.trim().equals(""))){
        	trans.setSuccessful(true);
       		return trans;
        }
        nisDomain = nisDomain.trim();
        
        String home  =  System.getProperty("user.home");
        String cmds = SUDO_COMMAND + " " + home 
                      + SCRIPT_API_CHECK_NIS_DOMAIN + " " 
                      + nisDomain;
        CmdHandler cmdHandler = new CmdHandler(){
           public void cmdHandle(SoapResponse rps,Process proc,String[] cmds)throws Exception{
                SoapRpsString trans=(SoapRpsString)rps;
                InputStreamReader bufReader = new InputStreamReader(proc.getInputStream());
                BufferedReader buf = new BufferedReader(bufReader);
                String result=buf.readLine();
                if (result != null && !result.trim().equals("")){
                    trans.setString(result);
                }
            }
        };
        SOAPServerBase.execCmd(cmds,trans,cmdHandler);
        return trans;
    }

    public SoapRpsVector  getAllExportRootInfo()throws Exception{
        SoapRpsVector trans = new SoapRpsVector();
        String home  =  System.getProperty("user.home");
        String cmds = SUDO_COMMAND + " " + home 
                      + SCRIPT_API_GET_ALL_EXPORTINFO + " " 
                      + ClusterSOAPServer.getEtcPath();
        CmdHandler cmdHandler = new CmdHandler(){
           public void cmdHandle(SoapResponse rps,Process proc,String[] cmds)throws Exception{
                SoapRpsVector trans=(SoapRpsVector)rps;
                InputStreamReader bufReader = new InputStreamReader(proc.getInputStream());
                BufferedReader buf = new BufferedReader(bufReader);
                String result = null; 
                Vector allExport = new Vector();
                ExportRoot exportRoot = new ExportRoot();
                LocalDomain localDomain = new LocalDomain();
                while((result = buf.readLine())!= null){
                    String[] words = result.split(" ");
                    if(words[0].equals("localdomain")){
                        localDomain.setLocalDomainName(words[1]);
                    }else if(words[0].equals("netbios")){
                        Vector v = new Vector(Arrays.asList(words));
                        v.remove(0);
                        for(int i=0; i<v.size(); i++){
                            localDomain.setNetbios((String)v.get(i));    
                        }
                    }else if(words[0].equals("security")){
                        localDomain.setSecurity(words.length == 1?"":words[1]);
                    }else if(words[0].startsWith("----------")){
                        exportRoot.setLocalDomain(localDomain);
                        allExport.add(exportRoot);
                        exportRoot = new ExportRoot();
                        localDomain = new LocalDomain();
                    }else{
                        exportRoot.setPath(words[0]);
                    }
                }
                trans.setVector(allExport);
            }
        };
        SOAPServerBase.execCmd(cmds,trans,cmdHandler);
        return trans;
    } 
   
    /**
    * when takeover happened, get exportgroup and codepage. 
    *@param     groupNo.
    *@return    (exportgroup1,codepage1,exportgroup2,codepage2,...).
    */
    public SoapRpsVector getExportGroups(String groupNo)throws Exception{
        SoapRpsVector trans = new SoapRpsVector();

        String origmyNumber= ClusterSOAPServer.getMyNumber();
        ClusterSOAPServer.setEtcPath(groupNo);
        ClusterSOAPServer.setMyNumber(groupNo);
        ClusterSOAPServer.setImsPath(groupNo);
        try{
            trans = getExportGroups();
        }catch(NSException e) {
            throw e;
        }finally{
            ClusterSOAPServer.setEtcPath(origmyNumber);
            ClusterSOAPServer.setMyNumber(origmyNumber);
            ClusterSOAPServer.setImsPath(origmyNumber);
        }
        return trans;
    }   

    /**
    * get exportgroup and codepage. 
    *@param     none.
    *@return    (exportgroup1,codepage1,exportgroup2,codepage2,...).
    */    
    public SoapRpsVector getExportGroups()throws Exception{
        SoapRpsVector rpsResult = new SoapRpsVector();
        String home     = System.getProperty("user.home");
        String cmds[]   = new String[3];
        cmds[0]         = SUDO_COMMAND;
        cmds[1]         = home + PERL_SCRIPT_GET_EXPORT_GROUP;
        cmds[2]         = ClusterSOAPServer.getEtcPath();
        
        CmdHandler cmdHandler = new CmdHandler(){       //create a new CmdHandler
            public void cmdHandle(SoapResponse rps, Process proc, String[] cmds)throws Exception{
                SoapRpsVector rpsResult = (SoapRpsVector)rps;
                Vector result = new Vector();
                InputStreamReader read = new InputStreamReader(proc.getInputStream());
                BufferedReader readbuf = new BufferedReader(read);
                String line = readbuf.readLine();
                while(line != null){
                    result.add(line);
                    line = readbuf.readLine();
                }
                rpsResult.setVector(result);
                rpsResult.setSuccessful(true);                               
            }
        };
        
        SOAPServerBase.execCmd(cmds,rpsResult,cmdHandler);
        return rpsResult;
    }

    public SoapRpsString getCodepage(String exportgroup, String groupNo)throws Exception{
        SoapRpsString rpsResult = new SoapRpsString();

        String origmyNumber= ClusterSOAPServer.getMyNumber();
        ClusterSOAPServer.setEtcPath(groupNo);
        ClusterSOAPServer.setMyNumber(groupNo);
        ClusterSOAPServer.setImsPath(groupNo);
        try{
            rpsResult = getCodepage(exportgroup);
        }catch(NSException e) {
            throw e;
        }finally{
            ClusterSOAPServer.setEtcPath(origmyNumber);
            ClusterSOAPServer.setMyNumber(origmyNumber);
            ClusterSOAPServer.setImsPath(origmyNumber);
        }
        return rpsResult;
    }

    /**
    * get exportgroup's codepage. 
    *@param     the exportgroup that need to know codepage.
    *@return    codepage such as "EUC-JP","SJIS","English" etc.
    */    
    public SoapRpsString getCodepage(String exportgroup)throws Exception{
        SoapRpsString rpsResult = new SoapRpsString();
        String home     = System.getProperty("user.home");
        String cmds[]   = new String[4];
        cmds[0]         = SUDO_COMMAND;
        cmds[1]         = home + PERL_SCRIPT_GET_ENCODING;
        cmds[2]         = ClusterSOAPServer.getEtcPath();
        cmds[3]         = exportgroup;
        
        CmdHandler cmdHandler = new CmdHandler(){       //create a new CmdHandler
            public void cmdHandle(SoapResponse rps, Process proc, String[] cmds)throws Exception{
                SoapRpsString rpsResult = (SoapRpsString)rps;
                Vector result           = new Vector();
                InputStreamReader read  = new InputStreamReader(proc.getInputStream());
                BufferedReader readbuf  = new BufferedReader(read);
                String line = readbuf.readLine();
                if(line != null) {
                    rpsResult.setString(line.trim());
                }
                rpsResult.setSuccessful(true);                               
            }
        };
        
        SOAPServerBase.execCmd(cmds,rpsResult,cmdHandler);
        return rpsResult;
    }
    /**
    * get mountpoint and its LVM 
    *@param     the mountpoint that need to know LVM.
    *@return    (lvm1,mountpoint,lvm2,sub-mountpoint,...)
    */    
    public SoapRpsVector getMountpointLV(String hexMountpoint)throws Exception{
        SoapRpsVector rpsResult = new SoapRpsVector();
        String home     = System.getProperty("user.home");
        String cmds[]   = new String[4];
        cmds[0]         = SUDO_COMMAND;
        cmds[1]         = home + PERL_SCRIPT_GET_MOUNTPOINT;
        cmds[2]         = ClusterSOAPServer.getEtcPath();
        cmds[3]         = hexMountpoint;
        
        CmdHandler cmdHandler = new CmdHandler(){       //create a new CmdHandler
            public void cmdHandle(SoapResponse rps, Process proc, String[] cmds)throws Exception{
                SoapRpsVector rpsResult = (SoapRpsVector)rps;
                Vector result = new Vector();
                InputStreamReader read = new InputStreamReader(proc.getInputStream());
                BufferedReader readbuf = new BufferedReader(read);
                String line = readbuf.readLine();
                while(line != null){
                    result.add(line);
                    line = readbuf.readLine();
                }
                rpsResult.setVector(result);
                rpsResult.setSuccessful(true);                               
            }
        };
        
        SOAPServerBase.execCmd(cmds,rpsResult,cmdHandler);
        return rpsResult;
    }

//Wrote by hetao start:
    
    /**
    * check whether has unix stype native domain
    *@param     none.
    *@return    if have, return true, else return false
    */    
    public SoapRpsBoolean hasUnixStyleNative()throws Exception{
        SoapRpsBoolean trans = new SoapRpsBoolean();
        String home     = System.getProperty("user.home");
        String cmds[]   = new String[3];
        cmds[0]         = SUDO_COMMAND;
        cmds[1]         = home + PERL_SCRIPT_HAS_UNIX_STYLE_NATIVE;
        cmds[2]         = ClusterSOAPServer.getEtcPath();
        
        CmdHandler cmdHandler = new BooleanCmdHandler();
        SOAPServerBase.execCmd(cmds,trans,cmdHandler);
        return trans;
    }
    
    /**
    * check whether the nis domain is used.
    *@param     nisDomainName - the name of nis domain
    *@return    if used, return true, else return false
    */    
    public SoapRpsBoolean isUsedNISDomain(String nisDomainName)throws Exception{
        SoapRpsBoolean trans = new SoapRpsBoolean();
        String home     = System.getProperty("user.home");
        String cmds[]   = new String[4];
        cmds[0]         = SUDO_COMMAND;
        cmds[1]         = home + PERL_SCRIPT_IS_USED_NIS_DOMAIN;
        cmds[2]         = ClusterSOAPServer.getEtcPath();
        cmds[3]         = nisDomainName;
        
        CmdHandler cmdHandler = new BooleanCmdHandler();
        SOAPServerBase.execCmd(cmds,trans,cmdHandler);
        return trans;
    }
    
    /**
    * get all the native domain
    *@param     none.
    *@return    return all the native domains
    */ 
    public SoapRpsVector getNativeList()throws Exception{
        SoapRpsVector trans = new SoapRpsVector();
        String home     = System.getProperty("user.home");
        String cmds[]   = new String[3];
        cmds[0]         = SUDO_COMMAND;
        cmds[1]         = home + PERL_SCRIPT_GET_NATIVE_LIST;
        cmds[2]         = ClusterSOAPServer.getEtcPath();
        
        CmdHandler cmdHandler = new NativeDomainCmdHandler();
        SOAPServerBase.execCmd(cmds,trans,cmdHandler);
        return trans;
    }
        
     /**
    * check native domain
    *@param     networkOrNTdomain - network or ntdomain
    *@param     kind - "win" or "unix"
    *@return    If the network or ntdomain has set the native domain, return true
    *           else return false;
    */ 
    public SoapRpsBoolean checkNativeDomain(String networkOrNTdomain,
                                            String kind)throws Exception{
        SoapRpsBoolean trans = new SoapRpsBoolean();
        String home     = System.getProperty("user.home");
        String cmds[]   = new String[5];
        cmds[0]         = SUDO_COMMAND;
        cmds[1]         = home + PERL_SCRIPT_CHECK_NATIVE_DOMAIN;
        cmds[2]         = ClusterSOAPServer.getEtcPath();
        cmds[3]         = networkOrNTdomain;
        cmds[4]         = kind;
        
        CmdHandler cmdHandler = new BooleanCmdHandler();
        SOAPServerBase.execCmd(cmds,trans,cmdHandler);
        return trans;
    }
    
    
     /**
    * get native domain
    *@param     networkOrNTdomain - network or ntdomain
    *@param     kind - "win" or "unix"
    *@return    get the native domain of network or ntdomain
    */ 
    public SoapRpsVector getNativeDomain(String networkOrNTdomain,
                                                String kind)throws Exception{
        SoapRpsVector transVector = new SoapRpsVector();
        
        String home     = System.getProperty("user.home");
        String cmds[]   = new String[5];
        cmds[0]         = SUDO_COMMAND;
        cmds[1]         = home + PERL_SCRIPT_GET_NATIVE_DOMAIN;
        cmds[2]         = ClusterSOAPServer.getEtcPath();
        cmds[3]         = networkOrNTdomain;
        cmds[4]         = kind;
        
        CmdHandler cmdHandler = new NativeDomainCmdHandler();
        SOAPServerBase.execCmd(cmds,transVector,cmdHandler);
        
        return transVector;
    }

     /**
    * when takeover happened, get auth domain
    *@param     hexDirectMP - direct mountpoint as hex format
    *           groupNo - 0|1
    *@return    get the auth domain of that mount point
    */ 
    public SoapRpsVector getAuthDomain(String hexDirectMP,String groupNo)throws Exception{
        SoapRpsVector trans = new SoapRpsVector();
        
        String origmyNumber = ClusterSOAPServer.getMyNumber();
        ClusterSOAPServer.setEtcPath(groupNo);
        ClusterSOAPServer.setMyNumber(groupNo);
        ClusterSOAPServer.setImsPath(groupNo);
        try{
            trans = getAuthDomain(hexDirectMP);
        }catch(NSException e){
            throw e;
        }finally{
            ClusterSOAPServer.setEtcPath(origmyNumber);
            ClusterSOAPServer.setMyNumber(origmyNumber);
            ClusterSOAPServer.setImsPath(origmyNumber);
        }
        return trans;
    }

    
    //start
     /**
    * get auth domain
    *@param     hexDirectMP - direct mountpoint as hex format
    *@return    get the auth domain of that mount point
    */ 
    public SoapRpsVector getAuthDomain(String hexDirectMP)throws Exception{
        SoapRpsHashtable transHash = new SoapRpsHashtable();
        
        String home     = System.getProperty("user.home");
        String cmds[]   = new String[4];
        cmds[0]         = SUDO_COMMAND;
        cmds[1]         = home + PERL_SCRIPT_GET_AUTH_DOMAIN_BY_MP;
        cmds[2]         = ClusterSOAPServer.getEtcPath();
        cmds[3]         = hexDirectMP;
        CmdHandler cmdHandler = new AuthDomainCmdHandler();
        SOAPServerBase.execCmd(cmds,transHash,cmdHandler);
        SoapRpsVector rpsVector = new SoapRpsVector();
        Vector v = new Vector();
        Hashtable result         = transHash.getHash();
        Enumeration values       = result.elements();
        if(values.hasMoreElements()){
            v.add(values.nextElement());
        }
        rpsVector.setVector(v);
        return rpsVector;
    }
     /**
    * get auth domain by kind
    *@param     exportroot - the root of export 
    *@param     kind - the kind of the auth domain 
    *@return    get the auth domain of that export root
    */ 
    public SoapRpsVector getAuthDomainByKind(String exportroot,
                                            String kind)throws Exception{
        SoapRpsHashtable transHash = new SoapRpsHashtable();
        
        String home     = System.getProperty("user.home");
        String cmds[]   = new String[5];
        cmds[0]         = SUDO_COMMAND;
        cmds[1]         = home + PERL_SCRIPT_GET_AUTH_DOMAIN_BY_KIND;
        cmds[2]         = ClusterSOAPServer.getEtcPath();
        cmds[3]         = exportroot;
        cmds[4]         = kind.substring(4);
        
        CmdHandler cmdHandler = new AuthDomainCmdHandler();
        SOAPServerBase.execCmd(cmds,transHash,cmdHandler);
        SoapRpsVector rpsVector = new SoapRpsVector();
        Vector v = new Vector();
        Hashtable result         = transHash.getHash();
        Enumeration values       = result.elements();
        if(values.hasMoreElements()){
            v.add(values.nextElement());
        }
        rpsVector.setVector(v);
        return rpsVector;
    }
     /**
    * get auth domain
    *@param     hexDirectMP - direct mountpoints as hex format
    *@return    get the auth domain of the mount points
    */ 
    public SoapRpsHashtable getAuthList(Vector hexDirectMPs)throws Exception{
        SoapRpsHashtable transHash = new SoapRpsHashtable();
        
        StringBuffer hexMpString = new StringBuffer();
        int size = hexDirectMPs.size();
        for( int i = 0 ;i < size ; i++ ){
            String hexMp = (String)hexDirectMPs.get(i);
            hexMpString.append(hexMp+" ");
        }
        
        String home     = System.getProperty("user.home");
        String cmds[]   = new String[4];
        cmds[0]         = SUDO_COMMAND;
        cmds[1]         = home + PERL_SCRIPT_GET_AUTH_DOMAIN_BY_MP;
        cmds[2]         = ClusterSOAPServer.getEtcPath();
        cmds[3]         = hexMpString.toString().trim();
        
        CmdHandler cmdHandler = new AuthDomainCmdHandler();
        SOAPServerBase.execCmd(cmds,transHash,cmdHandler);
        
        return transHash;
    }
    //Wrote by hetao end;

    //write by xiaocx maojb date:2003/02/11
    public SoapRpsString makeAllDirectory(String groupNo) throws Exception{
        SoapRpsString rpsResult = new SoapRpsString();
        String home     = System.getProperty("user.home");
        String cmds = SUDO_COMMAND + " " + home 
                      + SCRIPT_FILESYSTEM_MAKE_ALLDIR + " " 
                      + groupNo;
            
        CmdHandler cmdHandler = new CmdHandler(){       //create a new CmdHandler
            public void cmdHandle(SoapResponse rps, Process proc, String[] cmds)throws Exception{
                SoapRpsString rpsResult = (SoapRpsString)rps;
                InputStreamReader read  = new InputStreamReader(proc.getInputStream());
                BufferedReader readbuf  = new BufferedReader(read);
                String line = readbuf.readLine();
                if(line != null) {
                    rpsResult.setString(line.trim());
                } else {
                    rpsResult.setString("");
                }
                rpsResult.setSuccessful(true);                               
            }
        };
            
        SOAPServerBase.execCmd(cmds,rpsResult,cmdHandler);
        return rpsResult;
    }
}

//Wrote by hetao start:

interface DomainCmdConstants{
     public static final String OPERATION_SYSTEM_TYPE_WIN
                                                = "win"; 
     public static final String OPERATION_SYSTEM_TYPE_UNIX
                                                = "unix";
                                                
     public static final String DOMAIN_TYPE_SHR
                                                = "[SHRDomain]";
     public static final String DOMAIN_TYPE_DMC
                                                = "[DMCDomain]";
     public static final String DOMAIN_TYPE_NIS
                                                = "[NISDomain]";
     public static final String DOMAIN_TYPE_LDU
                                                = "[LDAPUDomain]";
     public static final String DOMAIN_TYPE_PWD
                                                = "[PWDDomain]";
     public static final String DOMAIN_TYPE_NIS_4WIN
                                                = "[NISDomain4Win]";
     public static final String DOMAIN_TYPE_LDU_4WIN
                                                = "[LDAPUDomain4Win]";
     public static final String DOMAIN_TYPE_PWD_4WIN
                                                = "[PWDDomain4Win]"; 
     public static final String DOMAIN_TYPE_ADS
                                                = "[ADSDomain]";
} 

class NativeDomainCmdHandler implements CmdHandler,DomainCmdConstants
{
    /**
    * set ntdomain or network of native domain 
    *@param     nDomain - the native domain
    *@param     networkOrNTdomain - network or ntdomain
    *@param     region - the region of native domain
    *@param     opType - "win" or "unix"
    *@return    none.
    */ 
    private void setNativeDomain(NativeDomain nDomain, 
                                    String networkOrNTDomain,
                                    String region, 
                                    String opType)throws Exception{
        if(opType.compareTo( OPERATION_SYSTEM_TYPE_WIN) == 0){
            nDomain.setNTDomain(networkOrNTDomain);
        }else{
            nDomain.setNetwork(networkOrNTDomain);
        }
        nDomain.setRegion(region);
    }
    
    public void cmdHandle(SoapResponse rps, 
                            Process proc, 
                            String[] cmds)throws Exception{
        SoapRpsVector trans=(SoapRpsVector)rps;
        InputStreamReader bufReader = new InputStreamReader(proc.getInputStream());
        BufferedReader buf          = new BufferedReader(bufReader);
        String curLine              = null;
        String domainType           = null;
        String opType               = OPERATION_SYSTEM_TYPE_WIN;
        Vector rpsVec               = new Vector();
        
        while((curLine = buf.readLine()) != null){
            //if current line is type line, get the operation type
            if(curLine.startsWith("[")){                              
                domainType = curLine;
                continue; 
            }
            
            //if current line is data line, get the network or ntdomain, get the region 
            String region               = curLine;
            String networkOrNTDomain    = buf.readLine();
            
            NativeDomain nDomain        = null;
            
            //-- shr --
            if(domainType.compareTo(DOMAIN_TYPE_SHR) == 0){
                nDomain = new NativeSHRDomain(); 
                opType =  OPERATION_SYSTEM_TYPE_WIN;
            
            //-- pwd --       
            }else if(domainType.compareTo(DOMAIN_TYPE_PWD) == 0){
                nDomain = new NativePWDDomain();
                ((NativePWDDomain)nDomain).setPasswd(NSUtil.perl2Page(
                                                    buf.readLine(),
                                                    NasConstants.BROWSER_ENCODE).getBytes());   
                ((NativePWDDomain)nDomain).setGroup(NSUtil.perl2Page(
                                                    buf.readLine(),
                                                    NasConstants.BROWSER_ENCODE).getBytes());   
                opType =  OPERATION_SYSTEM_TYPE_UNIX;
                
            //-- pwdforwin --
            }else if(domainType.compareTo(DOMAIN_TYPE_PWD_4WIN) == 0){
                nDomain = new NativePWDDomain4Win();
                ((NativePWDDomain)nDomain).setPasswd(NSUtil.perl2Page(
                                                    buf.readLine(),
                                                    NasConstants.BROWSER_ENCODE).getBytes());   
                ((NativePWDDomain)nDomain).setGroup(NSUtil.perl2Page(
                                                    buf.readLine(),
                                                    NasConstants.BROWSER_ENCODE).getBytes());    //need interface
                opType =  OPERATION_SYSTEM_TYPE_WIN;
                
            //-- nis --
            }else if(domainType.compareTo(DOMAIN_TYPE_NIS) == 0){
                nDomain = new NativeNISDomain();
                ((NativeNISDomain)nDomain).setDomainName(buf.readLine());   
                ((NativeNISDomain)nDomain).setDomainServer(buf.readLine());  
                opType =  OPERATION_SYSTEM_TYPE_UNIX;
                 
            //-- nisforwin --
            }else if(domainType.compareTo(DOMAIN_TYPE_NIS_4WIN) == 0){
                nDomain = new NativeNISDomain4Win();
                ((NativeNISDomain)nDomain).setDomainName(buf.readLine());   
                ((NativeNISDomain)nDomain).setDomainServer(buf.readLine());   
                opType =  OPERATION_SYSTEM_TYPE_WIN;
                
            //-- dmc -- 
            }else if(domainType.compareTo(DOMAIN_TYPE_DMC) == 0){
                nDomain = new NativeDMCDomain();
                opType =  OPERATION_SYSTEM_TYPE_WIN; 
            
            //-- ads -- 
            }else if(domainType.compareTo(DOMAIN_TYPE_ADS) == 0){
                nDomain = new NativeADSDomain();
                ((NativeADSDomain)nDomain).setDNSDomain(buf.readLine());   
                ((NativeADSDomain)nDomain).setKDCServer(buf.readLine());
                opType =  OPERATION_SYSTEM_TYPE_WIN; 
            
            //-- ldu --   
            }else if(domainType.compareTo(DOMAIN_TYPE_LDU) == 0){
                nDomain = new NativeLDAPUDomain();
                opType =  OPERATION_SYSTEM_TYPE_UNIX;
                
            //-- lduforwin --
            }else{
                nDomain = new NativeLDAPUDomain4Win();
                opType =  OPERATION_SYSTEM_TYPE_WIN;
            }                
            
            setNativeDomain(nDomain,networkOrNTDomain,region,opType);
            rpsVec.add(nDomain);
            
        }
        trans.setVector(rpsVec); 
    }
}

class AuthDomainCmdHandler implements CmdHandler,DomainCmdConstants
{
    
    
    /**
    * set ntdomain or network of auth domain 
    *@param     aDomain - the auth domain
    *@param     networkOrNTdomain - network or ntdomain
    *@param     region - the region of native domain
    *@param     opType - "win" or "unix"
    *@return    none.
    */ 
    private void setAuthDomain(AuthDomain aDomain, 
                                    String networkOrNTDomain,
                                    String region, 
                                    String opType)throws Exception{
        if(opType.compareTo( OPERATION_SYSTEM_TYPE_WIN) == 0){
            aDomain.setNTDomain(networkOrNTDomain);
        }
        aDomain.setRegion(region);
    }
    
    public void cmdHandle(SoapResponse rps, 
                            Process proc, 
                            String[] cmds)throws Exception{
        SoapRpsHashtable trans=(SoapRpsHashtable)rps;
        InputStreamReader bufReader = new InputStreamReader(proc.getInputStream());
        BufferedReader buf          = new BufferedReader(bufReader);
        String curLine              = null;
        String domainType           = null;
        String opType               = OPERATION_SYSTEM_TYPE_WIN;
        Hashtable rpsHash           = new Hashtable();
        
        while((curLine = buf.readLine()) != null){
            //if current line is type line, get the operation type
            if(curLine.startsWith("[")){                              
                domainType = curLine;
                continue; 
            }
            
            //if current line is data line, get the network or ntdomain, get the region 
            String region               = curLine;
            String mountpoint           = buf.readLine();
            String networkOrNTDomain    = buf.readLine();
            
            AuthDomain aDomain = null;
            
            //-- shr --
            if(domainType.compareTo(DOMAIN_TYPE_SHR) == 0){
                aDomain = new AuthSHRDomain(); 
                ((AuthSHRDomain)aDomain).setPath(buf.readLine());
                opType =  OPERATION_SYSTEM_TYPE_WIN;
            
            //-- pwd --       
            }else if(domainType.compareTo(DOMAIN_TYPE_PWD) == 0){
                aDomain = new AuthPWDDomain();
                ((AuthPWDDomain)aDomain).setPasswd(NSUtil.perl2Page(
                                                    buf.readLine(),
                                                    NasConstants.BROWSER_ENCODE).getBytes());     
                ((AuthPWDDomain)aDomain).setGroup(NSUtil.perl2Page(
                                                    buf.readLine(),
                                                    NasConstants.BROWSER_ENCODE).getBytes());      
                opType =  OPERATION_SYSTEM_TYPE_UNIX;
                
            //-- pwdforwin --
            }else if(domainType.compareTo(DOMAIN_TYPE_PWD_4WIN) == 0){
                aDomain = new AuthPWDDomain4Win();
                ((AuthPWDDomain)aDomain).setPasswd(NSUtil.perl2Page(
                                                    buf.readLine(),
                                                    NasConstants.BROWSER_ENCODE).getBytes());   
                ((AuthPWDDomain)aDomain).setGroup(NSUtil.perl2Page(
                                                    buf.readLine(),
                                                    NasConstants.BROWSER_ENCODE).getBytes());    
                opType =  OPERATION_SYSTEM_TYPE_WIN;
                
            //-- nis --
            }else if(domainType.compareTo(DOMAIN_TYPE_NIS) == 0){
                aDomain = new AuthNISDomain();
                ((AuthNISDomain)aDomain).setDomainName(buf.readLine());   
                ((AuthNISDomain)aDomain).setDomainServer(buf.readLine());  
                opType =  OPERATION_SYSTEM_TYPE_UNIX;
                 
            //-- nisforwin --
            }else if(domainType.compareTo(DOMAIN_TYPE_NIS_4WIN) == 0){
                aDomain = new AuthNISDomain4Win();
                ((AuthNISDomain)aDomain).setDomainName(buf.readLine());   
                ((AuthNISDomain)aDomain).setDomainServer(buf.readLine());   
                opType =  OPERATION_SYSTEM_TYPE_WIN;
                
            //-- dmc -- 
            }else if(domainType.compareTo(DOMAIN_TYPE_DMC) == 0){
                aDomain = new AuthDMCDomain();
                opType =  OPERATION_SYSTEM_TYPE_WIN; 
            
            //-- ads -- 
            }else if(domainType.compareTo(DOMAIN_TYPE_ADS) == 0){
                aDomain = new AuthADSDomain();
                ((AuthADSDomain)aDomain).setDNSDomain(buf.readLine());   
                ((AuthADSDomain)aDomain).setKDCServer(buf.readLine());
                opType =  OPERATION_SYSTEM_TYPE_WIN; 
             
            //-- ldu --   
            }else if(domainType.compareTo(DOMAIN_TYPE_LDU) == 0){
                aDomain = new AuthLDAPUDomain();
                opType =  OPERATION_SYSTEM_TYPE_UNIX;
               
            //-- lduforwin --
            }else{
                aDomain = new AuthLDAPUDomain4Win();
                opType =  OPERATION_SYSTEM_TYPE_WIN;
            }                
            
            setAuthDomain(aDomain,networkOrNTDomain,region,opType);
            rpsHash.put(mountpoint, aDomain);
            
        }
        trans.setHash(rpsHash); 
    }
}


class BooleanCmdHandler implements CmdHandler
{
    public void cmdHandle(SoapResponse rps,Process proc,String[] cmds)throws Exception{
        SoapRpsBoolean trans=(SoapRpsBoolean)rps;
        InputStreamReader bufReader = new InputStreamReader(proc.getInputStream());
        BufferedReader buf = new BufferedReader(bufReader);
        String result=buf.readLine();
        if (result != null && result.trim().equals("true")){
            trans.setBoolean(true);
        }else{
            trans.setBoolean(false);
        }
    }
}
//Wrote by hetao end;
