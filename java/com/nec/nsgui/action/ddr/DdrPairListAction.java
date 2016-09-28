/*
 *      Copyright (c) 2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.ddr;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.actions.DispatchAction;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.ddr.DdrHandler;
import com.nec.nsgui.model.entity.ddr.DdrPairInfoBean;

public class DdrPairListAction extends DispatchAction {
	private static final String cvsid = "@(#) $Id: DdrPairListAction.java,v 1.4 2008/04/29 05:42:28 pizb Exp $";
	
	public ActionForward display(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
	    try {
            String forword = "ddrPairInfoList4Nsview";
            if (!NSActionUtil.isNsview(request)) {
                if ( NSActionUtil.getSessionAttribute(request, DdrActionConst.SESSION_DDR_HAS_VOLSCAN ) == null ) {
                    DdrHandler.volScan();
                    request.getSession().setAttribute(DdrActionConst.SESSION_DDR_HAS_VOLSCAN, true);
                }
                forword = "ddrPairInfoList";
            }
            // get the node of current condition.
            int currentNodeNo = NSActionUtil.getCurrentNodeNo(request);
            
            List <DdrPairInfoBean> ddrPairInfoList = DdrHandler.getPairInfoList(currentNodeNo);
            request.setAttribute("ddrPairInfoList", ddrPairInfoList);
            
            // judge that whether there is any operation of sync volume.
            NSActionUtil.setSessionAttribute(request, DdrActionConst.SESSION_DDR_ASYNCVOL, 
                                             NSActionUtil.hasActiveBatchVolume(request) || NSActionUtil.hasAsyncVolume(request));
            // judge that whether there is any operation of sync pair.
            NSActionUtil.setSessionAttribute(request, DdrActionConst.SESSION_DDR_ASYNCPAIR, NSActionUtil.hasAsyncPair(request));
            // judge that whether there is any active operation of sync pair.
            NSActionUtil.setSessionAttribute(request, DdrActionConst.SESSION_DDR_ACTIVE_ASYNCPAIR, NSActionUtil.hasActiveAsyncPair(request));
            
            boolean hasAsyncPairAtCURNode = false;
            boolean hasAbnormalPairAtCURNode = false;
            boolean hasAsyncErrorAtCURNode = false;
            for (DdrPairInfoBean ddrPairInfo : ddrPairInfoList){			
                String status = ddrPairInfo.getStatus();
                // judge whether there is async pair.
                if ( !hasAsyncPairAtCURNode 
                        && ( status.endsWith("ing") 
                                || status.endsWith("fail"))){
                    hasAsyncPairAtCURNode = true;
                }
                
                // judge whether there is abnormal pair.
                if ( !hasAbnormalPairAtCURNode 
                        && DdrActionConst.PAIRINFO_STATUS_ABNORMALITYCOMPOSITION.equals(status) ){
                    hasAbnormalPairAtCURNode = true;
                }
                
                // judge whether there is async error.
                if ( hasAsyncPairAtCURNode && status.endsWith("fail") ){
                    hasAsyncErrorAtCURNode = true;
                    break;
                }
            }
            
            NSActionUtil.setSessionAttribute(request, DdrActionConst.SESSION_DDR_CUR_NODE_HAS_STATUS, hasAsyncPairAtCURNode || hasAbnormalPairAtCURNode);
            NSActionUtil.setSessionAttribute(request, DdrActionConst.SESSION_DDR_CUR_NODE_HAS_ERROR, hasAsyncErrorAtCURNode || hasAbnormalPairAtCURNode);
            NSActionUtil.setSessionAttribute(request, DdrActionConst.SESSION_DDR_CUR_NODE_NEED_CLEARBUTTON, hasAsyncErrorAtCURNode);
            NSActionUtil.setSessionAttribute(request, DdrActionConst.SESSION_DDR_CUR_NODE_ABNORMAL_COMPOSITION, hasAbnormalPairAtCURNode);
            
            return mapping.findForward(forword);
        }
        catch (Exception e) {
            NSActionUtil.setNoFailedAlert(request);
            throw e;
        }
	}

}
