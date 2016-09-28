/*
 *      Copyright (c) 2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.ddr;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;
import org.apache.struts.actions.DispatchAction;
import org.apache.struts.util.MessageResources;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.ddr.DdrHandler;
import com.nec.nsgui.model.biz.volume.VolumeHandler;
import com.nec.nsgui.action.volume.VolumeAddShowAction;
import com.nec.nsgui.action.volume.VolumeDetailAction;
import com.nec.nsgui.action.volume.VolumeActionConst;
import com.nec.nsgui.model.entity.ddr.DdrExtendPairBean;
import com.nec.nsgui.model.entity.ddr.DdrPairInfoBean;

public class DdrPairExtendShowAction extends DispatchAction implements DdrActionConst {
	private static final String cvsid = "@(#) $Id: DdrPairExtendShowAction.java,v 1.2 2008/05/06 08:36:33 liuyq Exp $";
    
    public ActionForward loadPairExtendTop(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		DynaActionForm dynaForm = (DynaActionForm)form;
		DdrPairInfoBean listBean = (DdrPairInfoBean)dynaForm.get("ddrPairInfo");
		String mvName = listBean.getMvName();
		String rvNames = listBean.getRvName();
		String rvLdNameList = listBean.getRvLdNameList();
		String asyncStatus = listBean.getStatus();
		
		request.getSession().setAttribute(SESSION_MV_NAME, mvName);
		
		int nodeNo = NSActionUtil.getCurrentNodeNo(request);
		List pairInfoList = DdrHandler.getInfo4PairExtend(mvName, rvNames, asyncStatus, rvLdNameList, nodeNo);
		
		DdrExtendPairBean mvInfo = (DdrExtendPairBean)pairInfoList.get(0);
		mvInfo.setPoolNo4extend(mvInfo.getPoolNo());
		String mvPoolNameAndNo = mvInfo.getPoolNameAndNoForDetail();
		mvInfo.setPoolNameAndNo(VolumeDetailAction.compactAndSort(mvPoolNameAndNo));
		List<DdrExtendPairBean> rvInfoList = parseRvBean((DdrExtendPairBean)pairInfoList.get(1));
		DdrExtendPairBean rv0Info = rvInfoList.get(0);
		DdrExtendPairBean rv1Info = rvInfoList.get(1);
		DdrExtendPairBean rv2Info = rvInfoList.get(2);
		
		String hasSnapshot = MV_HAS_SNAPSHOT;
		float allowableSize = Float.valueOf(VolumeActionConst.VOLUME_SIZE_20TB);
		if(mvInfo.getMp().equals(MV_NO_MOUNTPOINT)){
			MessageResources msgResource = (MessageResources) getResources(request);
			String msg =
                msgResource.getMessage(
                    request.getLocale(),
                    MSG_EXTEND_MV_NO_MOUNTPOINT);
			NSActionUtil.setSessionAttribute(
	                request, NSActionUtil.SESSION_OPERATION_RESULT_MESSAGE, msg);
			return mapping.findForward("globalForward2PairList");
			
		}else{
			int mvNode = Integer.valueOf(mvInfo.getNode());
			hasSnapshot = VolumeHandler.hasSnapshotSet(mvInfo.getMp(), mvNode);
		}
		if(hasSnapshot.equals(MV_NO_SNAPSHOT)){
			allowableSize = Float.valueOf(VolumeActionConst.VOLUME_MAX_SIZE);
		}
		
		dynaForm.set("mvInfo", mvInfo);
		// mvAllowableSize unit is GB
		request.setAttribute("mvAllowableSize", Float.toString(allowableSize));
		request.setAttribute("mvHasSnapshot", hasSnapshot);
		
		if(rv0Info != null){
			String errMsg = getErrMsg(request, rv0Info);
			if(!errMsg.equals("")){
				//	 Rv raidType is not raid6.
				return mapping.findForward("globalForward2PairList");
			}
			rv0Info.setPoolNameAndNo(VolumeDetailAction.compactAndSort(rv0Info.getPoolNameAndNoForDetail()));
			dynaForm.set("rv0Info", rv0Info);
			request.setAttribute("existRv0Info", "yes");
		}else{
			dynaForm.set("rv0Info", new DdrExtendPairBean());
			request.setAttribute("existRv0Info", "no");
		}
		if(rv1Info != null){
			String errMsg = getErrMsg(request, rv1Info);
			if(!errMsg.equals("")){
				return mapping.findForward("globalForward2PairList");
			}
			rv1Info.setPoolNameAndNo(VolumeDetailAction.compactAndSort(rv1Info.getPoolNameAndNoForDetail()));
			dynaForm.set("rv1Info", rv1Info);
			request.setAttribute("existRv1Info", "yes");
		}else{
			dynaForm.set("rv1Info", new DdrExtendPairBean());
			request.setAttribute("existRv1Info", "no");
		}
		if(rv2Info != null){
			String errMsg = getErrMsg(request, rv2Info);
			if(!errMsg.equals("")){
				return mapping.findForward("globalForward2PairList");
			}
			rv2Info.setPoolNameAndNo(VolumeDetailAction.compactAndSort(rv2Info.getPoolNameAndNoForDetail()));
			dynaForm.set("rv2Info", rv2Info);
			request.setAttribute("existRv2Info", "yes");
		}else{
			dynaForm.set("rv2Info", new DdrExtendPairBean());
			request.setAttribute("existRv2Info", "no");
		}
		VolumeAddShowAction.setLicenseChkSession(request);
		return mapping.findForward("pairExtendTop");
	}
	
	private List<DdrExtendPairBean> parseRvBean(DdrExtendPairBean rvInfoBean){
		List<DdrExtendPairBean> rvBeanList = new ArrayList<DdrExtendPairBean>();
		String[] rvNames = rvInfoBean.getName().split("#");
		String[] poolNameAndNos = rvInfoBean.getPoolNameAndNoForDetail().split("#");
		String[] raidTypes = rvInfoBean.getRaidType().split("#");
		String[] wwnns = rvInfoBean.getWwnn().split("#");
		DdrExtendPairBean rv0Info = null;
		DdrExtendPairBean rv1Info = null;
		DdrExtendPairBean rv2Info = null;
		for(int i = 0; i < rvNames.length; i++){
			DdrExtendPairBean tempRvInfo = new DdrExtendPairBean();
			tempRvInfo.setName(rvNames[i]);
			tempRvInfo.setPoolNameAndNo(poolNameAndNos[i]);
			tempRvInfo.setPoolNo4extend(tempRvInfo.getPoolNo());
			tempRvInfo.setRaidType(raidTypes[i]);
			tempRvInfo.setWwnn(wwnns[i]);
			if(rvNames[i].startsWith(STARTWITH_NV_RV0)){
				rv0Info = tempRvInfo;
			}else if(rvNames[i].startsWith(STARTWITH_NV_RV1)){
				rv1Info = tempRvInfo;
			}else if(rvNames[i].startsWith(STARTWITH_NV_RV2)){
				rv2Info = tempRvInfo;
			}
		}
		rvBeanList.add(rv0Info);
		rvBeanList.add(rv1Info);
		rvBeanList.add(rv2Info);
		return rvBeanList;
	}
	
	private String getErrMsg(HttpServletRequest request, DdrExtendPairBean rvInfo){
		MessageResources msgResource = (MessageResources) getResources(request);
		String msg = "";
		if(!rvInfo.getRaidType().startsWith(RAIDTYPE_IS_RAID6)){
			msg =
                msgResource.getMessage(
                    request.getLocale(),
                    MSG_EXTEND_RAIDTYPE_INVALID);
			NSActionUtil.setSessionAttribute(
	                request, NSActionUtil.SESSION_OPERATION_RESULT_MESSAGE, msg);
		}
		return msg;
	}
}
