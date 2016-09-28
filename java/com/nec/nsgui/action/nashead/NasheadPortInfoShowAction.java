/*
 *      Copyright (c) 2004 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.nashead;

import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.nec.nsgui.action.nashead.NasheadActionConst;
import com.nec.nsgui.model.biz.base.NSException;
import com.nec.nsgui.model.biz.nashead.NasheadHandler;
import com.nec.nsgui.model.entity.nashead.NasheadLunInfoBean;

public class NasheadPortInfoShowAction extends Action implements NasheadActionConst {
    private static final String cvsid = "@(#) $Id: NasheadPortInfoShowAction.java,v 1.1 2004/11/12 03:04:06 jiangfx Exp $";
    
    public ActionForward execute(
    	ActionMapping mapping,
    	ActionForm form,
    	HttpServletRequest request,
    	HttpServletResponse response)
    	throws Exception{
          	
        	TreeMap portInfoTreeMap = new TreeMap();
            NasheadHandler nasheadHandler = new NasheadHandler(); //declare a instance of NasheadHandler
        	//get port connection information of specified node
        	try {
        		if (request.getParameter("nodeNo").equals("0")) {
        			portInfoTreeMap = nasheadHandler.getPortConnectionInfo(0);
        		} else {
        			portInfoTreeMap = nasheadHandler.getPortConnectionInfo(1);
        		}	
        	} catch (NSException e) {
                if (e.getErrorCode().equals(CONSTANT_ERR_EXECUTE_INQPORT)) {
                    request.setAttribute("exitCode", "1");
                    return mapping.findForward("showPortInfo");                
                } else {
                    throw e;
                }
        	}
        	
        	request.setAttribute("exitCode", "0");        	
       	
        	//set tableVector for jsp display
        	Iterator portNoIterator;
        	Vector   tableVector = new Vector();
        	
        	int maxLunNum = getMaxLunNum(portInfoTreeMap);
        	for (int row = 0; row < maxLunNum; row++) {
        		//create a rowVector with the lun information which has the same index of each port  
        		portNoIterator = portInfoTreeMap.keySet().iterator();
        		Vector rowVector = new Vector();
        		while (portNoIterator.hasNext()) {
        			Vector lunInfoVector = (Vector)portInfoTreeMap.get((String)portNoIterator.next());
        			
        			NasheadLunInfoBean lunInfo = new NasheadLunInfoBean();
        			if ((lunInfoVector != null) && (row < lunInfoVector.size())) {
        				lunInfo = (NasheadLunInfoBean)lunInfoVector.get(row);
        				
        			} else {
        				lunInfo.setStorage(CONSTANT_NULL_VALUE);
        				lunInfo.setLUN(CONSTANT_NULL_VALUE);
        				lunInfo.setState(CONSTANT_NULL_VALUE);
        			}
        			rowVector.add(lunInfo);
        		} //while 	
        		tableVector.add(rowVector);
        	} //for
        	
        	request.setAttribute("portNoSet", portInfoTreeMap.keySet());
        	request.setAttribute("tableVector", tableVector);
        	
        	return mapping.findForward("showPortInfo");
	}
	
	// count max connected LUN num on each port of HBA card
    private int getMaxLunNum(TreeMap portInfoTreeMap) {
     	int maxLunNum = 0;
        	
       	if ((portInfoTreeMap == null) || (portInfoTreeMap.size() == 0)) {
       		return maxLunNum;
       	}
        
        Iterator portNoIterator = portInfoTreeMap.keySet().iterator();
       	while (portNoIterator.hasNext()) {
       		Vector lunInfoVector = (Vector)portInfoTreeMap.get((String)portNoIterator.next());
        		
       		if (lunInfoVector == null) {
       			continue;
       		}
        		
       		int tmp_max = lunInfoVector.size();
       		if (tmp_max > maxLunNum) {
       			maxLunNum = tmp_max;
       		}
       	}
        	
       	return maxLunNum;
    }	
}