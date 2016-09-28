/*
 *      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.sydney.beans.ddr;

import java.util.*;
import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.atom.admin.ddr.*;
import com.nec.nsgui.model.biz.base.*;
import com.nec.nsgui.model.biz.base.NSCmdResult;
import com.nec.nsgui.model.biz.nfs.NFSModel;


public class DdrScheduleHandler implements DdrConstants,NasConstants{
    private static final String   cvsid = "@(#) $Id: DdrScheduleHandler.java,v 1.2 2007/09/10 11:28:15 liy Exp $";
    
    private static final String	SCRIPT_GET_DDR_PAIRING_INFO
                            = "/home/nsadmin/bin/ddr_getPairingInfo.pl";
    private static final String	SCRIPT_GET_DDR_SCHEDULE_INFO
                            = "/home/nsadmin/bin/ddr_getScheduleInfo.pl";
    private static final String	SCRIPT_DEL_SCHEDULE
                            = "/home/nsadmin/bin/ddr_delScheduleInfo.pl";
    private static final String	SCRIPT_ADD_SCHEDULE
                            = "/home/nsadmin/bin/ddr_addSchedule.pl";
    private static final String	SCRIPT_DEL_DELPAIRINGSCHEDULE
                            = "/home/nsadmin/bin/ddr_delPairingSchedule.pl";
    public static final String DELETE_TEMP_FILE 
    						= "/home/nsadmin/bin/serverprotect_deleteTempFile.pl";
    public static final String CRONJOB_PATH = "/home/nsadmin/bin/ddr_cronjob.pl";
    /**
    * get the pairing name, status and schedule sign. 
    *@param   account  cron file's path ,normally is /var/spool/cron/DDR
    *@return  object of SoapRpsVector which include the object of DdrInfo.java
    */
    public static Vector getDDRPairingInfo (String account, int nodeNum)throws Exception{
    	String[] cmd = {"sudo", SCRIPT_GET_DDR_PAIRING_INFO, account, String.valueOf(nodeNum)};
    	NSCmdResult result = CmdExecBase.execCmd (cmd, nodeNum);
    	String[] ddrPairingInfo = result.getStdout();
    	Vector v = new Vector();
    	for(int i=0;i< ddrPairingInfo.length;i++){
    		String[] info = ddrPairingInfo[i].split("\\s+");
    		DdrInfo di = new DdrInfo(info);
    		v.add(di);
        }
    	return v;

    }
    
    /**
    * get the schedule's information according to pair. 
    *@param  mvName   pair's mv's name
             rvName   pair's rv's name
             account  cron file's path ,normally is /var/spool/cron/DDR
    *@return object of SoapRpsVector which include the object of DdrScheduleInfo.java
    */
    public static Vector getDDRScheduleInfo(String mvName, String rvName, String account,int nodeNum) throws Exception{
    	String[] cmd = {"sudo",SCRIPT_GET_DDR_SCHEDULE_INFO , account, mvName, rvName};
    	NSCmdResult result = CmdExecBase.execCmd (cmd, nodeNum);
    	String[] ddrScheduleInfo = result.getStdout();
    	Vector v = new Vector();
    	for(int i=0;i< ddrScheduleInfo.length;i++){
    		DdrScheduleInfo dsi = cron2Ddr(ddrScheduleInfo[i]);
    		v.add(dsi); 
    	}
    	return v;

    }
    
    /**
    * convert the infoLine into a DdrScheduleInfo. 
    *@param  infoLine   DdrScheduleInfo's information
    *@return object of DdrScheduleInfo 
    */
    private static DdrScheduleInfo cron2Ddr(String infoLine){
    	DdrScheduleInfo dsi = new DdrScheduleInfo();
    	infoLine = infoLine.trim();
    	String[] infos = infoLine.split(":");
    	if(infos[1].indexOf("\\")>0){
            dsi.setAction(infos[1].substring(0,infos[1].indexOf("\\")));
            dsi.setSyncMode(infos[1].substring(infos[1].indexOf("(")+1,infos[1].indexOf(")")-1));
    	}else{
    	    dsi.setAction(infos[1]);
    	    dsi.setSyncMode(null);
    	}
    	//get the time string of cron
    	String[] timeInfo = infos[0].split("\\s+");
    	int period;
    	if(timeInfo.length==5 && setDsiMinute(dsi, timeInfo[0]) && setDsiHour(dsi, timeInfo[1])){
    	    if(timeInfo[2].equals("*") && timeInfo[3].equals("*")
    	            && setDsiDay(dsi, timeInfo[4], DDR_CRON_PERIOD_WEEKDAY)){
    	        period = DDR_CRON_PERIOD_WEEKDAY;
  	    }else if(timeInfo[3].equals("*") && timeInfo[4].equals("*")
    	            && setDsiDay(dsi, timeInfo[2], DDR_CRON_PERIOD_MONTHDAY)){
    	        period = DDR_CRON_PERIOD_MONTHDAY;
      	    }else if(timeInfo[2].equals("*") && timeInfo[3].equals("*")
      	                && timeInfo[4].equals("*")){
    	        period = DDR_CRON_PERIOD_DAILY;
    	    }else{
    	        period = DDR_CRON_PERIOD_DIRECT;
    	    }
    	}else{
    	    period = DDR_CRON_PERIOD_DIRECT;
    	}
    	dsi.setDirectEditInfo(infos[0]);
    	dsi.setPeriod(period);
    	return dsi;
    }
    
    /**
    * set the min into dsi
    *@param  dsi      the object that minute will be stored.
    *        minute   the minute string
    *@return  return true if the minute is valid ,otherwise return false 
    */
    private static boolean setDsiMinute(DdrScheduleInfo dsi, String minute){
        if(minute.matches("^\\d{1,2}$")){
            int minNum = Integer.parseInt(minute);
            if(minNum >= 0 && minNum <= 59){
                dsi.setMinute(minute);
                return true;
            }
        }
    	return false;
    }
    
    /**
    * set the hour into dsi
    *@param  dsi      the object that hour is to be stored.
    *        hour     the hour string
    *@return  return true if the hour is valid ,otherwise return false 
    */
    private static boolean setDsiHour(DdrScheduleInfo dsi, String hour){
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
            dsi.setHour(hour);
            return true;
        }
        return false;
    }
    
    /**
    * set the day into dsi
    *@param  dsi     the object that day is to be stored.
    *        day     the day of month or week
    *        period  that means the day is weekday or not
    *@return return true if the day is valid ,otherwise return false 
    */
    private static boolean setDsiDay(DdrScheduleInfo dsi, String paramday, int period){
        if(paramday.matches("^\\d+$")){
            int iDay = Integer.parseInt(paramday);
            if ((period==DDR_CRON_PERIOD_WEEKDAY && iDay >= 0 && iDay <=6)
                    ||(period==DDR_CRON_PERIOD_MONTHDAY && iDay >= 1 && iDay <=31)){
                dsi.setDay(paramday);
                return true;
            }
        }else if(paramday.matches("^\\d+(,\\d+)+$")){
            String[] monthdayNum = paramday.split(",");
            for(int i=0; i<monthdayNum.length; i++){
                int iDay = Integer.parseInt(monthdayNum[0]);
                if(period==DDR_CRON_PERIOD_WEEKDAY && (iDay < 0 || iDay > 6)){
                    return false;
                }else if (period==DDR_CRON_PERIOD_MONTHDAY  && (iDay < 1 || iDay > 31)){
                    return false;
                }
            }    
            dsi.setDay(paramday);
            return true;
    	}
    	return false;
    }
    
    /**
    * delete a schedule. 
    *@param   account  cron file's path ,normally is /var/spool/cron/DDR
    *         mvName   mv name.
    *         rvName   rv name
    *         timeStr  schedule's infomation.
    *@return  object of SoapResponse that contains delete's infomation.
    */
    public static void deleteDdrSchedule (String mvName, String rvName, String timeStr, String account,int nodeNum)throws Exception{
    	String[] cmd = {"sudo", SCRIPT_DEL_SCHEDULE, account, mvName, rvName, CRONJOB_PATH ,timeStr};
    	CmdExecBase.execCmd(cmd, nodeNum);
    }
    
    /**
    * delete multi schedules. 
    *@param   account  cron file's path ,normally is /var/spool/cron/DDR
              paramPairing   contains all mv and rv's information that is to be deleted.
    *@return  object of SoapResponse that contains delete's infomation.
    */
    public static void delDdrPairingSchedule (Vector paramPairing, String account, int nodeNum)throws Exception{
    	Vector cmd = new Vector();
    	cmd.add("sudo");
    	cmd.add(SCRIPT_DEL_DELPAIRINGSCHEDULE);
    	cmd.add(account);
    	cmd.add(CRONJOB_PATH);
    	cmd.addAll(paramPairing);
    	String[] cmds = new String[cmd.size()];
    	cmd.toArray(cmds);
    	CmdExecBase.execCmd(cmds, nodeNum);

    }

    /**
    * add one or more schedules. 
    *@param   account  cron file's path ,normally is /var/spool/cron/DDR
              data     contains all mv and rv's information that is to be added.
              dsi      the schedule's format
    *@return  object of SoapResponse that contains addition's infomation.
    */
    public static void addSchedule(DdrScheduleInfo dsi, Vector data, String account,int nodeNum)throws Exception{
    	//get the command line
    	Vector cmdInfo = ddr2Cron(data, dsi);
    	StringBuffer content= new StringBuffer();
        content.append(cmdInfo.get(0).toString());
        for(int i=1;i<cmdInfo.size();i++){
        	content.append("\n");
        	content.append(cmdInfo.get(i).toString());
        }
        String tmpFile = NFSModel.createTempFile(nodeNum, content.toString());
		
        String[] cmds = {"sudo",SCRIPT_ADD_SCHEDULE,account,tmpFile};
    	//execute cmds	
    	try{
			CmdExecBase.execCmd (cmds,nodeNum);
		}
    	finally{
    		String[] cmd_rm = {CmdExecBase.CMD_SUDO,
    	             DELETE_TEMP_FILE,tmpFile};
    		CmdExecBase.execCmdForce(cmd_rm, nodeNum, true);
    		
    	}
    }
    
    /**
    * get the information that is to be written in cron file 
    *@param   data     contains all mv and rv's information.
    *         dsi      the schedule's content
    *@return  Vector of that is to be written in cron file.
    */
    private static Vector ddr2Cron(Vector data, DdrScheduleInfo dsi){
    	String timePart,paraPart;
    	String cmdPart ="sudo /home/nsadmin/bin/ddr_cronjob.pl" ;
    	Vector vCmd = new Vector(data.size());
    	for(int i=0; i< data.size(); i++){
            String[] mvrv = data.get(i).toString().split("\\s+");			
            paraPart = dsi.getAction().equals("separate")
                ?mvrv[0]+" "+mvrv[1]+" "+dsi.getAction()+ " 2>&1 > /dev/null"
                :mvrv[0]+" "+mvrv[1]+" "+dsi.getAction()+ "\\("+dsi.getSyncMode()+"\\) 2>&1 > /dev/null";
            int period = dsi.getPeriod();
            switch(period){
            	case DDR_CRON_PERIOD_WEEKDAY:
                    timePart = dsi.getMinute() + " " + dsi.getHour() + " * * " + dsi.getDay();
                    vCmd.add(timePart+" "+cmdPart+" "+paraPart);
                    break;
            	case DDR_CRON_PERIOD_MONTHDAY:
                    timePart = dsi.getMinute() + " " +dsi.getHour() + " " + dsi.getDay() + " * *";
                    vCmd.add(timePart+" "+cmdPart+" "+paraPart);
                    break;
            	case DDR_CRON_PERIOD_DAILY:
                    timePart = dsi.getMinute() + " " +dsi.getHour() + " * * *";
                    vCmd.add(timePart+" "+cmdPart+" "+paraPart);
                    break;
            	case DDR_CRON_PERIOD_DIRECT:
                    vCmd.add(dsi.getDirectEditInfo() + " " + cmdPart + " " + paraPart);
                    break;
            }
    	}
    	return vCmd;
    }
}
