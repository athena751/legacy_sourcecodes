/*
 *      Copyright (c) 2001-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.service.admin;


import com.nec.sydney.atom.admin.nashead.*;
import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.net.soap.*;
import java.util.*;
import java.io.*;


public class NasHeadSOAPServer implements NSExceptionMsg, NasHeadConstants {
	private static final String cvsid = "@(#) $Id: NasHeadSOAPServer.java,v 1.5 2008/04/19 15:11:53 jiangfx Exp $";
    
    private String home;
    private static final String PERL_GET_HBA_INFO = "nashead_gethbainfo.pl";
    private static final String PERL_GET_HBA_INFO_L = "nashead_gethbainfo.pl -l";
    private static final String SCRIPT_LD_AUTO_LINK = "nashead_autoLink.pl";
    private static final String SCRIPT_MODIFY_STORAGE_NAME = "nashead_modifyStorageName.pl";
    
    private static final String SCRIPT_GET_STORAGE_INFO = "nashead_getStorage.pl";
    private static final String SCRIPT_GET_LUN_INFO = "nashead_getLunInfo.pl";
    private static final String SCRIPT_DELETE_LD = "nashead_deleteLun.pl";
    private static final String SCRIPT_NASHEAD_GETSTORAGENAME = "nashead_getStorageName.pl";
    private static final String SCRIPT_GET_NAS_HEAD = "/home/nsadmin/bin/lvm_isNasHead.pl";

    private static final String SCRIPT_GET_UNLINKED_LUN = "/home/nsadmin/bin/nashead_getUnlinkedLunList.pl";
	private static final String	SCRIPT_SET_LUNLINK = "/home/nsadmin/bin/nashead_setLunLink.pl";

    
    private static final int  GETDDMAP_FAILED = 10;
    private static final int  LDCONF_NOT_EXIST_FOR_DELETE = 20;
    private static final int  FAILED_TO_RUN_LDHARDLN_1 = 30;
    private static final int  FAILED_TO_RUN_LDHARDLN_2 = 40;
    private static final int  LD_AUTO_LINK_LD_IS_FULL = 100;
    private static final int  STORAGE_NAME_EXIST = 50;
    
    public NasHeadSOAPServer() {
        home = System.getProperty("user.home");
    }
    
    public SoapRpsString getHBAInfo(boolean isPort)throws Exception {
        SoapRpsString transObject = new SoapRpsString();

        StringBuffer cmdbuf = new StringBuffer(SUDO_COMMAND);  

        cmdbuf.append(" ");
        cmdbuf.append(home);   
        cmdbuf.append(SCRIPT_DIR);  
        if (isPort) {
            cmdbuf.append(PERL_GET_HBA_INFO_L);
        } else {
            cmdbuf.append(PERL_GET_HBA_INFO);
        }
        String cmd = cmdbuf.toString();
        
        CmdHandler cmdHandler = new CmdHandler() {
            public void cmdHandle(SoapResponse trans, Process proc, String[] cmds)throws Exception {
                SoapRpsString transRpsStr = (SoapRpsString) trans;

                transRpsStr.setSuccessful(true);
                BufferedReader readbuf = new BufferedReader(
                        new InputStreamReader(proc.getInputStream()));
                StringBuffer sb = new StringBuffer(1024);
                String line = readbuf.readLine();            

                while (line != null) {
                    sb.append(line).append("\n");
                    line = readbuf.readLine();   
                }
                transRpsStr.setString(sb.toString());
            }
        };
        
        /*
         *In order to display the error message instead of throwing exception,
         *the successful flag must be set to "true";
         */
        CmdErrHandler cmdErrHandler = new CmdErrHandler() {
            public void errHandle(SoapResponse trans, Process proc, String[] cmds) throws Exception {
                trans.setSuccessful(true);
                trans.setErrorCode(proc.exitValue());
                trans.setErrorMessage(
                        "Exec command failed! Command = " + cmds[1] + "\n"
                        + SOAPServerBase.getCmdErrMsg(proc.getErrorStream()));
            }
        };
        
        SOAPServerBase.execCmd(cmd, transObject, cmdHandler, cmdErrHandler);
        return transObject;
    }    

    public SoapRpsString ldAutoLink()throws Exception {
        SoapRpsString trans = new SoapRpsString();
        
        String[] cmds = { SUDO_COMMAND, home + SCRIPT_DIR + SCRIPT_LD_AUTO_LINK};
        
        CmdHandler cmdHandler = new CmdHandler() {
            public void cmdHandle(SoapResponse trans, Process proc, String[] cmds)throws Exception {
                SoapRpsString transStr = (SoapRpsString) trans;
                BufferedReader buf = new BufferedReader(
                        new InputStreamReader(proc.getInputStream()));
                String result = buf.readLine();

                transStr.setString(result);
                transStr.setSuccessful(true);
            }
        };
        
        CmdErrHandler cmdErrHandler = new CmdErrHandler() {
            public void errHandle(SoapResponse rps, Process proc, String[] cmds)throws Exception {
                rps.setSuccessful(false);
                if (proc.exitValue() == LD_AUTO_LINK_LD_IS_FULL) {
                    rps.setErrorCode(LD_AUTO_LINK_LD_IS_FULL_EXCEPTION);
                } else {
                    rps.setErrorMessage(
                            SOAPServerBase.getCmdErrMsg(proc.getErrorStream()));
                }
            }
        };
        
        SOAPServerBase.execCmd(cmds, trans, cmdHandler, cmdErrHandler);
        return trans;
    }
    
    public SoapResponse setStorageName(String wwnn, String storageName)throws Exception {
        SoapResponse trans = new SoapResponse();
        String[] cmds = {
            SUDO_COMMAND,
            home + SCRIPT_DIR + SCRIPT_MODIFY_STORAGE_NAME, wwnn,
            new String(storageName.getBytes(NSUtil.EUC_JP))
        };
        CmdErrHandler cmdErrHandler = new CmdErrHandler() {
            public void errHandle(SoapResponse rps, Process proc, String[] cmds)throws Exception {
                rps.setSuccessful(false);
                if (proc.exitValue() == STORAGE_NAME_EXIST) {
                    rps.setErrorCode(STORAGE_NAME_EXIST_EXCEPTION);
                } else {
                    rps.setErrorMessage(
                            SOAPServerBase.getCmdErrMsg(proc.getErrorStream()));
                }
            }
        };

        SOAPServerBase.execCmd(cmds, trans, cmdErrHandler);
        return trans;
    }
    
    public SoapRpsString getStorageName(String wwnn)throws Exception {
        SoapRpsString trans = new SoapRpsString();
        
        String[] cmds = {
            SUDO_COMMAND,
            home + SCRIPT_DIR + SCRIPT_NASHEAD_GETSTORAGENAME, wwnn};
        
        CmdHandler cmdHandler = new CmdHandler() {
            public void cmdHandle(SoapResponse trans, Process proc, String[] cmds)throws Exception {
                SoapRpsString transStr = (SoapRpsString) trans;
                BufferedReader buf = new BufferedReader(
                        new InputStreamReader(proc.getInputStream()));
                String result = buf.readLine();

                transStr.setString(NSUtil.perl2Page(result, NSUtil.EUC_JP));
                transStr.setSuccessful(true);
            }
        };
        
        SOAPServerBase.execCmd(cmds, trans, cmdHandler);
        return trans;
    }
    
    public SoapRpsVector getStorageList() throws Exception {
        SoapRpsVector trans = new SoapRpsVector();
        String[] cmds = {
            SUDO_COMMAND,
            home + SCRIPT_DIR + SCRIPT_GET_STORAGE_INFO};
        CmdHandler cmdHandler = new CmdHandler() {
            public void cmdHandle(SoapResponse trans, 
                    Process proc, 
                    String[] cmds) throws Exception {
                InputStreamReader read = new InputStreamReader(
                        proc.getInputStream());
                BufferedReader inputStr = new BufferedReader(read);
                String line = inputStr.readLine();
                Vector templdVec = new Vector();

                while (line != null) {
                    line = NSUtil.perl2Page(line, NSUtil.EUC_JP);
                    StorageInfo storageinfo = new StorageInfo();
                    String[] storageDetail = line.split(",");

                    storageinfo.setWwnn(storageDetail[0].trim());
                    storageinfo.setModel(storageDetail[1].trim());
                    if (storageDetail.length < 3) {
                        storageinfo.setStorageName("");
                    } else {
                        storageinfo.setStorageName(storageDetail[2]);
                    }
                                 
                    templdVec.addElement(storageinfo);
                    line = inputStr.readLine();
                }
                ((SoapRpsVector) trans).setVector(templdVec);
            }
        };
        
        CmdErrHandler errHandler = new CmdErrHandler() {
            public void errHandle(SoapResponse rps, Process proc, String[] cmds)throws Exception {
                rps.setSuccessful(false);
                if (proc.exitValue() == GETDDMAP_FAILED) {
                    rps.setErrorCode(CONSTANT_GETDDMAP_FAILED);
                } else {
                    rps.setErrorMessage(
                            SOAPServerBase.getCmdErrMsg(proc.getErrorStream()));
                }
            }
        };

        SOAPServerBase.execCmd(cmds, trans, cmdHandler, errHandler);
        return trans;
        
    }
    
    public SoapRpsVector getLunList(String wwnn, String needScan, boolean isNsview) throws Exception {
        SoapRpsVector trans = new SoapRpsVector();
        String[] cmds = {
            SUDO_COMMAND, home + SCRIPT_DIR + SCRIPT_GET_LUN_INFO,
            wwnn,
            needScan,
            isNsview?"yes":"no"};
        CmdHandler cmdHandler = new CmdHandler() {
            public void cmdHandle(SoapResponse trans, 
                    Process proc, 
                    String[] cmds) throws Exception {
                InputStreamReader read = new InputStreamReader(
                        proc.getInputStream());
                BufferedReader inputStr = new BufferedReader(read);
                String line = inputStr.readLine();
                Vector templdVec = new Vector();

                while (line != null) {
                    LunInfo	luninfo = new LunInfo();
                    String[] lunDetail = line.split(","); 

                    luninfo.setLun(lunDetail[0].trim());
                    luninfo.setDevicePath(lunDetail[1].trim());
                    ;
                    luninfo.setConnectStatus(lunDetail[2].trim());
                    luninfo.setLvm(lunDetail[3].trim());
                    luninfo.setPairStatus(lunDetail[4].trim());
                                      
                    templdVec.addElement(luninfo);
                    line = inputStr.readLine();
                }
                ((SoapRpsVector) trans).setVector(templdVec);
            }
        };
        
        CmdErrHandler errHandler = new CmdErrHandler() {
            public void errHandle(SoapResponse rps, Process proc, String[] cmds)throws Exception {
                rps.setSuccessful(false);
                if (proc.exitValue() == GETDDMAP_FAILED) {
                    rps.setErrorCode(CONSTANT_GETDDMAP_FAILED);
                } else {
                    rps.setErrorMessage(
                            SOAPServerBase.getCmdErrMsg(proc.getErrorStream()));
                }
            }
        };

        SOAPServerBase.execCmd(cmds, trans, cmdHandler, errHandler);
        return trans;
    }
    
    public SoapRpsVector deleteLUN(String devicepath) throws Exception {
        SoapRpsVector trans = new SoapRpsVector();
        String[] cmds = {
            SUDO_COMMAND, home + SCRIPT_DIR + SCRIPT_DELETE_LD,
            devicepath};
        CmdErrHandler cmdErrHandler = new CmdErrHandler() {
            public void errHandle(SoapResponse rps, Process proc, String[] cmds)throws Exception {
                rps.setSuccessful(false);
                if (proc.exitValue() == LDCONF_NOT_EXIST_FOR_DELETE) {
                    rps.setErrorCode(CONSTANT_LDCONF_NOT_EXIST_FOR_DELETE);
                } else if (proc.exitValue() == FAILED_TO_RUN_LDHARDLN_1) {
                    rps.setErrorCode(CONSTANT_FAILED_TO_RUN_LDHARDLN_1);                  
                } else if (proc.exitValue() == FAILED_TO_RUN_LDHARDLN_2) {
                    rps.setErrorCode(CONSTANT_FAILED_TO_RUN_LDHARDLN_2); 
                } else {
                    rps.setErrorMessage(
                            SOAPServerBase.getCmdErrMsg(proc.getErrorStream()));
                }
            }
        };

        SOAPServerBase.execCmd(cmds, trans, cmdErrHandler);
        return trans;
    }
    
    // check for current machine is nas head case by excute /home/nsadmin/bin/lvm_isNasHead.pl
    public String getNasHead() {
        SoapRpsString trans = new SoapRpsString();
        String[] cmds = { "sudo", SCRIPT_GET_NAS_HEAD};
        CmdHandler cmdHandler = new CmdHandler() {
            public void cmdHandle(SoapResponse trans, 
                    Process proc, 
                    String[] cmds) throws Exception {
                InputStreamReader read = new InputStreamReader(
                        proc.getInputStream());
                BufferedReader buf = new BufferedReader(read);
                String line = buf.readLine();

                ((SoapRpsString) trans).setString(line.trim());
            }
        };

        SOAPServerBase.execCmd(cmds, trans, cmdHandler);
        return trans.getString();
    }
 
 	/*
	*to get unlinked lun list
	*parameter: none
	*return:
	*	SoapRpsVector
	*/
	public SoapRpsVector getUnlinkedLunList() throws Exception{
        SoapRpsVector trans = new SoapRpsVector();
        String[] cmds = {
            SUDO_COMMAND, SCRIPT_GET_UNLINKED_LUN};
        CmdHandler cmdHandler = new CmdHandler() {
            public void cmdHandle(SoapResponse trans, 
                    Process proc, 
                    String[] cmds) throws Exception {
                InputStreamReader read = new InputStreamReader(
                        proc.getInputStream());
                BufferedReader inputStr = new BufferedReader(read);
                String line = inputStr.readLine().trim();
                Vector templdVec = new Vector();
                if (line.startsWith("maxLuns:")){
            		templdVec.addElement(line.substring(line.indexOf(":")+1));
                }
                line = inputStr.readLine();
                while (line != null) {
	                line = NSUtil.perl2Page(line, NSUtil.EUC_JP);
                    UnlinkedLunInfo	luninfo = new UnlinkedLunInfo();
                    String[] lunDetail = line.split(","); 

                    luninfo.setStorageName(lunDetail[0]);
                    luninfo.setWwnn(lunDetail[1]);
                    luninfo.setLun(lunDetail[2]);
                                      
                    templdVec.addElement(luninfo);
                    line = inputStr.readLine();
                }
                ((SoapRpsVector) trans).setVector(templdVec);
            }
        };
        
        CmdErrHandler errHandler = new CmdErrHandler() {
            public void errHandle(SoapResponse rps, Process proc, String[] cmds)throws Exception {
                rps.setSuccessful(false);
                if (proc.exitValue() == GETDDMAP_FAILED) {
                    rps.setErrorCode(CONSTANT_GETDDMAP_FAILED);
                } else {
                    rps.setErrorMessage(
                            SOAPServerBase.getCmdErrMsg(proc.getErrorStream()));
                }
            }
        };

        SOAPServerBase.execCmd(cmds, trans, cmdHandler, errHandler);
        return trans;
	}

	/*
	*to set lunlink
	*parameter:
	*	lunInfo:wwwnn and lun info,such as "wwnn1,lun1 wwnn2,lun2..."
	*	flag:"0"(initialize and link)|"1"(link only)
	*return:
	*	SoapRpsVector(the first element is Linked successfullly Lun number, 
	*		if has lun linked failed, include the storage name and luns.)
	*/
	public SoapRpsVector setLunLink(String lunInfo, String flag) throws Exception{
        SoapRpsVector trans = new SoapRpsVector();
        String[] cmds = {
            SUDO_COMMAND, SCRIPT_SET_LUNLINK, lunInfo, flag};
        CmdHandler cmdHandler = new CmdHandler() {
            public void cmdHandle(SoapResponse trans, 
                    Process proc, 
                    String[] cmds) throws Exception {
                InputStreamReader read = new InputStreamReader(
                        proc.getInputStream());
                BufferedReader inputStr = new BufferedReader(read);
                String line = inputStr.readLine().trim();
                Vector templdVec = new Vector();
                if (line.startsWith("LinkedLuns:")){
            		templdVec.addElement(line.substring(line.indexOf(":")+1));
                }
                line = inputStr.readLine();
                while (line != null) {
	                if (line.startsWith("storageName:")){
	                    templdVec.addElement(NSUtil.perl2Page(line.substring(line.indexOf(":")+1), NSUtil.EUC_JP));
					}else if (line.startsWith("LUNS:")){
	                    templdVec.addElement(line.substring(line.indexOf(":")+1));
    				}
    	            line = inputStr.readLine();
                }
                ((SoapRpsVector) trans).setVector(templdVec);
            }
        };
        
        CmdErrHandler errHandler = new CmdErrHandler() {
            public void errHandle(SoapResponse rps, Process proc, String[] cmds)throws Exception {
                rps.setSuccessful(false);
                rps.setErrorMessage(
                        SOAPServerBase.getCmdErrMsg(proc.getErrorStream()));
            }
        };

        SOAPServerBase.execCmd(cmds, trans, cmdHandler, errHandler);
        return trans;
	}

}

