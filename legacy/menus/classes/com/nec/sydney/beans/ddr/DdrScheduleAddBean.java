/*
 *      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *      $Id: DdrScheduleAddBean.java,v 1.5 2007/04/26 05:42:00 liy Exp $
 */
package com.nec.sydney.beans.ddr;

import java.util.*;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.sydney.beans.base.*;
import com.nec.sydney.framework.NSMessageDriver;
import com.nec.nsgui.model.biz.base.NSException;
import com.nec.sydney.atom.admin.ddr.*;

public class DdrScheduleAddBean extends TemplateBean implements DdrConstants {
    private static final String cvsid = "@(#) DdrScheduleAddBean.java,v 1.1 2004/08/24 09:50:22 wangw Exp";
    private Vector unSchedulePair;
    boolean success;
    
    public boolean isSuccess(){
    	return success;
    }
    
    public Vector getUnSchedulePair(){
    	return unSchedulePair;
    }
    
    public void onDisplay() throws Exception{
        Vector allPair = (Vector)session.getAttribute(DDR_SESSION_ALL_PAIR);
        unSchedulePair = new Vector();
        for(int i=0; i<allPair.size(); i++){
            DdrInfo di = (DdrInfo)allPair.get(i);
            if(di.getHasSchedule().equals("false")){
                unSchedulePair.add(di);
            }
        }
    }
    
    public void onSingleAdd() throws Exception{
        Vector v = new Vector();
        String mv = request.getParameter("mvName");
        String rv = request.getParameter("rvName");
        v.add(mv+" "+rv);
        onAdd(v);
    }
    
    public void onMultiAdd() throws Exception{
        String mvrv = request.getParameter("pairName");
        String[] mvrvList = mvrv.split(":");
        Vector v = new Vector(Arrays.asList(mvrvList));
        onAdd(v);
    }
    
    public void onAdd(Vector data)throws Exception{
        DdrScheduleInfo dsi = new DdrScheduleInfo();
        int period = 0;
        dsi.setAction(request.getParameter("act"));
        dsi.setSyncMode(request.getParameter("mode"));
        String timeSetting = request.getParameter("timeset");
        if(timeSetting.equals("indirectEdit")){
            String selectedDay = request.getParameter("radio_day");
            if(selectedDay.equals("weekday")){
                dsi.setDay(DdrCommonUtil.joinArray2String(request.getParameterValues("weekday"),","));
                dsi.setPeriod(DDR_CRON_PERIOD_WEEKDAY);
            }else if(selectedDay.equals("monthday")){
                dsi.setDay(request.getParameter("text_monthday"));
                dsi.setPeriod(DDR_CRON_PERIOD_MONTHDAY);
            }else{
                dsi.setPeriod(DDR_CRON_PERIOD_DAILY);
            }                       
            dsi.setHour(request.getParameter("text_hour"));
            dsi.setMinute(request.getParameter("text_minute"));
        }else{
        	dsi.setDirectEditInfo(request.getParameter("text_directedit").replaceAll("\\s+"," "));
        	dsi.setPeriod(DDR_CRON_PERIOD_DIRECT);
        }
        int groupNo = NSActionUtil.getCurrentNodeNo(request);
        try{
        	DdrScheduleHandler.addSchedule( dsi, data, DDR_CRON_FILE_NAME,groupNo);
        	success=true;
        }
        catch(NSException e) {
        	success = false;
        	String[] alertMsg = DdrCommonUtil.DdrSchedule4Display(dsi,session);
        	StringBuffer sb = new StringBuffer();
        	if(alertMsg.length == 5){
        		sb.append(" ").append(alertMsg[0]).append("(").append(alertMsg[1]).append(") ")
        			.append(alertMsg[2]).append("(").append(alertMsg[3])
                   	.append(alertMsg[4]).append(") ");
        	}else if(alertMsg.length == 4){
        		sb.append(" ").append(alertMsg[0]).append(" ")
        			.append(alertMsg[1]).append("(").append(alertMsg[2])
        			.append(alertMsg[3]).append(") ");
        	}else{
        		sb.append(" ").append(alertMsg[0]).append(" ");
        	}
        	String[] replacements= {sb.toString()};
        	if (e.getErrorCode().equals(DDR_EXCEP_NO_SAME_SCHEDULE)) {
        		super.setMsg(NSMessageDriver.getInstance().getMessage(session, "common/alert/failed") + "\\r\\n"
        				+ NSMessageDriver.getInstance().getMessage(session, "nas_ddrschedule/alert/same_schedule", replacements));
        		return;
        	}else if(e.getErrorCode().equals(DDR_EXCEP_NO_CRONTAB_FAILED)){
        		super.setMsg(NSMessageDriver.getInstance().getMessage(session, "common/alert/failed") + "\\r\\n"
                       + NSMessageDriver.getInstance().getMessage(session, "nas_snapshot/alert/crontab_failed", replacements));            
        	}else {throw e;}
        }//end of catch
    }
}