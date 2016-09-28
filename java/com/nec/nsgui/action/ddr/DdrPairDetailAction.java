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
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;
import org.apache.struts.util.MessageResources;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.action.ddr.DdrActionConst;
import com.nec.nsgui.action.ddr.ScheduleUtil;
import com.nec.nsgui.action.volume.VolumeDetailAction;
import com.nec.nsgui.action.volume.VolumeListAction;
import com.nec.nsgui.model.biz.base.NSException;
import com.nec.nsgui.model.biz.ddr.DdrHandler;
import com.nec.nsgui.model.entity.ddr.DdrPairInfoBean;
import com.nec.nsgui.model.entity.ddr.DdrRVDetailBean;
import com.nec.nsgui.model.entity.ddr.DdrVolInfoBean;

public class DdrPairDetailAction extends Action implements DdrActionConst {
    public static final String cvsid =
        "@(#) $Id: DdrPairDetailAction.java,v 1.2 2008/04/24 13:42:06 lil Exp $";

    public ActionForward execute(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response) throws Exception {

        try{
            DynaActionForm dynaForm = (DynaActionForm) form;
            DdrPairInfoBean pairInfoBean = (DdrPairInfoBean) dynaForm.get("ddrPairInfo");
            String mvName = pairInfoBean.getMvName();
            String rvName = pairInfoBean.getRvName();
            String usage = pairInfoBean.getUsage();
            String rvLdNameStr = pairInfoBean.getRvLdNameList();
            String asyncStatus = pairInfoBean.getStatus();
            String mvResCode = pairInfoBean.getMvResultCode();
            String rvResCode = pairInfoBean.getRvResultCode();
            String schedResCode = pairInfoBean.getSchedResultCode();
    
            // get pair detail
            int nodeNo = NSActionUtil.getCurrentNodeNo(request);
            List pairDetailList = 
                DdrHandler.getPairDetail(
                        mvName, rvName, asyncStatus, rvLdNameStr, nodeNo);
            DdrVolInfoBean mvDetailBean = (DdrVolInfoBean) pairDetailList.get(0);
            DdrRVDetailBean rvDetailBean = (DdrRVDetailBean) pairDetailList.get(1);
            
            // set property from DdrPairInfoBean
            mvDetailBean.setStatus(asyncStatus);
            mvDetailBean.setMvResultCode(mvResCode);
            mvDetailBean.setRvResultCode(rvResCode);
            mvDetailBean.setSchedResultCode(schedResCode);
            rvDetailBean.setCopyControlState(pairInfoBean.getCopyControlState());
            rvDetailBean.setSyncState(pairInfoBean.getSyncState());
            rvDetailBean.setSyncStartTime(pairInfoBean.getSyncStartTime());
            rvDetailBean.setProgressRate(pairInfoBean.getProgressRate());
    
            // edit for view
            String rvDetailHtmlCode = editView(mvDetailBean, rvDetailBean, request);
    
            // schedule
            if (USAGE_GENERATION.equals(usage)) {
                // edit schedule for view & encode
                String scheduleInfo = pairInfoBean.getSchedule();
                if (scheduleInfo != null 
                        && !("").equals(scheduleInfo)) {
                    String[] schedInfoArrs = scheduleInfo.split("#");
                    StringBuffer schedInfo4Show = new StringBuffer();
                    for (String schedInfoStr:schedInfoArrs) {
                        schedInfoStr = ScheduleUtil.getSchedule(schedInfoStr, request);
                        if (schedInfoStr != null 
                                && !("").equals(schedInfoStr)) {
                            schedInfo4Show.append("<br>");
                            schedInfo4Show.append(schedInfoStr);
                        }
                    }
                    // set session:schedule
                    if (schedInfo4Show.length() > 0) { 
                        mvDetailBean.setSchedule(schedInfo4Show.toString().substring(4));
                    }
                }
            }
    
            // set session:mvBean,rvHtmlCode,usage
            NSActionUtil.setSessionAttribute(request, SESSION_DDR_DETAIL_RVHTMLCODE, rvDetailHtmlCode);
            NSActionUtil.setSessionAttribute(request, SESSION_DDR_DETAIL_MVBEAN, mvDetailBean);
            NSActionUtil.setSessionAttribute(request, SESSION_DDR_DETAIL_TYPE, usage);
        }catch(NSException e){
            // iSAdisklis error during creating or extending
            VolumeListAction.setISAdiskListErrorCode(e, "84", request);
            throw e;    
        }
        
        return mapping.findForward("showDetail");
    }

