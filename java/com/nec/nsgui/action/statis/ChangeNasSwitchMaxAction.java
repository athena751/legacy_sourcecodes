/*
 *      Copyright (c) 2005 NEC Corporation
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
import com.nec.nsgui.model.entity.statis.YInfoBean;

/**
 * @author Administrator
 *
 * To change the template for this generated type comment go to
 * Window>Preferences>Java>Code Generation>Code and Comments
 */
public class ChangeNasSwitchMaxAction
	extends DispatchAction
	implements StatisActionConst {
    public static final String cvsid 
            = "@(#) $Id: ChangeNasSwitchMaxAction.java,v 1.1 2005/10/18 16:24:27 het Exp $";	    
	public ActionForward changeMax(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response)
		throws Exception {
		DynaActionForm dForm = (DynaActionForm) form;
		String isDetail = (String) dForm.get("isDetail");
		String watchItem = (String) dForm.get("selectedItem");
		String collectionItem = (String) dForm.get("collectionItem");
		String[] watchItemId = NasSwitchAssistant.getWatchItemId(collectionItem);
		if (watchItem.equals("access")) {
			watchItem = watchItemId[0];
		}
		if (watchItem.equals("res")) {
			watchItem = watchItemId[1];
		}
		if (watchItem.equals("rover")) {
			watchItem = watchItemId[2];
		}
		YInfoBean yInfoBean =
			(YInfoBean) dForm.get("yInfoBean");
		String session_y = "statis_" + collectionItem + watchItem;
		request.getSession().setAttribute(session_y, yInfoBean);
		if (isDetail.trim().equals("0")) {
			return mapping.findForward("displayNasSwitchGraph");
		} else {
			return mapping.findForward("displayDetailNasSwitchGraph");
		}
	}

	public ActionForward displayMax(
		ActionMapping mapping,
		ActionForm form,
		HttpServletRequest request,
		HttpServletResponse response)
		throws Exception {
		DynaActionForm dForm = (DynaActionForm) form;
		String collectionItem = (String) dForm.get("collectionItem");
		String watchItem = (String) dForm.get("selectedItem");
		String tempItem = watchItem;
		String[] watchItemId = NasSwitchAssistant.getWatchItemId(collectionItem);
		if (watchItem.equals("access")) {
			watchItem = watchItemId[0];
		}
		if (watchItem.equals("res")) {
			watchItem = watchItemId[1];
		}
		if (watchItem.equals("rover")) {
			watchItem = watchItemId[2];
		}
		String session_y = "statis_" + collectionItem + watchItem;
		YInfoBean yInfoBean =
			(YInfoBean) request.getSession().getAttribute(session_y);
		if (yInfoBean == null) {
			yInfoBean = new YInfoBean();
		} else {
			if (yInfoBean.getMaxradio().equals("default")) {
				yInfoBean.setMax("");
				yInfoBean.setMaxunit("-");
				yInfoBean.setDisplaymax("");
			}
			if (yInfoBean.getMinradio().equals("default")) {
				yInfoBean.setMin("");
				yInfoBean.setMinunit("-");
				yInfoBean.setDisplaymin("");
			}
		}
		dForm.set("yInfoBean", yInfoBean);
		return mapping.findForward("displayMaxPage");

	}

}