/*
 *      Copyright (c) 2005-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *      $Id: NicBondSetAction.java,v 3.2 2005/06/13 02:01:04 wanghb Exp
 *      
 */
package com.nec.nsgui.action.nic;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.nic.NicHandler;
import com.nec.nsgui.model.entity.nic.BondingInfoBean;
import com.nec.nsgui.model.biz.base.NSException;
import com.nec.nsgui.model.entity.nic.NicInformationBean;
import com.nec.nsgui.action.nic.NicActionConst;
public class NicBondSetAction extends Action {
	private static final String cvsid = "@(#) NicDetailTopAction.java,v 1.1 2005/08/25 07:37:58 changhs Exp";

	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		BondingInfoBean bondInfo = (BondingInfoBean) ((DynaActionForm) form)
				.get("bondInfo");
        String interfaceName = bondInfo.getBondName();
        try{
		    NicHandler.createBondingIF(bondInfo, NSActionUtil
				.getCurrentNodeNo(request));
        }catch (NSException ex) {
            if(ex.getErrorCode().equals(NicActionConst.BOND_ISALIAS_BASEIF)) {
                NSException e = new NSException();
                e.setErrorCode(NicActionConst.BOND_ISALIAS_BASEIF_SELF);
                throw e;
            } else {
                throw ex;
            }
        }
        boolean isCluster = NSActionUtil.isCluster(request);
        if(isCluster){
            NicInformationBean interfaceInfoFriend =null;
            try{
                interfaceInfoFriend = NicHandler.getInterfaceInfo(interfaceName, 1 - NSActionUtil.getCurrentNodeNo(request));
            }catch(Exception e){
            }
            if(interfaceInfoFriend == null){
              try{
                  NicHandler.createBondingIF(bondInfo, 1-NSActionUtil
                  .getCurrentNodeNo(request));
              }catch (NSException ex) {
                  NSException e = new NSException();
                  if(ex.getErrorCode().equals(NicActionConst.BOND_ISALIAS_BASEIF)) {
                      e.setErrorCode(NicActionConst.BOND_ISALIAS_BASEIF_FRIEND);
                  } else {
                      e.setErrorCode(NicActionConst.CLUSTER_FAILED_ERROR_NUMBER);
                  }
                  throw e;
              }
            }
        }
		((DynaActionForm) form).set("bondInfo",new BondingInfoBean());
		String from = (String) ((DynaActionForm) form).get("from");
		if (from != null && from.equals("vlan")) {
		    NSActionUtil.setSessionAttribute(request,
                NSActionConst.SESSION_SUCCESS_ALERT, "true");
			return mapping.findForward("vlanCreate");
		} else {
			String path = "/interfaceChange.do?nic_from4change=bond&interfaceName="
					+ bondInfo.getBondName();
			return new ActionForward(path);
		}

	}
}