    private String editView(
        DdrVolInfoBean mvDetail, 
        DdrRVDetailBean rvDetail,
        HttpServletRequest request) throws Exception {

        // edit mv detail for view
        String mvName = mvDetail.getName();
        String mvCapacity = mvDetail.getCapacity();
        String mvPool = mvDetail.getPoolNameAndNoForDetail();
        mvDetail.setName(mvName.replaceFirst("NV_LVM_", ""));
        mvDetail.setCapacity(VolumeDetailAction.getCapacity4Show(mvCapacity));
        mvDetail.setPoolNameAndNo(VolumeDetailAction.compactAndSort(mvPool));

        // edit rv detail for view
        String[] valueArrs = {
                rvDetail.getName(), 
                rvDetail.getNode(), 
                rvDetail.getPoolNameAndNoForDetail(),
                rvDetail.getRaidType(),
                rvDetail.getSyncState(),
                rvDetail.getCopyControlState(),
                rvDetail.getProgressRate(),
                rvDetail.getSyncStartTime()};
        String[] propertyNameArrs = {
                "name", 
                "group", 
                "poolNameAndNo", 
                "raidType", 
                "syncState", 
                "copyControlState", 
                "progressRate",
                "syncStartTime"};
        String[] thKeyArrs = {
                PAIR_DETAIL_TH_RVNAME,
                PAIR_DETAIL_TH_NODE,
                PAIR_DETAIL_TH_POOLNAMENO,
                PAIR_DETAIL_TH_RAIDTYPE,
                PAIR_DETAIL_TH_SYNCSTATE,
                PAIR_DETAIL_TH_COPYCTRLSTATE,
                PAIR_DETAIL_TH_PROCESS,
                PAIR_DETAIL_TH_SYNCSTARTTIME};
        StringBuffer sbTRs = new StringBuffer();
        for (int i = 0; i < propertyNameArrs.length; i++) {
            sbTRs.append(
                    editTR(propertyNameArrs[i], valueArrs[i], thKeyArrs[i], request));
        }

        // edit async info
        String asyncStatus = mvDetail.getStatus();
        if (!INFO_NODATA.equals(asyncStatus)) {
            // edit mv async info
            editMvAsyncInfo(mvDetail, request);
            
            // edit rv async info
            sbTRs.append(editRvAsyncInfo(mvDetail,request));
            
            // eidt schedule async info
            editSchedAsyncInfo(mvDetail, request);
        }

        return sbTRs.toString();
        
    }

    /**
     * editMvAsyncInfo: edit mv async info
     *
     */
    private void editMvAsyncInfo(
        DdrVolInfoBean mvDetail,
        HttpServletRequest request) throws Exception {
        
        // get message resources
        MessageResources resources = getResources(request);
        Locale locale = request.getLocale();

        String asyncStatus = mvDetail.getStatus();
        String mvResCode = mvDetail.getMvResultCode();        
        if ("extendmvfail".equals(asyncStatus)) {
            // mv extend fail
            mvDetail.setMvStatusMsg(
                    resources.getMessage(locale, 
                            PAIR_DETAIL_MSGKEY_PREFIX_ASYNC_STATUS + asyncStatus));
            mvDetail.setMvErrMsg(
                    getMvErrMsgByErrCode(mvResCode, asyncStatus, request));                
        } else if ("extending".equals(asyncStatus)) {
            // extending
            if (DDR_OPERATING_CODE.equals(mvResCode)) {
                // mv extending
                mvDetail.setMvStatusMsg(
                        resources.getMessage(locale, 
                                PAIR_DETAIL_MSGKEY_PREFIX_ASYNC_STATUS + asyncStatus));
            }
        }
    }
    
