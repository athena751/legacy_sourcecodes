/*
 *      Copyright (c) 2001-2006 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.quota;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.util.Collections;
import java.util.Comparator;
import java.util.StringTokenizer;
import java.util.TreeMap;
import java.util.Vector;

import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.biz.base.NSProcess;
import com.nec.sydney.atom.admin.base.NSExceptionMsg;
import com.nec.sydney.atom.admin.base.NSUtil;
import com.nec.sydney.atom.admin.base.NasConstants;
import com.nec.sydney.atom.admin.base.NasSession;
import com.nec.sydney.atom.admin.quota.QuotaInfo;
import com.nec.sydney.beans.base.APISOAPClient;
import com.nec.sydney.beans.base.AbstractJSPBean;

public class GetReportBean extends AbstractJSPBean implements NasConstants,NasSession,NSExceptionMsg {
 
    private static final String     cvsid = "@(#) $Id: GetReportBean.java,v 1.2312 2006/12/08 02:49:02 zhangjun Exp $";

    private Vector reports;
    private String title;
    private String blocktime;
    private String filetime;
    private QuotaInfo template;
    private boolean alertFlag;
    private String exceedLimit;

    public GetReportBean() {
        reports = new Vector();
        //template = new QuotaInfo();
    }
 
    public void beanProcess() throws Exception {
        final String  EXCEED_FLAG = "1";
        String DirQuota = (String)request.getParameter("DirQuota");
        boolean isDirQuota = false;
        String filesystem;
        if (DirQuota == null){
            filesystem = (String)session.getAttribute(MP_SESSION_HEX_MOUNTPOINT);
            isDirQuota = false;
        } else {
            filesystem = (String)session.getAttribute(SESSION_HEX_DIRQUOTA_DATASET);
            isDirQuota = true;
        }
        
        String commandid = request.getParameter("commandid");
        String type = request.getParameter("type");
        String fsType = (String)session.getAttribute(NasSession.SESSION_QUOTA_FSTYPE);
        exceedLimit = getLimit();
        String displayControl = request.getParameter("displayControl"); //added by maojb on 2003.8.1
        //beanProcess is called by datasetlist.jsp, all parameter haven't been transfered
        boolean isFromDataSet = false;
        if (commandid==null && type==null && displayControl==null){
            commandid = "dir";
            type = "none";
            displayControl = "all";
            isFromDataSet = true;
        }
        TreeMap dataSetMap = new TreeMap();
        if (isFromDataSet){
            dataSetMap = getDataMap(); 
        }
        if (!isFromDataSet || dataSetMap.size()>0){
                Vector temp = QuotaSOAPClient.getReport(target,filesystem,commandid,type,fsType, exceedLimit, displayControl, isDirQuota); 
    
                BufferedReader readbuf = new BufferedReader(new StringReader((String)temp.get(0)));
                String line = readbuf.readLine();
                if(line.trim().equals(EXCEED_FLAG)) {
                    alertFlag = true;
                }
                line = readbuf.readLine();
                line = readbuf.readLine();
                title = line;
                line = readbuf.readLine();
                String graceflag;
                StringTokenizer token = new StringTokenizer(line,";");
                blocktime = token.nextToken();
                filetime = token.nextToken();
                for(int i=0;i<3;i++){
                    line = readbuf.readLine();
                }
                
                line = readbuf.readLine();
                boolean flagTakedTemplate = false;   //add by jinkc for "name=template":2003/04/03
                
                while(line!=null){
                    if (line.trim().startsWith(REP_STATUS_START))
                        break;
                    token = new StringTokenizer(line);
                    int count=token.countTokens();
                    if(token.hasMoreTokens()){
                        String id = (token.nextToken()).replace(':', ' ');      //modify by jinkc for "name contained space":2003/04/03
                        if(id.equals(TEMPLATE_FLAG) && (!flagTakedTemplate)){   //modify by jinkc for "name=template":2003/04/03
                            template = new QuotaInfo();
                            template.setID(id);
                            token.nextToken();
                            //token.nextToken();
                            template.setBlockSoftLimit(token.nextToken());
                            template.setBlockHardLimit(token.nextToken());
                        //add begin:2002/4/27 lhy add for "grace--none"
                            if(count==9){
                                token.nextToken();
                            }
                        //add end:2002/4/27 lhy add for "grace--none"
                            token.nextToken();                    
                            template.setFileSoftLimit(token.nextToken());
                            template.setFileHardLimit(token.nextToken());
                            flagTakedTemplate = true;   //add by jinkc for "name=template":2003/04/03
                         }else{
                            QuotaInfo report = new QuotaInfo();
                            if (isFromDataSet){                                
                                String dataset = (String)dataSetMap.get(id); 
                                dataset = (dataset!=null)?dataset:id;
                                report.setDataSet(dataset);  
                            }
                            report.setID(id);
                            graceflag = token.nextToken();
                            report.setBlockUsed(token.nextToken());
                            report.setBlockSoftLimit(token.nextToken());
                            report.setBlockHardLimit(token.nextToken());
                            if(graceflag.equals("--")){
                                report.setFileUsed(token.nextToken());
                                report.setFileSoftLimit(token.nextToken());
                                report.setFileHardLimit(token.nextToken());
                            }else if(graceflag.equals("-+")){
                                report.setFileUsed(token.nextToken());
                                report.setFileSoftLimit(token.nextToken());
                                report.setFileHardLimit(token.nextToken());
                                if(count>8){//2002/5/8 lhy add for difference between output "stop" and "start"
                                    report.setFileGraceTime(token.nextToken());
                                }
                            }else if(graceflag.equals("+-")){
                                if(count>8){//2002/5/8 lhy add for difference between output "stop" and "start"
                                    report.setBlockGraceTime(token.nextToken());
                                }
                                report.setFileUsed(token.nextToken());
                                report.setFileSoftLimit(token.nextToken());
                                report.setFileHardLimit(token.nextToken());
                            }else{
                                if(count>8){//2002/5/8 lhy add for difference between output "stop" and "start"
                                    report.setBlockGraceTime(token.nextToken());
                                }
                                report.setFileUsed(token.nextToken());
                                report.setFileSoftLimit(token.nextToken());
                                report.setFileHardLimit(token.nextToken());
                                if(count>8){//2002/5/8 lhy add for difference between output "stop" and "start"
                                    report.setFileGraceTime(token.nextToken());
                                }
                            }
                            reports.add(report);
                        }
                    }
                    line = readbuf.readLine();    
                }//end of while
                String codePage = getCodePage((String)session.getAttribute(NasConstants.MP_SESSION_EXPORTROOT));
                //reports.add(NSUtil.perl2Page(title,codePage));
                reports.add(NSActionUtil.perl2Page(title,codePage));
                reports.add(blocktime);
                reports.add(filetime);
                reports.add(template);            
    
            int count = reports.size();
            if(reports.get(count-1)!=null){
                template = (QuotaInfo)reports.get(count-1);
                reports.remove(count-1);
            }else{
                reports.remove(count-1);
            }
            filetime =(String) reports.get(count-2);
            reports.remove(count-2);
            blocktime = (String)reports.get(count-3);    
            reports.remove(count-3);
            title = (String)reports.get(count-4);
            reports.remove(count-4);
            String keyword = request.getParameter("keyword");
            //if datasetlist.jsp is loading from other page, keyword==null
            if (keyword==null){
                keyword = "id";
            }   
            boolean reverse = Boolean.valueOf(request.getParameter("reverse")).booleanValue();
            if (isFromDataSet && keyword.equals("id")){
                type = "id";    
            }
            sortReports(reports,keyword,type,reverse);
        }
     }

      
    private void sortReports(Vector reports, String keyword, String type, boolean reverse) {
        if(keyword.equals("id")&&reverse&&type.equals("id")){
            Collections.sort(reports, new Comparator(){
                        public int compare(Object a, Object z){
                          QuotaInfo info1 = (QuotaInfo)a;
                            QuotaInfo info2 = (QuotaInfo)z;
                            return (new Long(info1.getID())).compareTo((new Long(info2.getID())));//2002/6/17 lhy mod for mail[nas-dev-necas-02936] Integer->long
                        }
                       });
        }else if(keyword.equals("id")&&!reverse&&type.equals("id")){
                   Collections.sort(reports, new Comparator(){
                        public int compare(Object a, Object z){
                          QuotaInfo info1 = (QuotaInfo)a;
                            QuotaInfo info2 = (QuotaInfo)z;
                            return (new Long(info2.getID())).compareTo((new Long(info1.getID())));
                        }
                       });
                }else if(keyword.equals("id")&&reverse&&type.equals("name")){
                   Collections.sort(reports, new Comparator(){
                        public int compare(Object a, Object z){
                          QuotaInfo info1 = (QuotaInfo)a;
                            QuotaInfo info2 = (QuotaInfo)z;
                            return info1.getID().compareTo(info2.getID());
                        }
                       });
            }else if(keyword.equals("id")&&!reverse&&type.equals("name")){
                   Collections.sort(reports, new Comparator(){
                        public int compare(Object a, Object z){
                          QuotaInfo info1 = (QuotaInfo)a;
                            QuotaInfo info2 = (QuotaInfo)z;
                            return info2.getID().compareTo(info1.getID());
                        }
                       });
                }else if(keyword.equals("dataset")&&reverse){
                    Collections.sort(reports, new Comparator(){
                        public int compare(Object a, Object z){
                          QuotaInfo info1 = (QuotaInfo)a;
                            QuotaInfo info2 = (QuotaInfo)z;
                            return info1.getDataSet().compareTo(info2.getDataSet());
                        }
                       });
                }else if(keyword.equals("dataset")&&!reverse){
                    Collections.sort(reports, new Comparator(){
                        public int compare(Object a, Object z){
                          QuotaInfo info1 = (QuotaInfo)a;
                            QuotaInfo info2 = (QuotaInfo)z;
                            return info2.getDataSet().compareTo(info1.getDataSet());
                        }
                       });
                }else if(keyword.equals("bused")&&reverse){
            Collections.sort(reports, new Comparator(){
                        public int compare(Object a, Object z){
                          QuotaInfo info1 = (QuotaInfo)a;
                            QuotaInfo info2 = (QuotaInfo)z;
                            return (new Long(info1.getBlockUsed())).compareTo((new Long(info2.getBlockUsed())));
                        }
                       });
            }else if(keyword.equals("bused")&&!reverse){
                   Collections.sort(reports, new Comparator(){
                        public int compare(Object a, Object z){
                          QuotaInfo info1 = (QuotaInfo)a;
                            QuotaInfo info2 = (QuotaInfo)z;
                            return (new Long(info2.getBlockUsed())).compareTo((new Long(info1.getBlockUsed())));
                        }
                       });
                }else if(keyword.equals("bsoft")&&reverse){
            Collections.sort(reports, new Comparator(){
                        public int compare(Object a, Object z){
                          QuotaInfo info1 = (QuotaInfo)a;
                            QuotaInfo info2 = (QuotaInfo)z;
                            return (new Long(info1.getBlockSoftLimit())).compareTo((new Long(info2.getBlockSoftLimit())));
                        }
                       });
            }else if(keyword.equals("bsoft")&&!reverse){
                   Collections.sort(reports, new Comparator(){
                        public int compare(Object a, Object z){
                          QuotaInfo info1 = (QuotaInfo)a;
                            QuotaInfo info2 = (QuotaInfo)z;
                            return (new Long(info2.getBlockSoftLimit())).compareTo((new Long(info1.getBlockSoftLimit())));
                        }
                       });
                }else if(keyword.equals("bhard")&&reverse){
            Collections.sort(reports, new Comparator(){
                        public int compare(Object a, Object z){
                          QuotaInfo info1 = (QuotaInfo)a;
                            QuotaInfo info2 = (QuotaInfo)z;
                            return (new Long(info1.getBlockHardLimit())).compareTo((new Long(info2.getBlockHardLimit())));
                        }
                       });
            }else if(keyword.equals("bhard")&&!reverse){
                   Collections.sort(reports, new Comparator(){
                        public int compare(Object a, Object z){
                          QuotaInfo info1 = (QuotaInfo)a;
                            QuotaInfo info2 = (QuotaInfo)z;
                            return (new Long(info2.getBlockHardLimit())).compareTo((new Long(info1.getBlockHardLimit())));
                        }
                       });
                }else if(keyword.equals("bgrace")&&reverse){
            Collections.sort(reports, new Comparator(){
                        public int compare(Object a, Object z){
                          QuotaInfo info1 = (QuotaInfo)a;
                            QuotaInfo info2 = (QuotaInfo)z;
                            return getSeconds(info1.getBlockGraceTime())
                            .compareTo(getSeconds(info2.getBlockGraceTime()));
                        }
                       });
            }else if(keyword.equals("bgrace")&&!reverse){
                   Collections.sort(reports, new Comparator(){
                        public int compare(Object a, Object z){
                          QuotaInfo info1 = (QuotaInfo)a;
                            QuotaInfo info2 = (QuotaInfo)z;
                            return getSeconds(info2.getBlockGraceTime())
                            .compareTo(getSeconds(info1.getBlockGraceTime()));
                        }
                       });
                }else if(keyword.equals("fused")&&reverse){
            Collections.sort(reports, new Comparator(){
                        public int compare(Object a, Object z){
                          QuotaInfo info1 = (QuotaInfo)a;
                            QuotaInfo info2 = (QuotaInfo)z;
                            return (new Long(info1.getFileUsed())).compareTo((new Long(info2.getFileUsed())));
                        }
                       });
            }else if(keyword.equals("fused")&&!reverse){
                   Collections.sort(reports, new Comparator(){
                        public int compare(Object a, Object z){
                          QuotaInfo info1 = (QuotaInfo)a;
                            QuotaInfo info2 = (QuotaInfo)z;
                            return (new Long(info2.getFileUsed())).compareTo((new Long(info1.getFileUsed())));
                        }
                       });
                }else if(keyword.equals("fsoft")&&reverse){
            Collections.sort(reports, new Comparator(){
                        public int compare(Object a, Object z){
                          QuotaInfo info1 = (QuotaInfo)a;
                            QuotaInfo info2 = (QuotaInfo)z;
                            return (new Long(info1.getFileSoftLimit())).compareTo((new Long(info2.getFileSoftLimit())));
                        }
                       });
            }else if(keyword.equals("fsoft")&&!reverse){
                   Collections.sort(reports, new Comparator(){
                        public int compare(Object a, Object z){
                          QuotaInfo info1 = (QuotaInfo)a;
                            QuotaInfo info2 = (QuotaInfo)z;
                            return (new Long(info2.getFileSoftLimit())).compareTo((new Long(info1.getFileSoftLimit())));
                        }
                       });
                }else if(keyword.equals("fhard")&&reverse){
            Collections.sort(reports, new Comparator(){
                        public int compare(Object a, Object z){
                          QuotaInfo info1 = (QuotaInfo)a;
                            QuotaInfo info2 = (QuotaInfo)z;
                            return (new Long(info1.getFileHardLimit())).compareTo((new Long(info2.getFileHardLimit())));
                        }
                       });
            }else if(keyword.equals("fhard")&&!reverse){
                   Collections.sort(reports, new Comparator(){
                        public int compare(Object a, Object z){
                          QuotaInfo info1 = (QuotaInfo)a;
                            QuotaInfo info2 = (QuotaInfo)z;
                            return (new Long(info2.getFileHardLimit())).compareTo((new Long(info1.getFileHardLimit())));
                        }
                       });
                }else if(keyword.equals("fgrace")&&reverse){
            Collections.sort(reports, new Comparator(){
                        public int compare(Object a, Object z){
                          QuotaInfo info1 = (QuotaInfo)a;
                            QuotaInfo info2 = (QuotaInfo)z;
                            return getSeconds(info1.getFileGraceTime())
                            .compareTo(getSeconds(info2.getFileGraceTime()));
                        }
                       });
            }else{
                   Collections.sort(reports, new Comparator(){
                        public int compare(Object a, Object z){
                          QuotaInfo info1 = (QuotaInfo)a;
                            QuotaInfo info2 = (QuotaInfo)z;
                            return getSeconds(info2.getFileGraceTime())
                            .compareTo(getSeconds(info1.getFileGraceTime()));
                        }
                       });
                 }                        
        } 
    
    public Vector getReports() {
        return reports;
    }

    public String getBlocktime() {
        return blocktime;
    }
    
    public String getFiletime() {
        return filetime;
    }

    public String getTitle() {
        return title;
    }
    
    public boolean getAlertFlag() {
        return alertFlag;
    }    

    public String getExceedLimit() {
        return exceedLimit;
    }  
    
    public QuotaInfo getTemplate() {
        return template;
    }
    private String getLimit() throws Exception {
        String limit = "5000";
        try {
            String home = System.getProperty("user.home");
            String fileName = home + "/etc/properties/quota.conf";
            final String SCRIPT_GETPROPERTY = "/bin/quota_getProperty.pl";
            String[] cmd = { home + SCRIPT_GETPROPERTY,
                             fileName
                           };
            Runtime run=Runtime.getRuntime();
            NSProcess proc = new NSProcess(run.exec(cmd));
            proc.waitFor();
            if ( proc.exitValue() == 0){
                BufferedReader readbuf = new BufferedReader(new InputStreamReader(proc.getInputStream()));
                limit = readbuf.readLine();            
            }
        } catch (Exception e) {
        }
        return limit;
    }
    
    public String changeUnit(long limitValue, String unit){
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
    
    private String getCodePage(String export) throws Exception {
        return APISOAPClient.getCodepage(target, export);
    }
     
    private TreeMap getDataMap()throws Exception {
        String filesystem = (String)session.getAttribute(MP_SESSION_HEX_MOUNTPOINT);
        TreeMap dataMap = new TreeMap();
        Vector dataVec = QuotaSOAPClient.getDataMap(target,filesystem); 
        String line;
        String codePage = getCodePage((String)session.getAttribute(NasConstants.MP_SESSION_EXPORTROOT));        
        for (int i=0;i<dataVec.size();i++){
        	line = (String)dataVec.get(i);
            line = NSActionUtil.perl2Page(line,codePage);
            
            //modify by zhangjun:support the space
            int pos = line.indexOf("\t");
            String ID=line.substring(0,pos);
            String Dataset=line.substring(pos+1);
            dataMap.put(ID,Dataset);
        }
        return dataMap;
    }
    
    private Long getSeconds(String graceTime){
        long seconds = 0;
        if (graceTime==null || graceTime.equals("&nbsp;")){
              //the largest number is 1000,so 1001 will be sort in the end
              return new Long(1001*86400);
        }
        if (graceTime.equals("none")){
            //there are no more grace time, so it will be sort in the top
              return new Long(-1); 
        }
        if (graceTime.indexOf(":")!=-1){
            StringTokenizer st = new StringTokenizer(graceTime,":");
            seconds = (new Long(st.nextToken())).longValue()*3600
                      + (new Long(st.nextToken())).longValue()*60;
        } else{
            //trim the "days";
            //graceTime = "6days";
            String days = (graceTime.trim()).substring(0,graceTime.length()-4);
            seconds = (new Long(days).longValue())*86400;
        }
        return new Long(seconds);
        
    }
}