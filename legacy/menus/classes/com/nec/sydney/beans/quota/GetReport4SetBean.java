/*
 *      Copyright (c) 2006 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.quota;


import java.util.StringTokenizer;

import com.nec.sydney.atom.admin.base.*;

public class GetReport4SetBean extends GetOneReportBean implements NasConstants,NasSession,NSExceptionMsg
{

    private static final String     cvsid = "@(#) $Id: GetReport4SetBean.java,v 1.2 2006/01/03 02:44:48 cuihw Exp $";

    private String blockSoft;
    private String blockHard;
    private String fileSoft;
    private String fileHard;

    public GetReport4SetBean() {
        blockSoft = "0";
        blockHard = "0";
        fileSoft = "0";
        fileHard = "0";
    }
 
    public void beanProcess() throws Exception {
        String DirQuota = (String)request.getParameter("DirQuotaFlag");
        boolean isDirQuota = false;
        String filesystem;
        if (DirQuota == null){
            filesystem = (String)session.getAttribute(MP_SESSION_HEX_MOUNTPOINT);
            isDirQuota = false;
        } else {
            filesystem = (String)session.getAttribute(SESSION_HEX_DIRQUOTA_DATASET);
            isDirQuota = true;
        }
        String idnumber = (String)request.getParameter("idnumber");
        String flagUser = request.getParameter("flagUser");
        String flagName = request.getParameter("flagName");
        
        String[] limitInfo = getOneReport(isDirQuota, filesystem, idnumber, flagUser, flagName);
        if(limitInfo != null){
            if(limitInfo.length == 0){
                return;
            }
            blockSoft = limitInfo[0];
            blockHard = limitInfo[1];
            fileSoft  = limitInfo[2];
            fileHard  = limitInfo[3];
        }
        String referenceProperties = "?idnumber=" + idnumber + "&flagUser=" + flagUser
                                   + "&blockSoft=" + blockSoft + "&blockHard=" + blockHard
                                   + "&fileSoft=" + fileSoft + "&fileHard=" + fileHard;
                                   
        if (isDirQuota){
            response.sendRedirect(response.encodeRedirectURL("dirquotasetbottom.jsp" + referenceProperties));
        } else {
            response.sendRedirect(response.encodeRedirectURL("quotasetbottom.jsp" + referenceProperties));
        }
    }
    public String changeUnit4SetShow(long limitValue, String unit){
        if (unit == null || unit.equals("--")){
            java.text.DecimalFormat form = new java.text.DecimalFormat();
            form.applyPattern("#,##0");
            String longString = form.format(limitValue);
            return longString;   
        }  
        
        double limit_double = (new Double(limitValue).doubleValue());         
        if (unit.equals("k")){
            limit_double = limit_double/1024;
        } else if (unit.equals("M")){
            limit_double = limit_double/1048576;
        } else {
            limit_double = limit_double/1073741824;
        } 
        String doubleString =NSUtil.changeScienticDouble(limit_double);
        StringTokenizer st = new StringTokenizer(doubleString, ".");
        String stleft = st.nextToken();
        String strright = st.nextToken();
        if(strright.length() > 1){
            strright = strright.substring(0,2);
        }else {
            strright = strright.substring(0,1);
        }
        StringBuffer strBuf = new StringBuffer(stleft);
        strBuf.append(".");
        strBuf.append(strright);
        doubleString = strBuf.toString();
        
        java.text.DecimalFormat form = new java.text.DecimalFormat();
        form.applyPattern("#,##0.00");
        doubleString = form.format((new Double(doubleString)).doubleValue());
        return doubleString;
    }
    
}