/*
 *      Copyright (c) 2001-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.fcsan.componentconf;
import java.util.*;
import java.io.*;
import java.math.BigInteger;

import com.nec.sydney.framework.*;
import com.nec.sydney.beans.fcsan.common.*;
import com.nec.sydney.beans.fcsan.componentdisp.*;
import com.nec.nsgui.model.biz.base.NSProcess;

public class  LDBindUnbindBean extends FcsanAbstractBean implements FCSANConstants
{

    private static final String     cvsid = "@(#) $Id: LDBindUnbindBean.java,v 1.2311 2008/09/09 03:22:55 pizb Exp $";


    private Map PDGroups;
    private List AllLDInfo;
    private int numberOfLD;
    private int totalNumberOfLD;
    private boolean isNetError;
    private int numberOfLVM;

    public LDBindUnbindBean()
    {
        PDGroups=new TreeMap();
        AllLDInfo=new ArrayList();
        isNetError=false;
        numberOfLVM=0;
    }
     
    public void beanProcess() throws Exception 
    {
        String action=request.getParameter("action"); 
        String diskarrayid=request.getParameter("diskarrayid");
        String arraytype=request.getParameter("arraytype");
        String diskarrayname=request.getParameter("diskarrayname");
         if (diskarrayid==null) {
                throw new Exception(NSMessageDriver.getInstance().getMessage(session,"fcsan_common/exception/invalid_param"));
          }
        if (action!=null&&action.equals("PDGroup")) {
            getPDGroup(diskarrayid);
        }
        if (action!=null&&action.equals("refresh"))  {
            FCSANRefreshBean refresh=new FCSANRefreshBean();
            if(refresh.refresh(diskarrayid)!=0)  {
                setErrMsg("<h1 class='Error'>"+NSMessageDriver.getInstance().getMessage(session,"fcsan_componentconf/common/refreshldinfo_failed")+"</h1>"+"<h2 class='Error'>"+refresh.getErrMsg()+"</h2>");
                super.setErrorCode(refresh.getErrorCode());
                setSpecialErrMsg("title","h2");
                return;
            }
        //super.response.sendRedirect(super.response.encodeRedirectURL("ldbindunbindtop.jsp?action=PDGroup&diskarrayname="+diskarrayname+"diskarrayid="+diskarrayid+"arraytype="+arraytype));
        }
        if (action!=null&&action.equals("RankInfo"))
        {
            String err = request.getParameter("ErrMsgForMiddle");
            if (err != null){
                setErrMsg(err);
                return;
            }
            String PDNo=request.getParameter("PDNo");
            if (PDNo==null || diskarrayid == null) {
                throw new Exception(NSMessageDriver.getInstance().getMessage(session,"fcsan_common/exception/invalid_param"));
            }
            PDNo = PDNo +"h";
            
            // call evalNumberOfLD()
            if (evalNumberOfLD(diskarrayid, PDNo) == 1) {
                setErrMsg("<h1 class='Error'>" + NSMessageDriver.getInstance()
                        .getMessage(session,"fcsan_componentconf/common/getldinfo_failed")
                        + "</h1>" + "<h2 class='Error'>" + getErrMsg() + "</h2>");
                setSpecialErrMsg("title","h2");
                return;
            }

            List summaryRankInfo=new Vector();
            List allRankInfo=(List)session.getAttribute(SESSION_RANK_LIST);
            TreeMap lvms = null;
            //multi-machine, get all lvm used ld numbers;
            lvms = (TreeMap)getAllLVM();
            if(getErrMsg() != null){
                setErrMsg("<h1 class='Error'>" + NSMessageDriver.getInstance()
                .getMessage(session,"fcsan_componentconf/common/getldinfo_failed")
                            + "</h1>" + "<h2 class='Error'>"
                            + getErrMsg() + "</h2>");
                setSpecialErrMsg("title","h2");   
                return;
            } else if(lvms == null) {
                isNetError = true;   
            }            

            //get all the RankNo which PD groupNo equals to the PDNo from the session . and add the rank's No into the RankNo
            //Map temp_RankInfo=new Hashtable();
            for (int i=0;i<allRankInfo.size();i++ )
            {
                DiskArrayRankInfo rankinfo=(DiskArrayRankInfo)allRankInfo.get(i);
                int LDsCount = 0;
                if (!PDNo.startsWith(rankinfo.getPDG())) {      
                    continue;
                }
                BufferedReader readbuf;
                String line="";
                StringBuffer sb = new StringBuffer();
                // *************************get PD_NO of pool****************************
                // execute the command: iSAdisklist -poolp -aid diskarrayid -pno poolno. 
                // get all PD_NO from output and put it into a vector. then put the Vector into the LDInfo.
                readbuf= super.execCmd(CMD_DISKLIST_POOLP+" "+diskarrayid+" -pno "+ rankinfo.getPoolNo());
                if (readbuf==null)
                {
                    setErrMsg("<h1 class='Error'>"+NSMessageDriver.getInstance().getMessage(session,"fcsan_componentconf/common/getldinfo_failed")+"</h1>"+"<h2 class='Error'>"+getErrMsg()+"</h2>");
                    setSpecialErrMsg("title","h2");
                    return;
                }
                line=readbuf.readLine();
                while (line!=null && !line.startsWith(SEPARATED_LINE))
                {
                    line=readbuf.readLine();
                }
                line=readbuf.readLine();
                
                Vector v_PDnumber=new Vector();
                while (line!=null)
                {
                    if (line.startsWith(DISKLIST_CMD_NAME))
                    {
                        break;
                    }
                    StringTokenizer st=new StringTokenizer(line);
                    StringTokenizer rank_number=new StringTokenizer(st.nextToken(),"-");
                    rank_number.nextToken();
                    v_PDnumber.add(rank_number.nextToken());
                    line=readbuf.readLine();
                }
                Collections.sort(v_PDnumber);
                for (int j=0;j<v_PDnumber.size() ;j++ )
                    sb.append((String)v_PDnumber.get(j)+",");
                if (sb.length()>0)
                    sb.deleteCharAt(sb.length()-1);
                
                StringBuffer sbPdNo = sb;
                // **********************get PD_NO of pool end*************************
                
                List LDInfo=new Vector();
                BigInteger free_spare=new BigInteger(rankinfo.getCapacity());
                //add the relevant DiskArrayRankInfo into the LDInfo
                LDInfo.add(rankinfo);
                readbuf=super.execCmd(CMD_DISKLIST_POOLL 
                    + " "+diskarrayid + " -pno" + " " + rankinfo.getPoolNo());
                if (readbuf==null) {
                    setErrMsg("<h1 class='Error'>"+NSMessageDriver.getInstance().getMessage(session,"fcsan_componentconf/common/getldinfo_failed")+"</h1>"+"<h2 class='Error'>"+getErrMsg()+"</h2>");
                    setSpecialErrMsg("title","h2");
                    String isReload = request.getParameter("reload");
                    if (isReload != null && isReload.equals("reload")
                        && super.getErrorCode() == iSMSM_ENTRY_OVER){
                        setErrMsg("<h2 class='title'>"+NSMessageDriver.getInstance().getMessage(session,"fcsan_componentconf/common/errmsg_reload")+"</h2>");
                    }
                    return;
                }
                List ldbind=new Vector();
                List ldbindM=new Vector();
                line=readbuf.readLine();
                while (line!=null && !line.startsWith(SEPARATED_LINE))
                {
                    line=readbuf.readLine();
                }
                line=readbuf.readLine();
                //for each output line, get the LD_NO ,LD_name ,capacity ,type.Each one is separated by " ". if the multiRANK is yes .put these information into the ldbindM.if the multiRANK is not yes. put these information into the ldbind.
                BigInteger availableSize = new BigInteger("0");
                Vector LDVector = new Vector();
                String raidType = rankinfo.getRaidType();
                int partitionNum = 1;
                int pdNumber = v_PDnumber.size();
                if (!raidType.equals(RAID_6_4PQ)
                        &&!raidType.equals(RAID_6_8PQ)){
                    partitionNum = getPoolPartitionNumber(raidType, pdNumber);
                }
                while (line!=null)
                {
                    if (line.startsWith(DISKLIST_CMD_NAME)) {
                        break;
                    }
                    
                    LDsCount++;
                    DiskArrayLDInfo ldinfo=new DiskArrayLDInfo();
                    StringTokenizer st=new StringTokenizer(line);
                    int ct = st.countTokens();
                    ldinfo.setLdNo(st.nextToken());
                    ldinfo.setType(st.nextToken());
                    ldinfo.setName(st.nextToken());
                    //judge the state is two word or not.
                    String state=st.nextToken();
                    if (ct == 10)  {
                        st.nextToken();
                    }
                    
                    st.nextToken();
                    String capacity=st.nextToken();
                    ldinfo.setCapacity(capacity);
                    st.nextToken();
                    st.nextToken();
                    sb=new StringBuffer();
                    sb.append(ldinfo.getLdNo());
                    sb.append(" ");
                    sb.append(ldinfo.getName());
                    sb.append(" ");
                    sb.append(ldinfo.getCapacity());
                    sb.append(" ");
                    sb.append(ldinfo.getType());                  
                    //if the ld is lvm used ld, append "lvm created to sb"                   
                    if(lvms != null && lvms.size() != 0 
                                    && lvms.containsKey(ldinfo.getLdNo())) {
                        sb.append(" ");                                             
                        sb.append(NSMessageDriver.getInstance()
                        .getMessage(session,"fcsan_componentconf/ldbindunbind/ld_lvm"));                        
                    }
                    ldbind.add(sb.toString());
                    line=readbuf.readLine();
                    /* modified by caoyh & hujun 2002/11/13
                    */
                    
                    if (!rankinfo.getRaidType().equals(RAID_6_4PQ)
                            &&!rankinfo.getRaidType().equals(RAID_6_8PQ)){
                        if (getLDAddr(diskarrayid, ldinfo,rankinfo.getPoolNo()) < 0 ){  
                            return;
                        }
                        
                        free_spare=free_spare.subtract(new BigInteger(capacity));
                        // get the real capacity of logic disk which contains two parts, 
                        // user-capacity and management-capacity.
                        BigInteger realLDCapacityMB = new BigInteger(capacity).divide(new BigInteger(""+1024*1024)).add(new BigInteger("2"));
                        // realLDCapacityMB divided by partition number.
                        
                        int tmp = realLDCapacityMB.intValue() % partitionNum;
                        if (tmp == 0){
                            free_spare=free_spare.subtract(new BigInteger(""+2*1024*1024));
                        }
                        else{
                            free_spare=free_spare.subtract(new BigInteger(""+( 2 + partitionNum - tmp )*1024*1024));
                        }
                        
                        
                    }
                    
                    LDVector.add(ldinfo);
                }//end of while
                /* modified by caoyh & hujun 2002/11/13
                */

                ComparatorLDInfo comparator=new ComparatorLDInfo();
                Collections.sort(LDVector,comparator);
                
                if (rankinfo.getRaidType().equals(RAID_6_4PQ) 
                        || rankinfo.getRaidType().equals(RAID_6_8PQ) ){
                    free_spare = new BigInteger(rankinfo.getRemainCapacity());
                    availableSize = new BigInteger(rankinfo.getRemainCapacity());
                    if (LDVector.size()%128==0){
                        BigInteger bi256M = new BigInteger(""+256*1024*1024);
                        free_spare = free_spare.subtract(bi256M);
                        availableSize = availableSize.subtract(bi256M);
                    }
                }else{
                    availableSize =  getAvailableLDSize(LDVector, 
                        Long.valueOf(rankinfo.getCapacity()).longValue());
                    availableSize = availableSize.subtract(new BigInteger(""+(1+partitionNum)*1024*1024));
                }
                Collections.sort(ldbind);
                Collections.sort(ldbindM);
                LDInfo.add(ldbind);
                LDInfo.add(ldbindM);
                LDInfo.add(availableSize);
                LDInfo.add(free_spare.toString());
                //if free_spare is 0,It will not be display in the logicdiskbindmiddle.jsp
                double free_spare2 = free_spare.doubleValue()/1024/1024/1024;
                //if the LD's number is 36 in a rank It will not be displayed in the logicdiskbindmiddle.jsp.
                if (availableSize.divide(new BigInteger(""+1024*1024*1024)).intValue()>=1)
                {
                    StringBuffer summaryRank=new StringBuffer();
                    summaryRank.append(rankinfo.getPoolNo());
                    summaryRank.append(" ");
                    summaryRank.append(rankinfo.getPoolName());
                    summaryRank.append(" ");
                    summaryRank.append(rankinfo.getRaidType());
                    summaryRank.append(" ");
                    summaryRank.append(availableSize+" ");
                    //modify by caoyh 9/28 
                    summaryRank.append(GetDouble(free_spare2-0.05,1));
                    //summaryRank.append(free_spare);
                    //
                    summaryRankInfo.add(summaryRank.toString());
                }
                
                LDInfo.add(sbPdNo.toString());            
                AllLDInfo.add(LDInfo);
                line=readbuf.readLine();
            }
            ComparatorRankInfo rule=new ComparatorRankInfo();
            Collections.sort(AllLDInfo,rule);
            session.setAttribute(SESSION_RANK_SUMMARY,summaryRankInfo);
            session.setAttribute(SESSION_LVM_LIST,lvms);
            if(lvms != null) 
                numberOfLVM = lvms.size();           
        }
    }   
    public List getAllLDInfo()
    {
        return AllLDInfo;
    }
    public Map getPDGroups()
    {
        return PDGroups;
    }
    private void getPDGroup(String diskarrayid) throws Exception
    {
            
            BufferedReader readbuf=super.execCmd(CMD_DISKLIST_POOL+" "+diskarrayid);
            if (readbuf==null)
            {
                setErrMsg("<h1 class='Error'>"+NSMessageDriver.getInstance().getMessage(session,"fcsan_componentconf/common/getpdgroupinfo_failed")+"</h1>"+"<h2 class='Error'>"+getErrMsg()+"</h2>");
                setSpecialErrMsg("title","h2");
                String isReload = request.getParameter("reload");
                if (isReload != null && isReload.equals("reload")
                     && super.getErrorCode() == iSMSM_ENTRY_OVER){
                    setErrMsg("<h2 class='title'>"+NSMessageDriver.getInstance().getMessage(session,"fcsan_componentconf/common/errmsg_reload")+"</h2>");
                }
                return;
            }
            List RankInfo=new Vector();
            String line=readbuf.readLine();
            while (line!=null && !line.startsWith(SEPARATED_LINE))
            {
            line=readbuf.readLine();
            }
            line=readbuf.readLine();
            while(line!=null)
            {
                if (line.startsWith(DISKLIST_CMD_NAME))
                {
                    break;
                }
                StringTokenizer st=new StringTokenizer(line);
                int count = st.countTokens();
                String No=new String(st.nextToken());
                String pdg=getPDGByPoolCLI(diskarrayid,No);
                PDGroups.put(pdg,"");
                DiskArrayRankInfo rank=new DiskArrayRankInfo();
                rank.setPoolNo(No);
                rank.setPoolName(st.nextToken());
                if (count == 10){
                    st.nextToken();  //skip state
                }
                st.nextToken();     //skip state
                rank.setRaidType(st.nextToken());
                rank.setBasePd(st.nextToken());
                //String s_capacity=st.nextToken();
                //double d_ranksize=Double.valueOf(s_capacity).doubleValue(); 
                //String s_ranksize=Double.toString(d_ranksize);
                //rank.setCapacity(s_ranksize.substring(0,s_ranksize.indexOf('.')+2));
                rank.setCapacity(st.nextToken());
                st.nextToken();
                st.nextToken();
                rank.setRemainCapacity(st.nextToken());
                rank.setPDG(pdg);
                //rank.setCapacity(s_capacity);
                //rank.setCapacity(st.nextToken());
                RankInfo.add(rank);
                line=readbuf.readLine();
               
            }
            session.setAttribute(SESSION_RANK_LIST,RankInfo);
    }

    public int getNumberOfLD() {
        return numberOfLD;
    }

    public int getTotalNumberOfLD() {
        return totalNumberOfLD;
    }

    public String getDiskArrayMonState() throws Exception
    {
        String diskarrayid=request.getParameter("diskarrayid");
        String state = super.getDiskArrayMonState(diskarrayid);
        if (state == null) {
            setErrMsg("<h1 class='Error'>"+NSMessageDriver.getInstance().getMessage(session,"fcsan_common/specialmessage/msg_getnodisk")+"</h1>"+"<h2 class='Error'>"+getErrMsg()+"</h2>");
            setSpecialErrMsg("title","h2");
        }
        return state;
    }

    /*
     *   get control path from the output of iSAdisklist -ds.
     *   return the result of execLDUsed(ip)
     *   numbers who is uesd by LVM
     */
    private Map getAllLVM() throws Exception {
        String aid = request.getParameter("diskarrayid");
        if(aid  == null || aid .equals("")) {
            throw new Exception(NSMessageDriver.getInstance()
                          .getMessage(session,"fcsan_common/exception/invalid_param"));
        }
        return execLDUsed(aid);              
    }
    /*
     *   execute rsh (control) sudo ld_used.sh to get all LD
     *   numbers who is uesd by LVM
     */
    private Map execLDUsed(String aid) throws Exception {
        Runtime run=Runtime.getRuntime();
        NSProcess proc = new NSProcess(run.exec(CMD_LD_USED));
        proc.waitFor();
        InputStreamReader read;
        BufferedReader readbuf;
        if ( proc.exitValue() == 0){
            read = new InputStreamReader(proc.getInputStream());
            readbuf = new BufferedReader(read);            
        }else{
            return null;
        }
        
        Map lvms = new TreeMap();
        String line = readbuf.readLine();
        while(line != null){
            if(!line.trim().equals("")) {
                if (line.split(":")[0].equals(aid)){
                    String temp = Integer.toString(Integer
                                     .parseInt((line.split(":"))[1].trim(),10),16);
                    int no_length = temp.length();
                    for(int i=0; i<4-no_length; i++) {
                        temp = "0" + temp;
                    }
                    temp = temp + "h";
                    lvms.put(temp,"");
                }
            }
            line = readbuf.readLine();
        }
        return lvms;              
    }
    
    public int getLVMNum(){
        return numberOfLVM;
    }
    
    public boolean getNetError() {
        return isNetError;   
    }
    
    
    /*
     *   @param aid diskarrayid
     *   @param pdg PD group
     *   get the output of "iSAdisklist -l" and read each line from the output
     *   if the ld is the the pd group, numberOfLD++
     */
    private int evalNumberOfLD(String aid, String pdg) throws Exception {

        String line = null;
        if (aid == null || pdg == null || aid.equals("") || pdg.equals("")) {
                throw new Exception(NSMessageDriver.getInstance()
                        .getMessage(session,"fcsan_common/exception/invalid_param"));          
        }
        numberOfLD = 0;
        totalNumberOfLD = 0;
        BufferedReader readbuf = super.execCmd(CMD_DISKLIST_L + " "
                        + aid );
        if (readbuf == null) {
            return 1;
        } 
        while ((line = readbuf.readLine()) != null 
            && !line.startsWith(SEPARATED_LINE));
        boolean isFirstAry = super.isFirstArray(aid);
        while ((line = readbuf.readLine()) != null 
            && !line.startsWith(DISKLIST_CMD_NAME)) {
            String[] words = line.trim().split("\\s+");
            if (pdg.startsWith(getPDGByPool(aid,words[words.length-3]))) {
                numberOfLD++;
            }
            //for lun initialization, the ld No. cannot larger than 00FFh
            int ldn = Integer.parseInt(words[0].substring(0,4), 16);
            if (isFirstAry){
                if (15 < ldn && ldn < 256){
                    totalNumberOfLD++;
                }
            }else{
                if (0 <= ldn && ldn < 256){
                    totalNumberOfLD++;
                }
            }
            
            readbuf.readLine();
        }
        return 0;
    }

    /*return the max available size*/

