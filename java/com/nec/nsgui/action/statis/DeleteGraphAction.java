/*
 *      Copyright (c) 2005-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.statis;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;
import org.apache.struts.actions.DispatchAction;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.base.CmdExecBase;
import com.nec.nsgui.model.biz.base.NSException;
import com.nec.nsgui.model.biz.statis.MonitorConfig;
import com.nec.nsgui.model.biz.statis.MonitorConfig2;
import com.nec.nsgui.model.biz.statis.MonitorConfigBase;
import com.nec.nsgui.model.biz.statis.SamplingHandler;
import com.nec.nsgui.model.biz.statis.WatchItemDef;

/**
 * @author Administrator
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class DeleteGraphAction
	extends DispatchAction
	implements StatisActionConst {
    public static final String cvsid 
            = "@(#) $Id: DeleteGraphAction.java,v 1.4 2007/04/03 08:12:10 yangxj Exp $";	    
	public ActionForward deleteGraph(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response)
		throws Exception {
		MonitorConfigBase mc;
		String targetID = (String) ((DynaActionForm) form).get("targetId");
		String subWatchItem =
			(String) ((DynaActionForm) form).get("subWatchItem");
		String isInvestGraph =
			(String) NSActionUtil.getSessionAttribute(
				request,
				SESSION_IS_INVESTGRAPH);
		if (isInvestGraph.trim().equals("1")) {
			mc =
				(MonitorConfig2) NSActionUtil.getSessionAttribute(
					request,
					SESSION_MC_4SURVEY);
		} else {
			mc =
				(MonitorConfig) NSActionUtil.getSessionAttribute(
					request,
					SESSION_MC);
		}
		String watchItemId =
			(String) NSActionUtil.getSessionAttribute(
				request,
				SESSION_WATCHITEM_ID);
		WatchItemDef wid = mc.getWatchItemDef(watchItemId);
		String collectionItemId = wid.getCollectionItem();
		
		
		try{
			
			mc.deleteRRDFile(targetID, collectionItemId, subWatchItem);
			
		}
		catch(NSException e)
		{
			String me=e.getMessage();
			me = me.substring(0,me.length()-1);
			if(me.endsWith(CollectionConst.EXCEPTION_MSG2))
			{
				e.setErrorCode(CollectionConst.EXCEPTION_ERRCODE_01); 
				NSActionUtil.setSessionAttribute( request,NSActionConst.SESSION_EXCEPTION_MESSAGE,"true");
				
			}
			throw e;
		}
		
		SamplingHandler.syncSampling();
		return mapping.findForward("displayRRDGraph");

	}
}