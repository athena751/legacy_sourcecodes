/*
 *      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.fcsan.componentdisp;
import java.util.*;
import java.io.*;
import com.nec.sydney.framework.*;
import com.nec.sydney.beans.fcsan.common.*;
import javax.servlet.http.*;
import com.nec.nsgui.model.entity.disk.DiskConstant;
public class DiskArrayFreshBean extends FcsanAbstractBean implements FCSANConstants 
{

    private static final String     cvsid = "@(#) $Id: DiskArrayFreshBean.java,v 1.2304 2007/09/07 08:17:58 liq Exp $";


    private List diskArrayInfoList;
    private int result;
    private boolean hasSameName;
    
    public DiskArrayFreshBean()
    {
        result = 0;
        hasSameName = false;
    }

    public void beanProcess() throws Exception
    {
        String cmd = CMD_DISKLIST_D;    
        BufferedReader readbuf = execCmd(cmd);
        if (readbuf == null) {
             result = 1;             
        } else {
            diskArrayInfoList = new ArrayList();
            result = 0;
            String line=readbuf.readLine();
            while (!line.startsWith(SEPARATED_LINE)) {
                line = readbuf.readLine();
            }
            line = readbuf.readLine();
            Vector Vec = new Vector();
            while (line != null) {
                StringTokenizer st = new StringTokenizer(line);
                DiskArrayInfo diskarrayinfo = new DiskArrayInfo();
                if (st.countTokens() == 7)
                {
                    String diskarrayid=st.nextToken();
                    Vec.add(diskarrayid);
                    diskarrayinfo.setID(diskarrayid);
                    diskarrayinfo.setName(st.nextToken());
                    String diskarraytype=st.nextToken();
                    diskarrayinfo.setType(diskarraytype);
                    HttpSession session = request.getSession();
                    String typeInSession=(String)session.getAttribute(DiskConstant.SESSION_DISKARRAY_TYPE);
                    if(typeInSession==null||typeInSession.equals("")||typeInSession.equals("--")){
                        String tmptype="--";
                        if (diskarraytype.equals("05h")){
                            tmptype="S1500";
                        }else if (diskarraytype.equals("04h")){
                            tmptype="S1400";    
                        }else if (diskarraytype.equals("80h")){
                            tmptype="D1";    
                        }else if (diskarraytype.equals("81h")){
                            tmptype="D3";
                        }
                        session.setAttribute(DiskConstant.SESSION_DISKARRAY_TYPE,tmptype);
                    }
                    
                    //diskarrayinfo.setState((String)valueDisplayHash.get(st.nextToken()));
                    diskarrayinfo.setState(st.nextToken());//caoyh 4.15
                    //diskarrayinfo.setObservation((String)valueDisplayHash.get(st.nextToken()));
                    diskarrayinfo.setObservation(st.nextToken());//caoyh 4.15
                    diskarrayinfo.setSAA(st.nextToken());
                    diskarrayinfo.setWWNN(st.nextToken());  //Add by wangli on 2005.9.12                   
                    diskArrayInfoList.add(diskarrayinfo);
                } else if (!line.startsWith(DISKLIST_CMD_NAME)) {
                    NSException ex = new NSException(NSMessageDriver.getInstance().getMessage(session,"fcsan_componentdisp/common/invalid_cmd_output"));
                    throw ex;
                }
                line = readbuf.readLine();
            }
            for (int i=0; i<diskArrayInfoList.size(); i++) {
                if (hasSameName){
                    break;   
                }
                String diskArrayName = ((DiskArrayInfo)diskArrayInfoList.get(i)).getName();
                for (int j=0; j<i; j++){
                    if (diskArrayName.equals(((DiskArrayInfo)diskArrayInfoList.get(j)).getName())){
                        hasSameName = true;
                        break;
                    }  
                }   
            }            
            session.setAttribute("FcsanDiskArrayId",Vec);
        }
    }

    public int refreshDiskArray(HttpSession http) throws Exception
    {
        Vector diskArrayId = (Vector)http.getAttribute("FcsanDiskArrayId");
       
        if (diskArrayId == null || diskArrayId.size() == 0) {
            return 0;
        }
               
        FCSANRefreshBean refresh=new FCSANRefreshBean();
        for(int i = 0;i < diskArrayId.size();i++)
        {
          if((refresh.refresh((String)diskArrayId.get(i)))!=FCSAN_SUCCESS){
            setErrMsg(refresh.getErrMsg());
            setErrorCode(refresh.getErrorCode());
            return 1;
          }
        }
        return 0;
    }
    public List getDiskArrayInfo() {
        Collections.sort(diskArrayInfoList, new Comparator() {
                    public int compare(Object a, Object z){
                        String info1 = ((DiskArrayInfo)a).getID();
                        String info2 = ((DiskArrayInfo)z).getID();
                        return info1.compareTo(info2);
                    }
                });
        return diskArrayInfoList;
    }

    public int getResult() {
        return result;
    }
    
    public boolean getHasSameName(){
        return hasSameName;   
    }
    
}

