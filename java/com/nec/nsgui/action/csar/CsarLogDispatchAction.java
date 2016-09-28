/*
 *      Copyright (c) 2008-2009 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.csar;

import java.util.Hashtable;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;
import org.apache.struts.actions.DispatchAction;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.base.ClusterUtil;
import com.nec.nsgui.model.biz.base.NSCmdResult;
import com.nec.nsgui.model.biz.base.NSException;
import com.nec.nsgui.model.biz.base.NSReporter;
import com.nec.nsgui.model.biz.csar.CsarHandler;

public class CsarLogDispatchAction extends DispatchAction {
    private static final String cvsid = "@(#) $Id: CsarLogDispatchAction.java,v 1.9 2009/02/11 02:35:39 wanghui Exp $";
    
    public ActionForward load(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        ((DynaActionForm)form).set("infoType", "summary");
        if(NSActionUtil.isSingleNode(request)){
        	((DynaActionForm)form).set("nodeCollect", "-1");
        }else{
        	String fipNodeNum = CsarHandler.getFIPNodeNum();  
            ((DynaActionForm)form).set("nodeCollect", fipNodeNum);            
        }
        return mapping.findForward("csarframe");
    }
    
    
    public ActionForward collectInfo(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {   
        DynaActionForm dynaForm = (DynaActionForm) form;
            
        String nodeCollect = (String)dynaForm.get("nodeCollect");    
        String infoType = (String)dynaForm.get("infoType");  
        
        if(NSActionUtil.isSingleNode(request)){            
            nodeCollect = "-1";
        }            
        NSCmdResult result = null;
        try{            
            if(nodeCollect.equals("both")){             	
                result = CsarHandler.collectOnBothNode(infoType);
            }else{                     	
                result = CsarHandler.collectOnOneNode(nodeCollect, infoType);
            }
            /*
             * result>>
             * errorcode:XXXX
             * http:XXXX
             * maininfo:XXXX
             * otherinfo:XXXX
             */            
            String errorCode = result.getStdout()[0].substring(10);//get errorcode             
            if (null != errorCode && !errorCode.trim().equals("")){             	
                dealError(errorCode, result, nodeCollect, request);
            }else{              	
                setHTTPDownloadFileName(result, request);
                NSActionUtil.setSessionAttribute(request,"csar_collect_finish","finished");//used to close heartbeat
            }            
        }catch(NSException e){
            /*errorCode:0x13900NHS
              N: 0, when collect both node information, and the fip is on node0
                 1, when collect both node information, and the fip is on node1
                 2, when collect one node information
              H: (0~d),when collect both node information, and the error occured on the node that fip is not on
              S: (0~a),when collect both node information, and the error occured on the node that fip is on
                 (0~9),when collect one node information
             */
            String errorCode = e.getErrorCode(); 
            if(null != errorCode && !errorCode.trim().equals("")){//expectable error
                //find whether error is timeout by judge "HS" of errorCode is "ff" 
                if(errorCode.substring(8).trim().equalsIgnoreCase("ff")){  // timeout occured            
                	String alertMessage = getResources(request).getMessage(
                            request.getLocale(),
                            "csar.error.timeout.alert");
                    request.getSession().setAttribute(NSActionConst.SESSION_OPERATION_RESULT_MESSAGE,
                                  alertMessage);
                    return mapping.findForward("csarframe");
                }else{//timeout didn't occur              	
                    throw e;
                }    
            }else{//unexpectable error
            	throw e;
            }        
        }
        return mapping.findForward("csardownload");
    }
    
    /**
     * Judge whether the error is csar error, 
     * if it is csar error, write the error information into GUI trace file.
     * When machine type is single node, error information writed into file as follows:
     * XXXXXX
     * When machine type is cluster and collect information on one node, 
     * error information writed into file as follows:
     * Node[0|1]:XXXXXX
     * When machine type is cluster and collect information on both nodes,
     * error information writed into file as follows:
     * Node[0|1]:XXXXXX
     * Node[1|0]:XXXXXX 
     * @param errorCode
     * @param result
     * @param nodeCollect
     */
    private void reportCsarError(String errorCode, NSCmdResult result, String nodeCollect){
        Hashtable mainErrorInfoHash = new Hashtable();
    	mainErrorInfoHash.put("0", CsarConst.TRACE_LOG_MESSAGE_MAINNODE_0);
        mainErrorInfoHash.put("1", CsarConst.TRACE_LOG_MESSAGE_MAINNODE_1);
        mainErrorInfoHash.put("3", CsarConst.TRACE_LOG_MESSAGE_MAINNODE_3);
        mainErrorInfoHash.put("4", CsarConst.TRACE_LOG_MESSAGE_MAINNODE_4);
        mainErrorInfoHash.put("5", CsarConst.TRACE_LOG_MESSAGE_MAINNODE_5);
        mainErrorInfoHash.put("6", CsarConst.TRACE_LOG_MESSAGE_MAINNODE_6);
        mainErrorInfoHash.put("7", CsarConst.TRACE_LOG_MESSAGE_MAINNODE_7);
        mainErrorInfoHash.put("8", CsarConst.TRACE_LOG_MESSAGE_MAINNODE_8);
        mainErrorInfoHash.put("9", CsarConst.TRACE_LOG_MESSAGE_MAINNODE_9);
        mainErrorInfoHash.put("a", CsarConst.TRACE_LOG_MESSAGE_MAINNODE_A);
        
        Hashtable otherErrorInfoHash = new Hashtable();
        otherErrorInfoHash.put("0", CsarConst.TRACE_LOG_MESSAGE_OTHERNODE_0);
        otherErrorInfoHash.put("1", CsarConst.TRACE_LOG_MESSAGE_OTHERNODE_1);
        otherErrorInfoHash.put("2", CsarConst.TRACE_LOG_MESSAGE_OTHERNODE_2);
        otherErrorInfoHash.put("4", CsarConst.TRACE_LOG_MESSAGE_OTHERNODE_4);
        otherErrorInfoHash.put("5", CsarConst.TRACE_LOG_MESSAGE_OTHERNODE_5);
        otherErrorInfoHash.put("6", CsarConst.TRACE_LOG_MESSAGE_OTHERNODE_6);
        otherErrorInfoHash.put("7", CsarConst.TRACE_LOG_MESSAGE_OTHERNODE_7);
        otherErrorInfoHash.put("8", CsarConst.TRACE_LOG_MESSAGE_OTHERNODE_8);
        otherErrorInfoHash.put("9", CsarConst.TRACE_LOG_MESSAGE_OTHERNODE_9);
        otherErrorInfoHash.put("a", CsarConst.TRACE_LOG_MESSAGE_OTHERNODE_A);
        otherErrorInfoHash.put("b", CsarConst.TRACE_LOG_MESSAGE_OTHERNODE_B);
        otherErrorInfoHash.put("c", CsarConst.TRACE_LOG_MESSAGE_OTHERNODE_C);
        otherErrorInfoHash.put("d", CsarConst.TRACE_LOG_MESSAGE_OTHERNODE_D);
    	
        String n = String.valueOf(errorCode.charAt(7)); //"N" of errorCode        
        String s = String.valueOf(errorCode.charAt(9)); //"S" of errorCode           
        StringBuffer info = new StringBuffer();        
        if(n.equals("2")){//collect one node information  
            info.append("Csar Error Code (1 node):"+errorCode+"\n");
            if(s.equals("3")){//csar error        		
                if(nodeCollect.equals("-1")){  //collect one node information on single node               
                    info.append(result.getStdout()[2].substring(9).trim()); //result[2]>>maininfo:xxxxx                    
                }else{ //collect one node information on cluster 
               	    info.append("Node" + nodeCollect + ":\n" +
               			 result.getStdout()[2].substring(9).trim()); //result[2]>>maininfo:xxxxx                     
                }
            }else{// add by liq ADD KNOWN ERROR INFO TO TRACE
                if(nodeCollect.equals("-1")){  //collect one node information on single node               
                    info.append((String)otherErrorInfoHash.get(s)); 
                }else{ //collect one node information on cluster 
               	    info.append("Node" + nodeCollect + ":\n" + (String)otherErrorInfoHash.get(s)); 
                }
            }            
        }else{// collect both node information    
            info.append("Csar Error Code (2 node):"+errorCode+"\n");
            if(s.equals("2")){//csar error on fip node               	
                info.append("Node" + n + ":\n" + result.getStdout()[2].substring(9).trim());                
            }else{
                info.append("Node" + n + ":\n" + (String)mainErrorInfoHash.get(s));                
            }
            info.append("\n");
            String h = String.valueOf(errorCode.charAt(8));            
            if(h.equals("3")){//csar error on the other node              	           
                info.append("Node" + (1-Integer.valueOf(n)) + ":\n" + 
                		result.getStdout()[3].substring(10).trim());                
            }else{
                if(h.equals("d")){//failed to get hostname of fip node,add this info to trace. 
                   info.append(CsarConst.TRACE_LOG_MESSAGE_MAINNODE_NOTICEFILE_FAIL);
                   info.append("\n");
                }
                info.append("Node" + (1-Integer.valueOf(n)) + ":\n" + (String)otherErrorInfoHash.get(h)); 
            }            
        }
        String i = info.toString();
        if(null != i && !i.trim().equals("")){        	
            NSReporter.getInstance().report(NSReporter.ERROR, i.replaceAll("\t", "\n"));            
        }        
    }
    
    private void setHTTPDownloadFileName(NSCmdResult result, HttpServletRequest request){     	
        String filename = result.getStdout()[1].substring(5);
        if(null != filename){
        	filename =filename.trim();        	
        }
        NSActionUtil.setSessionAttribute(request, "csar_filename", filename);          
    }
    
    private void dealError(String errorCode, NSCmdResult result, String nodeCollect, HttpServletRequest request)throws Exception{  
        /*errorCode:0x13900NHS
        N: 0, when collect both node information, and the fip is on node0
           1, when collect both node information, and the fip is on node1
           2, when collect one node information
        H: (0~a),when collect both node information, and the error occured on the node that fip is not on
        S: (0~8),when collect both node information, and the error occured on the node that fip is on
           (1~9),when collect one node information
       
         * result of command>>
         * errorcode:XXXX
         * http:XXXX
         * maininfo:XXXX
         * otherinfo:XXXX
         */    	
        reportCsarError(errorCode, result, nodeCollect);//report csar errors into trace log;        
        String mainInfo = result.getStdout()[2].substring(9);//result[2]>>maininfo:xxxxxx           
        if(null != mainInfo && !mainInfo.trim().equals("")){
            mainInfo = mainInfo.substring(mainInfo.indexOf("\t")+1);//remove first line info about command information
            request.getSession().setAttribute("csar_main_info", mainInfo.trim().replaceAll("\t", "<br>"));              
        }
        
        String nodeNum = errorCode.substring(7, 8);//"N" of errorCode
        if(!nodeNum.equals("2")){//collect both node information        	
            String otherInfo = result.getStdout()[3].substring(10);//result[3]>>otherinfo:xxxxx            
            if(null != otherInfo && !otherInfo.trim().equals("")){
                otherInfo = otherInfo.substring(otherInfo.indexOf("\t")+1);//remove first line info about command information
            	NSActionUtil.setSessionAttribute(request, "csar_other_info", otherInfo.trim().replaceAll("\t", "<br>"));             	
            }
            NSActionUtil.setSessionAttribute(request, "csar_main_node", nodeNum);            
            NSActionUtil.setSessionAttribute(request, "csar_other_node", String.valueOf(1-Integer.valueOf(nodeNum)));              
        }
        setHTTPDownloadFileName(result, request);
        NSActionUtil.setSessionAttribute(request, "csar_exception_occured", "yes");//for show "Collect Again" button
        NSException e = new NSException();
        e.setErrorCode(errorCode);         
        throw e;
    }
    
    public ActionForward popupHeartbeat(
            ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {

            NSActionUtil.setSessionAttribute(request,"csar_startTime", (String)((DynaActionForm)form).get("startTime"));
            return mapping.findForward("popupHeartbeat");
    }
}
