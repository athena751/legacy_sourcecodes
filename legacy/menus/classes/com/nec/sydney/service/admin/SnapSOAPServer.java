/*
 *      Copyright (c) 2001-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.service.admin;

import java.util.*;
import java.io.*;
import com.nec.sydney.atom.admin.snapshot.*;
import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.beans.base.*;
import com.nec.sydney.framework.*;
import com.nec.sydney.net.soap.*;

public class SnapSOAPServer implements NasConstants,NSExceptionMsg{

    private static final String     cvsid = "@(#) $Id: SnapSOAPServer.java,v 1.2308 2008/07/01 07:22:06 liy Exp $";
    
    private static final String SCRIPT_SNAP_GET_AVAILABLE_NUMBER = "/bin/snap_getAvailableNumber.pl";
    private static final String CRON_FILE_PATH                   = "/var/spool/cron/snapshot";
    private static final int ERR_CODE_SCHEDULE_NAME_EXIST = 5;
    private static final int ERR_CODE_SCHEDULE_TIME_EXIST = 6;
    private static final int ERR_CODE_ADD_SNAP_CMD_FAILED = 10;
    private static final int ERR_CODE_ADD_SNAP_NAME_WRONG = 11;
    private static final String FILE_DELSCHE_CRON = "/var/spool/cron/snapshot";
    public static  final String SCRIPT_DELSNAP_CRONJOB = "sudo /home/nsadmin/bin/snap_cronjob4del.pl";
    public static  final String SCRIPT_ADD_DELSCHE = "snap_addDelSche.pl";
    private static final int ERR_CODE_CRONTAB_FAILED = 18; // failed to execute comannd "crontab"
    private CmdErrHandler cmdErrHandler = new CmdErrHandler(){
        public void errHandle(SoapResponse rps,Process proc,String[] cmds)throws Exception{
            rps.setSuccessful(false);
            rps.setErrorCode(proc.exitValue());
            rps.setErrorMessage("Exec command failed! Command = "+ cmds[1]+"\n"+SOAPServerBase.getCmdErrMsg(proc.getErrorStream())+"\n");
       }
    }; 
       
    //constructor
    public SnapSOAPServer(){}
    //convert a object of SnapSchedule class to a string used for writing cron file
    /**
    * convert the infoLine into a SnapSchedule. 
    *@param  infoLine   SnapSchedule's information
    *@return return object of SnapSchedule if inforline is valid,else return null
    */
    private SnapSchedule cron2snap(String infoLine,String cronjob) throws Exception{
        SnapSchedule schedule   = new SnapSchedule();
        String[] scheduleInfo   = infoLine.split("\\s+");
        if(scheduleInfo!=null && scheduleInfo.length==10
                && (scheduleInfo[5]+" "+scheduleInfo[6]).equals(cronjob)){
            int period;
            if(setDsiMinute(schedule, scheduleInfo[0]) && setDsiHour(schedule, scheduleInfo[1])){
                if(scheduleInfo[2].equals("*") && scheduleInfo[3].equals("*")
        	            && setDsiDay(schedule, scheduleInfo[4], CRON_PERIOD_WEEKDAY)){
        	    period = CRON_PERIOD_WEEKDAY;
                }else if(scheduleInfo[3].equals("*") && scheduleInfo[4].equals("*")
                            && setDsiDay(schedule, scheduleInfo[2], CRON_PERIOD_MONTHDAY)){
                    period = CRON_PERIOD_MONTHDAY;
                }else if(scheduleInfo[2].equals("*") && scheduleInfo[3].equals("*")
                            && scheduleInfo[4].equals("*")){
                    period = CRON_PERIOD_DAILY;
                }else{
                    period = CRON_PERIOD_DIRECTEDIT;
                }
    	    }else{
    	        period = CRON_PERIOD_DIRECTEDIT;
    	    }
            StringBuffer tmpDirect = new StringBuffer();
            for(int i=0; i<4; i++){
                tmpDirect.append(scheduleInfo[i]).append(" ");
            }
            schedule.setDirectEditInfo(tmpDirect.append(scheduleInfo[4]).toString());
            schedule.setPeriod(period);
            schedule.setMountPoint(scheduleInfo[7]); //This element is mountpoint or devicename .
            schedule.setDeviceName(scheduleInfo[7]); //This element is mountpoint or devicename .
            schedule.setScheduleName(scheduleInfo[8]);
            schedule.setGeneration(scheduleInfo[9]);
            return schedule;
        }
        return null;
    }
    
    /**
    * set the min into dsi
    *@param  snapSch  the object that minute will be stored.
    *        minute   the minute string
    *@return  return true if the minute is valid ,otherwise return false 
    */
    private boolean setDsiMinute(SnapSchedule snapSch, String minute){
        if(minute.matches("^\\d{1,2}$")){
            int minNum = Integer.parseInt(minute);
            if(minNum >= 0 && minNum <= 59){
                snapSch.setMinute(minute);
                return true;
            }
        }
    	return false;
    }
    
    /**
    * set the hour into dsi
    *@param  snapSch  the object that hour is to be stored.
    *        hour     the hour string
    *@return  return true if the hour is valid ,otherwise return false 
    */
    private boolean setDsiHour(SnapSchedule snapSch, String hour){
    	//hour must like ("^\\d+(\\-\\d+)?(,?\\d+(\\-\\d+)?)*$")
        String[] hourNumList = hour.split(",");
        for(int i=0; i<hourNumList.length; i++){
            if(hourNumList[i].matches("^\\d+$")){
                int hourNum = Integer.parseInt(hourNumList[i]);
                if(hourNum < 0 || hourNum > 23){
                    return false;
                }
            }else if(hourNumList[i].matches("^\\d+\\-\\d+$")){
                int beginHour = Integer.parseInt((hourNumList[i].split("-"))[0]);
                int endHour = Integer.parseInt((hourNumList[i].split("-"))[1]);
                if(beginHour < 0 || beginHour > 23 || endHour < 0 || endHour > 23){
                    return false;
                }
                if(beginHour >= endHour){
                    return false;    
                } 
            }else{
                return false;
            }
        }
        if(hourNumList.length!=0){
            snapSch.setHour(hour);
            return true;
        }
        return false;
    }
    
    /**
    * set the day into dsi
    *@param  snapSch the object that day is to be stored.
    *        day     the day of month or week
    *        period  that means the day is weekday or not
    *@return return true if the day is valid ,otherwise return false 
    */
    private boolean setDsiDay(SnapSchedule snapSch, String paramday, int period){
        if(paramday.matches("^\\d+$")){
            int iDay = Integer.parseInt(paramday);
            if ((period==CRON_PERIOD_WEEKDAY && iDay >= 0 && iDay <=6)
                    ||(period==CRON_PERIOD_MONTHDAY && iDay >= 1 && iDay <=31)){
                snapSch.setDay(paramday);
                return true;
            }
        }else if(paramday.matches("^\\d+(,\\d+)+$")){
            String[] monthdayNum = paramday.split(",");
            for(int i=0; i<monthdayNum.length; i++){
                int iDay = Integer.parseInt(monthdayNum[0]);
                if(period==CRON_PERIOD_WEEKDAY && (iDay < 0 || iDay > 6)){
                    return false;
                }else if (period==CRON_PERIOD_MONTHDAY  && (iDay < 1 || iDay > 31)){
                    return false;
                }
            }
            snapSch.setDay(paramday);
            return true;
    	}
    	return false;
    }
    private String[] snap2cron(SnapSchedule sch, String cronjob) throws Exception{ //modify by jiangfx, 2006/11/15
        String[] str=new String[4];        
        switch(sch.getPeriod()){
            case CRON_PERIOD_WEEKDAY:   str[0]= sch.getMinute()+" "+sch.getHour()+" * * "
                                                +sch.getDay()+" "+ cronjob +" ";
            break;
            case CRON_PERIOD_MONTHDAY:  str[0]= sch.getMinute()+" "+sch.getHour()+" "+sch.getDay()
                                                +" * * "+ cronjob +" ";
            break;
            case CRON_PERIOD_DAILY:     str[0]= sch.getMinute()+" "+sch.getHour()+" * * * "
                                                + cronjob +" ";
            break;
            case CRON_PERIOD_DIRECTEDIT:str[0]= sch.getDirectEditInfo()+" "+ cronjob +" ";
            break;
            default:                    str[0]= sch.getDirectEditInfo()+" "+ cronjob +" ";
        }
        str[1]= sch.getMountPoint();
        str[2]= sch.getDeviceName();
        str[3]= " "+sch.getScheduleName()+" "+sch.getGeneration();
        return str;
    }//end function "snap2cron"
    
    //get snapshot schedule list
    public SoapRpsSnapSummaryInfo getSnapSchedule(String mountPoint,
			String deviceName, String account) throws Exception {
		SoapRpsSnapSummaryInfo transObject = new SoapRpsSnapSummaryInfo();
		String home = System.getProperty("user.home");
		// PATH_SNAPSHOT_CRON+account is the name of cron file
		String cmd[] = new String[5];
		cmd[0] = SUDO_COMMAND;
		cmd[1] = home + SCRIPT_DIR + SCRIPT_SNAP_GETSCHEDULE;
		cmd[2] = PATH_SNAPSHOT_CRON + account;
		cmd[3] = mountPoint;
		cmd[4] = deviceName;
		CmdHandler cmdHandler = new CmdHandler() {
			public void cmdHandle(SoapResponse rps, Process proc, String[] cmds)
					throws Exception {
				SoapRpsSnapSummaryInfo trans = (SoapRpsSnapSummaryInfo) rps;
				BufferedReader inputStr = new BufferedReader(
						new InputStreamReader(proc.getInputStream()));
				Vector scheduleVec = new Vector();
				SnapSummaryInfo snapSummaryInfo = new SnapSummaryInfo();
				String line = inputStr.readLine();
				while (line != null) {
					SnapSchedule schedule = new SnapSchedule();
					schedule = cron2snap(line, SCRIPT_SNAP_CRONJOB);
					if (schedule != null) {
						scheduleVec.add(schedule);
					}

					line = inputStr.readLine();
				}// end while
				Collections.sort(scheduleVec);
				snapSummaryInfo.setSnapshotVector(scheduleVec);
				// get deleteSchedule Vector
				SoapRpsSnapSummaryInfo deleteScheduleTrans = getDeleteSnapSchedule(cmds);
				if (!deleteScheduleTrans.isSuccessful()) {
					return;
				}
				snapSummaryInfo.setDeleteSnapshotVector(deleteScheduleTrans
						.getInfo().getDeleteSnapshotVector());

				getAvailableNumberDetail(cmds[3], cmds[4], snapSummaryInfo);
				// int availableNumber =
				// Integer.parseInt((String)(scheduleOutCrontab2Time.get("normalName?")));
				// snapSummaryInfo.setSnapAvailableNumber(getAvailableNumber(cmds[3],cmds[4]));
				// snapSummaryInfo.setSnapAvailableNumber(availableNumber);
				// scheduleOutCrontab2Time.remove("normalName?");
				// snapSummaryInfo.setScheduleOutCrontab2Time(scheduleOutCrontab2Time);
				trans.setSuccessful(true);
				trans.setInfo(snapSummaryInfo);
			}
		};

		SOAPServerBase.execCmd(cmd, transObject, cmdHandler);
		return transObject;
	}// end function "getSnapSchedule"

	// get deleteSnapshot schedule list by li yi 2006
	public SoapRpsSnapSummaryInfo getDeleteSnapSchedule(String[] cmds)
			throws Exception {
		SoapRpsSnapSummaryInfo transObject = new SoapRpsSnapSummaryInfo();
		// PATH_DELSNAPSHOT_CRON is the name of deleteSchedule cron file
		cmds[2] = FILE_DELSCHE_CRON;

		CmdHandler cmdHandler = new CmdHandler() {
			public void cmdHandle(SoapResponse rps, Process proc, String[] cmds)
					throws Exception {
				SoapRpsSnapSummaryInfo trans = (SoapRpsSnapSummaryInfo) rps;
				BufferedReader inputStr = new BufferedReader(
						new InputStreamReader(proc.getInputStream()));
				Vector deleteScheduleVec = new Vector();
				SnapSummaryInfo snapSummaryInfo = new SnapSummaryInfo();
				String line = inputStr.readLine();
				while (line != null) {
					SnapSchedule deleteSchedule = new SnapSchedule();
					deleteSchedule = cron2snap(line,
							SCRIPT_DELSNAP_CRONJOB);
					if (deleteSchedule != null) {
						deleteScheduleVec.add(deleteSchedule);
					}
					line = inputStr.readLine();
				}// end while
				Collections.sort(deleteScheduleVec);
				snapSummaryInfo.setDeleteSnapshotVector(deleteScheduleVec);
				trans.setSuccessful(true);
				trans.setInfo(snapSummaryInfo);
			}
		};

		SOAPServerBase.execCmd(cmds, transObject, cmdHandler);
		return transObject;
	}// end function "getSnapSchedule"
    
    private int getAvailableNumber(String mountPoint , String deviceName){
        SoapRpsString transObject=new SoapRpsString();
        String home = System.getProperty("user.home");
        String cmd[] = new String[4];
        cmd[0] = SUDO_COMMAND;
        cmd[1] = home + SCRIPT_SNAP_GET_AVAILABLE_NUMBER;
        cmd[2] = mountPoint;
        cmd[3] = deviceName;

        CmdHandler cmdHandler = new CmdHandler(){
            public void cmdHandle(SoapResponse trans,Process proc,String[] cmds)throws Exception{
                SoapRpsString transStr = (SoapRpsString)trans;
                BufferedReader buf=new BufferedReader(new InputStreamReader(proc.getInputStream()));
                String result=buf.readLine();
                transStr.setString(result);
                transStr.setSuccessful(true);
            }
        };
        
        SOAPServerBase.execCmd(cmd,transObject,cmdHandler);                        
        return Integer.parseInt(transObject.getString());
    }

    private void getAvailableNumberDetail(String mountPoint , String deviceName,SnapSummaryInfo summaryInfo){
        SoapRpsSnapSummaryInfo transObject=new SoapRpsSnapSummaryInfo();
        String home = System.getProperty("user.home");
        String cmd[] = {SUDO_COMMAND , home + SCRIPT_SNAP_GET_AVAILABLE_NUMBER , mountPoint , deviceName , "on"};
        
        CmdHandler cmdHandler = new CmdHandler(){
            public void cmdHandle(SoapResponse trans,Process proc,String[] cmds)throws Exception{
                SoapRpsSnapSummaryInfo transSnapSummary  = (SoapRpsSnapSummaryInfo)trans;
                BufferedReader buf=new BufferedReader(new InputStreamReader(proc.getInputStream()));
                Hashtable result = new Hashtable();
                
                SnapSummaryInfo info = new SnapSummaryInfo();
                String line = buf.readLine() ;
                info.setSnapAvailableNumber(Integer.parseInt(line));
                
                while((line = buf.readLine()) != null) {
                    StringTokenizer st = new StringTokenizer(line , ":");
                    result.put(st.nextToken() , st.nextToken());
                }
                info.setScheduleOutCrontab2Time(result);

                transSnapSummary.setInfo(info);
                transSnapSummary.setSuccessful(true);
            }
        };
        
        SOAPServerBase.execCmd(cmd,transObject,cmdHandler);                        
        summaryInfo.setScheduleOutCrontab2Time(transObject.getInfo().getScheduleOutCrontab2Time());
        summaryInfo.setSnapAvailableNumber(transObject.getInfo().getSnapAvailableNumber());
        return;
    }
    
    //add snapshot schedule
    public SoapRpsString addSnapSchedule(SnapSchedule schedule,SnapSchedule delSnapSche,String account) throws Exception{
        SoapRpsString trans  = new SoapRpsString();
        String[] cronStr    = snap2cron(schedule, SCRIPT_SNAP_CRONJOB);
        String home         = System.getProperty("user.home");
        
        String[] cmdArray   = new String[7]; //2003/7/14 xinghui maojb
        cmdArray[0] = SUDO_COMMAND;
        cmdArray[1] = home+SCRIPT_DIR+SCRIPT_ADD_SNAP_SCHEDULE;
        cmdArray[2] = PATH_SNAPSHOT_CRON+account;
        cmdArray[3] = cronStr[0];
        cmdArray[4] = cronStr[1];
        cmdArray[5] = cronStr[2];
        cmdArray[6] = cronStr[3];
        //ADDED BY BAIWQ FOR "CLUSTER".    
        CmdErrHandler cmdErrHandler = new CmdErrHandler(){
            public void errHandle(SoapResponse rps,Process proc,String[] cmds)throws Exception{
                rps.setSuccessful(false);
                 //2.if exit code is 3,then set error code 3 and error message like the group name exists. 
                //if exit code is 4,then set error code 4 and error message like some Network Interfaces has been in other Port Groups                         
                if( proc.exitValue()==ERR_CODE_SCHEDULE_NAME_EXIST){
                    rps.setErrorCode(NAS_EXCEP_NO_SNAPSHOT_BEAN_SCHEDULE_EXIST);
                }else if(proc.exitValue() == ERR_CODE_CRONTAB_FAILED){
                	rps.setErrorCode(NAS_EXCEP_NO_SNAPSHOT_BEAN_CRONTAB_FAILED);
                }else{                
                    rps.setErrorCode(NAS_EXCEP_NO_SNAPSHOT_ADD_SCHEDULE_FAILED);
                    rps.setErrorMessage("Exec command failed! Command = "+ cmds[1]+"\n"+SOAPServerBase.getCmdErrMsg(proc.getErrorStream()));
                } 
            }
        };
        //ADDED BY wangw 2003/12/12 
        CmdHandler cmdHandler = new CmdHandler(){
            public void cmdHandle(SoapResponse trans,Process proc,String[] cmds)throws Exception{
                SoapRpsString transStr = (SoapRpsString)trans;
                BufferedReader buf=new BufferedReader(new InputStreamReader(proc.getInputStream()));
                String result=buf.readLine();
                transStr.setString(result);
                transStr.setSuccessful(true);
            }
        };

        SOAPServerBase.execCmd(cmdArray,trans,cmdHandler,cmdErrHandler);
        if (!trans.isSuccessful() || trans.getString()!=null) {
            return trans;
        }
        
        // add schedule of deleting snapshot if shcedule is created
        if (!delSnapSche.getScheduleName().equals("")) {
            String[] delScheCronStr    = snap2cron(delSnapSche, SCRIPT_DELSNAP_CRONJOB);

            cmdArray[0] = SUDO_COMMAND;
            cmdArray[1] = home+SCRIPT_DIR+SCRIPT_ADD_DELSCHE;
            cmdArray[2] = FILE_DELSCHE_CRON;   // cron file
            cmdArray[3] = delScheCronStr[0];   // date, time and cronjob
            cmdArray[4] = delScheCronStr[1];   // mount point
            cmdArray[5] = delScheCronStr[2];   // device
            cmdArray[6] = delScheCronStr[3];   // schedule name and reserved generation
            
            CmdErrHandler cmdErrHandler4DelSchdeule = new CmdErrHandler(){
                public void errHandle(SoapResponse rps,Process proc,String[] cmds)throws Exception{
                    rps.setSuccessful(false);
                    if(proc.exitValue() == ERR_CODE_CRONTAB_FAILED){
                    	rps.setErrorCode(NAS_EXCEP_NO_SNAPSHOT_BEAN_CRONTAB_FAILED_DELSCH);
                    }else{                
                        rps.setErrorCode(NAS_EXCEP_NO_SNAPSHOT_ADD_SCHEDULE_FAILED);
                        rps.setErrorMessage("Exec command failed! Command = "+ cmds[1]+"\n"+SOAPServerBase.getCmdErrMsg(proc.getErrorStream()));
                    } 
                }
            };
            SOAPServerBase.execCmd(cmdArray,trans,cmdHandler,cmdErrHandler4DelSchdeule);
        }
        return trans;
    }// end function "addSnapSchedule"
    
    //delete snapshot schedule
    public SoapResponse deleteSnapSchedule(String schedulename,String mountPoint,String deviceName, String account) throws Exception{
        SoapResponse trans  = new SoapResponse();
        String home         = System.getProperty("user.home");
        String cmd[]        = new String[6];
        cmd[0] = SUDO_COMMAND;
        cmd[1] = home + SCRIPT_DIR+SCRIPT_DEL_SNAP_SCHEDULE;
        cmd[2] = PATH_SNAPSHOT_CRON + account;
        cmd[3] = mountPoint;
        cmd[4] = deviceName;
        cmd[5] = schedulename;        
        SOAPServerBase.execCmd(cmd,trans);
        return trans;
    }//end function "deleteSnapSchedule"
    
    //as a service,this method sets the COW limit
    public SoapResponse setCOWLimit(int limit,String mountPoint) throws Exception{
        SoapResponse trans=new SoapResponse();
        String home=System.getProperty("user.home");
        String cmd[] = new String[4];
        cmd[0] = SUDO_COMMAND;
        cmd[1] = home+COMMAND_SNAPSETLIMIT;
        cmd[2] = Integer.toString(limit);
        cmd[3] = mountPoint;
        SOAPServerBase.execCmd(cmd,trans,this.cmdErrHandler);
        return trans;
    }//end function "setCOWLimit"
    
    //create a snapshot
    public SoapResponse createSnap(String name,String mountPoint) throws Exception{
        SoapResponse trans=new SoapResponse();
        String home=System.getProperty("user.home");
        String cmd[] = new String[4];
        cmd[0] = SUDO_COMMAND;
        cmd[1] = home+COMMAND_SNAPCREATE;
        cmd[2] = name;
        cmd[3] = mountPoint;
        //
               
        SOAPServerBase.execCmd(cmd,trans,this.cmdErrHandler);
        return trans;
    }//end function "createSnap"
    
    //delete a snapshot
    public SoapResponse deleteSnap(String name,String mountPoint) throws Exception{
        SoapResponse trans=new SoapResponse();
        String home=System.getProperty("user.home");
        String cmd[] = new String[4];
        cmd[0] = SUDO_COMMAND;
        cmd[1] = home+COMMAND_SNAPDELETE;
        cmd[2] = name;
        cmd[3] = mountPoint;
        SOAPServerBase.execCmd(cmd,trans,this.cmdErrHandler);
        return trans;
    }//end function "deleteSnap"
    
    //get the snapshot list
    public SoapRpsSnapSummaryInfo getSnapList(String mountPoint, final String deviceName) throws Exception{
        SoapRpsSnapSummaryInfo transObject=new SoapRpsSnapSummaryInfo();
        //String cmd=SUDO_COMMAND+" "+COMMAND_SNAPGETLIST+" "+mountPoint;
        String home=System.getProperty("user.home");
        String cmd[] = new String[3];
        cmd[0] = SUDO_COMMAND;
        cmd[1] = home+COMMAND_SNAPGETLIST;
        cmd[2] = mountPoint;

        CmdHandler cmdHandler = new CmdHandler(){
            public void cmdHandle(SoapResponse rps,Process proc,String[] cmds)throws Exception{
                SoapRpsSnapSummaryInfo trans=(SoapRpsSnapSummaryInfo)rps;
                Vector snaplist=new Vector();
                BufferedReader inputStr= new BufferedReader(new InputStreamReader(proc.getInputStream()));
                SnapSummaryInfo snapSummaryInfo = new SnapSummaryInfo();
                String line=inputStr.readLine();
                while(line!=null){
                    StringTokenizer st=new StringTokenizer(line.trim());
                    SnapInfo si=new SnapInfo();
                    si.setName(st.nextToken());
                    si.setDate(st.nextToken());
                    si.setTime(st.nextToken());
                    si.setStatus(st.nextToken());
                    snaplist.addElement(si);
                    line=inputStr.readLine();
                }
                snapSummaryInfo.setSnapshotVector(snaplist);
                snapSummaryInfo.setSnapAvailableNumber(getAvailableNumber(cmds[2],deviceName));
                trans.setSuccessful(true);
                trans.setInfo(snapSummaryInfo);
            }
        };
        
        SOAPServerBase.execCmd(cmd,transObject,cmdHandler);
        return transObject;
    }//end function "getSnapList"

