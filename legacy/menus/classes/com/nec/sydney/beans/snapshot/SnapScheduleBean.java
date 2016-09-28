/*
 *      Copyright (c) 2001-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.snapshot;

import com.nec.sydney.framework.*;
import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.atom.admin.snapshot.*;
import com.nec.sydney.beans.base.*;
import com.nec.sydney.net.soap.*;
import java.util.*;

public class SnapScheduleBean extends AbstractJSPBean implements NasConstants,NSExceptionMsg
{
    private static final String     cvsid = "@(#) $Id: SnapScheduleBean.java,v 1.2311 2008/06/17 06:43:55 liy Exp $";
    //member variable
    
    private SnapSummaryInfo snapSummaryInfo;
    //constructor
    public SnapScheduleBean(){}
    // this method overide method in abstract class
    public void beanProcess() throws Exception {
        String hexMountPointName;

        String fromWhere = request.getParameter("fromWhere");
        String targetURL = URL_SNAP_SCHEDULE_JSP;
        if(fromWhere != null && fromWhere.equals("cifs")){
            String normalMP = (String)session.getAttribute("cifs_mountPointForSnapSchedule");
            if(normalMP != null){
                int tmpIndex = normalMP.indexOf("/",8);//[/export/xxxx]
                session.setAttribute(MP_SESSION_EXPORTROOT, normalMP.substring(0, tmpIndex));
                session.setAttribute(MP_SESSION_MOUNTPOINT, normalMP.substring(tmpIndex));
                session.setAttribute("cifs_mountPointForSnapSchedule", null);
                session.setAttribute(MP_SESSION_HEX_MOUNTPOINT, NSUtil.ascii2hStr(normalMP));
            }
            targetURL = targetURL + "?fromWhere=cifs";
        }
        
        String action;
        hexMountPointName=(String)session.getAttribute(MP_SESSION_HEX_MOUNTPOINT);
        if(hexMountPointName==null){
            String redirectURL=super.response.encodeRedirectURL(URL_MOUNT_POINT_JSP);
               super.response.sendRedirect(redirectURL);
        }
        String account = SNAPSHOT;
        //2003/7/14 xinghui maojb
        String deviceName = SnapSOAPClient.hexMP2DevName(hexMountPointName , super.target); 

        snapSummaryInfo = SnapSOAPClient.getSnapSchedule(hexMountPointName,deviceName,account,super.target);
        action=super.request.getParameter(REQUEST_PARAMETER_ACT);
        if(action==null){
            return;
        }

        if(action.equals("Add")){
            //get scheduleName and validate it(shoud only include "0-9","a-z","A-Z",".","-","_")
            String scheduleName = super.request.getParameter("scheduleName");
            for(int i=0;i<scheduleName.length();i++){
                char a=scheduleName.charAt(i);
                if((a!='.')&&(a!='-')&&(a!='_')&&!Character.isLetterOrDigit(a)){
                    NSException ex = new NSException(this.getClass(), NSMessageDriver.getInstance().getMessage(session, "exception/snapshot/invalid_schedule"));
                    ex.setDetail("Schedule Name = "+ scheduleName);
                    ex.setReportLevel(NSReporter.ERROR);
                    ex.setErrorCode(NAS_EXCEP_NO_SNAPSHOT_BEAN_SCHEULENAME);
                    NSReporter.getInstance().report(ex);
                    throw ex;
                }
            }//end for
            //get generation from setSchShow.jsp and validate it(0<generation<...)
            String generation = super.request.getParameter("generation");
            int tmpInt = new Integer(generation).intValue();
            if(tmpInt < 1){
                NSException ex = new NSException(this.getClass(), NSMessageDriver.getInstance().getMessage(session, "exception/snapshot/invalid_schedule"));
                ex.setDetail("generation="+generation);
                ex.setReportLevel(NSReporter.ERROR);
                ex.setErrorCode(NAS_EXCEP_NO_SNAPSHOT_BEAN_GENERATION);
                NSReporter.getInstance().report(ex);
                throw ex;
            }
    
            SnapSchedule snapSch = new SnapSchedule();
            snapSch.setMountPoint(hexMountPointName);
            snapSch.setDeviceName(deviceName); //2003/7/14 xinghui maojb
            snapSch.setScheduleName(scheduleName);
            snapSch.setGeneration(generation);
            //snapSch.setPeriod(); 
            String timeSetting = request.getParameter("timeset");
            if(timeSetting.equals("indirectEdit")){
                String selectedDay = request.getParameter("radio_day");
                if(selectedDay.equals("weekday")){
                    snapSch.setDay(joinArray2String(request.getParameterValues("weekday"),","));
                    snapSch.setPeriod(CRON_PERIOD_WEEKDAY);
                }else if(selectedDay.equals("monthday")){
                    snapSch.setDay(request.getParameter("text_monthday"));
                    snapSch.setPeriod(CRON_PERIOD_MONTHDAY);
                }else{
                    snapSch.setPeriod(CRON_PERIOD_DAILY);
                }                       
                snapSch.setHour(request.getParameter("text_hour"));
                snapSch.setMinute(request.getParameter("text_minute"));
            }else{
            	snapSch.setDirectEditInfo(request.getParameter("text_directedit").replaceAll("\\s+"," "));
            	snapSch.setPeriod(CRON_PERIOD_DIRECTEDIT);
            }
            
            // get info of the schedule of deleting, add by jiangfx, 2006/9/8
            String delScheFlag = request.getParameter("delScheChkbox");
            if (delScheFlag == null) {
                delScheFlag = "off";
            }
            SnapSchedule delSnapSche = new SnapSchedule();
            if (delScheFlag.equals("on")) {
                delSnapSche.setMountPoint(hexMountPointName);
                delSnapSche.setDeviceName(deviceName);
                delSnapSche.setScheduleName(scheduleName);
                delSnapSche.setGeneration(request.getParameter("reservedGen"));
                
                String delSche_timeSetting = request.getParameter("delSche_timeset");
                               
                if(delSche_timeSetting.equals("indirectEdit")){
                    String delSche_selectedDay = request.getParameter("delSche_radio_day");
                    if(delSche_selectedDay.equals("weekday")){
                        delSnapSche.setDay(joinArray2String(request.getParameterValues("delSche_weekday"),","));
                        delSnapSche.setPeriod(CRON_PERIOD_WEEKDAY);
                    }else if(delSche_selectedDay.equals("monthday")){
                        delSnapSche.setDay(request.getParameter("delSche_text_monthday"));
                        delSnapSche.setPeriod(CRON_PERIOD_MONTHDAY);
                    }else{
                        delSnapSche.setPeriod(CRON_PERIOD_DAILY);
                    }                       
                    delSnapSche.setHour(request.getParameter("delSche_text_hour"));
                    delSnapSche.setMinute(request.getParameter("delSche_text_minute"));
                }else{
                    delSnapSche.setDirectEditInfo(request.getParameter("delSche_text_directedit").replaceAll("\\s+"," "));
                    delSnapSche.setPeriod(CRON_PERIOD_DIRECTEDIT);
                }
            }
                       
            //call soapclient to add it to crontab
            
            SnapSOAPClient.checkOutSnapshot(super.target);
            
            try{
                String tmpResult = SnapSOAPClient.addSnapSchedule(snapSch,delSnapSche,account,super.target);
                if(tmpResult!=null){
                    SnapSOAPClient.rollBackSnapshot(super.target);
                    String[] replacements= {this.getScheduleMsg(snapSch)};
                    super.setMsg(
                        NSMessageDriver.getInstance().getMessage(session, "common/alert/failed")+"\\r\\n"
                        +NSMessageDriver.getInstance().getMessage(session, "nas_snapshot/alert/timeExist", replacements));
                    String redirectURL = super.response.encodeRedirectURL(targetURL);
                    super.response.sendRedirect(redirectURL);
                    return;
                }
            }catch(NSException e){
                SnapSOAPClient.rollBackSnapshot(super.target);
                if(e.getErrorCode() == NAS_EXCEP_NO_SNAPSHOT_BEAN_SCHEDULE_EXIST){
                    String[] replacements= {scheduleName};
                    super.setMsg(
                        NSMessageDriver.getInstance().getMessage(session, "common/alert/failed")+"\\r\\n"
                        +NSMessageDriver.getInstance().getMessage(session, "nas_snapshot/alert/schduleExist", replacements));
                    String redirectURL=super.response.encodeRedirectURL(targetURL);
                    super.response.sendRedirect(redirectURL);
                    return;
                }else if(e.getErrorCode() == NAS_EXCEP_NO_SNAPSHOT_BEAN_CRONTAB_FAILED || e.getErrorCode() == NAS_EXCEP_NO_SNAPSHOT_BEAN_CRONTAB_FAILED_DELSCH){
                		SnapSchedule info = null;
                		if(e.getErrorCode() == NAS_EXCEP_NO_SNAPSHOT_BEAN_CRONTAB_FAILED){
                			info = snapSch;
                		}else{
                			info = delSnapSche;
                		}         		
                		String[] replacements= {this.getScheduleMsg(info)};
                    	super.setMsg(
                                NSMessageDriver.getInstance().getMessage(session, "common/alert/failed") + "\\r\\n"
                                +NSMessageDriver.getInstance().getMessage(session, "nas_snapshot/alert/crontab_failed", replacements));
                            String redirectURL=super.response.encodeRedirectURL(targetURL);
                            super.response.sendRedirect(redirectURL);
                            return;  	
                }else{
                    throw e;
                }
            }
            //added by baiwq for "cluster" 2002-05-31
            String friendTarget = Soap4Cluster.whoIsMyFriend(super.target); 
            if(friendTarget!=null&&!friendTarget.equals("")){
                try{
                    SnapSOAPClient.checkOutSnapshot(friendTarget);
                }catch(Exception e){
                    SnapSOAPClient.rollBackSnapshot(super.target);
                    throw e;
                }
                try{
                    SnapSOAPClient.addSnapSchedule(snapSch,delSnapSche,account,friendTarget);
                    SnapSOAPClient.checkInSnapshot(friendTarget);
                }catch(Exception e){
                    SnapSOAPClient.rollBackSnapshot(super.target);
                    SnapSOAPClient.rollBackSnapshot(friendTarget);
                    throw e;
                }
            }
            try{
                SnapSOAPClient.checkInSnapshot(super.target);
            }catch(Exception e){
                SnapSOAPClient.rollBackSnapshot(super.target);
                throw e;
            }
                    
            super.setMsg(
               NSMessageDriver.getInstance().getMessage(session, "common/alert/done"));
        }    
        // if the "Delete" button of setSchShow.jsp OnClick, delete the schedule of this
        if(action.equals("Delete")){
            String delSchedule = request.getParameter("delSchedule");
            SnapSOAPClient.checkOutSnapshot(super.target);
            try{
                SnapSOAPClient.deleteSnapSchedule(delSchedule
                                                ,hexMountPointName,deviceName
                                                ,account
                                                ,super.target);
            }catch(Exception e){
                SnapSOAPClient.rollBackSnapshot(super.target);
                throw e;
            }
            //added by baiwq for "cluster" 2002-05-31
            String friendTarget = Soap4Cluster.whoIsMyFriend(super.target); 
            if(friendTarget!=null&&!friendTarget.equals("")){
                try{
                    SnapSOAPClient.checkOutSnapshot(friendTarget);
                }catch(Exception e){
                    SnapSOAPClient.rollBackSnapshot(super.target);
                    throw e;
                }
                try{
                    SnapSOAPClient.deleteSnapSchedule(delSchedule
                                                    ,hexMountPointName,deviceName
                                                    ,account
                                                    ,friendTarget);
                    SnapSOAPClient.checkInSnapshot(friendTarget);
                }catch(Exception e){
                    SnapSOAPClient.rollBackSnapshot(super.target);
                    SnapSOAPClient.rollBackSnapshot(friendTarget);
                    throw e;
                }
            }
            try{
                SnapSOAPClient.checkInSnapshot(super.target);
            }catch(Exception e){
                SnapSOAPClient.rollBackSnapshot(super.target);
                throw e;
            }
            super.setMsg(
                NSMessageDriver.getInstance().getMessage(session, "common/alert/done"));
        }//end "delete" action
        //return to setSchShow.jsp
        String redirectURL=super.response.encodeRedirectURL(targetURL);
        super.response.sendRedirect(redirectURL);
    }//end "beanProcess"
    
    public Vector getSchedule(){
        return SnapSchedulePair
		 .makeSchedulePair(snapSummaryInfo.getSnapshotVector(),
		snapSummaryInfo.getDeleteSnapshotVector());
    }
    
    public int getAvailableNumber(){
        return snapSummaryInfo.getSnapAvailableNumber();
    }

    public Hashtable getAvailableNumberDetail() {
        return snapSummaryInfo.getScheduleOutCrontab2Time();
    }
    
    public String getScheduleMsg(SnapSchedule info){
        StringBuffer sb = new StringBuffer();
        String[] alertMsg = schedule4Display(info);
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
	    return sb.toString();
    }
    
    public String getMountPoint(){
        String mountPoint = "";
        String param = (String)session.getAttribute(MP_SESSION_EXPORTROOT); //Get the export root from session
        if ( param != null ){
            mountPoint = param;
            
        }
        
        param = (String)session.getAttribute(MP_SESSION_MOUNTPOINT); //Get the mount point from session
        if ( param != null ){
            mountPoint +=param;
        }
        
        return mountPoint;
    }
    /**
    * change SnapSchedule object to displaying style such as--DayOfWeek Sunday Time 0 Hour 00 Minute
    *@param  snapSch  the object that will be displayed.
    *@return the string array that include the content for displaying 
    */
    public String[] schedule4Display(SnapSchedule snapSch) {
    	java.text.DecimalFormat df = new java.text.DecimalFormat("00");
    	String[] alertMsg = {"","","","",""};
    	int period = snapSch.getPeriod();
    	switch(period){
            case CRON_PERIOD_WEEKDAY:
                alertMsg[0] = NSMessageDriver.getInstance().getMessage(session, "nas_snapshot/snapschedule/td_weekday");
            	String[] weekday = {
            	    NSMessageDriver.getInstance().getMessage(session, "nas_snapshot/snapschedule/display_sun"),
            	    NSMessageDriver.getInstance().getMessage(session, "nas_snapshot/snapschedule/display_mon"),
                    NSMessageDriver.getInstance().getMessage(session, "nas_snapshot/snapschedule/display_tue"),
                    NSMessageDriver.getInstance().getMessage(session, "nas_snapshot/snapschedule/display_wed"),
                    NSMessageDriver.getInstance().getMessage(session, "nas_snapshot/snapschedule/display_thu"),
                    NSMessageDriver.getInstance().getMessage(session, "nas_snapshot/snapschedule/display_fri"),
                    NSMessageDriver.getInstance().getMessage(session, "nas_snapshot/snapschedule/display_sat")
                };
                String[] displayDay = snapSch.getDay().split(",");
                for(int i=0; i<displayDay.length; i++){
                    displayDay[i] = weekday[Integer.parseInt(displayDay[i])];
                }
                alertMsg[1] = joinArray2String(displayDay
                                ,NSMessageDriver.getInstance().getMessage(session, "nas_snapshot/snapschedule/separateSign"));
                alertMsg[2] = NSMessageDriver.getInstance().getMessage(session, "nas_snapshot/snapschedule/th_time");
                alertMsg[3] = snapSch.getHour() 
                            + NSMessageDriver.getInstance().getMessage(session, "nas_snapshot/snapschedule/td_hour");
                alertMsg[4] = df.format(Double.parseDouble(snapSch.getMinute()))
                            + NSMessageDriver.getInstance().getMessage(session, "nas_snapshot/snapschedule/td_minute");
            	break;
            case CRON_PERIOD_MONTHDAY:
            	alertMsg[0] = NSMessageDriver.getInstance().getMessage(session, "nas_snapshot/snapschedule/td_monthday");
                alertMsg[1] = snapSch.getDay();
                alertMsg[2] = NSMessageDriver.getInstance().getMessage(session, "nas_snapshot/snapschedule/th_time");
                alertMsg[3] = snapSch.getHour() 
                            + NSMessageDriver.getInstance().getMessage(session, "nas_snapshot/snapschedule/td_hour");
                alertMsg[4] = df.format(Double.parseDouble(snapSch.getMinute()))
                            + NSMessageDriver.getInstance().getMessage(session, "nas_snapshot/snapschedule/td_minute");
            	break;
            case CRON_PERIOD_DAILY:
            	alertMsg = new String[]{
            	            NSMessageDriver.getInstance().getMessage(session, "nas_snapshot/snapschedule/td_daily")
                            ,NSMessageDriver.getInstance().getMessage(session, "nas_snapshot/snapschedule/th_time")
                            ,snapSch.getHour() 
                                    + NSMessageDriver.getInstance().getMessage(session, "nas_snapshot/snapschedule/td_hour")
                            ,df.format(Double.parseDouble(snapSch.getMinute()))
                                    + NSMessageDriver.getInstance().getMessage(session, "nas_snapshot/snapschedule/td_minute")
                            };
            	break;
            case CRON_PERIOD_DIRECTEDIT:
                alertMsg = new String[]{snapSch.getDirectEditInfo()};
            	break;
    	}
    	return alertMsg;
    }
    
    private String joinArray2String(String[] paramArray,String joinSign){
        StringBuffer tmpResult = new StringBuffer();
        for(int i=0; i<paramArray.length; i++){
            tmpResult.append(paramArray[i]);
            if(i!=paramArray.length-1){
                tmpResult.append(joinSign);
            }
        }
        return tmpResult.toString();
    }
}//end class