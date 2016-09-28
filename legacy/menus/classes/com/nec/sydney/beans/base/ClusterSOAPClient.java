/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.base;

import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.framework.*;
import com.nec.sydney.net.soap.*;
import java.util.*; 

public class ClusterSOAPClient{

    private static final String     cvsid = "@(#) $Id: ClusterSOAPClient.java,v 1.2300 2003/11/24 00:54:45 nsadmin Exp $";

    private static final String URN_CLUSTER_SERVICE        = "urn:ClusterConf";

    public static ClusterInfo getCluster(String routerUrl)throws Exception {
        SoapRpsCluster rtValue = (SoapRpsCluster)SoapClientBase.execSoapServerFunc("getCluster",URN_CLUSTER_SERVICE,routerUrl);
        return rtValue.getCluster();
    }

    /**
     * In the send node, rcp the /etc/sysconfig/static-route to targetNode:/tmp/static-route.
     * @param routeUrl  the soap Url
     */
    private static void sendStaticRoute(String routerUrl)throws Exception{
       SoapClientBase.execSoapServerFunc("sendStaticRoute",URN_CLUSTER_SERVICE,routerUrl);
    }

    /**
     * In the destination node, extract the tar file and cp the file to destination files.
     * @param routerUrl  the soap Url
     */
    private static void receiveStaticRoute(String routerUrl)throws Exception{
       SoapClientBase.execSoapServerFunc("receiveStaticRoute",URN_CLUSTER_SERVICE,routerUrl);
    }

    /**
     * cp the /etc/sycconfig/static-routes in the source node to /etc/sysconfig/static-routes:0 in
     * the destination node
     * @param srcUrl    the source soap server Url
     * @param destUrl the destination node soap url
     */
    public static void copyStaticRoutes(String srcUrl,String destUrl ) throws Exception{
       sendStaticRoute(srcUrl);
       receiveStaticRoute(destUrl);        
    }

    public static void remoteSync (String[] files, String fnode, String routerUrl) throws Exception {
	Vector fileVec = new Vector();
        for(int i=0; i<files.length; i++){
            fileVec.add(files[i]);
        }
	activeSync(fileVec, routerUrl);
        standbySync(fileVec, fnode);
        return ;
    }
    /**
     * This function is unsed to rsync the files from active node to standby node.
     *
     * @param: String[] files    -> the files to rsync
     * @param: String myNum      -> the node number of this target
     * @param: String routerUrl  -> the url of soapServer
    */
    public static void remoteSync (String[] files, String myNum, String fnode, String routerUrl) throws Exception {
        Vector fileVec = new Vector();
        for(int i=0; i<files.length; i++){
            fileVec.add(files[i].replaceAll( "%", myNum ) );
        }
        activeSync(fileVec, routerUrl);
        standbySync(fileVec, fnode);
        return ;
    }

    /**
     * Function: 1) tar target file to /tmp
     *           2) rcp tarfile to standby node
     *           3) rm tarfile in /tmp
     *
     * @param: Vector files      ->  The files to rsync
     * @param: String routerUrl  ->  The url of soapServer
     */
    private static void activeSync(Vector files, String routerUrl) throws Exception{
         Vector paramVec = new Vector();
         paramVec.add(files);
         SoapClientBase.execSoapServerFunc(paramVec,"activeSync",URN_CLUSTER_SERVICE,routerUrl);
    }

    /**
     * Function: 1) rm -rf /etc/groupN/nas_cifs
     *           2) tar Pxzf /tmp/cifsN.tar.gz
     *           3) rm -f /tmp/cifsN.tar.gz
     *
     * @param: Vector files      ->  The files to rsync
     * @param: String routerUrl  ->  The url of soapServer
    */
    private static void standbySync(Vector files, String routerUrl) throws Exception{
         Vector paramVec = new Vector();
         paramVec.add(files);
         SoapClientBase.execSoapServerFunc(paramVec,"standbySync",URN_CLUSTER_SERVICE,routerUrl);
    }

  
    //Call ClusterSOAPServer service "makeDir"
    public static void makeDir(String path,String routerUrl)throws Exception{
        Vector paramVec = new Vector();
        paramVec.add(path);
        SoapClientBase.execSoapServerFunc(paramVec,"makeDir",URN_CLUSTER_SERVICE,routerUrl);
    }//end function "makeDir"
    
    //Call ClusterSOAPServer service "deleteDir"
    public static void deleteDir(String path,String routerUrl)throws Exception{
        Vector paramVec = new Vector();
        paramVec.add(path);
        SoapClientBase.execSoapServerFunc(paramVec,"deleteDir",URN_CLUSTER_SERVICE,routerUrl);
    }//end function "makeDir"    

    //Call ClusterSOAPServer service "chmod"
    public static void chmod(String path,String routerUrl)throws Exception{
        Vector paramVec = new Vector();
        paramVec.add(path);
        SoapClientBase.execSoapServerFunc(paramVec,"chmod",URN_CLUSTER_SERVICE,routerUrl);
    }//end function "makeDir"    

    // added for NIC
    //sourceNode: ------ the node ID such as "/clusterID@IPSAN"
    //friendNode: ------ the node ID such as "nodeID/clusterID@IPSAN"
    public static void remoteSync_forIPSAN (String[] files, String friendNode, String sourceNode) throws Exception {
	getCluster(sourceNode);
	remoteSync(files, friendNode, sourceNode);
        return ;
    }

}