//////three methods (checkin,checkout,rollback) are added by WangWei at 1/14/2003
    public SoapResponse checkOutSnapshot()
    {
        SoapResponse trans    = Transaction.checkout(CRON_FILE_PATH);
        return trans;
    }
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    public SoapResponse checkInSnapshot()
    {
        SoapResponse trans    = Transaction.checkin(CRON_FILE_PATH);
        return trans;
    }
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    public SoapResponse rollBackSnapshot()
    {
        SoapResponse trans    = Transaction.rollback(CRON_FILE_PATH);
        return trans;
    }
    
//2003/07/14, maojb,xingh
    public static SoapRpsString hexMP2DevName( String hexMountPointName) {
        SoapRpsString transObject = new SoapRpsString();
        String home         = System.getProperty("user.home");
        String cmd[]        = new String[3];
        cmd[0] = SUDO_COMMAND;
        cmd[1] = home + SCRIPT_DIR+SCRIPT_SNAP_HEXMP2DEVNAME;
        cmd[2] = hexMountPointName;
        
        CmdHandler cmdHandler = new CmdHandler(){
            public void cmdHandle(SoapResponse rps,Process proc,String[] cmds)throws Exception{
                SoapRpsString trans    = (SoapRpsString)rps;
                BufferedReader inputStr  = new BufferedReader(new InputStreamReader(proc.getInputStream()));
                
                
                String devName = inputStr.readLine();
            
                trans.setSuccessful(true);
                trans.setString(devName);
            }
        };
        
        SOAPServerBase.execCmd(cmd,transObject,cmdHandler);
        return transObject;
    }
  //  2007/05/18, liy
   
}//end class