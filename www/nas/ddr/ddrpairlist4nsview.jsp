<!--
        Copyright (c) 2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: ddrpairlist4nsview.jsp,v 1.7 2008/05/30 02:55:15 liuyq Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.nec.nsgui.taglib.nssorttab.*"%>
<%@ page import="com.nec.nsgui.action.ddr.DdrActionConst"%>

<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/tld/nssorttab.tld" prefix="nssorttab"%>

<html>
<head>
<%@ include file="/common/head.jsp"%>
<%@ include file="ddrcommon.jsp"%>
<script language="JavaScript" src="/nsadmin/common/common.js"></script>
<script language="JavaScript">
function onRadioClick(value) {
    if (!parent || !parent.btnframe || !parent.btnframe.document.forms[0] || isSubmitted()){
        return false;
    }
    
	var mvPairInfo = value.split("<%=DdrActionConst.SEPARATOR_BETWEEN_MVINFO%>");
	// set current's pair's info to hidden-element of form[1].
    document.forms[0].elements["ddrPairInfo.usage"].value  				= mvPairInfo[0];
    document.forms[0].elements["ddrPairInfo.mvName"].value     			= mvPairInfo[1];
    document.forms[0].elements["ddrPairInfo.rvName"].value       		= mvPairInfo[2];
    document.forms[0].elements["ddrPairInfo.syncState"].value        	= mvPairInfo[3];
    document.forms[0].elements["ddrPairInfo.progressRate"].value  		= mvPairInfo[4];
    document.forms[0].elements["ddrPairInfo.syncStartTime"].value 		= mvPairInfo[5];
    document.forms[0].elements["ddrPairInfo.schedule"].value      		= mvPairInfo[6];
    document.forms[0].elements["ddrPairInfo.mvLdNameList"].value      	= mvPairInfo[7];
    document.forms[0].elements["ddrPairInfo.rvLdNameList"].value      	= mvPairInfo[8];
    document.forms[0].elements["ddrPairInfo.copyControlState"].value    = mvPairInfo[9];
    document.forms[0].elements["ddrPairInfo.status"].value      		= mvPairInfo[10];
    document.forms[0].elements["ddrPairInfo.rvResultCode"].value    	= mvPairInfo[11];
    document.forms[0].elements["ddrPairInfo.mvResultCode"].value    	= mvPairInfo[12];
    document.forms[0].elements["ddrPairInfo.schedResultCode"].value    	= mvPairInfo[13];
}

//load the bottom page when this page has been loaded
function loadBtnFrame(){
	if (parent.btnframe){
        setTimeout('parent.btnframe.location="' + '<html:rewrite page="/ddrPairList4NsviewBtn.do"/>' + '"',1);
  	}
}

var ddrDetailWin;
function displayDetail(){
    if (isSubmitted()){
       return false;
    }
    
    if ((ddrDetailWin == null) || (ddrDetailWin.closed)) {
	    ddrDetailWin = window.open("/nsadmin/common/commonblank.html", "ddr_detail_navigator",
	                                  "left=1,top=1,width=650,height=810,resizable=yes,scrollbars=yes");
	    document.forms[0].target = "ddr_detail_navigator";
	    document.forms[0].action = "/nsadmin/ddr/moduleForward.do?msgKey=apply.backup.ddr.forward.to.ddrEntry&h1=apply.backup.ddr&doNotLock=yes&url=/nsadmin/ddr/ddrPairDetail.do";
	    document.forms[0].submit();  
    } else {
        ddrDetailWin.focus();
        document.forms[0].submit();
    }
    return true;
}
</script>
</head>
<body onload="loadBtnFrame();setHelpAnchor('disk_backup_1');" onUnload="unLockMenu();closePopupWin(ddrDetailWin);unloadBtnFrame();">
<html:form action="ddrUnpair.do">
	<input type="hidden" name="ddrPairInfo.usage" value="" />
	<input type="hidden" name="ddrPairInfo.mvName" value="" />
	<input type="hidden" name="ddrPairInfo.rvName" value="" />
	<input type="hidden" name="ddrPairInfo.syncState" value="" />
	<input type="hidden" name="ddrPairInfo.progressRate" value="" />
	<input type="hidden" name="ddrPairInfo.syncStartTime" value="" />
	<input type="hidden" name="ddrPairInfo.mvLdNameList" value="" />
	<input type="hidden" name="ddrPairInfo.rvLdNameList" value="" />
	<input type="hidden" name="ddrPairInfo.schedule" value="" />
	<input type="hidden" name="ddrPairInfo.copyControlState" value="" />
	<input type="hidden" name="ddrPairInfo.status" value="" />
	<input type="hidden" name="ddrPairInfo.rvResultCode" value="" />
	<input type="hidden" name="ddrPairInfo.mvResultCode" value="" />
	<input type="hidden" name="ddrPairInfo.schedResultCode" value="" />
    <html:button property="reloadBtn" onclick="return loadDdrPairList();">
        <bean:message key="common.button.reload" bundle="common" />
    </html:button>
    <br>
    <br>