    /**
     * 
     *
     */
    private StringBuffer editRvAsyncInfo(
        DdrVolInfoBean mvDetail,
        HttpServletRequest request) throws Exception {

        String asyncStatus = mvDetail.getStatus();
        String rvResCode = mvDetail.getRvResultCode();
        StringBuffer sbTRs = new StringBuffer();
        
        // create or extend successful
        if (rvResCode.matches("^0x137fffff(#0x137fffff){0,2}$")) {
            return sbTRs;
        }

        // get message resources
        MessageResources resources = getResources(request);
        Locale locale = request.getLocale();

        // th
        String thMsgErrCode = 
            resources.getMessage(locale, PAIR_DETAIL_TH_ERRORCODE);
        String thMsgErrMsg = 
            resources.getMessage(locale, PAIR_DETAIL_TH_ERRORMSG);
        String thMsgStatus = 
            resources.getMessage(locale, PAIR_DETAIL_TH_STATUS);
        // td
        String[] rvResCodeArrs = rvResCode.split(SEPARATOR_NUMBERSIGN);
        StringBuffer errCodeHtmlCode = new StringBuffer();
        StringBuffer errMsgHtmlCode = new StringBuffer();
        StringBuffer statusHtmlCode = new StringBuffer();
        for (String rvResCodeTmp:rvResCodeArrs) {
            if (INFO_NODATA.equals(rvResCodeTmp) 
                    || "".equals(rvResCodeTmp) 
                    || DDR_OPERATED_CODE.equals(rvResCodeTmp)) {
                // rvResCodeTmp = '--' or '' or '0x137fffff'
                statusHtmlCode.append("<td>&nbsp;</td>");
                if ("creating".equals(asyncStatus) 
                        || "extending".equals(asyncStatus)) {
                    continue;
                }
                errCodeHtmlCode.append("<td>&nbsp;</td>");
                errMsgHtmlCode.append("<td class=\"wrapTD\">&nbsp;</td>");
            } else if (DDR_OPERATING_CODE.equals(rvResCodeTmp)) {
                // creating or extending
                statusHtmlCode.append("<td>" + 
                        resources.getMessage(locale, 
                                PAIR_DETAIL_MSGKEY_PREFIX_ASYNC_STATUS + asyncStatus) + "</td>");
            } else if (DDR_EXCEP_ABNORMAL_COMPOSITION.equals(rvResCodeTmp)) {
                // abnormal composition
                errCodeHtmlCode.append("<td>" + rvResCodeTmp + "</td>");
                statusHtmlCode.append("<td>" + 
                        resources.getMessage(locale, 
                                PAIR_DETAIL_MSGKEY_PREFIX_ASYNC_STATUS + PAIRINFO_STATUS_ABNORMALITYCOMPOSITION) + "</td>");
                errMsgHtmlCode.append("<td class=\"wrapTD\">" + 
                        getMsgByErrCode(
                                DDR_EXCEP_ABNORMAL_COMPOSITION, 
                                PAIRINFO_STATUS_ABNORMALITYCOMPOSITION, request) + "</td>");
            } else {
                // other error code
                errCodeHtmlCode.append("<td>" + rvResCodeTmp + "</td>");
                statusHtmlCode.append("<td>" + 
                        resources.getMessage(
                                locale, 
                                PAIR_DETAIL_MSGKEY_PREFIX_ASYNC_STATUS + asyncStatus) + "</td>");
                errMsgHtmlCode.append("<td class=\"wrapTD\">" + 
                        getMsgByErrCode(rvResCodeTmp, asyncStatus, request) + "</td>");
            }
        }
        sbTRs.append("<tr>");                
        sbTRs.append("<th>");
        sbTRs.append(thMsgStatus);
        sbTRs.append("</th>");
        sbTRs.append(statusHtmlCode);
        sbTRs.append("</tr>");
        if (errCodeHtmlCode.length() > 0) {
            sbTRs.append("<tr>");                
            sbTRs.append("<th>");
            sbTRs.append(thMsgErrCode);
            sbTRs.append("</th>");
            sbTRs.append(errCodeHtmlCode);
            sbTRs.append("</tr>");
        }
        if (errMsgHtmlCode.length() > 0) {
            sbTRs.append("<tr>");                
            sbTRs.append("<th>");
            sbTRs.append(thMsgErrMsg);
            sbTRs.append("</th>");
            sbTRs.append(errMsgHtmlCode);
            sbTRs.append("</tr>");
        }
        return sbTRs;
    }
    
