/*
 *      Copyright (c) 2001-2009 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.fcsan.componentconf;

import java.util.*;
import javax.servlet.ServletContext;

import com.nec.nsgui.model.biz.disk.DiskHandler;
import com.nec.sydney.beans.fcsan.common.*;
import com.nec.sydney.framework.*;
import java.io.*;

import com.nec.nsgui.action.volume.*;
import com.nec.nsgui.model.entity.volume.*;

public class RankAndLDReleaseBean extends FcsanAbstractBean implements FCSANConstants, VolumeActionConst
{

    private static final String     cvsid = "@(#) $Id: RankAndLDReleaseBean.java,v 1.2309 2009/01/05 10:15:29 wanghb Exp $";


    private Vector LDNoVec;
 
    public RankAndLDReleaseBean(){}

    public void beanProcess (){}

    //Execute the command iSAdisklist -rl -aid diskarrayid -nrank rankno
    public int getLDOfRank() throws Exception
    {
        String diskarrayid=request.getParameter("diskarrayid");
        String pdgroupnumber=request.getParameter("pdgroupnumber");
        String rankno=request.getParameter("rankno");

        if(diskarrayid==null || rankno==null || pdgroupnumber == null)
        {
            NSException e = new NSException(NSMessageDriver.getInstance().getMessage(session,"fcsan_common/exception/invalid_param"));
            throw e;
        }

        String cmd=CMD_DISKLIST_POOLL+" "+diskarrayid+" -pno "+rankno;
        BufferedReader buf=execCmd(cmd);        
    
        if(buf!=null)
        {
            String resultOneLine=buf.readLine();
                
            while (resultOneLine!=null)
            {
                if (resultOneLine.startsWith(SEPARATED_LINE))
                    break;
                resultOneLine=buf.readLine();
            }
            resultOneLine=buf.readLine();

            
            String ldno;
            LDNoVec = new Vector();
            while(resultOneLine!=null)
            {
                if (!(resultOneLine.startsWith(DISKLIST_CMD_NAME)))
                {
                    StringTokenizer resultValue = new StringTokenizer(resultOneLine.trim());
                    
                    if(resultValue.countTokens()!=0)
                    {
                        ldno=resultValue.nextToken();
                        LDNoVec.add(ldno);
                    }                    
                }//end if
                resultOneLine=buf.readLine();
            }//end while
            return FCSAN_SUCCESS;    
        }//end if
        else
        {
            return 1;
        }
    }

    //Execute the command E (iSAsetrank -r -aname diskarrayname -pdg pdgroupnumber -rank rankno) 
    public int releaseRank() throws Exception
    {
        String diskarrayname=request.getParameter("diskarrayname");
        String rankno=request.getParameter("rankno"); //two byte type 00h
        String pdgroupnumber=request.getParameter("pdgroupnumber");        
        
        if(diskarrayname==null || rankno==null || pdgroupnumber==null)
        {
            NSException e = new NSException(NSMessageDriver.getInstance().getMessage(session,"fcsan_common/exception/invalid_param"));
            throw e;
        }
        
        String cmd=CMD_DISKSETPOOL_R+" "+diskarrayname+" -pname "+getPoolNameByNo(rankno)+" -restart";
        //add by maojb on 5.24 corresponding for mail 2888
        BufferedReader buf=execCmd(cmd);
            
        if(buf!=null)
        {
            return FCSAN_SUCCESS;
        }
        else
        {    
            return 1;
        }
    }
    
    public String getPoolNameByNo(String poolNo){
        Vector ranklist = (Vector)session.getAttribute(SESSION_RANK_LIST);
        DiskArrayRankInfo diskArrayRankInfo;
        int size=ranklist.size();
        
        for(int i=0; i<size;i++){
            diskArrayRankInfo=(DiskArrayRankInfo)ranklist.get(i);
            if (diskArrayRankInfo.getPoolNo().equals(poolNo)){
                return diskArrayRankInfo.getPoolName();
            }
        }
        return "";
    }    

    //Execute the command m (iSAsetld -r -aname diskarrayname -ldn ldno) several times 
//return value : 0 (success) 1(normal error) 2(in LDSet error) 3(has Port error) 4(has LVM error) 5(has LD level's pair)
    public int releaseLD() throws Exception
    {
        String diskarrayname = request.getParameter("diskarrayname");
        String diskarrayid=request.getParameter("diskarrayid");
        String ldnodetail=request.getParameter("ldnodetail");
        String flg_Force=request.getParameter("isForce");
//modify by maojb and jinkc on 12.18 for LVM bind  check
        String isMultiMachine = request.getParameter("isMultiMachine");
        if(diskarrayname == null || diskarrayid == null || ldnodetail==null || isMultiMachine==null)
        {
            NSException e = new NSException(NSMessageDriver.getInstance().getMessage(session,"fcsan_common/exception/invalid_param"));
            throw e;
        }

        if (isMultiMachine.equals("yes") && flg_Force != null && flg_Force.equals("false")) {
            String returnValue = decideLVExist(ldnodetail);
            if (returnValue == null ) {
                return 1;
            } else if (!(returnValue.equals(""))) {
                setErrMsg(NSMessageDriver.getInstance().getMessage(session,"fcsan_componentconf/rankunbindhaveldresult/haslvmmsg")+returnValue);
                return 4;
            }
        }

        String cmd;
        String[] cmds = new String[5];
        cmds[0] = "sudo";
        cmds[1] = CMD_DISKLIST;
        cmds[2] = "-l";
        cmds[3] = "-aid";
        cmds[4] = diskarrayid;

        BufferedReader buf=execCmd(cmds);
        if(buf!=null)
        {
            String resultOneLine=buf.readLine();                
            while (resultOneLine!=null)
            {
                if (resultOneLine.startsWith(SEPARATED_LINE))
                    break;
                resultOneLine=buf.readLine();
            }
            resultOneLine=buf.readLine();

            
            String ldno;
            while(resultOneLine!=null)
            {
                if (!(resultOneLine.startsWith(DISKLIST_CMD_NAME)))
                {
                    String []resultValue = resultOneLine.trim().split("\\s+");
    
                    if (resultValue.length != 0) {
                        ldno = resultValue[0];
                        resultOneLine=buf.readLine().trim();
                        if (!resultOneLine.equals(FCSAN_NOMEAN_VALUE)) {
                            if (ldnodetail.indexOf(ldno) != -1) {
                                return 2;
                            }
                        }
                    }                    
                }//end if
                resultOneLine=buf.readLine();
            }//end while
        }//end if
        else
        {
            return 1;
        }

//add by maojb on 9.10 for NO.75
//get accesscontrol        
        cmd = CMD_DISKLIST_DS+" "+diskarrayid ;
        buf = execCmd(cmd);
//accesscontrol : false (off) true (on)
        boolean accesscontrol = false;
        if (buf != null) {
            String resultOneLine=buf.readLine();
            while (resultOneLine != null) {
                if ((resultOneLine.trim().split(":")).length == 2) {
                    break;
                }
            }
            
            for (int i=0 ; i<16; i++) {
                resultOneLine = buf.readLine();
            }
            
            String []resultValue = resultOneLine.trim().split(":");
            if (resultValue[1].equals("ON")) {
                accesscontrol = true;
            }
        } else {
            return 1;
        }


        String []ldnoArray = ldnodetail.trim().split(",");
        int size = ldnoArray.length;

        if (accesscontrol) {
            for (int i=0 ; i<size; i++) {
                cmd = CMD_DISKLIST_LAP+" "+diskarrayid+" -nld "+ldnoArray[i];
                buf = execCmd(cmd);
                if (buf == null) {
                    return 1;
                } else {
                    String resultOneLine;
                    String []resultValue;
                    while ((resultOneLine=buf.readLine())!=null 
                            && !(resultOneLine.startsWith(SEPARATED_LINE)));
                
                    while ((resultOneLine=buf.readLine())!=null) {
                        resultValue = resultOneLine.trim().split("\\s+");
                        if (resultValue.length == 5 && resultValue[2].equals("Port")) {
                                return 3;
                        }
                    }
                }
            }
        }
        
        for (int i=0 ; i<size; i++)
        {
            cmd=CMD_DISKSETLD_R+" "+diskarrayname+" -ldn ";
            cmd = cmd + ldnoArray[i];
            if(flg_Force != null && flg_Force.equals("false")){
                execCmd(CMD_DELLUN + " " + diskarrayid + " " 
                        + Integer.parseInt(ldnoArray[i].substring(0, 4), 16));	
            }
            buf=execCmd(cmd);
            if(buf==null){
                cmd=CMD_DISKSETMON_START+" "+diskarrayid;
                execCmd(cmd);
                // check if pair is set on LD
                Vector <String> errLdNoVec = new Vector <String> ();
                errLdNoVec.add(ldnoArray[i]);
                if (hasPairedLds(errLdNoVec)) {
                	return 5;
                }
                return 1;
            }
        }//end for
        super.execCmd(SCRIPT_RESTART_ISMSVR);
        
        return FCSAN_SUCCESS;
    }

    public Vector getLDNoVec()
    {
        return LDNoVec;
    }
    
    public boolean hasPairedLds(Vector ldNoVec)throws Exception{
        String diskArrayName = request.getParameter("diskarrayname");;
        Map <String, String> pairedLdsMap = DiskHandler.getPairedLdMap(diskArrayName);
        for (int i=0; i<ldNoVec.size(); i++) {
            String ldNo = (String)ldNoVec.get(i);
            if(pairedLdsMap.containsKey(ldNo)){
                return true;
            }
        }
        return false;
    }
    
    public boolean hasVolCreatingInfoOnPool() throws Exception{
        String diskarrayname = request.getParameter("diskarrayname");
        String rankno = request.getParameter("rankno");
        String[] poolList;
        try{
            poolList = DiskHandler.getRankhasVolCreating(diskarrayname);
            if (poolList!=null && poolList.length != 0){
            	for(int i=0;i<poolList.length; i++) {
            		if (poolList[i].equalsIgnoreCase(rankno)) {
            			return true;
            		}
            	}          
            }    
        }catch (Exception e) {
            return true;
        }        
        return false;
    }
    
    public boolean hasBatchVolCreatingInfoOnPool() throws Exception{
        String rankno = request.getParameter("rankno");
        try{
        	ServletContext application = request.getSession().getServletContext();
        	Vector volumeInfoVec = (Vector)application.getAttribute(APPLICATION_VOLUME_VOLUMEINFO);
        	if (volumeInfoVec==null) {
        		return false;
        	}else{
        		VolumeInfoBean volumeInfoBean;
        		for(int i = 0; i < volumeInfoVec.size(); i++) {
        			volumeInfoBean = (VolumeInfoBean)volumeInfoVec.get(i);
        			if(volumeInfoBean.getStatus().equals("msg.volume.status.processing") && volumeInfoBean.getPoolNo().indexOf(rankno) != -1) {
        				return true;
        			}
        		}
        	}
        }catch (Exception e){
        	return true;
        }
        
        return false;
    }
}