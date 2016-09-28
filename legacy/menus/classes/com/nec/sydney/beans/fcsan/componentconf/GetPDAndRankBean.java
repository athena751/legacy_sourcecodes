/*
 *      Copyright (c) 2001-2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.fcsan.componentconf;

import java.util.*;
import com.nec.sydney.beans.fcsan.common.*;
import com.nec.sydney.framework.*;
import java.io.*;

public class GetPDAndRankBean extends FcsanAbstractBean implements FCSANConstants
{

    private static final String     cvsid = "@(#) $Id: GetPDAndRankBean.java,v 1.2306 2005/12/16 06:43:15 wangli Exp $";


    private Vector PDGroupNoVec;
    private boolean success;
    //private boolean hasLargerPDNo;    delete mirror mode by wangli on 2005.9.13

    public GetPDAndRankBean ()
    {
        success=true;
    //    hasLargerPDNo=false;
    }

    public void beanProcess () throws Exception
    {
        int returnValue=getPDAndSetPDGroupNoVec();
        if (returnValue!=FCSAN_SUCCESS)
        {
            success=false;
            return;
        }
        
        returnValue=getRank();
        if(returnValue!=FCSAN_SUCCESS)
        {
            success=false;
            return;
        }
        //delete mirror mode by wangli on 2005.9.13
        /*
        returnValue=checkModel();
        if(returnValue!=FCSAN_SUCCESS){
            success=false;
            return;   
        }*/
    }

    public Vector getPDGroupNoVec ()
    {
        return PDGroupNoVec;
    }


    public boolean getSuccess()
    {
        return success;
    }

//The private function executes the command : iSAdisklist -p -aid diskarrayid
    private int getPDAndSetPDGroupNoVec() throws Exception
    {
        String diskarrayid = request.getParameter("diskarrayid");
        
        if (diskarrayid==null)
        {
            NSException e = new NSException(NSMessageDriver.getInstance().getMessage(session,"fcsan_common/exception/invalid_param"));
            throw e;
        }

        String cmd = CMD_DISKLIST_P+" "+diskarrayid;
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

            int count;
            Vector PDList = new Vector();
            PDGroupNoVec = new Vector();

            String pdno;
            while(resultOneLine!=null)
            {
                if (!(resultOneLine.startsWith(DISKLIST_CMD_NAME))) {
                    StringTokenizer resultValue = new StringTokenizer(resultOneLine.trim());
                    count = resultValue.countTokens();

                    DiskArrayPDInfo diskArrayPDInfo=new DiskArrayPDInfo();
                    StringBuffer tmpState;
                        
                    pdno=resultValue.nextToken();
                    setPDGroupNoVec(pdno.substring(0,2));
                    String pdgroupnumber = request.getParameter("pdgroupnumber");
                    pdgroupnumber = (pdgroupnumber==null ||pdgroupnumber.equals("null") )?"00":pdgroupnumber;                    
                    //delete mirror mode by wangli on 2005.9.13
                    /*int PDNo_int = Integer.parseInt(pdno.substring(4,6),16);
                    if (pdno.startsWith(pdgroupnumber)&&PDNo_int>=0x80){
                        hasLargerPDNo=true;
                    }*/ 
                    diskArrayPDInfo.setPdNo(pdno);
                    if (count==9) {
                        diskArrayPDInfo.setState(resultValue.nextToken());
                    }
                    if(count==10) {
                        tmpState=new StringBuffer();
                        tmpState.append(resultValue.nextToken());
                        tmpState.append(" ");
                        tmpState.append(resultValue.nextToken());
                        diskArrayPDInfo.setState(tmpState.toString());
                    }
                        
                    diskArrayPDInfo.setCapacity(resultValue.nextToken());
                    diskArrayPDInfo.setPoolNo(resultValue.nextToken());
                    diskArrayPDInfo.setPoolName(resultValue.nextToken());
                    diskArrayPDInfo.setPdDivision(resultValue.nextToken());

                    PDList.add(diskArrayPDInfo);
                }//end if
                resultOneLine=buf.readLine();
            }//end while
            sortVector(PDList,"pd");
            //setPDGroupNoVec(PDGroupNoVecTmp);
            Collections.sort(PDGroupNoVec);
            session.setAttribute(SESSION_PD_LIST,PDList);
            return FCSAN_SUCCESS;
        }//end if
        else
        {    
            return 1;
        }
        
    }

