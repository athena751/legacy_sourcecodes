/*
 *      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.ethguard;
import java.util.*;
import java.io.*;
import java.net.*;
import com.nec.sydney.framework.*;
import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.beans.base.*;
import com.nec.sydney.atom.admin.ethguard.*;
import com.nec.sydney.net.soap.Soap4Cluster;
import com.nec.nsgui.model.biz.base.NSProcess;

public class EthguardBean extends TemplateBean implements EthguardConstants{
    
    private static final String     cvsid = "@(#) $Id: EthguardBean.java,v 1.2308 2007/04/25 02:30:37 chenbc Exp $";
    private static final String     STATUS_START = "start";
    private static final String     STATUS_STOP = "stop";
    private static final String     SCRIPT_GET_VERSION_INFO = "/bin/ethguard_getVersionInfo.pl";
    private static final String     SCRIPT_GET_ADMIN_IP = "/bin/ethguard_getAdminIP.pl";
    private static final String     SCRIPT_GET_IP_FOR_ADMIN = "/bin/ethguard_getIpForAdmin.pl";
    
    private int status;
    private String connectionLimits;
    private String versionType;
    private boolean displayConnection;
   
    public EthguardBean() {
    }
    
    public void onStart() throws Exception{
        
        int rt = EthguardSOAPClient.setLogStatus(STATUS_START,super.target);
        if (rt==0){
            super.setMsg(NSMessageDriver.getInstance().getMessage(session,"common/alert/done"));
        }else{
            super.setMsg(NSMessageDriver.getInstance().getMessage(session,"common/alert/failed"));
        }
        setRedirectUrl("../nas/ethguard/filteringlog.jsp");
    }
    
    public void onStop() throws Exception{
        
        int rt = EthguardSOAPClient.setLogStatus(STATUS_STOP,super.target);
        if (rt==0){
            super.setMsg(NSMessageDriver.getInstance().getMessage(session,"common/alert/done"));
        }else{
            super.setMsg(NSMessageDriver.getInstance().getMessage(session,"common/alert/failed"));
        }
        setRedirectUrl("../nas/ethguard/filteringlog.jsp");
    }

    public void onDisplay() throws Exception{
        EthguardInfo guardInfo = EthguardSOAPClient.getEthguardInfo(super.target);
        setStatus(Integer.parseInt(guardInfo.getLoggingStatus()));
        setConnectionLimits(guardInfo.getConnectionLimits());
        setVersionType();
        setAdminNetwork();
    }

    public void onSetAvailable() throws Exception{
        //1.set local connection
        try{
            EthguardSOAPClient.setAvailable(super.target); 
        }catch(Exception e){
        //2.if local set failed, set message and return networkconnection.jsp
            super.setMsg(NSMessageDriver.getInstance().getMessage(session,"common/alert/failed"));
            setRedirectUrl("../nas/ethguard/networkconnection.jsp");
            return;
        } 
        //3.do it on another node  
        String fnode = EthguardSOAPClient.getFriendNode(super.target);
        if(fnode != null){
            try{
                EthguardSOAPClient.setAvailable(fnode);  
            }catch(Exception e){
                try{
                    EthguardSOAPClient.setDeny(super.target); 
                }catch(Exception ex){
                }
                super.setMsg(NSMessageDriver.getInstance().getMessage(session,"common/alert/failed"));
                setRedirectUrl("../nas/ethguard/networkconnection.jsp");
                return;
            }   
        }
        //4.return networkconnection.jsp
        super.setMsg(NSMessageDriver.getInstance().getMessage(session,"common/alert/done"));
        setRedirectUrl("../nas/ethguard/networkconnection.jsp");
    }

    public void onSetDeny() throws Exception{
        //1.set local connection
        try{
            EthguardSOAPClient.setDeny(super.target); 
        }catch(Exception e){
        //2.if local set failed, set message and return networkconnection.jsp
            super.setMsg(NSMessageDriver.getInstance().getMessage(session,"common/alert/failed"));
            setRedirectUrl("../nas/ethguard/networkconnection.jsp");
            return;
        } 
        //3.do it on another node  
        String fnode = EthguardSOAPClient.getFriendNode(super.target);
        if(fnode != null){
            try{
                EthguardSOAPClient.setDeny(fnode);  
            }catch(Exception e){
                try{
                    EthguardSOAPClient.setAvailable(super.target); 
                }catch(Exception ex){
                }
                super.setMsg(NSMessageDriver.getInstance().getMessage(session,"common/alert/failed"));
                setRedirectUrl("../nas/ethguard/networkconnection.jsp");
                return;
            }   
        }
        //4.return networkconnection.jsp
        super.setMsg(NSMessageDriver.getInstance().getMessage(session,"common/alert/done"));
        setRedirectUrl("../nas/ethguard/networkconnection.jsp");
    }

    public int getStatus(){
        return status;
    }
    public void setStatus(int status){
        this.status = status;
    }
    
    public String getConnectionLimits(){
        return connectionLimits;
    }
    private void setConnectionLimits(String connectionLimits){
        this.connectionLimits = connectionLimits;
    }
    
    public String getVersionType(){
        return versionType;
    }

    private void setVersionType(){
        versionType = VERSION_TYPE_OTHERS;
        try{
            String home = System.getProperty("user.home");
            String cmd = SUDO_COMMAND + " " + home + SCRIPT_GET_VERSION_INFO;
            //create the runtime object
            Runtime run = Runtime.getRuntime();
            //execute the linux command
            NSProcess proc = new NSProcess(run.exec(cmd));
            //wait for the process object has terminated
            proc.waitFor();
            if(proc.exitValue() == NAS_SUCCESS){
                BufferedReader inputStr= new BufferedReader(new InputStreamReader(proc.getInputStream()));
                versionType = inputStr.readLine().trim();
            }
        }catch(Exception e){
            //Failed to get the versionInfo and look it as others 
            versionType = VERSION_TYPE_OTHERS;
        }
    }
    
    private String getLocalAdminIp(String isCluster)throws Exception{
        String home = System.getProperty("user.home");
        String cmd = SUDO_COMMAND + " " + home + SCRIPT_GET_ADMIN_IP
                        + " " + isCluster;
        //create the runtime object
        Runtime run = Runtime.getRuntime();
        //execute the linux command
        NSProcess proc = new NSProcess(run.exec(cmd));
        //wait for the process object has terminated
        proc.waitFor();
        if(proc.exitValue() == NAS_SUCCESS){
            BufferedReader inputStr= new BufferedReader(new InputStreamReader(proc.getInputStream()));
            return inputStr.readLine();
        }else{
            return "";
        }
    }
    
    public boolean getDisplayConnection(){
        return displayConnection;
    }

    private void setAdminNetwork(){
        try{
            //check the administrative server
            String isCluster;
            if(EthguardSOAPClient.getFriendNode(super.target) == null){
                //single node
                isCluster = "false";
            }else{
                //cluster
                isCluster = "true";
            }
            String adminIP = EthguardSOAPClient.getAdminIp(target, isCluster);
            if(adminIP.equals("") || !adminIP.equals(getLocalAdminIp(isCluster))){
                //not administrative server
                displayConnection = true;
            }else{
                //administrative server
                String url_IP = InetAddress.getByName(request.getServerName()).getHostAddress();
                
                Vector adminIpVector = getIpForAdmin(isCluster);
                int size = adminIpVector.size();
                if(size < 1){
                    //failed to get IP and look it as administrative network
                    displayConnection = true;
                }else{
                    for(int i = 0; i < size; i++){
                        String tempIp = (String)adminIpVector.get(i);
                        if(url_IP.equals(tempIp)){
                            displayConnection = true;
                            return;
                        }
                    }
                    displayConnection = false;
                }
            }
        }catch(Exception e){
            //Failed to check the network and look it as administrative network 
            displayConnection = true;
        }
    }
    
    private Vector getIpForAdmin(String isCluster)throws Exception{
        
        String home = System.getProperty("user.home");
        String cmd = SUDO_COMMAND + " " + home + SCRIPT_GET_IP_FOR_ADMIN
                        + " " + isCluster;
        //create the runtime object
        Runtime run = Runtime.getRuntime();
        //execute the linux command
        NSProcess proc = new NSProcess(run.exec(cmd));
        //wait for the process object has terminated
        proc.waitFor();
        Vector adminIPVector = new Vector();
        if(proc.exitValue() == NAS_SUCCESS){
            BufferedReader inputStr= new BufferedReader(new InputStreamReader(proc.getInputStream()));
            String line = inputStr.readLine();
            while(line != null){
                adminIPVector.add(line);
                line = inputStr.readLine();
            }
        }
        
        return  adminIPVector;
    }
}