/*
 *      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.exportroot;

import javax.servlet.http.HttpSession;

import com.nec.sydney.atom.admin.mapd.*;
import com.nec.sydney.beans.base.*;
import com.nec.sydney.beans.mapd.*;
import com.nec.sydney.framework.*;
import com.nec.sydney.atom.admin.base.*;
import com.nec.nsgui.action.base.*;
import com.nec.nsgui.model.biz.base.CmdExecBase;
import com.nec.nsgui.model.biz.base.NSCmdResult;
import com.nec.nsgui.model.entity.framework.FrameworkConst;

public class ExportRootModifyBean extends AbstractJSPBean implements NasConstants,NSExceptionMsg
{
    private static final String cvsid = "@(#) $Id: ExportRootModifyBean.java,v 1.5 2007/06/28 01:30:36 wanghb Exp $";

    private static final String REQUEST_PARAMETER_EXPORT_ROOT_NAME = "exportgroup";
    private static final String     CMD_GET_DOMAIN_INFO = "/bin/userdb_getdomaininfo.pl";
    private static final String     CMD_GET_DC_FOR_ADSDOMAIN = "/bin/userdb_getDCforADSdomain.pl";
    
    private DomainInfo info4Unix = null; //Unix Domain Information
    private DomainInfo info4Win = null;  //Windows Domain Information
    private String dc = "";   //DC Information for ADSdomain

    public ExportRootModifyBean(){}

    public void beanProcess() throws Exception
    {
        String exportRootName = request.getParameter(REQUEST_PARAMETER_EXPORT_ROOT_NAME);
        setUserDBInfo(exportRootName);
        
        return;

    }

    private void setUserDBInfo(String exportRootName) throws Exception{
        int groupNo = NSActionUtil.getCurrentNodeNo(request);
        String[] cmds;
        //get unix domain's information
        cmds = new String[] {
                      SUDO_COMMAND,
                      System.getProperty("user.home")+
                      CMD_GET_DOMAIN_INFO,
                      exportRootName,
                      "sxfs",
                      (new Integer(groupNo)).toString()};
        NSCmdResult cmdResult = CmdExecBase.execCmd(cmds,groupNo,false,true);

        UserDBDomainConfBean userdbBean = new UserDBDomainConfBean();
        if (cmdResult.getExitValue() == 0) {
            info4Unix = userdbBean.fillDomainInfo(cmdResult.getStdout());
        }
        
        
        //get Windows domain's information
        cmds = new String[] {
                      SUDO_COMMAND,
                      System.getProperty("user.home")+
                      CMD_GET_DOMAIN_INFO,
                      exportRootName,
                      "sxfsfw",
                      (new Integer(groupNo)).toString()};
        cmdResult = CmdExecBase.execCmd(cmds,groupNo,true,true);
        if (cmdResult.getExitValue() == 0) {
            info4Win = userdbBean.fillDomainInfo(cmdResult.getStdout());
        }
        
        //get DC for ADSdomain
        DomainInfo domain4Win = getDomain4Win();
        if (domain4Win.getDomainType().equals("ads")) {
            cmds = new String[] { SUDO_COMMAND,
                    System.getProperty("user.home") + CMD_GET_DC_FOR_ADSDOMAIN,
                    (new Integer(groupNo)).toString(), "domain", exportRootName };
            NSCmdResult cmdResult1 = CmdExecBase.execCmd(cmds, groupNo, true,
                    true);
            String[] results = cmdResult1.getStdout();
            if (results == null || results[0] == null || results[0].trim().equals("")) {
                results[0] = "";
            }
            setDc(results[0].trim());
        }
        
        return;

    }
 	public void setDc(String x){
        dc = x;
    }
    public String getDc(){
        return dc;
    } 
 
    public DomainInfo getDomain4Unix(){
        return info4Unix;
    }

    public DomainInfo getDomain4Win(){
        return info4Win;
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
        } else if(codepage.equalsIgnoreCase("UTF8-NFC")){
        	codepageForDisplay = NSMessageDriver.getInstance().getMessage(session, "nas_exportroot/exportroot/radio_utf_nfc");
        }else {
        	codepageForDisplay = NSMessageDriver.getInstance().getMessage(session, "nas_exportroot/exportroot/radio_english");
        }
        return codepageForDisplay;
    }
    
}