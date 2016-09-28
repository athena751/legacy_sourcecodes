<!--
        Copyright (c) 2005-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: filesystemlistbottom.jsp,v 1.15 2008/04/19 13:46:06 jiangfx Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>
<%@ page import="com.nec.nsgui.action.filesystem.FilesystemConst"%>
<%@ page import="com.nec.nsgui.action.ddr.DdrActionConst"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>

<html:html lang="true">
<head>
<%@include file="/common/head.jsp" %>
<bean:define id="isNashead" value='<%=NSActionUtil.isNashead(request)?"true":"false"%>'/>
<bean:define id="isSingleNode" value='<%=NSActionUtil.isSingleNode(request)?"true":"false"%>'/>
<script language="JavaScript" src="/nsadmin/common/common.js"></script>
<script language="JavaScript" src="/nsadmin/common/validation.js"></script>
<script language="JavaScript">
function init(){
    var radioBtn;
    if (parent.frames[0].document.forms[0] && parent.frames[0].document.forms[0].elements["volumeRadio"] != null){
        radioBtn = parent.frames[0].document.forms[0].elements["volumeRadio"];
        if (!radioBtn.length){
            radioBtn.click();
        }else{
            var hasChecked = false;
            for (var i=0; i< radioBtn.length; i++){
                if (radioBtn[i].checked){
                    radioBtn[i].click();
                    hasChecked = true;
                }
            }
            if (!hasChecked){
                radioBtn[0].click();
            }
        }
    }   
    <logic:equal name="<%=FilesystemConst.SESSION_NV_ASYNC%>" value="true" scope="session">
        disableBtns();
    </logic:equal>
    <logic:equal name="<%=DdrActionConst.SESSION_DDR_ASYNCPAIR%>" value="true" scope="session">
        disableBtns();
    </logic:equal>
}

function disableBtns() {
    document.forms[0].mountBtn.disabled    = true;
    document.forms[0].extendBtn.disabled   = true;
    <logic:notEqual name="isSingleNode" value="true" scope="page">
        document.forms[0].moveBtn.disabled   = true;
    </logic:notEqual>
    document.forms[0].delBtn.disabled      = true;
    document.forms[0].forceFlag.disabled   = true;
}

function onDel(){
	if (isSubmitted()){
       return false;
    }
    if (document.forms[0].elements["fsInfo.wpPeriod"].value != "-1"
        && document.forms[0].elements["fsInfo.wpPeriod"].value != "--") {
        alert("<bean:message key="filesystem.del.alert.writeprotect"/>");
        return false;         
    }
	var action;
	var warning;
	var repliMsg = "";
	if (!document.forms[0].forceFlag.disabled
	    && document.forms[0].forceFlag.checked){
	    action = '<bean:message key="msg.force.del" />';
	    warning = '<bean:message key="msg.del.warning.force"/>';
	}else{
		action = '<bean:message key="btn.del" />';
		warning = '<bean:message key="msg.del.warning"/>';
	}	
	if (document.forms[0].elements["fsInfo.replicType"].value == "original"){
		repliMsg = '<bean:message key="msg.del.hasOriginal"/>';
	}
	if (document.forms[0].elements["fsInfo.replicType"].value == "replic"){
		repliMsg = '<bean:message key="msg.del.hasReplica"/>';
	}
	var confirmMsg = "<bean:message key="common.confirm" bundle="common" />" + "\r\n"
            + "<bean:message key="common.confirm.action" bundle="common"/>" 
            + action  + "\r\n"
            + "<bean:message key="info.mountpoint" bundle="volume/filesystem"/> : " 
            + document.forms[0].elements["fsInfo.mountPoint"].value + "\r\n"
            + warning + "\r\n\r\n"
            + repliMsg;
    if(document.forms[0].elements["fsInfo.useCode"].value == "0x1080001a"){
        confirmMsg = "<bean:message key="msg.delmp.useftp"/>";
    }       
	if (confirm(confirmMsg)){
        document.forms[0].target = "_parent";	        
	    setSubmitted();
	    document.forms[0].action = "filesystemListAndDel.do?operation=del";
	    lockMenu();
	    document.forms[0].submit();
	    return true;
	}
	return false;
}

function onMount(){
	if (isSubmitted()){
       return false;
    }
    
    document.forms[0].target = "_parent";
    setSubmitted();
	document.forms[0].action = "/nsadmin/filesystem/mountFS.do?operation=display";
	document.forms[0].submit();
	return true;
}

function onExtend(){
	if (isSubmitted()){
       return false;
    }
    
    document.forms[0].target = "_parent";
    setSubmitted();
    document.forms[0].action = "/nsadmin/filesystem/extendFSShow.do?from=list";
    lockMenu();
    document.forms[0].submit();
}