/* 
 *    the function returns the size between the ldNo LD and attribute "addr"
 *    modified by caoyh and hujun on Nov, 13, 2002
 */
     private long getLDAddr(String diskarrayid, DiskArrayLDInfo info,String rankno) throws Exception{
        long startAddr =0 , size = 0;
        BufferedReader readbuf = super.execCmd(CMD_DISKLIST_LPOOL + " "
                        + diskarrayid + " -nld " + info.getLdNo() );
        String line = null;

        if (readbuf == null)
        {
            setErrMsg("<h1 class='Error'>" + NSMessageDriver.getInstance()
                .getMessage(session,"fcsan_componentconf/common/getldinfo_failed")
                 + "</h1>" + "<h2 class='Error'>" + getErrMsg() + "</h2>");
            setSpecialErrMsg("title","h2");
            return -1;
        } 
        while ((line = readbuf.readLine()) != null 
            && !line.startsWith(SEPARATED_LINE));
        while ((line = readbuf.readLine()) != null 
            && !line.startsWith(DISKLIST_CMD_NAME)){            
            String[] words = line.trim().split("\\s+");
            if (!words[0].equals(rankno)){
                  continue; 
            }
            words[4] = words[4].replaceAll("h","");
            startAddr += Long.valueOf(words[4],16).longValue();
            size += Long.valueOf(words[5]).longValue();
            //return 0;
        }
        info.setPartition(size);
        info.setStartAddr(startAddr);
        return 0;
        //throw new Exception(NSMessageDriver.getInstance()
        //        .getMessage(session,"fcsan_componentdisp/common/invalid_cmd_output"));
        
    }

   private BigInteger getAvailableLDSize(Vector ldVector, long rankSize) throws Exception{
        long startAddr=0, partition=0, currentSize=0, addr =0;
        for(int i=0; i<ldVector.size(); i++) {
            startAddr = ((DiskArrayLDInfo)ldVector.get(i)).getStartAddr();
            partition = ((DiskArrayLDInfo)ldVector.get(i)).getPartition();
            currentSize = currentSize>startAddr - addr? currentSize:startAddr - addr;
            addr = startAddr + partition;
        }
        rankSize = rankSize/512;
        currentSize = currentSize>rankSize - addr? currentSize:rankSize - addr;
        return new BigInteger(""+currentSize*512);
    }
    
    /*
     * get the basic pool's partition number.
     */
    private int getPoolPartitionNumber (String raidType, int pdNum){
        // raid type is raid1 or raid5, the partition is 1.
        int partitionNum;
        
        if (raidType.equals(RAID_10)){
            partitionNum = pdNum / 2;
        }
        else if (raidType.equals(RAID_50)){
            partitionNum = pdNum / 5;
        }
        else {
            partitionNum = 1;
        }
        return partitionNum;
    }
   

    private boolean setSpecialErrMsg(String style,String size)
    {
        if (super.setSpecialErrMsg()){
            setErrMsg("<"+size+" class='"+style+"'>"+super.getErrMsg()+"</"+size+">");
            return true;
        }
        return false;
    }
    class ComparatorRankInfo implements Comparator
    {
        public int compare(Object a1,Object a2) {
            DiskArrayRankInfo rank1=(DiskArrayRankInfo)((List)a1).get(0);
            DiskArrayRankInfo rank2=(DiskArrayRankInfo)((List)a2).get(0);
            return rank1.getPoolNo().compareTo(rank2.getPoolNo());
        }
        public boolean equals(Object obj)  {
            return false;
        }    
    };
    class ComparatorLDInfo implements Comparator
    {
        public int compare(Object a1,Object a2) {
            DiskArrayLDInfo ld1=(DiskArrayLDInfo)a1;
            DiskArrayLDInfo ld2=(DiskArrayLDInfo)a2;
            return (new Long(ld1.getStartAddr())).compareTo(new Long(ld2.getStartAddr()));
        }
        public boolean equals(Object obj)  {
            return false;
        }    
    };
}
