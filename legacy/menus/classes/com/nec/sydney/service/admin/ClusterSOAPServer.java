/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.service.admin;
import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.framework.*;
import com.nec.sydney.net.soap.*;
import java.util.*;
import java.io.*;

public class ClusterSOAPServer implements NasConstants,NSExceptionMsg{


    private static final String     cvsid = "@(#) $Id: ClusterSOAPServer.java,v 1.2300 2003/11/24 00:54:58 nsadmin Exp $";


    private static final String NAS_SCRIPTE_GET_CLUSTER = "cluster_getCluster.pl";
    private static final String CLUSTER_MAKE_DIR = "/bin/cluster_makeDir.pl";
    private static final String CLUSTER_DELETE_DIR = "/bin/cluster_deleteDir.pl";
    private static final String CLUSTER_CHMOD_DIR = "/bin/filesystem_chmod.pl";
    private static final String SCRIPT_CLUSTER_UNTAR = "cluster_standbySync.pl";
    private static final String SCRIPT_CLUSTER_TAR = "cluster_activeSync.pl";
    
    private static final String SCRIPT_CLUSTER_SENDSTATICROUTE = "cluster_sendstaticroute.pl";
    private static final String SCRIPT_CLUSTER_RECSTATICROUTE = "cluster_recstaticroute.pl";
    
    private static final char OLD_CHAR = '%';

    private ClusterInfo cluster;
    private static ClusterSOAPServer clusterInstance;
    private static String etcPath = null; 
    private static String imsPath = null;
    private static String myNumber = null;

    public ClusterSOAPServer(){
        clusterInstance = this;
    }

    public SoapRpsCluster getCluster(){
        SoapRpsCluster rps=new SoapRpsCluster();

        if (cluster!=null){
            rps.setSuccessful(true);
            rps.setCluster(cluster);
            return rps;
        }
        String scriptHome = System.getProperty("user.home") + SCRIPT_DIR;
        String[] cmds = {COMMAND_SUDO ,
                        scriptHome + NAS_SCRIPTE_GET_CLUSTER
                        };

        CmdHandler cmdHandler = new CmdHandler(){
            public void cmdHandle(SoapResponse trans,Process proc,String[] cmds)throws Exception{
                SoapRpsCluster rpsCluster = (SoapRpsCluster)trans;
                InputStreamReader bufReader = new InputStreamReader(proc.getInputStream());
                BufferedReader buf = new BufferedReader(bufReader);
                ClusterInfo cls = new ClusterInfo();
                String result = buf.readLine();
                    cls.setFIP(result);
                    cls.setFMask(buf.readLine());
                    cls.setMyNo(buf.readLine());
                    cls.setMyName(buf.readLine());
                    cls.setMyIP(buf.readLine());
                    cls.setMyMask(buf.readLine());
                    result = buf.readLine();
                    while ( result!=null) {
                        ClusterNode node = new ClusterNode();
                        node.setNo(result);
                        node.setName(buf.readLine());
                        node.setIP(buf.readLine());
                        node.setMask(buf.readLine());
                        cls.addANode(node);
                        result = buf.readLine();
                    } //end of while
                    if (cls.getMyNo() != null){
                        cls.setIsCluster(true);
                        etcPath = "/etc/group" + cls.getMyNo() + "/";
                        imsPath = "/etc/group" + cls.getMyNo() + "/ims.conf";
                        myNumber = cls.getMyNo();
                    }else {
                        etcPath = "/etc/group0/";
                        imsPath = "/etc/group0/ims.conf";
                        myNumber = "0";
                    }
                cluster = cls;
                rpsCluster.setCluster(cls);
                rpsCluster.setSuccessful(true);
            } //end of cmdHandle
         }; //end of CmdHandler
         
        SOAPServerBase.execCmd(cmds,rps,cmdHandler);         
        return rps;
    }

    public static ClusterSOAPServer getInstance(){
        return clusterInstance;
    }
    
    public static void setEtcPath(String groupNo){
        etcPath = "/etc/group" + groupNo +"/";
    }

    public static void setMyNumber(String groupNo){
        myNumber = groupNo;
    }

    public static void setImsPath(String groupNo){
        imsPath = "/etc/group" + groupNo + "/ims.conf";
    }
    
    
    public static String getEtcPath(){
        if (etcPath == null){
            clusterInstance = new ClusterSOAPServer();
            SoapRpsCluster rps = clusterInstance.getCluster();
        }
        return etcPath; 
    }

    public static String getImsPath(){ 
        if (imsPath == null){
            clusterInstance = new ClusterSOAPServer();
            SoapRpsCluster rps = clusterInstance.getCluster();
        }
        return imsPath; 
    }

