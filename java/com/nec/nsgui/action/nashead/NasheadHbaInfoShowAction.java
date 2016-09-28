/*
 *      Copyright (c) 2004 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.nashead;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.nec.nsgui.action.nashead.NasheadActionConst;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.base.NSException;
import com.nec.nsgui.model.biz.nashead.NasheadHandler;

public class NasheadHbaInfoShowAction extends Action implements NasheadActionConst {
    private static final String cvsid = "@(#) $Id: NasheadHbaInfoShowAction.java,v 1.1 2004/11/12 03:03:49 jiangfx Exp $";
    
    public ActionForward execute(
    	ActionMapping mapping,
    	ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
        throws Exception{    	
        	
        	
        	Vector hbaInfoVector  = new Vector();   //element is Vector which element is NasheadPortInfoBean 
        	Vector exitCodeVector = new Vector();   //element is "0" or "1"
            NasheadHandler nasheadHandler = new NasheadHandler(); //declare a instance of NasheadHandler
        	//get HBA information on node0
        	Vector node0HbaInfoVector = new Vector();
        	try {
        		node0HbaInfoVector = nasheadHandler.getHbaInfo(0);
        		
        		exitCodeVector.add("0");	
        	} catch (NSException e) {
                if (e.getErrorCode().equals(CONSTANT_ERR_EXECUTE_INQPORT)) {
                    exitCodeVector.add("1");
                } else {
                    throw e;
                }
        	}
        	hbaInfoVector.add(node0HbaInfoVector); 
        	
        	//check if machine type is Cluster 
        	boolean isCluster = NSActionUtil.isCluster(request);
        	
        	if (isCluster) {
        		request.setAttribute("isCluster", "true");
        		
        		//get HBA information on node1
        		Vector node1HbaInfoVector = new Vector();
        		try {
        			node1HbaInfoVector = nasheadHandler.getHbaInfo(1);
        			exitCodeVector.add("0");	
        		} catch (NSException e) {
                    if (e.getErrorCode().equals(CONSTANT_ERR_EXECUTE_INQPORT)) {
                        exitCodeVector.add("1");
                    } else {
                        throw e;
                    }
        		}
        		hbaInfoVector.add(node1HbaInfoVector); 
        	} else {
        		request.setAttribute("isCluster", "false");
        	}
        	
        	request.setAttribute("hbaInfoVector", hbaInfoVector);
        	request.setAttribute("exitCodeVector", exitCodeVector);
        	
            return mapping.findForward("showHbaInfo");
        }
}