function onMoveMP(){
	if (isSubmitted()){
       return false;
    }
    
    // can not move the file system when GFS setting's already exists, (both in nashead add NV)
    if (document.forms[0].elements["fsInfo.useGfs"].value == "true") {
        alert("<bean:message key="filesystem.move.alert.gfs"/>");
        return false;         
    }
    
    // can not move the file system when set write-protect, (both in nashead add NV)
    if (document.forms[0].elements["fsInfo.wpPeriod"].value != "-1"
        && document.forms[0].elements["fsInfo.wpPeriod"].value != "--") {
        alert("<bean:message key="filesystem.move.alert.writeprotect"/>");
        return false;         
    }
    
    document.forms[0].target = "_parent";
    setSubmitted();
    document.forms[0].action = "/nsadmin/filesystem/moveFSShow.do";
    lockMenu();
    document.forms[0].submit();
}

var volumeDetailWin;
function onDetail(){
    if (isSubmitted()){
       return false;
    }
    
    if ((volumeDetailWin == null) || (volumeDetailWin.closed)) {
	    volumeDetailWin = window.open("/nsadmin/common/commonblank.html", "volume_detail_navigator",
	                                  "width=500,height=550,resizable=yes,scrollbars=yes");
	    document.forms[0].target = "volume_detail_navigator";
	    document.forms[0].action = "/nsadmin/filesystem/fsDetailShow.do?from=filesystem";
	    document.forms[0].submit();  
    } else {
        volumeDetailWin.focus();
        document.forms[0].submit();
    }
    return true;
}

</script>
</head>
<body onload="init();" onUnload="unLockMenu();closePopupWin(volumeDetailWin);">
    <html:form action="filesystemListAndDel.do?operation=del" target="_parent">
        <input type="hidden" name="fsInfo.volumeName" value="">
        <input type="hidden" name="fsInfo.mountPoint" value="">
        <input type="hidden" name="fsInfo.capacity" value="">
        <input type="hidden" name="fsInfo.quota" value="">
        <input type="hidden" name="fsInfo.noatime" value="">
        <input type="hidden" name="fsInfo.snapshot" value="">
        <input type="hidden" name="fsInfo.accessMode" value="">
        <input type="hidden" name="fsInfo.mountStatus" value="">
        <input type="hidden" name="fsInfo.replication" value="">
        <input type="hidden" name="fsInfo.replicType" value="">
        <input type="hidden" name="fsInfo.norecovery" value="">
        <input type="hidden" name="fsInfo.dmapi" value="">
        <input type="hidden" name="fsInfo.fsType" value="">
        <input type="hidden" name="fsInfo.useRate" value="">
        <input type="hidden" name="fsInfo.useGfs" value="">
        <input type="hidden" name="fsInfo.replication4Show" value="">
        <logic:equal name="isNashead" value="true" scope="page">
            <input type="hidden" name="fsInfo.lun" value="">
            <input type="hidden" name="fsInfo.storage" value="">
        </logic:equal>
        <logic:notEqual name="isNashead" value="true" scope="page">           
            <input type="hidden" name="fsInfo.raidType" value=""> 
            <input type="hidden" name="fsInfo.poolNameAndNo" value="">                   
            <input type="hidden" name="fsInfo.aid" value="">
            <input type="hidden" name="fsInfo.aname" value="">
            <input type="hidden" name="fsInfo.asyncStatus" value="">
            <input type="hidden" name="fsInfo.errCode" value="">  
        </logic:notEqual>
        <input type="hidden" name="fsInfo.useCode" value="">
        <input type="hidden" name="fsInfo.fsSize" value="">
        <input type="hidden" name="fsInfo.wpPeriod" value="">
           
        <html:button property="detailBtn" onclick="return onDetail()">
           <bean:message key="common.button.detail2" bundle="common"/>
        </html:button>&nbsp;        
        <html:button property="mountBtn" onclick="return onMount()">
		   <bean:message key="btn.mount"/>
		</html:button>&nbsp;
		<html:button property="extendBtn" onclick="onExtend()">
		   <bean:message key="btn.extend"/>
		</html:button>&nbsp;
		<logic:notEqual name="isSingleNode" value="true" scope="page">
	    	<html:button property="moveBtn" onclick="onMoveMP()">
	       		<bean:message key="btn.move"/>
	    	</html:button>
	    </logic:notEqual>
	    &nbsp;&nbsp;&nbsp;&nbsp;
	    <html:button property="delBtn" onclick="onDel()">
	       <bean:message key="btn.del"/>
	    </html:button>&nbsp;
	    <input type="checkbox" id="forceID" name="forceFlag" value="force"><label for="forceID">&nbsp;
	    <bean:message key="msg.force.del"/></label>
    </html:form>
</body>
</html:html>