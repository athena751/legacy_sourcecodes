/*
 *      Copyright (c) 2001-2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.fcsan.componentconf;

import java.text.NumberFormat;
import java.util.*;

import com.nec.sydney.beans.fcsan.common.*;
import com.nec.sydney.framework.*;

import java.io.*;
import java.math.BigInteger;

public class PDAndRankListBean extends FcsanAbstractBean implements FCSANConstants
{

    private static final String     cvsid = "@(#) $Id: PDAndRankListBean.java,v 1.2304 2005/09/29 08:20:00 liyb Exp $";


    private Vector PDStringVec;
    private Vector PDColorVec;
    private Vector PDStringTipVec;

    private Vector rankStringVec;
    private Vector rankStringTipVec;
    private Vector rankPDStringVec;

    private String pdgroupnumber;
    
//eight flags , they show the button's style.
    private boolean rankbind;
    private boolean rankunbind;
    private boolean rankexpand1;
    private boolean rankexpand2;
    private boolean rebuildingtimechange;
    private boolean poolnamechange;
    private boolean sparebind;
    private boolean spareunbind;

    private String sortRankPDString(Vector rankPDStringV)
    {
       /* StringTokenizer st = new StringTokenizer(rankPDString,":");
        int count = st.countTokens();
        Vector tmpVec = new Vector();
        for (int i=0;i<count;i++)
        {
            tmpVec.add(st.nextToken());
        }*/
        /*Collections.sort(tmpVec, new Comparator(){
                        public int compare(Object a, Object z){
                              String info1=(String)a;
                    String info2=(String)z;
                    
                    
                                return info1.compareTo(info2);
                        }
                       });*/
        Collections.sort(rankPDStringV);
        int count = rankPDStringV.size();
        
        String returnValue = new String();
        for(int i=0;i<count;i++)
        {
            returnValue=returnValue+rankPDStringV.get(i);
            returnValue=returnValue+":";
        }
        return returnValue;
    }
    public PDAndRankListBean()
    {
        rankbind=false;
        rankunbind=false;
        rankexpand1=false;
        rankexpand2=false;
        rebuildingtimechange=false;
        poolnamechange=false;
        sparebind=false;
        spareunbind=false;
    }

    public void beanProcess() throws Exception 
    {
        pdgroupnumber = request.getParameter("pdgroupnumber");
        
        if (pdgroupnumber==null)
        {
            NSException e = new NSException(NSMessageDriver.getInstance().getMessage(session,"fcsan_common/exception/invalid_param"));
            throw e;
        }
        /*if(pdgroupnumber.equals("none"))
        {
            Vector pdlist=(Vector)session.getAttribute(SESSION_PD_LIST);
            DiskArrayPDInfo diskArrayPDInfo=(DiskArrayPDInfo)pdlist.get(0);
            String pdno=diskArrayPDInfo.getPdNo();
            pdgroupnumber=pdno.substring(0,2);
        }*/
    }

    //set three Vectors:PDStringVec,PDStringTipVec,PDColorVec
    public void setPDVec()
    {
        PDStringVec = new Vector();
        PDStringTipVec = new Vector();
        PDColorVec = new Vector();

        Vector pdlist = (Vector)session.getAttribute(SESSION_PD_LIST);
        
        //convert pdgroupnumber into int 
        int pdgroupnumberInt = Integer.parseInt(pdgroupnumber,16);
        
        //temporary variable;
        String pdgroupnumberTmp;
        DiskArrayPDInfo diskArrayPDInfo;
        //boolean searchStart=true;
        //boolean searchEnd=false;        
        int positionStart=-1;
        //int positionEnd=-1;

        int size=pdlist.size();
        int positionEnd=size-1;
        if (size!=0)
        {
            for(int i=0;i<size;i++)
            {
                diskArrayPDInfo=(DiskArrayPDInfo)pdlist.get(i);
                pdgroupnumberTmp=diskArrayPDInfo.getPdNo().substring(0,2);
            
/*                if((Integer.parseInt(pdgroupnumberTmp,16)==pdgroupnumberInt)&&searchStart)
                {
                    positionStart=i;
                    searchStart=false;
                    searchEnd=true;
                }
                if((Integer.parseInt(pdgroupnumberTmp,16)==pdgroupnumberInt)&&searchEnd)
                {
                    positionEnd=i;
                }
                if((Integer.parseInt(pdgroupnumberTmp,16)!=pdgroupnumberInt)&&searchEnd)
                {
                    break;
                }*/
                //modified by caoyh sep.5
                int tmp_pdg = Integer.parseInt(pdgroupnumberTmp,16);
                if (positionStart == -1 && tmp_pdg == pdgroupnumberInt ){
                        positionStart = i;
                }
                if(tmp_pdg > pdgroupnumberInt ) {
                    positionEnd = i-1;
                    break;
                }
            
        }//end for
               
            //Get the count to be displayed (PDStringVec's size)
            diskArrayPDInfo=(DiskArrayPDInfo)pdlist.get(positionEnd);
            String pdnumber=diskArrayPDInfo.getPdNo().substring(4,5);
            int pdnumberInt=Integer.parseInt(pdnumber,16);

            int count=pdnumberInt*16+14;
        
            StringBuffer tip;
            for(int i=0;i<=count;i++)
            {
                if(positionStart>positionEnd)
                {
                    //modified by hujun sep.5
                    //for (;i<=count;i++)
                    //{
                    PDStringVec.add("##");
                    PDStringTipVec.add(NSMessageDriver.getInstance().getMessage(session,"fcsan_componentconf/ranksparemiddleleft/nopd"));
                    PDColorVec.add("#FFFFFF");
                    continue;
                    //}
                    //break;
                }

                diskArrayPDInfo=(DiskArrayPDInfo)pdlist.get(positionStart);
                pdnumber=diskArrayPDInfo.getPdNo().substring(4,6);
                pdnumberInt=Integer.parseInt(pdnumber,16);
            
                if((i+1)%16==0)
                {
                    continue;
                }        
                
                if(pdnumberInt>i)
                {
                    PDStringVec.add("##");
                    PDStringTipVec.add(NSMessageDriver.getInstance().getMessage(session,"fcsan_componentconf/ranksparemiddleleft/nopd"));
                    PDColorVec.add("#FFFFFF");
                }
                else
                {
                    //PDStringVec.add(diskArrayPDInfo.getPdNo().substring(4,6));
                    PDStringVec.add(pdnumber);
                    tip = new StringBuffer(diskArrayPDInfo.getPdNo());
                    tip.append(":");
                    tip.append("\n");
                    //Add by maojb on 5.14, sperate capacity with ","
                    String capacity = diskArrayPDInfo.getCapacity();
                    StringBuffer capacityTmp = new StringBuffer(capacity);
                    for(int j=capacity.length()-3;j>0;j=j-3)
                    {
                        capacityTmp.insert(j,",");
                    }
                    tip.append(capacityTmp.toString());
                    //end
                    
                    //tip.append("byte");
                    tip.append(NSMessageDriver.getInstance().getMessage(session,"fcsan_common/label/unit_bytes"));                    

                    PDStringTipVec.add(tip.toString());
        
                    if ((diskArrayPDInfo.getPdDivision()).equals("data"))
                        PDColorVec.add("#00FF00");
                    else if ((diskArrayPDInfo.getPdDivision()).equals("spare"))
                    {
                        PDColorVec.add("#FFFF33");
                        spareunbind=true;
                    }
                    else
                    {
                        PDColorVec.add("#FFFFFF");
                        rankbind=true;
                        rankexpand1=true;
                        //sparebind=true;
                    }
                    positionStart++;
                }//end else
            }//end for

//add by maojb on 8.23 for dealing with only two spares existing in one DE.
            if (rankbind) {
                decideSparebind();
            }
        }
    }

    private void decideSparebind() {
//session pdlist is null , don't deal with here
        if ( PDColorVec == null || PDColorVec.size() == 0 ) {
            return;
        }

        int count = PDColorVec.size()/15;
//PDColorVec.size() should be the value of 15*x
        if (count == 0) {
            return;
        }

        int spareCount = 0;
        int noneCount = 0;
        for (int i=0 ; i<count; i++) {
            for (int j=0; j<15; j++) {
                if (((String)PDColorVec.get(i*15+j)).equals("#FFFF33")) {
                    spareCount++;
                } else if (((String)PDColorVec.get(i*15+j)).equals("#FFFFFF") && !((String)PDStringVec.get(i*15+j)).equals("##")) {
                    noneCount++;
                }
            }
            if (spareCount<2 && noneCount>0 ) {
                sparebind = true;
                return;
            } else {
                spareCount = 0;
                noneCount = 0;
            }
        }
       // sparebind = false;
    }

    //set two Vectors: rankStringVec , rankStringTipVec
    //the function is used by more than one jsp : ranksparemiddleright.jsp and rankunbind.jsp
    public void setRankVec()throws Exception
    {
        rankStringVec = new Vector();
        rankStringTipVec = new Vector();
        
        Vector ranklist = (Vector)session.getAttribute(SESSION_RANK_LIST);
        
        //convert pdgroupnumber into int 
        //int pdgroupnumberInt = Integer.parseInt(pdgroupnumber,16);
        //temporary variable
        String pdgroupnumberTmp;
        String ranknumber;
        StringBuffer tip;
        DiskArrayRankInfo diskArrayRankInfo;
        boolean in=false;
        int size=ranklist.size();
        
        for(int i=0; i<size;i++)
        {
            diskArrayRankInfo=(DiskArrayRankInfo)ranklist.get(i);
            pdgroupnumberTmp=getPDGByPool(request.getParameter("diskarrayid"), 
                    diskArrayRankInfo.getPoolNo());
            
            //if(Integer.parseInt(pdgroupnumberTmp,16)==pdgroupnumberInt)
            if(pdgroupnumberTmp.equals(pdgroupnumber))
            {
                in=true;
                String raidType = diskArrayRankInfo.getRaidType();
                ranknumber=diskArrayRankInfo.getPoolNo();
                tip=new StringBuffer(diskArrayRankInfo.getPoolName());
                tip.append(":RAID");
                tip.append(raidType);
                tip.append("\n");
                //Add by maojb on 5.14, sperate capacity with ","
                String capacity = diskArrayRankInfo.getCapacity();
                StringBuffer capacityTmp = new StringBuffer(capacity);
                for(int j=capacity.length()-3;j>0;j=j-3)
                {
                    capacityTmp.insert(j,",");
                }
                tip.append(capacityTmp.toString());
                //end
            
                //tip.append("byte");
                tip.append(NSMessageDriver.getInstance().getMessage(session,"fcsan_common/label/unit_bytes"));

                rankStringVec.add(ranknumber);
                rankStringTipVec.add(tip.toString());
                
                rankunbind=true;
                rebuildingtimechange=true;
                poolnamechange=true;
                
                
                if(raidType.equals(RAID_6_4PQ) || raidType.equals(RAID_6_8PQ))
                {
                    rankexpand2=true;
                }
            }
            //if((Integer.parseInt(pdgroupnumberTmp,16)!=pdgroupnumberInt)&&in)
            if((!(pdgroupnumberTmp.equals(pdgroupnumber)))&&in)
            {
                break;
            }
        }//end for
    }
    
    //add by maojb on 10.28 for defect-206
    //delete the rank which contains 00h-0fh LD in rankStringVec
    public int delSpecialRank() throws Exception {
        if (rankStringVec == null  || rankStringVec.size() == 0) {
            return 0;
        } 

        String diskarrayid = request.getParameter("diskarrayid");
        String cmd=CMD_DISKLIST_L+" "+diskarrayid;

        BufferedReader buf=execCmd(cmd);
        if(buf!=null){
            String resultOneLine; 
            while ((resultOneLine=buf.readLine())!=null)
            {
                if (resultOneLine.startsWith(SEPARATED_LINE))
                    break;
            }    
            resultOneLine=buf.readLine();
                    
            while (resultOneLine!=null) {
                StringTokenizer resultValue = new StringTokenizer(resultOneLine);
                int count=resultValue.countTokens();
                if (count != 1 && count != 2)
                {
                    if (count!=11 && count!=12)
                    {
                        NSException e = new NSException(NSMessageDriver.getInstance().getMessage(session,"fcsan_componentdisp/common/invalid_cmd_output"));
                        throw e;
                    } else {
                        String ldno = resultValue.nextToken();
                        ldno = ldno.substring(0 , ldno.length()-1);
                        int ldnoInt = Integer.parseInt(ldno , 16);
                        if (ldnoInt >= 0 && ldnoInt <= 15) {
                            resultValue.nextToken();    //skip type
                            resultValue.nextToken();    //skip ldname
                            resultValue.nextToken();    //skip state
                            if (count == 12) {
                                resultValue.nextToken(); //skip state
                            }
                            resultValue.nextToken();
                            resultValue.nextToken();
                            resultValue.nextToken();
                            resultValue.nextToken();
                            
                            String poolno = resultValue.nextToken();
                            String now_pdgroup = getPDGByPool(diskarrayid, poolno);

                            if (now_pdgroup.equals(pdgroupnumber)) {
                                rankStringVec.remove(poolno);
                            }

                            resultOneLine = buf.readLine();
                        } else {
                            resultOneLine = buf.readLine();
                        }
                    }
                } else {
                    resultOneLine = buf.readLine();
                }
            }   //end while
            return 0;
        } else {
            return 1;
        }
    }

    //set rankPDStringVec 
    public int setRankPDVec() throws Exception
    {
        rankPDStringVec = new Vector();
        
        int size = rankStringVec.size();
        
        String cmd;
        String diskarrayid=request.getParameter("diskarrayid");
            
        if (diskarrayid==null)
        {
            NSException e = new NSException(NSMessageDriver.getInstance().getMessage(session,"fcsan_common/exception/invalid_param"));
            throw e;
        }

        for(int i=0;i<size;i++)
        {

            cmd=CMD_DISKLIST_POOLP+" "+diskarrayid+" "+"-pno"+" "+rankStringVec.get(i);

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

                //int count;
                String rankPDString;
                Vector rankPDStringV = new Vector();
                while(resultOneLine!=null)
                {
                    if (!(resultOneLine.startsWith(DISKLIST_CMD_NAME)))
                    {
                        StringTokenizer resultValue = new StringTokenizer(resultOneLine.trim());
                        //count=resultValue.countTokens();

                        //rankPDString=rankPDString+resultValue.nextToken().substring(4,6);
                        //rankPDString=rankPDString+":";
                        rankPDStringV.add(resultValue.nextToken().substring(4,6));                        
                    }//end if
                    resultOneLine=buf.readLine();
                }//end while
                //if(rankPDString.length()!=0)
                if (rankPDStringV.size() != 0)
                {
                    rankPDString=sortRankPDString(rankPDStringV);
                    rankPDStringVec.add(rankPDString);
                }
            }//end if
            else
            {
                if (errorCode == FCSANConstants.iSMSM_ARG_ERR) {
                    specialErrMsgHash.put(new Integer(FCSANConstants.iSMSM_ARG_ERR) 
                            ,NSMessageDriver.getInstance()
                            .getMessage(session,"fcsan_componentconf/alert/alert_reload"));
                }
                return 1;
            }
            
        }//end for
        return FCSAN_SUCCESS;
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

    //get function
    public Vector getPDStringVec()
    {
        return PDStringVec;
    }

    public Vector getPDStringTipVec()
    {
        return PDStringTipVec;
    }

    public Vector getPDColorVec()
    {
        return PDColorVec;
    }

    public Vector getRankStringVec()
    {
        return rankStringVec;
    }

    public Vector getRankStringTipVec()
    {
        return rankStringTipVec;
    }

    public Vector getRankPDStringVec()
    {
        return rankPDStringVec;
    }

    public String getPdgroupnumber()
    {
        return pdgroupnumber;
    }

    public boolean getRankbind()
    {
        return rankbind;
    }
    public boolean getRankunbind()
    {
        return rankunbind;
    }
    public boolean getRankexpand1()
    {
        return rankexpand1;
    }
    public boolean getRankexpand2()
    {
        return rankexpand2;
    }
    public boolean getRebuildingtimechange()
    {
        return rebuildingtimechange;        
    }
    public boolean getPoolnamechange()
    {
        return poolnamechange;        
    }
    public boolean getSparebind()
    {
        return sparebind;
    }
    public boolean getSpareunbind()
    {
        return spareunbind;
    }
}