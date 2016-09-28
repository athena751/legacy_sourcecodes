/*
 *      Copyright (c) 2001-2009 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.exportroot;

import java.util.*;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.atom.admin.base.api.*;
import com.nec.sydney.atom.admin.exportroot.*;
import com.nec.sydney.beans.base.*;
import com.nec.sydney.framework.*;
import com.nec.sydney.beans.mapdcommon.*;
import com.nec.nsgui.action.base.*;
import com.nec.nsgui.action.volume.VolumeActionConst;
import com.nec.nsgui.model.biz.base.CmdExecBase;
import com.nec.nsgui.model.biz.base.NSCmdResult;
import com.nec.nsgui.model.biz.ddr.DdrHandler;
import com.nec.nsgui.model.biz.volume.VolumeHandler;
import com.nec.nsgui.model.entity.framework.FrameworkConst;
import com.nec.nsgui.model.entity.volume.VolumeInfoBean;

public class ExportRootBean extends AbstractJSPBean implements NasConstants,NSExceptionMsg
{
    private static final String cvsid = "@(#) $Id: ExportRootBean.java,v 1.2314 2009/01/12 10:21:43 xingyh Exp $";

    private static final String EG_REQUEST_CODEPAGE = "detailCodePage";
    private static final String EG_EXPORTROOT_MAIN_JSP = "exportRoot.jsp";
    private static final String EG_EXPORTROOT_MPLIST_JSP = "exportrootmplist.jsp";
    private static final String EG_FORM_ACTION_DETAIL = "detail";
    private static final String EG_FORM_ACTION_DELETE = "delete";
    private static final String EG_EXPORTROOT_NAME = "exportgroup";
    private static final String SCIRPT_GET_EXPORTGROUP_LIST = "/bin/exportgroup_list.pl";
    private static final String SCIRPT_DELETE_EXPORTGROUP = "/bin/exportgroup_delete.pl";
    private static final String SCIRPT_DELETE_SERVERPROTECT_CONF = "/bin/exportgroup_delSPConf.pl";
    private static final String SCRIPT_DELETE_SCHEDULESCAN_CONF = "/bin/exportgroup_delScheduleScanConf.pl";
    private static final String PREFIX_EXPORT_GROUP = "/export/";
    
    private static final String ERR_CODE_DELETE_NOT_UMOUNT = "0x10600007";
    private static final String ERR_CODE_DELETE_LUDB_PATH = "0x10600009";
    private static final String ERR_CODE_DELETE_SERVERPROTECT = "0x10600011";
    private static final String ERR_CODE_DELETE_SCHEDULESCAN = "0x10600012";
    
    private Vector exportRootList;

    public ExportRootBean(){}

    public void beanProcess() throws Exception
    {

        //1. Get the parameter "act" from the request
        String action = request.getParameter(REQUEST_PARAMETER_EXPORT_ROOT_ACT);

        //2. If "act" is null, which indicates a browser refresh or the first time the page is loaded,
        if(action == null){
            setExportRootList();
        }else if(action.equalsIgnoreCase(EG_FORM_ACTION_DELETE)){// if act is "delete", do:
            String exportGroupName= PREFIX_EXPORT_GROUP + request.getParameter(EG_EXPORTROOT_NAME);
            String[] msgArray = new String[1];
            msgArray[0] = exportGroupName;
            
            try{
            	delServerProtectConf(exportGroupName);
            	delScheduleScanConf(exportGroupName);
                deleteExportRoot(exportGroupName,super.target);
                super.setMsg(NSMessageDriver.getInstance().getMessage(session, "common/alert/done", msgArray));
            }catch(com.nec.nsgui.model.biz.base.NSException e){
                if(e.getErrorCode().equals(ERR_CODE_DELETE_NOT_UMOUNT)){
                    super.setMsg(NSMessageDriver.getInstance().getMessage(session, "common/alert/failed") + "\\r\\n"
                            + NSMessageDriver.getInstance().getMessage(session, "nas_exportroot/alert/delexport_mount", msgArray));
                }else if(e.getErrorCode().equals(ERR_CODE_DELETE_LUDB_PATH)){
                    super.setMsg(NSMessageDriver.getInstance().getMessage(session, "common/alert/failed") + "\\r\\n"
    			+ NSMessageDriver.getInstance().getMessage(session, "nas_exportroot/alert/deleexport_local", msgArray));
                }else if(e.getErrorCode().equals(ERR_CODE_DELETE_SERVERPROTECT)) {
                    super.setMsg(NSMessageDriver.getInstance().getMessage(session, "common/alert/failed") + "\\r\\n"
                            + NSMessageDriver.getInstance().getMessage(session, "nas_mapd/alert/failed_del_sp", msgArray));
                }else if(e.getErrorCode().equals(ERR_CODE_DELETE_SCHEDULESCAN)) {
                    super.setMsg(NSMessageDriver.getInstance().getMessage(session, "common/alert/failed") + "\\r\\n"
                            + NSMessageDriver.getInstance().getMessage(session, "nas_mapd/alert/failed_del_ss", msgArray));
                }else{
                    throw e;
                }
            }
            
        }
        
        return;

    }


    private void setExportRootList() throws Exception
    {
        //get the exportRoot List.
        int groupNo = NSActionUtil.getCurrentNodeNo(request);
        String[] cmds = {SUDO_COMMAND,
                        System.getProperty("user.home")+
                        SCIRPT_GET_EXPORTGROUP_LIST,
                        Integer.toString(groupNo)};
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds,groupNo,true,true);
        String[] result = cmdResult.getStdout();

        exportRootList = new Vector();
        for (int i = 0; i < result.length; i ++) {
            StringTokenizer st = new StringTokenizer(result[i]);
            ExportGroupInfo er = new ExportGroupInfo();
            er.setExportGroupName(st.nextToken().substring(PREFIX_EXPORT_GROUP.length()));
            er.setEncoding(st.nextToken());
            String ntDomain = st.nextToken();
            er.setNtDomain(ntDomain.equals("-")?"":ntDomain);
            String netBios = st.nextToken();
            er.setNetBios(netBios.equals("-")?"":netBios);
            er.setMounted(st.nextToken());
            er.setUserDB(st.nextToken());
            exportRootList.add(er);
    	}
        
        sortExportRoot(exportRootList);
    }

    public Vector getExportRootList(){
        return exportRootList;
    }

    private void sortExportRoot (Vector export)
    {
        Collections.sort(export, new Comparator()
                                {
                                    public int compare(Object a, Object b)
                                    {
                                        ExportGroupInfo export1 = (ExportGroupInfo)a;
                                        ExportGroupInfo export2 = (ExportGroupInfo)b;
                                        return export1.getExportGroupName().compareTo(export2.getExportGroupName());
                                    }
                                }
                           );
    }

    private void deleteExportRoot(String exportRootPath, String sTarget) throws Exception
    {
        int groupNo = NSActionUtil.getCurrentNodeNo(request);
        
        String[] cmds = {SUDO_COMMAND,System.getProperty("user.home")+
                        SCIRPT_DELETE_EXPORTGROUP,
                        Integer.toString(groupNo),
                        exportRootPath
                        };
                        
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds,groupNo);

        MapdCommon.deleteLocalDomain(session,exportRootPath,sTarget);

        MapdCommon.deleteAuthDomain(session,exportRootPath,AuthDomain.AUTH_NIS,sTarget);
        MapdCommon.deleteAuthDomain(session,exportRootPath,AuthDomain.AUTH_PWD,sTarget);
        MapdCommon.deleteAuthDomain(session,exportRootPath,AuthDomain.AUTH_LDAPU,sTarget);
        
        MapdCommon.deleteAuthDomain(session,exportRootPath,AuthDomain.AUTH_NISW,sTarget);
        MapdCommon.deleteAuthDomain(session,exportRootPath,AuthDomain.AUTH_PWDW,sTarget);
        MapdCommon.deleteAuthDomain(session,exportRootPath,AuthDomain.AUTH_LDAPUW,sTarget);
        MapdCommon.deleteAuthDomain(session,exportRootPath,AuthDomain.AUTH_DMC,sTarget);
        MapdCommon.deleteAuthDomain(session,exportRootPath,AuthDomain.AUTH_SHR,sTarget);
        MapdCommon.deleteAuthDomain(session,exportRootPath,AuthDomain.AUTH_ADS,sTarget);
    }

    private void delServerProtectConf(String exportRootPath) throws Exception {
        int groupNo = NSActionUtil.getCurrentNodeNo(request);
        String[] cmds = {
                SUDO_COMMAND,
                System.getProperty("user.home")
                        + SCIRPT_DELETE_SERVERPROTECT_CONF,
                Integer.toString(groupNo), exportRootPath };
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, groupNo);
    }
    
    private void delScheduleScanConf(String exportRootPath) throws Exception {
        int groupNo = NSActionUtil.getCurrentNodeNo(request);
        String[] cmds = {
                SUDO_COMMAND,
                System.getProperty("user.home")
                        + SCRIPT_DELETE_SCHEDULESCAN_CONF,
                Integer.toString(groupNo), exportRootPath };
        CmdExecBase.execCmd(cmds, groupNo);
    }

    public String codepageToDisplay(String codepage){
        String codepageForDisplay;
        if( codepage.equalsIgnoreCase("EUC-JP") ) {
        	codepageForDisplay = NSMessageDriver.getInstance().getMessage(session, "nas_exportroot/exportroot/radio_euc");
        } else if( codepage.equalsIgnoreCase("SJIS") ) {
        	codepageForDisplay = NSMessageDriver.getInstance().getMessage(session, "nas_exportroot/exportroot/radio_sjis");
        } else if( codepage.equalsIgnoreCase("UTF-8") ) {
        	HttpSession session = request.getSession();
        	String machine = (String) session.getAttribute(FrameworkConst.SESSION_MACHINE_SERIES);
        	if (machine.equals(FrameworkConst.MACHINE_SERIES_CALLISTO)){
        		codepageForDisplay = NSMessageDriver.getInstance().getMessage(session, "nas_exportroot/exportroot/radio_utf");
        	} else {
        	    //The machine type can only be set "Callisto" or "Procyon".If there is another machine tyep,it deal as "Procyon".
        		codepageForDisplay = NSMessageDriver.getInstance().getMessage(session, "nas_exportroot/exportroot/radio_utf_mac");
        	}
        } else if (codepage.equalsIgnoreCase("UTF8-NFC")){
        	codepageForDisplay = NSMessageDriver.getInstance().getMessage(session, "nas_exportroot/exportroot/radio_utf_nfc");
        }else {
        	codepageForDisplay = NSMessageDriver.getInstance().getMessage(session, "nas_exportroot/exportroot/radio_english");
        }
        return codepageForDisplay;
    }
    public static  String getCreatingVolInExport(HttpServletRequest request) throws Exception {	
    	List<String> creatingVolExportList = new ArrayList<String>();
    	try {
    		//Get export group has async volume
	        String[] asyncInfo = VolumeHandler.getAsyncInfo();
	        for (int i=0;i< asyncInfo.length; i++){
	        	//asyncInfo[i] is as "create export/stinger0/voltest3 0x108000b2"
	        	if (!asyncInfo[i].trim().equals("")){
	        	    String mountPoint = (asyncInfo[i].split("\\s+"))[1];
		        	String [] tmp = mountPoint.split("/");
		        	if ((null != tmp )&&(tmp.length > 2)){
		        	    creatingVolExportList.add(tmp[2]);
		        	}
	        	}
	        }
            // Get export group has batch creating volume 
            ServletContext application = request.getSession().getServletContext();
        	Vector volumeInfoVec = (Vector)application.getAttribute(VolumeActionConst.APPLICATION_VOLUME_VOLUMEINFO);      
        	if ( null != volumeInfoVec ) {
                //Batch creating volume has the same export group,get the first
        		VolumeInfoBean volumeInfoBean = (VolumeInfoBean)volumeInfoVec.get(0);
	        	//mount point is as: /export/stinger0/voltest3
	        	String [] tmp =volumeInfoBean.getMountPoint().split("/");
	        	if ((null != tmp )&&(tmp.length > 2)){
	        	    creatingVolExportList.add(tmp[2]);
	        	} 
            }
         }catch ( Exception e){
             // When exception happened ,can not del export group
             return NSActionConst.ERROR_GET_BUSY_EXPORT_GROUP;
         }
         if( creatingVolExportList.size() < 1 ){
             return "";
         }
        String exportGroups = DdrHandler.join((String [])creatingVolExportList.toArray(new String[0]),",");
        return exportGroups;
    }  
}