<logic:empty name="ddrPairInfoList" scope="request">
	<bean:message key="pair.info.nopair" />
</logic:empty> 
<logic:notEmpty name="ddrPairInfoList" scope="request">
	<bean:define id="ddrPairInfoList" name="ddrPairInfoList" scope="request" type="java.util.ArrayList" />
	<nssorttab:table tablemodel="<%=new ListSTModel((ArrayList)ddrPairInfoList)%>"
		id="pairList" table="border=1" 
		sortonload='<%=(DdrActionConst.PAIR_LIST_COL_USAGE + ":ascend")%>'>

		<nssorttab:column name='<%=DdrActionConst.PAIR_LIST_COL_RADIO%>' 
			th="STHeaderRender"
			td="com.nec.nsgui.action.ddr.STDataRender4PairList" 
			sortable="no">
		</nssorttab:column>

		<nssorttab:column name='<%=DdrActionConst.PAIR_LIST_COL_USAGE%>' 
			th="STHeaderRender"
			td="com.nec.nsgui.action.ddr.STDataRender4PairList"
			sortable="no" 
			sidesort='<%=DdrActionConst.PAIR_LIST_COL_MVNAME%>'>
			<bean:message key="pair.info.usage" />
		</nssorttab:column>

		<nssorttab:column name='<%=DdrActionConst.PAIR_LIST_COL_MVNAME%>' 
			th="STHeaderRender"
			td="com.nec.nsgui.action.ddr.STDataRender4PairList"
			sortable="no">
			<bean:message key="pair.info.mvname" />
		</nssorttab:column>

		<nssorttab:column name='<%=DdrActionConst.PAIR_LIST_COL_RVNAME%>' 
			th="STHeaderRender"
			td="com.nec.nsgui.action.ddr.STDataRender4PairList" 
			sortable="no">
			<bean:message key="pair.info.rvname" />
		</nssorttab:column>

		<nssorttab:column name='<%=DdrActionConst.PAIR_LIST_COL_SYNCSTATE%>' 
			th="STHeaderRender"
			td="com.nec.nsgui.action.ddr.STDataRender4PairList" 
			sortable="no">
			<bean:message key="pair.info.syncstate" />
		</nssorttab:column>

		<nssorttab:column name='<%=DdrActionConst.PAIR_LIST_COL_PROGRESSRATE%>' 
			th="STHeaderRender"
			td="com.nec.nsgui.action.ddr.STDataRender4PairList" 
			sortable="no">
			<bean:message key="pair.info.progressrate" />
		</nssorttab:column>

		<nssorttab:column name='<%=DdrActionConst.PAIR_LIST_COL_SYNCSTARTTIME%>' 
			th="STHeaderRender"
			td="com.nec.nsgui.action.ddr.STDataRender4PairList" 
			sortable="no">
			<bean:message key="pair.info.syncstarttime" />
		</nssorttab:column>

		<nssorttab:column name='<%=DdrActionConst.PAIR_LIST_COL_SCHEDULE%>' 
			th="STHeaderRender"
			td="com.nec.nsgui.action.ddr.STDataRender4PairList" 
			sortable="no">
			<bean:message key="pair.info.schedule" />
		</nssorttab:column>
		
		<logic:equal name='<%=DdrActionConst.SESSION_DDR_CUR_NODE_HAS_STATUS%>' value="true" scope="session">
			<nssorttab:column name='<%=DdrActionConst.PAIR_LIST_COL_STATUS%>' 
				th="STHeaderRender"
				td="com.nec.nsgui.action.ddr.STDataRender4PairList" 
				sortable="no">
				<bean:message key="pair.info.status" />
			</nssorttab:column>
	
			<logic:equal name='<%=DdrActionConst.SESSION_DDR_CUR_NODE_HAS_ERROR%>' value="true" scope="session">
				<nssorttab:column name='<%=DdrActionConst.PAIR_LIST_COL_ERRORCODE%>' 
					th="STHeaderRender"
					td="com.nec.nsgui.action.ddr.STDataRender4PairList" 
					sortable="no">
					<bean:message key="pair.info.errorcode" />
				</nssorttab:column>
			</logic:equal>
		</logic:equal>
	</nssorttab:table>
</logic:notEmpty>
</html:form>
</body>
</html>
