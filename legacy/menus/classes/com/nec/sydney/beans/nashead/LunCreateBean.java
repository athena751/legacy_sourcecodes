/*
 *      Copyright (c) 2001-2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package    com.nec.sydney.beans.nashead;

import com.nec.nsgui.action.base.NSActionConst;
import     com.nec.sydney.framework.*;
import     com.nec.sydney.atom.admin.base.*;
import     com.nec.sydney.beans.base.*;
import     com.nec.sydney.atom.admin.nashead.*;
import java.util.*;


public class LunCreateBean extends TemplateBean implements NasHeadConstants,NasConstants, NasSession{

    private static final String     cvsid = "@(#) $Id: LunCreateBean.java,v 1.3 2005/10/24 01:03:32 liq Exp $";
    private Vector lunsVec ;
    private boolean success = false;
    
    
    public void onDisplay() throws Exception {
        //allInfo's information: first is available's number
        try {
            Vector allInfo = NasHeadSOAPClient.getUnlinkedLunList(target);
            if(allInfo.size()>1){
                request.setAttribute("nashead_availlun", allInfo.get(0));
                allInfo.remove(0);
                lunsVec = allInfo;
            }else{
                lunsVec = new Vector();
            }
            //NasHeadSOAPClient.getUnlinkedLunList() is success. 
            success = true;
        }catch(NSException e){
            if (e.getErrorCode() == CONSTANT_GETDDMAP_FAILED) {
                this.success = false;
                return;
            } else {
                throw e;
            }
        }
    }
    
    public void onCreateLun () throws Exception{
        session.setAttribute(MP_SESSION_END_WAIT, "");
        String[] lunInfo =  request.getParameterValues("lun");
        String src = request.getParameter("src");
        //0 means init, 1 means link
        String opType = src.equals("link")?"1":"0";
        
        StringBuffer luns = new StringBuffer();
        for(int i = 0; i<lunInfo.length; i++){
            luns.append(lunInfo[i]+" ");
        }
        Vector resultInfo = NasHeadSOAPClient.setLunLink(target, 
                                         luns.toString().trim(), 
                                         opType);
        //get the result message
        String sucessTip = opType.equals("0")?"nas_nashead/luninit/init_complete":"nas_nashead/luninit/link_complete";
        String failedTip = opType.equals("0")?"nas_nashead/luninit/init_failed":"nas_nashead/luninit/link_failed";
        //resultInfo's first is success created LUN count.
        String resultMsg = NSMessageDriver.getInstance().getMessage(session, "common/alert/done")
                            + "\\r\\n"
                            + NSMessageDriver.getInstance().getMessage(session, sucessTip) 
                            + resultInfo.get(0).toString()
                            + "\\r\\n";
        String errorInfo = "";
        success = true;
        //when the sesultInfo's size == 1 means all lun are created successfully
        if (resultInfo.size() > 1){
            errorInfo = NSMessageDriver.getInstance().getMessage(session, failedTip)
                            + "\\r\\n";
            success = false;
        }
        //after the 1st element, the rest is the format as following:
        //resultInfo[1]: storageName1 
        //resultInfo[2]: 00h,01h,02h
        //resultInfo[3]: storageName2
        //resultInfo[4]: 00h,02h,03h
        for(int i = 1; i< resultInfo.size(); i=i+2){
            String[] errorLuns = resultInfo.get(i+1).toString().trim().split(",");
            String errorLunInfo = "";
            //when lun count exceed 16, display 16 luns in per line.
            for(int j=0; j< errorLuns.length; j++){
                //conver the decimal to the hex
                String lun = errorLuns[j];
                lun = Integer.toHexString(Integer.parseInt(lun));
                lun = lun.length() == 1?"0"+lun:lun;
                lun = lun + "h";
                errorLunInfo = errorLunInfo + lun + ",";
                if(j != 0 && j%16 == 0){
                    errorLunInfo = errorLunInfo + lun + "\\r\\n";
                }
            }
            //when end char is "\\r\\n", delete it
            errorLunInfo = errorLunInfo.trim();
            //when end char is ",", delete it.
            errorLunInfo = errorLunInfo.endsWith(",")
                            ?errorLunInfo.substring(0, errorLunInfo.length()-1)
                            :errorLunInfo;

            errorInfo = errorInfo 
                        + NSMessageDriver.getInstance().getMessage(session, "nas_nashead/storage/storagename") 
                        + ":" + resultInfo.get(i).toString() + "\\r\\n"
                        + "    " 
                        + NSMessageDriver.getInstance().getMessage(session, "nas_nashead/gateway/th_lun")
                        + ":" + errorLunInfo + "\\r\\n";
        }
        resultMsg = resultMsg + errorInfo;
        if (request.getParameter("nextURL") == null){
            super.setMsg(resultMsg);// for nas head component in old framework.
        }else{
            session.setAttribute(NSActionConst.SESSION_OPERATION_RESULT_MESSAGE
                ,resultMsg);// for volume add and extend in struts framework. 
        }
        session.setAttribute(MP_SESSION_END_WAIT, MKFS_FINISHED);
        
        String nextURL = "../nas/nashead/ldlist.jsp";//success, go to ldlist.jsp
        if (!success){
            //error go to luncreat.jsp
            nextURL = "../nas/nashead/luncreate.jsp?src="+src;
        }
        //when the volume module, In ACTION frame ,go to volume's page.
        if (request.getParameter("nextURL") != null){
            nextURL = request.getParameter("nextURL")+"?src="+src;
        }else{
        	String target = request.getParameter("target");
        	if((target != null) && !target.equals("")){
        	    if(!success){
        	        //nextURL = luncreate.jsp
        	        nextURL = nextURL + "&target=" + target;
        	    }else{
        	        //nextURL = ldlist.jsp
                    nextURL = nextURL + "?target=" + target;
                }
            }
        }
        
        response.sendRedirect(response.encodeRedirectURL(nextURL));
    }
    
    public Vector getLunList(){
        return lunsVec;
    }
    
    public boolean isSuccess(){
        return success;
    }
}
