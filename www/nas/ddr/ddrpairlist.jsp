<!--
        Copyright (c) 2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: ddrpairlist.jsp,v 1.11 2008/05/30 02:54:51 liuyq Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.nec.nsgui.taglib.nssorttab.*"%>
<%@ page import="com.nec.nsgui.action.ddr.DdrActionConst"%>

<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/tld/nssorttab.tld" prefix="nssorttab"%>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror"%>

<html>
<head>
<%@ include file="/common/head.jsp"%>
<%@ include file="ddrcommon.jsp"%>
<script language="JavaScript" src="/nsadmin/common/common.js"></script>
<script language="JavaScript">
var winHeartBeat;
function onRadioClick(value) {
    if (!parent || !parent.btnframe || !parent.btnframe.document.forms[0] || isSubmitted()){
        return false;
    }
        
    var mvPairInfo = value.split("<%=DdrActionConst.SEPARATOR_BETWEEN_MVINFO%>");
	// set current's pair's info to hidden-element of form.
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
    
    // disable all button of btnframe.
    disableInputElement(parent.btnframe.document);
    
    // enable [Detail...] button.
    parent.btnframe.document.forms[0].moreInfoBtn.disabled      = false;
    
    <logic:notEqual name="<%=DdrActionConst.SESSION_DDR_ACTIVE_ASYNCPAIR%>" value="true" scope="session">
    	var status = mvPairInfo[10].replace(/[<%=DdrActionConst.INFO_NODATA%>]/g,"");
    	
        var hasAbnormalPair = false;
        // current pair is not async-status and abnormal.
    	if ( status == "" ) {
	    	// enable [schedule modify...] button.
		    if(mvPairInfo[0]=="<%=DdrActionConst.USAGE_GENERATION%>" 
		          && mvPairInfo[6].split("<%=DdrActionConst.SEPARATOR_BETWEEN_SCHEDULE%>").length == 1 
		          && mvPairInfo[6] != "--" ){
		    	parent.btnframe.document.forms[0].modifyPairBtn.disabled   	= false
		    }
	    }
        else if ( status == "<%=DdrActionConst.PAIRINFO_STATUS_ABNORMALITYCOMPOSITION%>" ) {
            hasAbnormalPair = true;
        }
	    <bean:define id="hasAsyncVolume" name="<%=DdrActionConst.SESSION_DDR_ASYNCVOL%>" scope="session" type="java.lang.Boolean" />
		<bean:define id="hasAsyncPair" name="<%=DdrActionConst.SESSION_DDR_ASYNCPAIR%>" scope="session" type="java.lang.Boolean" />

	    var hasAsyncVolume = <%=hasAsyncVolume%>;
	    var hasAsyncPair = <%=hasAsyncPair%>;
	    
	    // do not enable the [Extend...] and [unpair] button if there is
	    // async volumn or async pair in the cluster or current pair is abnormal.
	    if ( !( hasAsyncVolume || hasAsyncPair || hasAbnormalPair ) ){
	    	// get the number of rv.
		    var rvNumber = mvPairInfo[2].split("<%=DdrActionConst.SEPARATOR_BETWEEN_RVINFO%>").length;
		    
		    // get the specified syncState's list.
		    var syncStateListAry = mvPairInfo[3].split("<%=DdrActionConst.SEPARATOR_BETWEEN_RVINFO%>");
		    
		    var separatedStateNumber = 0;
		    var cancelStateNumber = 0;
		    var faultStateNumber = 0;
		    
		    for (var i = 0; i < syncStateListAry.length; i++){
		    	switch (syncStateListAry[i]){
		    		case "<%=DdrActionConst.SYNCSTATE_SEPARATED%>":
		    			separatedStateNumber++;
		    			break;
		    		case "<%=DdrActionConst.SYNCSTATE_CANCEL%>":
		    			cancelStateNumber++;
		    			break;
		    		case "<%=DdrActionConst.SYNCSTATE_FAULT%>":
		    			faultStateNumber++;
		    			break;
		    		default:
		    			break;
		    	}
		    }
	    
		    // enable [Extend...] button if every pair meets the condition.
		    if ( separatedStateNumber == rvNumber){
		    	parent.btnframe.document.forms[0].extendPairBtn.disabled    = false;
		    }
	    
		    // enable [unpair] button if every pair meets the condition.
		    if ( (separatedStateNumber + cancelStateNumber + faultStateNumber) == rvNumber && mvPairInfo[6].split("<%=DdrActionConst.SEPARATOR_BETWEEN_SCHEDULE%>").length == 1 ){
		    	parent.btnframe.document.forms[0].unpairBtn.disabled    = false;
		    }
	    }
    </logic:notEqual>
}