    public static String getMyNumber(){
        if (myNumber == null){
            clusterInstance = new ClusterSOAPServer();
            SoapRpsCluster rps = clusterInstance.getCluster();
        }
        return myNumber; 
    }

    // make directory
    public SoapResponse makeDir(String path) throws Exception{
        SoapResponse trans=new SoapResponse();
        String home=System.getProperty("user.home");
        String[] cmds = { COMMAND_SUDO,
                           home + CLUSTER_MAKE_DIR,
                           path
                        };
        SOAPServerBase.execCmd(cmds,trans);
        return trans;
    }// end function "makeDir"

    // delete directory
    public SoapResponse deleteDir(String path) throws Exception{
        SoapResponse trans=new SoapResponse();
        String home=System.getProperty("user.home");
        String[] cmds = { COMMAND_SUDO,
                           home + CLUSTER_DELETE_DIR,
                           path
                        };
        SOAPServerBase.execCmd(cmds,trans);
        return trans;
    }// end function "deleteDir"    

    // chmod a directory
    public SoapResponse chmod(String path) throws Exception{
        SoapResponse trans=new SoapResponse();
        chgmod(trans, "-c", path, "777");
        return trans;
    }// end function "chmod" 
    
    private void chgmod(SoapResponse rps, String convert, String path, String mod){
        String home=System.getProperty("user.home");
        String[] cmds = { COMMAND_SUDO,
                           home + CLUSTER_CHMOD_DIR,
                           convert,
                           path,
                           mod
                        };
        SOAPServerBase.execCmd(cmds, rps); 
    }

    /**
     * Function: 1) tar target file to /tmp
     *           2) rcp tarfile to standby node
     *           3) rm tarfile in /tmp
     *
     * @param: Vector files      ->  The files to rsync
     * @param: String routerUrl  ->  The url of soapServer
    */
    public SoapResponse activeSync(Vector files) throws Exception{
        SoapResponse rps = new SoapResponse();
        rps.setSuccessful(true);
        String home=System.getProperty("user.home");
        String file = null;
        Vector otherNodes = cluster.getOtherNodes();
        for (int i=0; i< otherNodes.size(); i++){
            ClusterNode clusterNode = (ClusterNode)otherNodes.get(i);

            for (int t=0; t<files.size(); t++){
                file = (String)files.get(t);
                String[] cmds = {  home + SCRIPT_DIR + SCRIPT_CLUSTER_TAR,
                                   file,
                                   clusterNode.getIP()
                                };
                SOAPServerBase.execCmd(cmds, rps); 
            }
        }
        return rps;
    }

    /**
     * Function: 1) rm -rf /etc/groupN/nas_cifs
     *           2) tar Pxzf /tmp/cifsN.tar.gz
     *           3) rm -f /tmp/cifsN.tar.gz
     *
     * @param: Vector files      ->  The files to rsync
     * @param: String routerUrl  ->  The url of soapServer
    */
    public SoapResponse standbySync(Vector files) throws Exception{
        SoapResponse rps = new SoapResponse();
        rps.setSuccessful(true);
        String home=System.getProperty("user.home");
        String file = null;
        
        for (int i=0; i<files.size(); i++){
            file = (String)files.get(i);
            String[] cmds = { COMMAND_SUDO,
                               home + SCRIPT_DIR + SCRIPT_CLUSTER_UNTAR,
                               file
                            };
            SOAPServerBase.execCmd(cmds, rps); 
        }
        return rps;
    }


    /**
     * Function: rcp /etc/sysconfif/static-routes target:/tmp/static-routes:0
     */
    public SoapResponse sendStaticRoute() throws Exception{
        
        clusterInstance.getCluster();
        
        SoapResponse rps = new SoapResponse();
        rps.setSuccessful(true);
        String home=System.getProperty("user.home");
        Vector otherNodes = cluster.getOtherNodes();
        for (int i=0; i< otherNodes.size(); i++){
            ClusterNode clusterNode = (ClusterNode)otherNodes.get(i);
            String[] cmds = {  home + SCRIPT_DIR + SCRIPT_CLUSTER_SENDSTATICROUTE,
                                   clusterNode.getIP()
                                };
                SOAPServerBase.execCmd(cmds, rps); 
        }
        return rps;
    }

    /**
     * Function: 1) cp /tmp/static-routes:0 /etc/sysconfig/static-routes:0
     *           2) rm /tmp/static-routes:0 
     */
    public SoapResponse receiveStaticRoute() throws Exception{
        SoapResponse rps = new SoapResponse();
        rps.setSuccessful(true);
        String home=System.getProperty("user.home");
        
        String[] cmds = { COMMAND_SUDO,
                          home + SCRIPT_DIR + SCRIPT_CLUSTER_RECSTATICROUTE
                        };
            SOAPServerBase.execCmd(cmds, rps); 
        return rps;
    }

}