    /**
     * 
     *
     */
    private void editSchedAsyncInfo(
        DdrVolInfoBean mvDetail,
        HttpServletRequest request) throws Exception {

        // get message resources
        MessageResources resources = getResources(request);
        Locale locale = request.getLocale();

        String asyncStatus = mvDetail.getStatus();
        String schedResCode = mvDetail.getSchedResultCode();
        if ("createschedfail".equals(asyncStatus) || "createfail".equals(asyncStatus)) {
            // set schedule fail
            mvDetail.setSchedStatusMsg(
                    resources.getMessage(locale, 
                            PAIR_DETAIL_MSGKEY_PREFIX_ASYNC_STATUS + "createschedfail"));
            mvDetail.setSchedErrMsg(
                    getMsgByErrCode(schedResCode, "createschedfail", request));
        } else if ("creating".equals(asyncStatus)) {
            // during creating
            if (DDR_OPERATING_CODE.equals(schedResCode)) {
                // schedule creating
                mvDetail.setSchedStatusMsg(
                        resources.getMessage(locale, "pair.detail.status.schedcreating"));
            }
        }
    }
    
    private String editTR(
        String name, 
        String value, 
        String thMsgKey, 
        HttpServletRequest request) throws Exception {

        // get message resources
        MessageResources resources = getResources(request);
        Locale locale = request.getLocale();

        StringBuffer sbTR = new StringBuffer();
        sbTR.append("<tr>");

        // append th
        String thMsg = resources.getMessage(locale, thMsgKey);
        sbTR.append("<th>" + thMsg + "</th>");

        // edit td of property
        String[] valueArrs = value.split(SEPARATOR_NUMBERSIGN);
        for (String tmpValue:valueArrs) {
            // append td
            if ("group".equals(name)) {
                tmpValue = resources.getMessage(locale, PAIR_DETAIL_TH_NODE_TEXT) + tmpValue;
            } else if ("poolNameAndNo".equals(name)) {
                // sort & add <br>
                tmpValue = VolumeDetailAction.compactAndSort(tmpValue);
                String[] poolArrs = tmpValue.split("<br>");
                String divHeight = "auto";
                if (poolArrs != null && poolArrs.length >= 3) {
                    divHeight = "54px";
                }
                tmpValue = "<DIV style=\"overflow:auto;width:auto;height:" + divHeight + "\">" + tmpValue + "</DIV>";
            } else if ("syncState".equals(name)) {
                if (!INFO_NODATA.equals(tmpValue) && !"".equals(tmpValue)) {
                    tmpValue = resources.getMessage(locale, MSGKEY_PREFIX_SYNCSTATE + tmpValue);
                }
            } else if ("copyControlState".equals(name)) {
                if (!INFO_NODATA.equals(tmpValue) && !"".equals(tmpValue)) {
                    tmpValue = tmpValue.replaceAll(" ", "");
                    tmpValue = resources.getMessage(locale, MSGKEY_PREFIX_COPYCONTROLSTATE + tmpValue);
                }
            } else if ("syncStartTime".equals(name)) {
                if (!INFO_NODATA.equals(tmpValue) && !"".equals(tmpValue)) {
                    tmpValue = NSActionUtil.getLocalDateTimeStr(tmpValue, "/", ":", " ", request);
                }                
            } else if ("progressRate".equals(name)) {
                if (!INFO_NODATA.equals(tmpValue) && !"".equals(tmpValue)) {
                    tmpValue += "%";
                }
            }
            if (tmpValue == null || "".equals(tmpValue)) {
                sbTR.append("<td>&nbsp;</td>");
            } else {
                sbTR.append("<td>" + tmpValue + "</td>");
            }
        }

        sbTR.append("</tr>");
        return sbTR.toString();
    }
    