//load the bottom page when this page has been loaded
function loadBtnFrame(){
	if (parent.btnframe){
        setTimeout('parent.btnframe.location="' + '<html:rewrite page="/ddrPairListBtn.do"/>' + '"',1);
  	}
}

function onDelete(){   
    if (isSubmitted()) {
        return false;
    }
    var mvName = document.forms[0].elements["ddrPairInfo.mvName"].value.replace("NV_LVM_","");
    var rvName = document.forms[0].elements["ddrPairInfo.rvName"].value.replace(/#/g, ",");
    var schedule = document.forms[0].elements["ddrPairInfo.schedule"].value.replace(/[#-]/g, "");
    
    var msg="<bean:message key="common.confirm" bundle="common"/>" +"\r\n"+
        "<bean:message key="common.confirm.action" bundle="common"/>"+ 
        "<bean:message key="common.button.delete" bundle="common"/>"+ "\r\n" +
        "<bean:message key="ddr.unpair.confirm.pair"/>" + mvName +": "+ rvName; 
    
    var patrnBlank = /^\s*$/;
    if ( patrnBlank.exec(schedule) == null ) {
        msg = "<bean:message key="ddr.unpair.confirm.schedule"/>" + "\r\n" + msg;
    }
    
    if(confirm(msg)){
        setSubmitted();
        winHeartBeat = openHeartBeatWin();
        lockMenu();
        document.forms[0].target = "_self";
        document.forms[0].action ="ddrUnpair.do";
        document.forms[0].submit();
        return true;
    }else{
        return  false;
    }
} 

function onDelAsyncPair(mvName) {
    if (isSubmitted()) {
        return false;
    }
    var mvName4show = mvName.replace("NV_LVM_","");
    var msg="<bean:message key="ddr.delAsyncPair.confirm"/>" + "\r\n" +
        "<bean:message key="ddr.unpair.confirm.mvName"/>"+ mvName4show;
    if(confirm(msg)){
        setSubmitted();
        lockMenu();
        document.forms[0].target = "_self";
        document.forms[0].action = 'ddrDelAsyncFile.do?mvName='+mvName;
        document.forms[0].submit();
        return true;
    }else{
        return  false;
    }
}

function onModifyDdrPair(){
	if (isSubmitted()) {
        return false;
    }
    setSubmitted();
    lockMenu();
    document.forms[0].target = "_self";
    document.forms[0].action = "ddrSchedule.do?operation=modifyShow";
    document.forms[0].submit();
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

function onExtendDdrPair(){
	if (isSubmitted()) {
        return false;
    }
    setSubmitted();
    lockMenu();
    document.forms[0].target = "_self";
    document.forms[0].action = "/nsadmin/ddr/moduleForward.do?msgKey=apply.backup.ddr.forward.to.ddrEntry&url=/nsadmin/ddr/ddrPairExtendShow.do?operation=loadPairExtendTop";
    document.forms[0].submit();
}

</script>
</head>
<body onload="loadBtnFrame();setHelpAnchor('disk_backup_1');" 
      onUnload="unLockMenu();closeDetailErrorWin();closePopupWin(winHeartBeat);closePopupWin(ddrDetailWin);unloadBtnFrame();">

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
    <displayerror:error h1_key="ddr.h1"/>
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
				sidesort="<%=DdrActionConst.PAIR_LIST_COL_MVNAME%>">
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
				
				<logic:equal name='<%=DdrActionConst.SESSION_DDR_CUR_NODE_NEED_CLEARBUTTON%>' value="true" scope="session">
					<nssorttab:column name='<%=DdrActionConst.PAIR_LIST_COL_CLEARBUTTON%>' 
						th="STHeaderRender"
						td="com.nec.nsgui.action.ddr.STDataRender4PairList" 
						sortable="no">
					</nssorttab:column>
				</logic:equal>
			</logic:equal>
			
		</nssorttab:table>
	</logic:notEmpty>
</html:form>
</body>
</html>
