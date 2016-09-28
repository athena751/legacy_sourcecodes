/*
 *      Copyright (c) 2004-2006 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.cifs;

import java.util.HashMap;
import java.util.List;
import java.util.ArrayList;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.beanutils.PropertyUtils;
import org.apache.struts.util.MessageResources;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.cifs.CifsCmdHandler;
import com.nec.nsgui.action.framework.ClientInfoBean;
import com.nec.nsgui.action.framework.SessionManager;
import com.nec.nsgui.action.base.NSActionConst;

/**
 *
 */
public class CommonUtil {
    private static final String cvsid =
        "@(#) $Id: CommonUtil.java,v 1.5 2006/07/05 05:46:02 yangxj Exp $";


    /**
    * set the corresponding message for the specified Property of all the object in List
    * @param objList - the list of object
    * @param protertyName - the target Property
    * @param value_msgKey - the value and the corresponding message's key in the Resource file
    * @param msgResources - MessageResources
    * @param request - http servlet request
    */
    static public void setMsgInObj(List objList, String protertyName,
        HashMap value_msgKey, MessageResources msgResources, HttpServletRequest request)throws Exception {
        int objNumbers = objList.size();
        Object object;
        Object objValue;
        for(int i = 0; i < objNumbers; i++){
            object = objList.get(i);
            try {
                objValue = PropertyUtils.getProperty(object, protertyName);
            }catch (Exception e){
                throw e;
            }
            if(value_msgKey.containsKey(objValue)){
                //need change the value to the corresponding message
                PropertyUtils.setProperty(object, protertyName, 
                        msgResources.getMessage(request.getLocale(), (String)value_msgKey.get(objValue.toString()))
                    );
            }
        }
    }
    
   static public void setMsgInObj(Object obj, String protertyName,
 		HashMap value_msgKey, MessageResources msgResources, HttpServletRequest request)throws Exception {
			
			List obList = new ArrayList();
			obList.add(obj);
			setMsgInObj(obList,protertyName,value_msgKey,msgResources,request);
   }
   
   static public void setNoContentMsgInObj(Object obj, String protertyName,
		   MessageResources msgResources, HttpServletRequest request)throws Exception {
			Object objValue;
			try {
				objValue = PropertyUtils.getProperty(obj, protertyName);
			}catch (Exception e){
					  throw e;
			}
			if(objValue.toString().equals("")){
				PropertyUtils.setProperty(obj, protertyName, 
						msgResources.getMessage(request.getLocale(), "cifs.shareDetial.nocontent"));
                
			}
   }
   
   public static String getSysDate (int nodeNo, boolean bForce, HttpServletRequest request) throws Exception {
        String dates[] = CifsCmdHandler.getSysDate(nodeNo, false);
        String dates2[] = NSActionUtil.getLocalDate_Time(dates[0], dates[1], request);
        String date = dates2[0] + " " + dates2[1];
        return date;
   }
   
       public static String getCurSessionsID(HttpServletRequest request)throws Exception{
    	SessionManager sm = SessionManager.getInstance();
    	Vector admvec = (Vector)(sm.getActiveSessionsInfo(request).get(NSActionConst.NSUSER_NSADMIN));
    	Vector viwvec = (Vector)(sm.getActiveSessionsInfo(request).get(NSActionConst.NSUSER_NSVIEW));
    	String sessionsId = new String();
    	sessionsId = "";
    	if (admvec != null){
    	    for(int i = 0; i<admvec.size(); i++){
    		    ClientInfoBean cib = (ClientInfoBean)admvec.get(i);
    		    String sid = cib.getSessionId();
    		    sessionsId = sessionsId + sid + " ";
    	    }
    	}
    	if (viwvec != null){
    	    for(int i = 0; i<viwvec.size(); i++){
    		    ClientInfoBean cib = (ClientInfoBean)viwvec.get(i);
    		    String sid = cib.getSessionId();
    		    sessionsId = sessionsId + sid + " ";
    	    }
    	}
    	return sessionsId;
    }
}
