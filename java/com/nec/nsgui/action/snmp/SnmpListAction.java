/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.nsgui.action.snmp;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.snmp.SnmpCmdHandler;
import com.nec.nsgui.model.entity.snmp.SnmpListBean;

/**
 *
 */
public class SnmpListAction extends SnmpAction{
    private static final String cvsid = "@(#) $Id: SnmpListAction.java,v 1.1 2005/08/21 04:43:20 zhangj Exp $";
            
    public ActionForward displayList(
            ActionMapping mapping,
            ActionForm form,
            final HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {
        clearSession(request);
        HashMap infoHash = SnmpCmdHandler.getSnmpList(false);
        HashMap errorHash = new HashMap();
        errorHash.put(ERRCODE_INFORECOVERY, new ExceptionProcessor(){
            public void processExcep(Object info)throws Exception{
                NSActionUtil.setNoFailedAlert(request);
                NSActionUtil.setNotDisplayDetail(request);
                for(int i = 0; i < 2; i ++ ){
                    SnmpListBean snmpInfoList = (SnmpListBean)((HashMap)info).get("snmpInfoList"+Integer.toString(i) );
                    NSActionUtil.setSessionAttribute( request,"contact"+snmpInfoList.getNodeNo(),snmpInfoList.getContact() );
                    NSActionUtil.setSessionAttribute( request,"location"+snmpInfoList.getNodeNo(),snmpInfoList.getLocation() );
                    NSActionUtil.setSessionAttribute( request,"communityList"+snmpInfoList.getNodeNo(), snmpInfoList.getCommunityList() );
                    NSActionUtil.setSessionAttribute( request,"userList"+snmpInfoList.getNodeNo(), snmpInfoList.getUserList() );
                }
            }
        });

		errorHash.put(ERRCODE_CONVERTFAILED, new ExceptionProcessor(){
			public void processExcep(Object info)throws Exception{
				SnmpListBean SnmpListBean = (SnmpListBean)((HashMap)info).get("snmpInfoList");
				request.setAttribute("contact",SnmpListBean.getContact());
				request.setAttribute("location",SnmpListBean.getLocation());
				request.setAttribute("communityList", SnmpListBean.getCommunityList());
				request.setAttribute("userList", SnmpListBean.getUserList());
				NSActionUtil.setNoFailedAlert(request);
				NSActionUtil.setNotDisplayDetail(request);
			}
		});        
        
		errorHash.put(ERRCODE_RECOVERYCONVERTFAILED, new ExceptionProcessor(){
			public void processExcep(Object info)throws Exception{
				NSActionUtil.setNoFailedAlert(request);
				NSActionUtil.setNotDisplayDetail(request);
				NSActionUtil.setSessionAttribute( request, SESSION_SNMP_RECOVERYCONVERTFAILED, "true" );
				for(int i = 0; i < 2; i ++ ){
					SnmpListBean snmpInfoList = (SnmpListBean)((HashMap)info).get("snmpInfoList"+Integer.toString(i) );
					NSActionUtil.setSessionAttribute( request,"contact"+snmpInfoList.getNodeNo(),snmpInfoList.getContact() );
					NSActionUtil.setSessionAttribute( request,"location"+snmpInfoList.getNodeNo(),snmpInfoList.getLocation() );
					NSActionUtil.setSessionAttribute( request,"communityList"+snmpInfoList.getNodeNo(), snmpInfoList.getCommunityList() );
					NSActionUtil.setSessionAttribute( request,"userList"+snmpInfoList.getNodeNo(), snmpInfoList.getUserList() );
				}
			}
		});
        
        errorHash.put(ERRCODE_COMMUNITY, new ExceptionProcessor(){
            public void processExcep(Object info)throws Exception{
                SnmpListBean SnmpListBean = (SnmpListBean)((HashMap)info).get("snmpInfoList");
                String errorComs = (String)((HashMap)info).get("errorComs");
                request.setAttribute("contact",SnmpListBean.getContact());
                request.setAttribute("location",SnmpListBean.getLocation());
                request.setAttribute("communityList", SnmpListBean.getCommunityList());
                request.setAttribute("userList", SnmpListBean.getUserList());
                //for exception of community difference of iptables and snmp.conf
                request.setAttribute("errorComs", errorComs);
                //for exception of community difference of iptables and snmp.conf
                NSActionUtil.setNoFailedAlert(request);
                NSActionUtil.setNotDisplayDetail(request);
            }
        });
        
        errorHash.put(ERRCODE_USER, new ExceptionProcessor(){
            public void processExcep(Object info)throws Exception{
                SnmpListBean SnmpListBean = (SnmpListBean)((HashMap)info).get("snmpInfoList");
                request.setAttribute("contact",SnmpListBean.getContact());
                request.setAttribute("location",SnmpListBean.getLocation());
                request.setAttribute("communityList", SnmpListBean.getCommunityList());
                request.setAttribute("userList", SnmpListBean.getUserList());
                NSActionUtil.setNoFailedAlert(request);
                NSActionUtil.setNotDisplayDetail(request);
            }
        });
        
        errorHash.put(ERRCODE_COMMUNITY_USER, new ExceptionProcessor(){
            public void processExcep(Object info)throws Exception{
                SnmpListBean SnmpListBean = (SnmpListBean)((HashMap)info).get("snmpInfoList");
                String errorComs = (String)((HashMap)info).get("errorComs");
                request.setAttribute("contact",SnmpListBean.getContact());
                request.setAttribute("location",SnmpListBean.getLocation());
                request.setAttribute("communityList", SnmpListBean.getCommunityList());
                request.setAttribute("userList", SnmpListBean.getUserList());
                //for exception of community difference of iptables and snmp.conf
                request.setAttribute("errorComs", errorComs);
                //for exception of community difference of iptables and snmp.conf
                NSActionUtil.setNoFailedAlert(request);
                NSActionUtil.setNotDisplayDetail(request);
            }
        });
        
		errorHash.put(ERRCODE_USER_IPTABLE, new ExceptionProcessor(){
			public void processExcep(Object info)throws Exception{
				SnmpListBean SnmpListBean = (SnmpListBean)((HashMap)info).get("snmpInfoList");
				request.setAttribute("contact",SnmpListBean.getContact());
				request.setAttribute("location",SnmpListBean.getLocation());
				request.setAttribute("communityList", SnmpListBean.getCommunityList());
				request.setAttribute("userList", SnmpListBean.getUserList());
				NSActionUtil.setNoFailedAlert(request);
				NSActionUtil.setNotDisplayDetail(request);
			}
		});
		
		errorHash.put(ERRCODE_COMMUNITY_IPTABLE, new ExceptionProcessor(){
			public void processExcep(Object info)throws Exception{
				SnmpListBean SnmpListBean = (SnmpListBean)((HashMap)info).get("snmpInfoList");
				request.setAttribute("contact",SnmpListBean.getContact());
				request.setAttribute("location",SnmpListBean.getLocation());
				request.setAttribute("communityList", SnmpListBean.getCommunityList());
				request.setAttribute("userList", SnmpListBean.getUserList());
				NSActionUtil.setNoFailedAlert(request);
				NSActionUtil.setNotDisplayDetail(request);
			}
		});
		
		errorHash.put(ERRCODE_COMMUNITY_USER_IPTABLE, new ExceptionProcessor(){
			public void processExcep(Object info)throws Exception{
				SnmpListBean SnmpListBean = (SnmpListBean)((HashMap)info).get("snmpInfoList");
				request.setAttribute("contact",SnmpListBean.getContact());
				request.setAttribute("location",SnmpListBean.getLocation());
				request.setAttribute("communityList", SnmpListBean.getCommunityList());
				request.setAttribute("userList", SnmpListBean.getUserList());
				NSActionUtil.setNoFailedAlert(request);
				NSActionUtil.setNotDisplayDetail(request);
			}
		});
        
        exceptionHandler(request,infoHash,errorHash,new NormalProcessor(){
            public void processNormal(Object info)throws Exception{
                SnmpListBean SnmpListBean = (SnmpListBean)((HashMap)info).get("snmpInfoList");
                request.setAttribute("contact",SnmpListBean.getContact());
                request.setAttribute("location",SnmpListBean.getLocation());
                request.setAttribute("communityList", SnmpListBean.getCommunityList());
                request.setAttribute("userList", SnmpListBean.getUserList());
            }
        });
		
        return mapping.findForward("displayList");   
    }
    
    public ActionForward apply(
            ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {
        String nodeNo = request.getParameter("nodeNo");
        SnmpCmdHandler.applySettingsofNode(nodeNo);
        NSActionUtil.setSuccess(request);
        return mapping.findForward("enterSnmpInfoList");  
    }
}
