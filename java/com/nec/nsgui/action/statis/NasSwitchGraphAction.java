/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.statis;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;
import org.apache.struts.actions.DispatchAction;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.statis.MonitorConfig3;
import com.nec.nsgui.model.biz.statis.SamplingHandler;
import com.nec.nsgui.model.entity.statis.CsvDownloadInfoBean;
import com.nec.nsgui.model.entity.statis.NasSwitchSubItemInfoBean;
import com.nec.nsgui.taglib.nssorttab.ListSTModel;

/**
 * @author Administrator
 *
 * To change the template for this generated type comment go to
 * Window>Preferences>Java>Code Generation>Code and Comments
 */
public class NasSwitchGraphAction
	extends DispatchAction
	implements StatisActionConst {
    public static final String cvsid 
            = "@(#) $Id: NasSwitchGraphAction.java,v 1.1 2005/10/18 16:24:27 het Exp $";	    
	public ActionForward init(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response)
		throws Exception {
		DynaActionForm dForm = (DynaActionForm) form;
		String[] subItem = request.getParameterValues("subItemCheckbox");
		ListSTModel listSTModel =
			(ListSTModel) NSActionUtil.getSessionAttribute(
				request,
				SESSION_STATIS_NASSWITCH_TABLE_MODE);
		List subItemList = listSTModel.getDataList();
		List subItemList_Checked = new ArrayList();
		for (int i = 0; i < subItemList.size(); i++) {
			NasSwitchSubItemInfoBean subItemInfo =
				(NasSwitchSubItemInfoBean) subItemList.get(i);
			int sequence = subItemInfo.getSequence();
			for (int j = 0; j < subItem.length; j++) {
				if (sequence == Integer.parseInt(subItem[j])) {
					subItemList_Checked.add(subItemInfo);
				}
			}
		}
		NSActionUtil.setSessionAttribute(
			request,
			SESSION_STATIS_NASSWITCH_SUBITEMLIST_CHECKED,
			subItemList_Checked);
		return mapping.findForward("forwardToGraphBottom");
	}
	public ActionForward displayGraph(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response)
		throws Exception {
		DynaActionForm dForm = (DynaActionForm) form;
		String graphType = (String) dForm.get("graphType");
		if (graphType == null || graphType.equals("")) {
			graphType =
				(String) NSActionUtil.getSessionAttribute(request, "graphType");
		} else {
			NSActionUtil.setSessionAttribute(request, "graphType", graphType);
		}
		NasSwitchAssistant nsa = new NasSwitchAssistant();
		nsa.init(getResources(request), request);
		request.setAttribute("autoReloadInterval", nsa.getAutoReloadInterval());
		request.setAttribute("autoReloadFlag", nsa.getAutoReloadFlag());
		request.setAttribute("graphInfoList", nsa.getGraphInfoList3(graphType));
		List subItemList =
			(List) NSActionUtil.getSessionAttribute(
				request,
				SESSION_STATIS_NASSWITCH_SUBITEMLIST_CHECKED);
		if (subItemList.size() > 0) {
			request.setAttribute("isHasButton", "yes");
		} else {
			request.setAttribute("isHasButton", "no");
		}
		String collectionId =
			(String) NSActionUtil.getSessionAttribute(
				request,
				SESSION_COLLECTION_ID);
		CsvDownloadInfoBean downloadInfo = new CsvDownloadInfoBean();
		downloadInfo.setCustomEndTime(nsa.getCustomEndTime());
		downloadInfo.setCustomStartTime(nsa.getCustomStartTime());
		downloadInfo.setDefaultPeriod(graphType);
		downloadInfo.setCollectionItemId(collectionId);
		dForm.set("downloadInfo", downloadInfo);
		return mapping.findForward("displayGraph");

	}
	public ActionForward displayDetailGraph(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response)
		throws Exception {
		DynaActionForm dForm = (DynaActionForm) form;
		String index = (String) dForm.get("index");
		String targetId = (String) dForm.get("targetID");
		String grayBackColor = (String) dForm.get("grayBackColor");
		String watchItemId = (String) dForm.get("watchItem");
		NasSwitchAssistant nsa = new NasSwitchAssistant();
		nsa.init(getResources(request), request);
		request.setAttribute("autoReloadInterval", nsa.getAutoReloadInterval());
		request.setAttribute("autoReloadFlag", nsa.getAutoReloadFlag());
		request.setAttribute("nickName", nsa.getNickName(targetId));
		if (NSActionUtil.isSingleNode(request)) {
			request.setAttribute("isCluster", "false");
		} else {
			request.setAttribute("isCluster", "true");
		}
		request.setAttribute(
			"detailGraph",
			nsa.getDetailGraph3(targetId, index, watchItemId, grayBackColor));
		String collectionId =
			(String) NSActionUtil.getSessionAttribute(
				request,
				SESSION_COLLECTION_ID);
		CsvDownloadInfoBean downloadInfo = new CsvDownloadInfoBean();
		downloadInfo.setDefaultResource(index);
		downloadInfo.setCustomEndTime(nsa.getCustomEndTime());
		downloadInfo.setCustomStartTime(nsa.getCustomStartTime());
		downloadInfo.setDefaultPeriod(
			(String) ((DynaActionForm) form).get("graphType"));
		downloadInfo.setCollectionItemId(collectionId);
		((DynaActionForm) form).set("downloadInfo", downloadInfo);
		return mapping.findForward("displayDetailGraph");

	}
	public ActionForward deleteGraph(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response)
		throws Exception {
		String index = (String) ((DynaActionForm) form).get("index");
		List subItemList_checked =
			(List) NSActionUtil.getSessionAttribute(
				request,
				SESSION_STATIS_NASSWITCH_SUBITEMLIST_CHECKED);
        List subItemList_checked_new=new ArrayList();
		String subItem = "";
		for(int i=0;i<subItemList_checked.size();i++) {
			NasSwitchSubItemInfoBean subItemInfo =
				(NasSwitchSubItemInfoBean) subItemList_checked.get(i);
			if (subItemInfo.getSequence() == Integer.parseInt(index)) {
				subItem = subItemInfo.getSubItem();
			}else{
                subItemList_checked_new.add(subItemInfo);
            }
		}
        NSActionUtil.setSessionAttribute(
                request,
                SESSION_STATIS_NASSWITCH_SUBITEMLIST_CHECKED,
                subItemList_checked_new);
		MonitorConfig3 mc3 =
			(MonitorConfig3) NSActionUtil.getSessionAttribute(
				request,
				SESSION_MC);
		String collectionItemId =
			(String) NSActionUtil.getSessionAttribute(
				request,
				SESSION_COLLECTION_ID);
		String targetID =
			(String) NSActionUtil.getSessionAttribute(
				request,
				SESSION_TARGET_ID);
		mc3.deleteRRDFile(targetID, collectionItemId, subItem);
		SamplingHandler.syncSampling();
		return mapping.findForward("displayNasSwitchGraph");
	}
}