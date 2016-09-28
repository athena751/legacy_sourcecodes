/*
 *      Copyright (c) 2005-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 * 
 *      $Id: NicVlanAction.java,v 1.4 2007/08/29 00:55:04 fengmh Exp $
 */

package com.nec.nsgui.action.nic;

import javax.servlet.http.*;
import org.apache.struts.action.*;
import org.apache.struts.actions.*;
import com.nec.nsgui.model.biz.nic.*;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.base.NSException;
import com.nec.nsgui.model.entity.nic.NicInformationBean;
import java.util.*;
import com.nec.nsgui.action.nic.NicActionConst;

public class NicVlanAction extends DispatchAction {
    private static final String cvsid =
        "@(#) NICRouteDispatchAction.java,v 1.0 2005/06/21 07:16:49 dengyp Exp";

    /*
     * the action to set a list of routes
     * 
     * @param none
     * @successful to go forward to nicroutelist.jsp
     * @failed to go forward to nicroutechange.jsp
     *@throw exception
     */

    private static String vlanName = "";

    public ActionForward onSet(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        DynaActionForm dynaForm = (DynaActionForm) form;
        String tmp = (String) ((DynaActionForm) form).get("interfaceName");
        String str[] = tmp.split("\\.");
        if (str.length < 2)
            throw new Exception();
        String interfaceName = str[0];
        String vid = str[1];
        try {
            NicHandler.setVlan(interfaceName, vid, nodeNo);
        } catch (NSException ex) {
            vlanName = tmp;
            if(ex.getErrorCode().equals(NicActionConst.VLAN_ISALIAS_BASEIF)) {
                NSException e = new NSException();
                e.setErrorCode(NicActionConst.VLAN_ISALIAS_BASEIF_SELF);
                throw e;
            } else {
                throw ex;
            }
        }
        boolean isCluster = NSActionUtil.isCluster(request);
        if(isCluster){
            NicInformationBean interfaceInfoFriend=null;
            try{
                interfaceInfoFriend = NicHandler.getInterfaceInfo(tmp, 1 - nodeNo);
            }catch(Exception e){
            }
            if(interfaceInfoFriend == null){
                try{
                    NicHandler.setVlan(interfaceName, vid, 1-nodeNo);
                }catch (NSException ex) {
                    vlanName = tmp;
                    NSException e = new NSException();
                    if(ex.getErrorCode().equals(NicActionConst.VLAN_ISALIAS_BASEIF)) {
                        e.setErrorCode(NicActionConst.VLAN_ISALIAS_BASEIF_FRIEND);
                    } else {
                        e.setErrorCode(NicActionConst.CLUSTER_FAILED_ERROR_NUMBER);
                    }
                    throw e;
                }
            }
        }
        return mapping.findForward("setIP");
    }
    /*
     *the Operation to show the route change's top page    
     *forward to nicroutechangetop.jsp
     *throw Exception
     */
    public ActionForward loadTop(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception {        
        int nodeNo = NSActionUtil.getCurrentNodeNo(request);
        NicHandler nicHandler = new NicHandler();
        Vector nicList = nicHandler.getNicNames(nodeNo, 1);
        request.setAttribute("nicNameList4Vlan",nicList);    
        Vector vlanNicList = nicHandler.getNicList(2, nodeNo);
        int vlanCount =0;
        for(int i=0;i<vlanNicList.size();i++){
           if(((NicInformationBean)vlanNicList.get(i)).getNicName().indexOf(".")!=-1 &&
                !((NicInformationBean)vlanNicList.get(i)).getNicName().matches("\\S+:\\d{3,}")){
                vlanCount ++;
           } 
        }       
        NSActionUtil.setSessionAttribute(request,"vlanCount",Integer.toString(vlanCount));    
        int availableNicCount4Bond = NicHandler.getAvaiNicForCreatingBond(nodeNo).size();
            NSActionUtil.setSessionAttribute(request,"availableNicCount4Bond",Integer.toString(availableNicCount4Bond));     
        if (!vlanName.equals("")) {
            request.setAttribute("vlanName", vlanName);
            vlanName = "";
        }
        return mapping.findForward("vlanTop");
    }

}