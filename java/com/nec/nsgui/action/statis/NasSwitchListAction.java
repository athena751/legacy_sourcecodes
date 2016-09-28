/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.statis;

import java.text.SimpleDateFormat;
import java.util.AbstractList;
import java.util.ArrayList;
import java.util.Date;
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

import com.nec.nsgui.model.biz.statis.RRDGraphDef;
import com.nec.nsgui.model.entity.statis.CsvDownloadInfoBean;
import com.nec.nsgui.model.entity.statis.NasSwitchSubItemInfoBean;
import com.nec.nsgui.taglib.nssorttab.ListSTModel;
import com.nec.nsgui.taglib.nssorttab.SortTableModel;

/**
 * @author Administrator
 *
 * To change the template for this generated type comment go to
 * Window>Preferences>Java>Code Generation>Code and Comments
 */
public class NasSwitchListAction
	extends DispatchAction
	implements StatisActionConst {
    public static final String cvsid 
            = "@(#) $Id: NasSwitchListAction.java,v 1.1 2005/10/18 16:24:27 het Exp $";	    
	public ActionForward init(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response)
		throws Exception {
		DynaActionForm dForm = (DynaActionForm) form;
		String collectionId = (String) dForm.get("collectionItem");
		NSActionUtil.setSessionAttribute(
			request,
			SESSION_COLLECTION_ID,
			collectionId);
		String user =
			(String) NSActionUtil.getSessionAttribute(
				request,
				SESSION_USERINFO);
		MonitorConfig3 mc3 = new MonitorConfig3();
		mc3.loadDefs();
		NSActionUtil.setSessionAttribute(request, SESSION_MC, mc3);
		RRDGraphDef rgd;
		if(request.getSession().getAttribute(SESSION_RGD_4NSW)==null){
			rgd = mc3.loadRRDGraphDef(user, false);
			request.getSession().setAttribute(SESSION_RGD_4NSW, rgd);
		}else{
			rgd=(RRDGraphDef)request.getSession().getAttribute(SESSION_RGD_4NSW);
		}
		String graphType = rgd.getDefaultPeriod();
		String target = request.getParameter("target");
		String targetId = MonitorConfig3.stripTargetID(target);
		NSActionUtil.setSessionAttribute(request, SESSION_TARGET_ID, targetId);
		NSActionUtil.setSessionAttribute(request, "graphType", graphType);
		NSActionUtil.setSessionAttribute(
			request,
			"watchItemDesc",
			NasSwitchAssistant.getCollectionItemKey(collectionId));
		if (collectionId.equals(NSW_NFS_Node)) {
            NasSwitchAssistant nsa = new NasSwitchAssistant();
            nsa.init(getResources(request), request);
			List subItemList = nsa.getAllSubItemInfoList(graphType);
			NSActionUtil.setSessionAttribute(
				request,
				SESSION_STATIS_NASSWITCH_SUBITEMLIST_CHECKED,
				subItemList);
			return mapping.findForward("displayGraph");
		} else {
			return mapping.findForward("forwardToNasSwitchFrame");
		}
	}
	public ActionForward displayListTop(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response)
		throws Exception {
		DynaActionForm dForm = (DynaActionForm) form;
		String graphType = (String) dForm.get("graphType");
		if (graphType == null
			|| graphType.equals(
				"")) { //come back from detail graph or auto reload
			graphType =
				(String) NSActionUtil.getSessionAttribute(request, "graphType");
		} else {
			NSActionUtil.setSessionAttribute(request, "graphType", graphType);
		}
		NasSwitchAssistant nsa = new NasSwitchAssistant();
		nsa.init(getResources(request), request); 
        List subItemInfoList = nsa.getAllSubItemInfoList(graphType);
        SortTableModel tableMode =
                new ListSTModel((AbstractList) subItemInfoList);
        if (subItemInfoList.size() == 0) {
             NSActionUtil.setSessionAttribute(
                    request,
                    SESSION_STATIS_NASSWITCH_TABLE_MODE,
                    null);
        } else {
             NSActionUtil.setSessionAttribute(
                    request,
                    SESSION_STATIS_NASSWITCH_TABLE_MODE,
                    tableMode);
        }
        if (NSActionUtil.isSingleNode(request)) {
             request.setAttribute("isCluster", "false");
        } else {
             request.setAttribute("isCluster", "true");
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
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		Date date = new Date();
		String time = sdf.format(date);
		request.setAttribute("time", time);
		return mapping.findForward("displayListTop");
	}
	public ActionForward deleteList(
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
					subItemList_Checked.add(subItemInfo.getSubItem());
				}
			}
		}
		String targetID =
			(String) NSActionUtil.getSessionAttribute(
				request,
				SESSION_TARGET_ID);
		MonitorConfig3 mc3 =
			(MonitorConfig3) NSActionUtil.getSessionAttribute(
				request,
				SESSION_MC);
		String collectionItemId =
			(String) NSActionUtil.getSessionAttribute(
				request,
				SESSION_COLLECTION_ID);
		mc3.deleteRRDFiles(targetID, collectionItemId, subItemList_Checked);
		SamplingHandler.syncSampling();
		return mapping.findForward("displayNasSwitchList");
	}
}