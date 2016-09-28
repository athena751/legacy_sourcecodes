/*
 *      Copyright (c) 2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 * 
 *      $Id: DdrScheduleTDataRender.java,v 1.1 2005/08/29 04:44:21 wangzf Exp $
 */
package com.nec.sydney.beans.ddr;

import javax.servlet.http.HttpSession;

import com.nec.nsgui.taglib.nssorttab.*;
import com.nec.sydney.atom.admin.base.NasConstants;
import com.nec.sydney.framework.NSMessageDriver;

public class DdrScheduleTDataRender extends STAbstractRender implements NasConstants {

    /**
     * Get the HTML code which specified by (rowIndex, colName)
     * 
     * @param rowIndex
     * @param colName
     * @return HTML code
     * @throws Exception
     */
    public String getCellRender(int rowIndex, String colName) throws Exception{
        SortTableModel tableModel = getTableModel();               
        String cellData = getCellData(rowIndex, colName);
        int period = Integer.parseInt(tableModel.getValueAt(rowIndex, "period").toString()); 
        String htmlCode;
        if(period == CRON_PERIOD_DIRECTEDIT) {
            if(colName.equals("day")) {
                htmlCode = "<td colspan=\"2\">";
                htmlCode = htmlCode + cellData;
                htmlCode = htmlCode + "</td>" ;
            } else if(colName.equals("action")) {
                htmlCode = "<td>";
                htmlCode = htmlCode + cellData;
                htmlCode = htmlCode + "</td>" ;
            }else{
                htmlCode = "";
            }
        } else {               
            htmlCode = "<td>";
            htmlCode = htmlCode + cellData;
            htmlCode = htmlCode + "</td>" ;
        }
        
        return htmlCode;
    }
    

    /**
     * Get the HTML code between <td> and </td> which specified by (rowIndex, colName)
     * 
     * @param rowIndex
     * @param colName
     * @return HTML code
     * @throws Exception
     */
    private String getCellData(int rowIndex, String colName) throws Exception{
        SortTagInfo tagInfo = getSortTagInfo();
        HttpSession session = tagInfo.getPageContext().getSession();
        java.text.DecimalFormat df = new java.text.DecimalFormat("00");
        String[] weekday = {
            NSMessageDriver.getInstance().getMessage(session, "nas_snapshot/snapschedule/nsview_sun"),
            NSMessageDriver.getInstance().getMessage(session, "nas_snapshot/snapschedule/nsview_mon"),
            NSMessageDriver.getInstance().getMessage(session, "nas_snapshot/snapschedule/nsview_tue"),
            NSMessageDriver.getInstance().getMessage(session, "nas_snapshot/snapschedule/nsview_wed"),
            NSMessageDriver.getInstance().getMessage(session, "nas_snapshot/snapschedule/nsview_thu"),
            NSMessageDriver.getInstance().getMessage(session, "nas_snapshot/snapschedule/nsview_fri"),
            NSMessageDriver.getInstance().getMessage(session, "nas_snapshot/snapschedule/nsview_sat")
        };
        String[] displayDay;
                
        SortTableModel tableModel = getTableModel();
        String dataStr = "";
        int period = Integer.parseInt(tableModel.getValueAt(rowIndex, "period").toString()); 
        
        if (tableModel != null){
            if(colName.equals("day")) {
                switch(period){
                    case CRON_PERIOD_WEEKDAY:
                        displayDay = tableModel.getValueAt(rowIndex, "day").toString().split(",");
                        for(int i=0; i<displayDay.length; i++){
                            displayDay[i] = weekday[Integer.parseInt(displayDay[i])];
                        }
                        dataStr = joinArray2String(displayDay
                                                  ,NSMessageDriver.getInstance().getMessage(session, "nas_snapshot/snapschedule/separateSign"));                    
                        break;
                    case CRON_PERIOD_MONTHDAY:
                        displayDay = tableModel.getValueAt(rowIndex, "day").toString().split(",");
                        for(int i=0; i<displayDay.length; i++){
                            displayDay[i] = displayDay[i] + NSMessageDriver.getInstance().getMessage(session, "nas_snapshot/snapschedule/unit_day");
                        }                        
                        dataStr = joinArray2String(displayDay
                                                   ,NSMessageDriver.getInstance().getMessage(session, "nas_snapshot/snapschedule/separateSign"));
                        break;
                    case CRON_PERIOD_DAILY:
                        dataStr = NSMessageDriver.getInstance().getMessage(session, "nas_snapshot/snapschedule/td_daily");
                        break;
                    case CRON_PERIOD_DIRECTEDIT:
                        dataStr = tableModel.getValueAt(rowIndex, "directEditInfo").toString();
                        break;
                }
            } else if(colName.equals("hour")){
                if(period == CRON_PERIOD_DIRECTEDIT) {
                    dataStr = "";
                } else {
                    dataStr = tableModel.getValueAt(rowIndex, "hour").toString()
                              + NSMessageDriver.getInstance().getMessage(session, "nas_snapshot/snapschedule/unit_hour")
                              + "  "
                              + df.format(Double.parseDouble(tableModel.getValueAt(rowIndex, "minute").toString()))
                              + NSMessageDriver.getInstance().getMessage(session, "nas_snapshot/snapschedule/unit_minute");
                }
            }else{
                dataStr = NSMessageDriver.getInstance().getMessage(session, "nas_ddrschedule/ddrschlist/td_"
                                    + tableModel.getValueAt(rowIndex, "action").toString());
                if(tableModel.getValueAt(rowIndex, "syncMode") != null ){
                    dataStr = dataStr + "(" + NSMessageDriver.getInstance().getMessage(session, "nas_ddrschedule/ddrschlist/td_"
                                    + tableModel.getValueAt(rowIndex, "syncMode").toString()) + ")";
                }
            }
        }
        
        return dataStr;
    }
    
    private String joinArray2String(String[] paramArray, String joinSign){
        StringBuffer tmpResult = new StringBuffer();
        for(int i=0; i<paramArray.length; i++){
            tmpResult.append(paramArray[i]);
            if(i!=paramArray.length-1){
                tmpResult.append(joinSign);
            }
        }
        return tmpResult.toString();
    }
}