//The private function executes the command : iSAdisklist -pool -aid diskarrayid
    private int getRank() throws Exception
    {
        String diskarrayid = request.getParameter("diskarrayid");
        
        if (diskarrayid==null)
        {
            NSException e = new NSException(NSMessageDriver.getInstance().getMessage(session,"fcsan_common/exception/invalid_param"));
            throw e;
        }

        String cmd = CMD_DISKLIST_POOL+" "+diskarrayid;
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

            int count;
            Vector RankList = new Vector();
            while(resultOneLine!=null) {
                if (!(resultOneLine.startsWith(DISKLIST_CMD_NAME))) {
                    StringTokenizer resultValue = new StringTokenizer(resultOneLine.trim());
                    count=resultValue.countTokens();

                    DiskArrayRankInfo diskArrayRankInfo=new DiskArrayRankInfo();
                    StringBuffer tmpState;
                
                    diskArrayRankInfo.setPoolNo(resultValue.nextToken());
                    diskArrayRankInfo.setPoolName(resultValue.nextToken());
                    tmpState=new StringBuffer(resultValue.nextToken());                        

                //the variable flag(true):the state has space , 
                //flag(false):the state has no space.
                    if(count==10) {
                        tmpState.append(" ");
                        tmpState.append(resultValue.nextToken());
                    }

                    diskArrayRankInfo.setType(tmpState.toString());        
                    diskArrayRankInfo.setRaidType(resultValue.nextToken());
                    diskArrayRankInfo.setBasePd(resultValue.nextToken());
                    diskArrayRankInfo.setCapacity(resultValue.nextToken());
                    diskArrayRankInfo.setProgression(resultValue.nextToken());

                    diskArrayRankInfo.setRebuildingTime(resultValue.nextToken());
                    diskArrayRankInfo.setRemainCapacity(resultValue.nextToken());
                    diskArrayRankInfo.setPDG(getPDGByPoolCLI(diskarrayid,diskArrayRankInfo.getPoolNo()));
                    RankList.add(diskArrayRankInfo);
                }//end if
                resultOneLine=buf.readLine();
            }//end while
            sortVector(RankList,"rank");
            session.setAttribute(SESSION_RANK_LIST,RankList);
            return FCSAN_SUCCESS;
        }//end if
        else
        {
            return 1;
        }
    }

    private void sortVector(Vector vectorValue , String keyword)
    {
        if(vectorValue.size()==0)
        {
            return;
        }
        if (keyword.equals("pd"))
        {
            Collections.sort(vectorValue, new Comparator(){
                        public int compare(Object a, Object z){
                          DiskArrayPDInfo info1 = (DiskArrayPDInfo)a;
                            DiskArrayPDInfo info2 = (DiskArrayPDInfo)z;
                            return info1.getPdNo().compareTo(info2.getPdNo());
                        }
                       });
        }
        if (keyword.equals("rank"))
        {
            Collections.sort(vectorValue, new Comparator(){
                        public int compare(Object a, Object z){
                          DiskArrayRankInfo info1 = (DiskArrayRankInfo)a;
                            DiskArrayRankInfo info2 = (DiskArrayRankInfo)z;
                            return info1.getPoolNo().compareTo(info2.getPoolNo());
                        }
                       });
        }
    }
    
//delete all same elements
    private void setPDGroupNoVec(String pdgroupno)
    {        
        int size=PDGroupNoVec.size();
        //PDGroupNoVec=new Vector();
        for (int i = 0 ; i<size; i++) {
            if(pdgroupno.equals((String)PDGroupNoVec.get(i))) {
                return;
            }
        }

        PDGroupNoVec.add(pdgroupno);       
    }

    public String getDiskArrayMonState() throws Exception
     {
      String diskarrayid=request.getParameter("diskarrayid");
      String cmd = CMD_DISKLIST_DS+" "+diskarrayid;
      BufferedReader buf=execCmd(cmd);
      if(buf!=null)
      {
       int count=0;
       for (int i=0;i<4 ;i++ )
        buf.readLine();
       StringTokenizer st=new StringTokenizer(buf.readLine(),":");
       st.nextToken();
       return NSMessageDriver.getInstance().getMessage(session,"fcsan_hashvalue/hashvalue/"+st.nextToken());
      } 
        success=false;
      return null;
     }
     
    //delete mirror mode by wangli on 2005.9.13
    /*
     private int checkModel() throws Exception{
        String cmd = CMD_SUDO + " " + CMD_CHECK_MODEL;
        BufferedReader buf = execCmd(cmd);
        if (buf!=null){
            String result = buf.readLine();
            if (!hasLargerPDNo && result.equals("1")){
                session.setAttribute(SESSION_DISK_MODEL,"2");   
            } else{
                session.setAttribute(SESSION_DISK_MODEL,result);
            }
            return 0;   
        }
        return 1;
     }
     */
}