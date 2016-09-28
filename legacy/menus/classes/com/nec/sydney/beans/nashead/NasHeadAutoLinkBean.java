/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.nashead;


import com.nec.nsgui.action.base.NSActionConst;
import com.nec.sydney.framework.*;
import com.nec.sydney.atom.admin.nashead.NasHeadConstants;
import com.nec.sydney.atom.admin.base.NasConstants;
import com.nec.sydney.atom.admin.base.NasSession;
import com.nec.sydney.beans.base.AbstractJSPBean;


public class NasHeadAutoLinkBean extends AbstractJSPBean implements NasConstants, NasSession, NasHeadConstants {

    private static final String     cvsid = "@(#) NasHeadAutoLinkBean.java,v 1.4 2004/11/12 03:48:06 liuyq Exp";
    
    private static final int  MAX_SLEEP_TIMES = 700;
    private static final int  SLEEP_MILLI_SECONDDS = 3000;
    private boolean isRunning;
        
    public void beanProcess() throws Exception {}
    
    private void ldAutoLink() throws Exception {
        
        String lunCompletedNumber = "0";

        try {
            //String node0Url = Soap4Cluster.makeTargetN(super.target, 0);

            lunCompletedNumber = NasHeadSOAPClient.ldAutoLink(super.target);
        } catch (NSException e) {
            int error_code = e.getErrorCode();

            switch (error_code) {
            case LD_AUTO_LINK_LD_IS_FULL_EXCEPTION:
                //modified by changhs 2004-08-09
                String failMsg = NSMessageDriver.getInstance().getMessage(session, 
                                    "nas_nashead/alert/ld_is_full");
                if (request.getParameter("nextURL") == null){
                    super.setMsg(failMsg);  // for nas head component in old framework.
                }else{
                    session.setAttribute(NSActionConst.SESSION_OPERATION_RESULT_MESSAGE
                        ,failMsg); // for volume add and extend in struts framework. 
                }
                break;
                //modify end.
            default:
                isRunning = false;
                throw e;
            }
            return;
        }
        
        //modified by changhs 2004-08-09
        String succMsg = NSMessageDriver.getInstance().getMessage(session, "common/alert/done")
                            + "\\r\\n"
                            + NSMessageDriver.getInstance().getMessage(session, 
                                    "nas_nashead/alert/link_complete")
                                    + lunCompletedNumber;
        if (request.getParameter("nextURL") == null){
            super.setMsg(succMsg);   // for nas head component in old framework. 
        }else{
            session.setAttribute(NSActionConst.SESSION_OPERATION_RESULT_MESSAGE
                ,succMsg);  // for volume add and extend in struts framework. 
        }
        //modify end.
    }
    
    public void execAutoLink()throws Exception {
        session.setAttribute(MP_SESSION_END_WAIT, "");
        if (!getIsRunning()) {
            try {
                isRunning = true;
                ldAutoLink();
                isRunning = false;
            }catch (Exception e){
                isRunning = false;
                throw e;
            }
        } else {
            Thread.sleep(SLEEP_MILLI_SECONDDS);
            int sleepTimes = 0;

            while (getIsRunning()) {
                if (sleepTimes > MAX_SLEEP_TIMES) {
                    break;
                }
                Thread.sleep(SLEEP_MILLI_SECONDDS);
                sleepTimes++;
            }
        }
        session.setAttribute(MP_SESSION_END_WAIT, MKFS_FINISHED);
        
    }
    
    public boolean getIsRunning() {
        return this.isRunning;
    }
    
}
