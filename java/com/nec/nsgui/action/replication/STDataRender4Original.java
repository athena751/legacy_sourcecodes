/*
 *      Copyright (c) 2005-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.replication;

import java.util.AbstractList;

import javax.servlet.jsp.PageContext;

import org.apache.struts.Globals;
import org.apache.struts.taglib.TagUtils;
import org.apache.struts.util.MessageResources;

import com.nec.nsgui.action.base.NSActionConst;
import com.nec.nsgui.model.entity.replication.OriginalBean;
import com.nec.nsgui.taglib.nssorttab.ListSTModel;
import com.nec.nsgui.taglib.nssorttab.STAbstractRender;

/**
 *
 */
public class STDataRender4Original
    extends STAbstractRender
    implements NSActionConst, ReplicationActionConst {
    private static String replicationBundle =
        Globals.MESSAGES_KEY + "/replication";

    public static final String cvsid =
        "@(#) $Id: STDataRender4Original.java,v 1.6 2008/05/28 02:56:29 liy Exp $";

    /**
     * Get the HTML code which specified by (rowIndex, colName)
     * 
     * @param rowIndex
     * @param colName
     * @return HTML code
     * @throws Exception
     */
    public String getCellRender(int rowIndex, String colName)
        throws Exception {

        AbstractList originalList =
            ((ListSTModel) getTableModel()).getDataList();
        OriginalBean ori = (OriginalBean) originalList.get(rowIndex);
        PageContext context = getSortTagInfo().getPageContext();

        if (colName.equals("radioFset")) {
            return this.getCellRadio(rowIndex, context, ori);
        }
        if (colName.equals("filesetName")) {
                    return this.getCellFilesetName(rowIndex, context, ori);
                }
        

        if (colName.equals("bandWidth")) {
            return this.getCellBandwidth(rowIndex, context, ori);
        }

        if (colName.equals("replicaHost")) {
            return this.getCellReplicahost(rowIndex, context, ori);
        }
        if (colName.equals("transInterface")) {
            return this.getCellInterface(rowIndex, context, ori);
        }
        if (colName.equals("checkPoint")){
        	return this.getCellCheckpoint(rowIndex, context, ori);
        }
        return "";
    }
    
	private String getCellCheckpoint(
		        int rowIndex,
		        PageContext context,
		        OriginalBean ori)
		        throws Exception {		
		if(ori.getRepliMethod().equals(CONST_REPLI_METHOD_FULL)){		
			return "<td nowrap align=center>--</td>";
		}
		
		String dailyMsg =
			TagUtils.getInstance().message(
	                context,
	                replicationBundle,
	                null,
	                "original.info.daily");
		String nosettingMsg =
			TagUtils.getInstance().message(
	                context,
	                replicationBundle,
	                null,
	                "original.info.nosetting");
		String hour = ori.getHour();
		String minute = ori.getMinute();
		StringBuffer checkPointContent = new StringBuffer("<td nowrap align=left>");	
		if(hour.equals("--") && minute.equals("--")){
			checkPointContent.append(nosettingMsg);
		}else{
			checkPointContent.append(dailyMsg);
			checkPointContent.append("&nbsp;&nbsp;");
			checkPointContent.append(to2Digit(hour));
			checkPointContent.append(":").append(to2Digit(minute));
		}
		checkPointContent.append("</td>");
		return checkPointContent.toString();
	}

    //get value of current row
    private String getRowValue(
        int rowIndex,
        PageContext context,
        OriginalBean ori)
        throws Exception {



        //set interfaceIP
        String interfaceWithoutCard = ori.getTransInterface();
        if (interfaceWithoutCard.length() > 0) {
            int iBracket = interfaceWithoutCard.indexOf("(");
            if (iBracket >= 0) {

                interfaceWithoutCard =
                    interfaceWithoutCard.substring(0, iBracket);
            }

        }

        //set bandwidth unit
        String bandWidthWithUnit = ori.getBandWidth();
        bandWidthWithUnit = this.getBandWidthToShow(bandWidthWithUnit);

     
        StringBuffer value = new StringBuffer();
        value.append(ori.getFilesetName());
        value.append("$");
        value.append(ori.getConnectionAvailable());
        value.append("$");
        value.append(interfaceWithoutCard);
        value.append("$");
        value.append(bandWidthWithUnit);
        value.append("$");
        value.append(ori.getReplicaHost());
        value.append("$");
        value.append(ori.getMountPoint());
        value.append("$");
        value.append(ori.getHasMounted());
        value.append("$");
        value.append(ori.getType());
        value.append("$");
        value.append(ori.getVolSyncInFileset());
        value.append("$");
        value.append(ori.getHour());
        value.append("$");
        value.append(ori.getMinute());
        value.append("$");
        value.append(ori.getRepliMethod());


        return value.toString();
    }

    /**
     * get content of current radio row  
     * @param rowIndex
     * @return
     */
    private String getCellRadio(
        int rowIndex,
        PageContext context,
        OriginalBean ori)
        throws Exception {
        StringBuffer radioContent =
            new StringBuffer("<td nowrap align=center><input name=\"originalRadio\" type=\"radio\" ");
        radioContent.append(" id=\"replicaRadio");
        radioContent.append(Integer.toString( rowIndex));
        radioContent.append("\" ");        
        radioContent.append("onclick=\"onRadioClick(this.value);\" value=\"");
        radioContent.append(getRowValue(rowIndex, context, ori));
        radioContent.append("\" ");

        String checkedOriginal =
            (String) context.getSession().getAttribute(SESSION_FILESET);

        if ((checkedOriginal != null)
            && checkedOriginal.equals(ori.getFilesetName())) {
            radioContent.append("checked");
            context.getSession().setAttribute(SESSION_FILESET, null);
        }

        radioContent.append(" /></td>");

        return radioContent.toString();

    }

    /**
     * for bandwidth column
     * to get the HTML code between <td> and </td> which specified by (rowIndex, colName)
     * 
     * @param rowIndex
     * @param colName
     * @return HTML code
     * @throws Exception
     */
    private String getCellBandwidth(
        int rowIndex,
        PageContext context,
        OriginalBean ori)
        throws Exception {

        String value = ori.getBandWidth();

        String strUnlimited =
            TagUtils.getInstance().message(
                context,
                replicationBundle,
                null,
                "original.bandwidth.unlimited");

        if (value.equals("0")) {
            value = strUnlimited;

        } else {
            value = this.getBandWidthToShow(value);
            
            int len=value.length();
            long lValue=Long.parseLong(value.substring(0,len-1) );
            
            java.text.NumberFormat numfmt = java.text.NumberFormat.getInstance();
                        
            String strValue=numfmt.format(lValue);
            
            value=strValue+value.substring(len-1,len );         

        }
        return "<td nowrap align=right>" + value + "</td>";
    }

    //according to the true value of bandwidth whose unit is bps, to set the value to be showed in jsp

    private String getBandWidthToShow(String value) throws Exception {
        
        if (value.equals("0")) {
            return value;

        } else {

            long lValue;// = Long.parseLong(value);
            int len=value.length();
            char cUnit = value.charAt(len - 1);
            //the last char in "value"

            long lResidue; // residue 
            if (!Character.isDigit(cUnit)) //if bandwidth has unit
                {
                lValue=Long.parseLong(value.substring(0,len-1 ) );
                switch (Character.toUpperCase(cUnit)) {
                    //case 'G':               unit need no change ,and then value=value;

                    case 'M' :
                        lResidue = lValue % 1024; // residue 
                        if (lResidue == 0) // need to change unit
                            {
                            lValue = lValue / 1024;
                            value = Long.toString(lValue) + "G";
                        }
                        break;
                    case 'K' :
                        {
                            lResidue = lValue % 1024; // residue 

                            if (lResidue == 0) // need to change unit
                                {
                                lValue = lValue / 1024;
                                lResidue = lValue % 1024;
                                if (lResidue == 0) {
                                    lValue = lValue / 1024;
                                    value = Long.toString(lValue) + "G";
                                } else {
                                    value = Long.toString(lValue) + "M";
                                }
                            }
                            break;

                        }
                }

            } else //"value"  has no unit
                {
                lValue =Long.parseLong( value);  
                    
                lResidue = lValue % 1024; // residue 

                if (lResidue == 0) // need to change unit
                    {
                    lValue = lValue / 1024;
                    lResidue = lValue % 1024;
                    if (lResidue == 0) {
                        lValue = lValue / 1024;
                        lResidue = lValue % 1024;

                        if (lResidue == 0) {
                            lValue = lValue / 1024;
                            value = Long.toString(lValue) + "G";
                        } else {
                            value = Long.toString(lValue) + "M";
                        }
                    } else {
                        value = Long.toString(lValue) + "k";
                    }
                }
                //else , "value" donot change

            }
        }

        return value;
    }
    /**
     * for replicahost column
     * to get the HTML code between <td> and </td> which specified by (rowIndex, colName)
     * 
     * @param rowIndex
     * @param colName
     * @return HTML code
     * @throws Exception
     */
    private String getCellReplicahost(
        int rowIndex,
        PageContext context,
        OriginalBean ori)
        throws Exception {

        String value = ori.getReplicaHost();

        value = this.getReplicahostToShow(value, context);
        value = "<td nowrap>" + value + "</td>";
        return value;
    }

    //according to the true value of replica hosts to set the value to be showed in jsp
    private String getReplicahostToShow(
        String trueReplicahost,
        PageContext context)
        throws Exception {
        String rtnHost = "";

        String strNoContent =
            TagUtils.getInstance().message(
                context,
                replicationBundle,
                null,
                "original.info.nocontent");
        String strPermitAllHost =
            TagUtils.getInstance().message(
                context,
                replicationBundle,
                null,
                "original.replicahost.permitall");
        if (trueReplicahost.equals("localhost")) {
            rtnHost ="<center>" +strNoContent+"</center>";
        } else if (trueReplicahost.equals("all")) {
            rtnHost = "<center>" +strPermitAllHost+"</center>";
        } else if (trueReplicahost.equals("")) {        	
        	rtnHost = "&nbsp;";
        } else {
        	String[] hosts = trueReplicahost.split(",");
			int len = hosts.length;
			for (int i = 0; i < len; i++) {
				if (!hosts[i].equals("localhost")) {
					rtnHost += " " + hosts[i];
				}
			}
			rtnHost = rtnHost.trim();        
        }

        return rtnHost;
    }
    /**
     * for interface column
     * to get the interface code between <td> and </td> which specified by (rowIndex, colName)
     * 
     * @param rowIndex
     * @param colName
     * @return HTML code
     * @throws Exception
     */
    private String getCellInterface(
        int rowIndex,
        PageContext context,
        OriginalBean ori)
        throws Exception {

        String value = ori.getTransInterface();

        String strNoContent =
            TagUtils.getInstance().message(
                context,
                replicationBundle,
                null,
                "original.info.nocontent");

        if (value.equals("")) {
            value = "<td nowrap align=center>" + strNoContent + "</td>";
        } else {
            value = "<td nowrap align=center>" + value + "</td>";
        }
        return value;
    }
    
    //get filesetName
    private String getCellFilesetName(
        int rowIndex,
        PageContext context,
        OriginalBean ori)
        throws Exception {

        String value = ori.getFilesetName ();


        
         value = "<td nowrap ><label for=\"replicaRadio"+ rowIndex +"\">"+ value + "</label></td>";
       
        return value;
    }
    
//  add a left 0 for 1 digit String
    public static String to2Digit(String num){
        if(num.length() == 1){
        	return "0" + num;
        }
        return num;
    }
    
    
}