    private String getMsgByErrCode(
        String errCode, 
        String asyncStatus,
        HttpServletRequest request) throws Exception {

        // get message resources
        MessageResources resources = getResources(request);
        Locale locale = request.getLocale();

        String msg = "";
        String unexpectMsg = resources.getMessage(locale, COMMON_MSGKEY_UNKNOWN);
        if ("createschedfail".equals(asyncStatus)) {
            msg = resources.getMessage(
                    locale, PAIR_DETAIL_MSGKEY_PREFIX_ASYNC_ERR_SCHEDULE + errCode);
        } else {
            msg = resources.getMessage(
                    locale, PAIR_DETAIL_MSGKEY_PREFIX_ASYNC_ERR + errCode);
        }
        if (null == msg) {
            return unexpectMsg;
        }
        // add how to deal if nsadmin
        if (!NSActionUtil.isNsview(request)) {
            msg += "<br>";
            // "0x137f0005" or "0x13700031" or "0x137f0113"
            if (PAIR_DETAIL_ERR_ABNSTOP.equals(errCode) 
                    || "0x13700031".equals(errCode)
                    || "0x137f0113".equals(errCode)) {
                // deal is different from others
                msg += resources.getMessage(
                        locale, PAIR_DETAIL_MSGKEY_PREFIX_ASYNC_ERR_DEAL + errCode);
                return msg;
            }
            if ("extendfail".equals(asyncStatus) || "extendmvfail".equals(asyncStatus)) {
                if (DDR_OPERATE_STOP_CODE.equals(errCode)) {
                    msg += resources.getMessage(
                            locale, PAIR_DETAIL_MSGKEY_PREFIX_ASYNC_ERR_DEAL + errCode);
                } else {
                    msg += resources.getMessage(
                            locale, PAIR_DETAIL_MSGKEY_ASYNC_ERR_DEAL_EXTEND);
                }
            } else if ("createfail".equals(asyncStatus)) {
                if (DDR_OPERATE_STOP_CODE.equals(errCode)) {
                    msg += resources.getMessage(
                            locale, PAIR_DETAIL_MSGKEY_PREFIX_ASYNC_ERR_DEAL + errCode);
                } else {
                    msg += resources.getMessage(
                            locale, PAIR_DETAIL_MSGKEY_ASYNC_ERR_DEAL_CREATE);
                }
            } else if ("createschedfail".equals(asyncStatus)) {
                if (DDR_OPERATE_STOP_CODE.equals(errCode)) {
                    msg += resources.getMessage(
                            locale, PAIR_DETAIL_MSGKEY_ASYNC_ERR_DEAL_CREATE);
                } else {
                    msg += resources.getMessage(
                            locale, PAIR_DETAIL_MSGKEY_ASYNC_ERR_DEAL_SCHEDULE);
                }
            } else if (PAIRINFO_STATUS_ABNORMALITYCOMPOSITION.equals(asyncStatus)) {
                msg += resources.getMessage(
                        locale, PAIR_DETAIL_MSGKEY_PREFIX_ASYNC_ERR_DEAL + errCode);                
            }
        }
        return msg;
    }
    
    private String getMvErrMsgByErrCode(
        String errCode, 
        String asyncStatus, 
        HttpServletRequest request) throws Exception {

        // get message resources
        MessageResources volumeResources = getResources(request, "volumeResource");
        MessageResources ddrResources = getResources(request);
        Locale locale = request.getLocale();

        String msg = "";
        String unexpectMsg = ddrResources.getMessage(locale, COMMON_MSGKEY_UNKNOWN);
        if ("0x10800033".equals(errCode) || "0x1080003a".equals(errCode)) {
            // use volume nsview message
            msg = volumeResources.getMessage(
                    locale, VOLUME_MSGKEY_PREFIX_ASYNC_ERR_NSVIEW + errCode);
        } else if (PAIR_DETAIL_ERR_ABNSTOP.equals(errCode)) {
            // abnormal stop
            msg = ddrResources.getMessage(
                    locale, PAIR_DETAIL_MSGKEY_PREFIX_ASYNC_ERR + errCode);
        } else {
            // use volume message
            msg = volumeResources.getMessage(
                    locale, VOLUME_MSGKEY_PREFIX_ASYNC_ERR + errCode);
        }
        if (msg == null) {
            return unexpectMsg;
        }
        //  add how to deal if nsadmin
        if (!NSActionUtil.isNsview(request)) {
            msg += "<br>" ;
            if ("0x10800033".equals(errCode) 
                    || "0x1080003a".equals(errCode) 
                    || PAIR_DETAIL_ERR_ABNSTOP.equals(errCode)) {
                // deal is different from others
                msg += ddrResources.getMessage(
                        locale, PAIR_DETAIL_MSGKEY_PREFIX_ASYNC_ERR_DEAL + errCode);
            } else {
                msg += ddrResources.getMessage(
                        locale, PAIR_DETAIL_MSGKEY_ASYNC_ERR_DEAL_EXTEND);
            }
        }

        return msg;
    }
}