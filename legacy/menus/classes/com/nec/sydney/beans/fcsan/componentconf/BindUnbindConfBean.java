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
import com.nec.sydney.framework.*;
import com.nec.sydney.beans.fcsan.common.*;
import com.nec.nsgui.action.disk.DiskCommon;
import com.nec.nsgui.model.biz.disk.DiskHandler;

public class BindUnbindConfBean extends FcsanAbstractBean implements FCSANConstants
{

    private static final String     cvsid = "@(#) $Id: BindUnbindConfBean.java,v 1.2314 2008/11/26 09:18:09 chenb Exp $";


    private List ldnum;
    private List ldnameVec;
    private boolean success=true;
    public BindUnbindConfBean() {}
    public boolean isSuccess()
    {
        return success;
    }
    /*
        the doGetLDNums() are called by getLDNo() and getUnUsedLDNum()
        when the parameter type is "all",it means get all ld's info.
        when the parameter type is "pdgroup", it means get the ld's info 
        according to the pdgroup's NO.
    */
    private boolean doGetLDNums(String type) throws Exception
    {
        String diskarrayid=request.getParameter("diskarrayid");
        String pdgroup=request.getParameter("pdnum");
        if (diskarrayid==null || pdgroup==null)
        {
            throw new NSException(NSMessageDriver.getInstance().getMessage(session,"fcsan_common/exception/invalid_param"));
        }
        BufferedReader readbuf=super.execCmd(CMD_DISKLIST_L+" "+diskarrayid);
        if (readbuf==null)
        {
            super.setErrMsg("<h1 class='popupError'>"+NSMessageDriver.getInstance().getMessage(session,"fcsan_componentconf/common/getldinfo_failed")+"</h1>"+"<h2 class='popupError'>"+super.getErrMsg()+"</h2>");
            setSpecialErrMsg("popup","h2");
            success=false;
            return false;
        }
        ldnum = new Vector();
        ldnameVec = new Vector();
        String line=readbuf.readLine();
        while ((line!=null) && !line.startsWith(SEPARATED_LINE))
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
            String[] words = line.trim().split("\\s+");
            if (type.equals("all") || 
                    (type.equals("pdgroup") && pdgroup.startsWith(getPDGByPool(diskarrayid, words[words.length-3])))) {
                ldnum.add(words[0]);
                ldnameVec.add(words[2]);
            }
           //the information about a LD,contains two line as a recorder.
            line=readbuf.readLine();
            //if (line!=null)
            //{
                line=readbuf.readLine();
            //}
        }
        if (ldnum.size()==0)
        {
            super.setErrMsg(NSMessageDriver.getInstance().getMessage(session,"fcsan_componentconf/logicdiskunbind/nold"));
        }
        return true;
    }
    public void beanProcess() throws Exception
    {
        
    }
    public void LDUnbind() throws Exception
    {
        String diskarrayname =request.getParameter("diskarrayname");
        String diskarrayid=request.getParameter("diskarrayid");
        String arraytype = request.getParameter("arraytype");
        String LDNo=request.getParameter("LDNo");
        if (diskarrayname==null || LDNo==null || arraytype==null)
        {
            throw new NSException(NSMessageDriver.getInstance().getMessage(session,"fcsan_common/exception/invalid_param"));
        }
        
        //judge that if the ld is used by a LV.  2002.12.19, add by zhangjx
        //int diskarraytype = Integer.valueOf(arraytype .substring(0,arraytype.length()-1),16).intValue();
        //if (diskarraytype >=0x50 && diskarraytype <=0x6f) {
            String usedld = decideLVExist(LDNo);  
            if (usedld == null || !usedld.equals("")) {
                //decideLVExist function error
                if (usedld != null) {
                    super.setErrMsg("<h1 class='popup'>"+NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"</h1>"+"<h2 class='popup'>"+ NSMessageDriver.getInstance().getMessage(session,"fcsan_componentconf/logicdiskunbind/unbind_failed_lvm")  + usedld+"</h2>");                      
                } else if (super.setSpecialErrMsg()) {
                    super.setErrMsg("<h1 class='popup'>"+NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"</h1>"+"<h2 class='popup'>"+super.getErrMsg()+"</h2>");                           
                } else {
                    super.setErrMsg("<h1 class='popupError'>"+NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"</h1>"+"<h2 class='popupError'>"+super.getErrMsg()+"</h2>");                                                
                }
                success = false;
                return;   
            }
        //}      
        
        //judge that if the ld could be unbind
        BufferedReader readbuf = super.execCmd(CMD_DISKLIST_LAL+" "+diskarrayid+" -nld "+LDNo);
        if (readbuf == null) {            
            super.setErrMsg("<h1 class='popupError'>"+NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"</h1>"+"<h2 class='popupError'>"+super.getErrMsg()+"</h2>");
            if(super.setSpecialErrMsg()) 
               super.setErrMsg("<h1 class='popup'>"+NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"</h1>"+"<h2 class='popup'>"+super.getErrMsg()+"</h2>");
            success=false;
            return;
        }        
        String line ;
        while ((line = readbuf.readLine()) != null && !line.startsWith(SEPARATED_LINE) ) ;
        if (!(line = readbuf.readLine()).startsWith(DISKLIST_CMD_NAME)) {
            super.setErrMsg("<h1 class=\"popup\">"+NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"</h1>"+"<h2 class=\"popup\">"+NSMessageDriver.getInstance().getMessage(session,"fcsan_componentconf/logicdiskunbind/unbind_failed_inldset")+"</h2>");
            success=false;
            return;
        }
        
        readbuf = super.execCmd(CMD_DISKLIST_DS + " " + diskarrayid);
        if(readbuf == null) {
            super.setErrMsg("<h1 class='popupError'>"+NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"</h1>"+"<h2 class='popupError'>"+super.getErrMsg()+"</h2>");
            if(super.setSpecialErrMsg()) 
                super.setErrMsg("<h1 class='popup'>"+NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"</h1>"+"<h2 class='popup'>"+super.getErrMsg()+"</h2>");
            success=false;
            return; 
        }
    
        while ((line = readbuf.readLine()) != null && !line.startsWith(DISKLIST_CMD_NAME) ) {

            if(line.startsWith("Access") && line.endsWith("ON")) {
                readbuf = super.execCmd(CMD_DISKLIST_LAP+" "+diskarrayid+" -nld "+LDNo);
                if(readbuf == null) {
                    super.setErrMsg("<h1 class='popupError'>"+NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"</h1>"+"<h2 class='popupError'>"+super.getErrMsg()+"</h2>");
                    if(super.setSpecialErrMsg()) 
                        super.setErrMsg("<h1 class='popup'>"+NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"</h1>"+"<h2 class='popup'>"+super.getErrMsg()+"</h2>");
                    success=false;
                    return; 
                }
                while((line = readbuf.readLine()) != null && !line.startsWith(SEPARATED_LINE));
                while (!((line = readbuf.readLine()).startsWith(DISKLIST_CMD_NAME))) {  
                    StringTokenizer st = new StringTokenizer(line);                    
                    st.nextToken();
                    st.nextToken();
                    if(st.nextToken().equals("Port")) {
                       super.setErrMsg("<h1 class=\"popup\">"+NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"</h1>"+"<h2 class=\"popup\">"+NSMessageDriver.getInstance().getMessage(session,"fcsan_componentconf/logicdiskunbind/unbind_failed_port")+"</h2>");
                       success=false;
                       return;
                    }              
                }
                break;             
             }//end of if            
        }
        //end of judging
        
        super.execCmd(CMD_DELLUN + " " + diskarrayid + " " + Integer.parseInt(LDNo.substring(0, 4), 16));
        
        readbuf=super.execCmd(CMD_DISKSETLD_R+" "+diskarrayname+" -ldn "+LDNo+" -restart");
        if (readbuf==null)
        {
            super.setErrMsg("<h1 class=\"popupError\">"+NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"</h1>"+"<h2 class=\"popupError\">"+super.getErrMsg()+"</h2>");
            if(setSpecialErrMsg("popup","h2"))
                super.setErrMsg("<h1 class='popup'>"+NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"</h1>"+super.getErrMsg());
            success=false;
            return;
        }
        
        super.execCmd(SCRIPT_RESTART_ISMSVR);
        
        super.setErrMsg("<h1 class=\"popup\">"+NSMessageDriver.getInstance().getMessage(session,"common/alert/done")+"</h1>"+"<h2 class=\"popup\">"+NSMessageDriver.getInstance().getMessage(session,"fcsan_common/specialmessage/msg_do_reload")+"</h2>");
    }
    public Map getLDNo() throws Exception
    {
        Map M_ldnumber=new TreeMap();
        if (!doGetLDNums("pdgroup"))
        {
            if (super.setSpecialErrMsg())
                super.setErrMsg("<h1 class='popup'>"+NSMessageDriver.getInstance().getMessage(session,"fcsan_componentconf/common/h1_configure")+"</h1>"+"<h2 class='popup'>"+super.getErrMsg()+"</h2>");
            return M_ldnumber;
        }
        TreeMap lvms = (TreeMap)session.getAttribute(SESSION_LVM_LIST);
        
        String diskarrayName = request.getParameter("diskarrayname");
        Map <String, String> pairedLdMap = DiskHandler.getPairedLdMap(diskarrayName);
        Map <String, String> creatingLdMap = new TreeMap <String, String> ();
        try {
        	creatingLdMap = DiskHandler.getCreatingLdMap(diskarrayName);
        }catch(Exception e) {
            // show error message
            success = false;
            super.setErrMsg("<h1 class='popup'>"+NSMessageDriver.getInstance().getMessage(session,"fcsan_componentconf/common/h1_configure")+"</h1>"+"<h2 class='popup'>"+NSMessageDriver.getInstance().getMessage(session,"fcsan_componentconf/common/getcreatingldinfo_failed")+"</h2>");
            return M_ldnumber;
        }
        for (int i=0;i<ldnum.size();i++)
        {
        	// Do not return the LD No for unbinding if LD is creating 
        	if ((creatingLdMap !=null) && creatingLdMap.containsKey(ldnum.get(i))) {
        		continue;
        	}
        	
            if((lvms == null || !lvms.containsKey(ldnum.get(i)))
               && (pairedLdMap ==null || !pairedLdMap.containsKey(ldnum.get(i)))) {
                M_ldnumber.put((String)ldnum.get(i), (String)ldnum.get(i));
            }
        }
        return M_ldnumber;
    }
    public void LDTimeset () throws Exception
    {
        String diskarrayname=request.getParameter("diskarrayname");
        String bltime=request.getParameter("bltime");
        if (diskarrayname==null||bltime==null)
        {
            throw new NSException(NSMessageDriver.getInstance().getMessage(session,"fcsan_common/exception/invalid_param"));
        }
        BufferedReader readbuf=null;
        if (DiskCommon.isSSeries(request)){
            readbuf=super.execCmd(CMD_DISKSETARRAY_CLD+" "+diskarrayname+" "+"-bltime"+" "+bltime+" "+"-ptype"+" "+"basic"+" "+"-restart");    

        }else if (DiskCommon.isCondorLiteSeries(request)){
            readbuf=super.execCmd(CMD_DISKSETARRAY_CLD+" "+diskarrayname+" "+"-bltime"+" "+bltime+" "+"-ptype"+" "+"all"+" "+"-restart");    
        }
        if (readbuf==null)
        {
            super.setErrMsg("<h1 class=\"popupError\">"+NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"</h1>"+"<h2 class=\"popupError\">"+super.getErrMsg()+"</h2>");
            if(setSpecialErrMsg("popup","h2"))
                super.setErrMsg("<h1 class='popup'>"+NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"</h1>"+super.getErrMsg());
            success=false;
            return;
        }
        super.setErrMsg("<h1 class=\"popup\">"+NSMessageDriver.getInstance().getMessage(session,"common/alert/done")+"</h1>"+"<h2 class=\"popup\">"+NSMessageDriver.getInstance().getMessage(session,"fcsan_common/specialmessage/msg_do_reload")+"</h2>");
    }
    public void LDBind() throws Exception
    {
        
        String ldnum=request.getParameter("ldnum")+"h";
        String ldtype=request.getParameter("ldtype");
        String ldsize=request.getParameter("ldsize");
        String bltime=request.getParameter("bltime");
        String rankNo=request.getParameter("rankNo");
        String poolName=request.getParameter("poolName");
        String ldname=request.getParameter("ldname");
        String diskarrayid = request.getParameter("diskarrayid");
        String pdnum=request.getParameter("pdnum");
        String diskarrayname=request.getParameter("diskarrayname");
        String poolraidtype=request.getParameter("raid");
        if (ldnum==null||ldtype==null||ldsize==null||rankNo==null||pdnum==null||diskarrayname==null||diskarrayid==null)
        {
            throw new NSException(NSMessageDriver.getInstance().getMessage(session,"fcsan_common/exception/invalid_param"));
        }
        StringBuffer cmd=new StringBuffer(CMD_DISKSETLD_B+" ");
        cmd.append(diskarrayname);
        cmd.append(" -pname ");
        cmd.append(poolName);
        cmd.append(" -ldsz ");
        cmd.append(ldsize);
        cmd.append(" -ldn ");
        cmd.append(ldnum);
        cmd.append(" -syscapa");
        cmd.append(" -ldtype ");
        cmd.append(ldtype);
        cmd.append(" -name ");
        cmd.append(ldname);
        if (bltime != null){
            cmd.append(" -bltime ");
            cmd.append(bltime);
        }
        cmd.append(" -restart");
        if (DiskCommon.isCondorLiteSeries(request)){
            if (!poolraidtype.equalsIgnoreCase("6(4+PQ)") && !poolraidtype.equalsIgnoreCase("6(8+PQ)")){
                cmd.append(" -qkfmt");
            }
            cmd.append(" -dnmcfmttm"); 
        }else if (DiskCommon.isSSeries(request)){
            if (!poolraidtype.equalsIgnoreCase("6(4+PQ)") && !poolraidtype.equalsIgnoreCase("6(8+PQ)")){
                cmd.append(" -dnmcfmttm"); 
            }
        }
        
        BufferedReader readbuf=super.execCmd(cmd.toString());
        if (readbuf==null){
            /* when the error code is -18.operation is success*/
            if (getErrorCode() == iSMSM_ALREADY) {
                super.setErrMsg("<h1 class=\"popup\">"+NSMessageDriver.getInstance().getMessage(session,"common/alert/done")+"</h1>"+"<h2 class=\"popup\">"+NSMessageDriver.getInstance().getMessage(session,"fcsan_common/specialmessage/msg_do_reload")+"</h2>"+NSMessageDriver.getInstance().getMessage(session,"fcsan_componentconf/logicdiskbind/sameldname"));
                success = true;
                return;
            }else {
                success=false;
            }
//  modified by hujun according to mail  (nas 5598) [nas-dev-necas:04731] on Dec, 10th ,2002
            specialErrMsgHash.put(new Integer(FCSANConstants.iSMSM_ARG_ERR) 
                ,NSMessageDriver.getInstance()
                .getMessage(session,"fcsan_componentconf/logicdiskbind/capacity_error"));
// end
// modified by hujun, move the following lines from setSpecialErrMsg
        specialErrMsgHash.put(new Integer(FCSANConstants.iSMSM_EXIST) 
            ,NSMessageDriver.getInstance()
            .getMessage(session,"fcsan_componentconf/logicdiskbind/msg_repeat_ldnum"));
// end

            if(setSpecialErrMsg("popup","h2")){
                super.setErrMsg("<h1 class='popup'>" 
                        + NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"</h1>"+super.getErrMsg());
            } else {            
                super.setErrMsg("<h1 class=\"popupError\">"+NSMessageDriver.getInstance().getMessage(session,"common/alert/failed")+"</h1>"+"<h2 class=\"popupError\">"+super.getErrMsg()+"</h2>");
            }
            return;
        }
        
        /*
        readbuf=super.execCmd(CMD_INITLUN + " " + diskarrayid + " " + ldnum);
        if (readbuf==null){
            throw new NSException("Fail to initialize the LUN.");
        }*/
        
        super.setErrMsg("<h1 class=\"popup\">"+NSMessageDriver.getInstance().getMessage(session,"common/alert/done")+"</h1>"+"<h2 class=\"popup\">"+NSMessageDriver.getInstance().getMessage(session,"fcsan_common/specialmessage/msg_do_reload")+"</h2>");
    }
    
    public String getUnUsedLDNum () throws Exception
    {
        //boolean hasFreeSystemLd = false;
        //boolean isCompositeMachine = false;
        if (!doGetLDNums("all"))
        {
            success=false;
            return null;
        }
        
        String aid = request.getParameter("diskarrayid");
        int startNo = super.isFirstArray(aid) ? 0x10 : 0x0;
        String unusedNo = "";
        for (int i = startNo; i <= 0xff; i++){
            String s = Integer.toHexString(i);
            for (int j = s.length(); j < 4; j++){
                s = "0" + s;
            }
            if (!ldnum.contains(s + "h")){
                unusedNo = s;
                break;
            }
        }
        return unusedNo;
        
        /*
        String arraytype =  request.getParameter("arraytype");
        if (arraytype == null) {
            throw new NSException(NSMessageDriver.getInstance().getMessage(session,"fcsan_common/exception/invalid_param"));
        }
        //int diskarraytype = Integer.valueOf(arraytype.substring(0,arraytype.length()-1),16).intValue();
        isCompositeMachine = true;//diskarraytype >= 0x50 && diskarraytype <= 0x6f;
        Collections.sort(ldnum);
        int i = 0;
        int j = 0x10;

        //find first the position that is over the 0xf;
        for (;i < ldnum.size(); i++) {
            StringBuffer sb=new StringBuffer((String)ldnum.get(i));
            String ldNo=sb.deleteCharAt(sb.length()-1).toString(); 
            int tmp_ldno = Integer.valueOf(ldNo,16).intValue();
            if (tmp_ldno > 0xf){
                break;
            }
        }
        if (i != 0x10) {
            hasFreeSystemLd= true;
        }
        
        //find the unused position put it into j.

        for (;i < ldnum.size(); i++) {
            StringBuffer sb=new StringBuffer((String)ldnum.get(i));
            String ldNo=sb.deleteCharAt(sb.length()-1).toString(); 
            if (Integer.valueOf(ldNo,16).intValue() != j){
            //ensure the unused LDnumber is bigger than 0xfh
                break;
            }
            j++;
        }
        
        if (j>511 && isCompositeMachine && hasFreeSystemLd) {
            return "";
        } else if (j>511) {
            super.setErrMsg(NSMessageDriver.getInstance().getMessage(session,"fcsan_componentconf/logicdiskbind/noldnumber"));
            success = false;
            return null;
        }
        
        //ensure the unused LDnumber is bigger than 0xfh 
        //when the ldnum.size() smaller than 0xfh
        String s=Integer.toHexString(j);
        for (i=s.length();i<4;i++)
            s="0"+s;
        return s;
        */
    }

    public String getTrimCapacity() throws Exception
    {
        String ldsize = request.getParameter("ldsize");
        double ldsize_db = Double.valueOf(ldsize).doubleValue();
        long size = Math.round(ldsize_db*1024+0.4)*1024*1024;
        return ""+size;
    }
    private boolean setSpecialErrMsg(String style,String size)
    {
        if (super.setSpecialErrMsg()){
            setErrMsg("<"+size+" class='"+style+"'>"+super.getErrMsg()+"</"+size+">");
            return true;
        }
        return false;
    }
}
