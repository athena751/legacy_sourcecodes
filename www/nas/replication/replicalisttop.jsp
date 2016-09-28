<!--
        Copyright (c) 2005-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: replicalisttop.jsp,v 1.15 2008/10/09 09:53:01 chenb Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.nec.nsgui.taglib.nssorttab.*"%>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>
<%@ page import="com.nec.nsgui.action.volume.VolumeActionConst"%>
<%@ page import="com.nec.nsgui.action.ddr.DdrActionConst"%>
<%@ page import="com.nec.nsgui.action.replication.ReplicationActionConst"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/tld/nssorttab.tld" prefix="nssorttab"%>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror"%>

<html:html lang="true">
<head>
<%@ include file="/common/head.jsp"%>
<%@ include file="replicationcommon.jsp"%>
<script language="JavaScript" src="/nsadmin/common/common.js"></script>
<script language="JavaScript">
function init() {
    <logic:equal name="asyncVol" value="true" scope="session">
        document.forms[0].createBtn.disabled = true;
    </logic:equal>
    <logic:equal name="<%=DdrActionConst.SESSION_DDR_ASYNCPAIR%>" value="true" scope="session">
		document.forms[0].createBtn.disabled = true;
    </logic:equal>
    if (parent.btnframe){
        setTimeout('parent.btnframe.location="' + '<html:rewrite page="/replicaListBottom.do"/>' + '"',1);
    }
}

function onRadioClick(value) {
    if (!parent || !parent.btnframe || !parent.btnframe.document.forms[0]){
        return false;
    }

    var tmp = value.split("$");

    document.forms[1].elements["replicaInfo.originalServer"].value  = tmp[0];
    document.forms[1].elements["replicaInfo.filesetName"].value     = tmp[1];
    document.forms[1].elements["replicaInfo.connected"].value       = tmp[2];
    document.forms[1].elements["replicaInfo.syncRate"].value        = tmp[3];
    document.forms[1].elements["replicaInfo.transInterface"].value  = tmp[4];
    document.forms[1].elements["replicaInfo.replicationData"].value = tmp[5];
    document.forms[1].elements["replicaInfo.mountPoint"].value      = tmp[6];
    document.forms[1].elements["replicaInfo.hasShared"].value       = tmp[7];
    document.forms[1].elements["replicaInfo.hasMounted"].value      = tmp[8];
    document.forms[1].elements["replicaInfo.originalMP"].value      = tmp[9];
    document.forms[1].elements["replicaInfo.onceConnected"].value   = tmp[10];
    document.forms[1].elements["replicaInfo.volumeName"].value      = tmp[11];
    document.forms[1].elements["replicaInfo.wpCode"].value          = tmp[12];
    document.forms[1].elements["replicaInfo.snapKeepLimit"].value   = tmp[13];
    document.forms[1].elements["replicaInfo.repliMethod"].value     = tmp[14];
    document.forms[1].elements["replicaInfo.volSyncInFileset"].value= tmp[15];
    
    <logic:equal name="asyncVol" value="true" scope="session">
        return;
    </logic:equal> 
    <logic:equal name="<%=DdrActionConst.SESSION_DDR_ASYNCPAIR%>" value="true" scope="session">
		return;
    </logic:equal>
    // enable btmframe all button
    parent.btnframe.document.forms[0].modifyBtn.disabled       = false;
    parent.btnframe.document.forms[0].promoteBtn.disabled      = false;
    parent.btnframe.document.forms[0].ctrlInNodeBtn.disabled   = false;
    parent.btnframe.document.forms[0].volSyncBtn.disabled      = false;
    parent.btnframe.document.forms[0].delBtn.disabled          = false;
    parent.btnframe.document.forms[0].delVolumeChkbox.disabled = false;
    
    // if the replica has been set CIFS|NFS|FTP share, disable "Delete the volume" checkbox
    if (tmp[7] == "0x1080001b" || tmp[7] == "0x1080001c") {
        parent.btnframe.document.forms[0].delVolumeChkbox.disabled = true;     
    }
    
    // if the replica is connected, disable Promote button
    if (tmp[2] == "yes") {
        parent.btnframe.document.forms[0].promoteBtn.disabled      = true;    
    }
    
    // if the replica has never been connected, disable Promote and Ctrl In Node button
    if (tmp[10] == "no") {
        parent.btnframe.document.forms[0].promoteBtn.disabled      = true;
        parent.btnframe.document.forms[0].ctrlInNodeBtn.disabled   = true;    
    }
    
    // disable Volume Sync button if syncRate is not stopped
    if (tmp[3] != "stopped") {
    	parent.btnframe.document.forms[0].volSyncBtn.disabled = true;
    }
    
    // disable all button and checkbox of btnframe if there is sync volume in selected fileset
    if (tmp[15] == "1") {
    	parent.btnframe.disableAllBtn();
    }
    
    // disable ctrlInNode buttton and volumeSync button if original does not exist
    if (tmp[15] == "<%=ReplicationActionConst.ERR_ORIGINAL_NOT_EXIST%>") {
    	parent.btnframe.document.forms[0].ctrlInNodeBtn.disabled = true;    	
    	parent.btnframe.document.forms[0].volSyncBtn.disabled    = true;
    }
}


function onCreate() {
    if (isSubmitted()) {
        return false;
    }
    
    setSubmitted();
    window.location="<html:rewrite page='/replicaCreateShow.do'/>";
    return true;
}

function onModify() {
    if (isSubmitted()) {
        return false;
    }

    if (document.forms[1].elements["replicaInfo.hasMounted"].value == "no") {
        alert("<bean:message key="replica.mountPoint.unmount"/>");
        return false;    
    }

    setSubmitted();
    document.forms[1].action="/nsadmin/replication/replicaModify.do?operation=display";
    document.forms[1].submit();

    return true;   
}

function onPromote(){
    if (isSubmitted()) {
        return false;
    }
    
    if (document.forms[1].elements["replicaInfo.hasMounted"].value == "no") {
        alert("<bean:message key="replica.mountPoint.unmount"/>");
        return false;    
    }

    setSubmitted();
    document.forms[1].action="/nsadmin/replication/forwardReplicaPromote.do";
    document.forms[1].submit();

    return true;   
}

function onCtrlInNode(){
    if (isSubmitted()) {
        return false;
    }
    
    if (document.forms[1].elements["replicaInfo.hasMounted"].value == "no") {
        alert("<bean:message key="replica.mountPoint.unmount"/>");
        return false;    
    }

    if (document.forms[1].elements["replicaInfo.originalMP"].value == "--") {
        alert("<bean:message key="replica.noLocalOriginal"/>");
        return false;    
    }

    setSubmitted();
    document.forms[1].action="/nsadmin/replication/forwardReplicaCtrlInNode.do";
    document.forms[1].submit();

    return true;
}

function onVolSync(){
    if (isSubmitted()) {
        return false;
    }

    setSubmitted();
    document.forms[1].action="/nsadmin/replication/replicaVolumeSyncShow.do";
    document.forms[1].submit();

    return true;
}

var heartbeatWin;
function onDelete(){
    if (isSubmitted()) {
        return false;
    }
    
    if (document.forms[1].elements["replicaInfo.hasMounted"].value == "no") {
        alert("<bean:message key="replica.mountPoint.unmount"/>");
        return false;    
    }
    
    var warning = "";
    var confirmMsg = "<bean:message key="common.confirm" bundle="common"/>" + "\r\n"
              + "<bean:message key="common.confirm.action" bundle="common"/>" 
              + "<bean:message key="common.button.delete" bundle="common"/>";
    if (!(parent.btnframe.document.forms[0].delVolumeChkbox.disabled)
        && (parent.btnframe.document.forms[0].delVolumeChkbox.checked)) {
        document.forms[1].delVolumeFlag.value = "true";
        
        if (document.forms[1].elements["replicaInfo.wpCode"].value != "-1" 
            && document.forms[1].elements["replicaInfo.wpCode"].value != "--"){
            alert("<bean:message key="alert.del.haswriteprotect" bundle="volume/replication"/>");
            return false; 
        }
        warning = "\r\n" + '<bean:message key="msg.del.warning" bundle="volume/replication"/>'
                  + "\r\n" + "\r\n"
                  + '<bean:message key="msg.longTimeWait" bundle="volume/replication"/>';
        if(document.forms[1].elements["replicaInfo.hasShared"].value == "0x1080001a"){
           confirmMsg = '<bean:message key="msg.delmp.useftp"/>'
                  + "\r\n" + "\r\n"
                  + '<bean:message key="msg.longTimeWait" bundle="volume/replication"/>';
        }else{
           confirmMsg = confirmMsg + "\r\n" + warning;
        }
    } else {
    	document.forms[1].delVolumeFlag.value = "false";
    }
    
    if (confirm(confirmMsg)){  
        setSubmitted();
        if (document.forms[1].delVolumeFlag.value == "true") {
            heartbeatWin = openHeartBeatWin();
        }
        document.forms[1].submit();
        return true;   
    }
    
    return false;
}

function onDelAsyncVol(filesetName, volName) {
    if (isSubmitted()) {
        return false;
    }
    
    if (confirm("<bean:message key="info.confirm.delTmpFile" bundle="volume/replication"/>")) {
        setSubmitted();  
        window.location='/nsadmin/volume/clearTmpFile.do?volName=' + volName;
        return true;
    }
        
    return false;
}
</script>
</head>
<body onload="init();setHelpAnchor('replication_5');" 
      onUnload="closeDetailErrorWin();closePopupWin(heartbeatWin);unloadBtnFrame();">
<form>
	<html:button property="reloadBtn" onclick="return loadReplicaList();">
	    <bean:message key="common.button.reload" bundle="common"/>
	</html:button>&nbsp;
	
	<html:button property="createBtn" onclick="return onCreate();">
	    <bean:message key="common.button.create2" bundle="common"/>
	</html:button>
	<br>
	<displayerror:error h1_key="replicate.h1"/>
    <br>
    <logic:empty name="replicaInfoList" scope="request">
        <bean:message key="replica.info.noReplica"/>
    </logic:empty>
    <logic:notEmpty name="replicaInfoList" scope="request">
        <bean:define id="replicaInfoList" name="replicaInfoList" scope="request" type ="java.util.ArrayList"/>
        <nssorttab:table tablemodel="<%=new ListSTModel((ArrayList)replicaInfoList)%>" 
                        id="replicaList" 
                        table="border=1" 
                        sortonload="originalServer:ascend">

            <nssorttab:column name="radio"
                              th="STHeaderRender"
                              td="com.nec.nsgui.action.replication.STDataRender4Replica"
                              sortable="no">
            </nssorttab:column>
            
            <nssorttab:column name="originalServer"
                              th="STHeaderRender"
                              td="com.nec.nsgui.action.replication.STDataRender4Replica"
                              sortable="yes">
                <bean:message key="replication.info.oriservername"/>
            </nssorttab:column>
            
            <nssorttab:column name="filesetName"
                              th="STHeaderRender"
                              td="STDataRender"
                              sortable="yes">
                <bean:message key="replication.info.filesetname"/>
            </nssorttab:column>            

            <nssorttab:column name="connected"
                              th="STHeaderRender"
                              td="com.nec.nsgui.action.replication.STDataRender4Replica"
                              sortable="no">
                <bean:message key="replica.th.connected"/>
            </nssorttab:column>                              

            <nssorttab:column name="syncRate"
                              th="STHeaderRender"
                              td="com.nec.nsgui.action.replication.STDataRender4Replica"
                              sortable="no">
                <bean:message key="replica.th.syncRate"/>
            </nssorttab:column>

            <nssorttab:column name="transInterface"
                              th="STHeaderRender"
                              td="com.nec.nsgui.action.replication.STDataRender4Replica"
                              sortable="no">
                <bean:message key="replication.info.interface"/>
            </nssorttab:column>    

            <nssorttab:column name="replicationData"
                              th="STHeaderRender"
                              td="com.nec.nsgui.action.replication.STDataRender4Replica"
                              sortable="no">
                <bean:message key="replication.info.replidata"/>
            </nssorttab:column>    
            
            <nssorttab:column name="mountPoint"
                              th="STHeaderRender"
                              td="STDataRender"
                              sortable="yes">
                <bean:message key="replication.info.mountpoint"/>
            </nssorttab:column>

            <nssorttab:column name="snapKeepLimit"
                              th="STHeaderRender"
                              td="com.nec.nsgui.action.replication.STDataRender4Replica"
                              sortable="no">
                <bean:message key="replication.th.snapKeep"/>
            </nssorttab:column>              

            <logic:notEqual name="isNashead" value="true" scope="session">
			    <logic:equal name="asyncReplica" value="true" scope="session">
		            <nssorttab:column name="asyncStatus"
					                  th="STHeaderRender"
					                  td="com.nec.nsgui.action.replication.STDataRender4Replica"
					                  sortable="no">
		                <bean:message key="info.asyncStatus" bundle="volume/replication"/>
		            </nssorttab:column>
		            <logic:equal name="asyncErr" value="true" scope="session">
			            <nssorttab:column name="errCode"
		                                  th="STHeaderRender"
		                                  td="com.nec.nsgui.action.replication.STDataRender4Replica"
		                                  sortable="no">
		                    <bean:message key="info.errCode" bundle="volume/replication"/>
		                </nssorttab:column>
		                <%NSActionUtil.setSessionAttribute(request, VolumeActionConst.SESSION_FROM, "replica");%>
		                <nssorttab:column name="confirmDel"
	                                      th="STHeaderRender"
	                                      td="com.nec.nsgui.action.replication.STDataRender4Replica"
	                                      sortable="no">
	                    </nssorttab:column> 	            
		            </logic:equal>           
			    </logic:equal>             
            </logic:notEqual>                                                                        
        </nssorttab:table>
    </logic:notEmpty>    
</form>

<html:form action="replicaList.do?operation=delete">
    <input type="hidden" name="replicaInfo.originalServer" value="">
    <input type="hidden" name="replicaInfo.filesetName" value="">
    <input type="hidden" name="replicaInfo.connected" value="">
    <input type="hidden" name="replicaInfo.syncRate" value="">
    <input type="hidden" name="replicaInfo.transInterface" value="">
    <input type="hidden" name="replicaInfo.replicationData" value="">
    <input type="hidden" name="replicaInfo.mountPoint" value="">
    <input type="hidden" name="replicaInfo.hasShared" value="">
    <input type="hidden" name="replicaInfo.hasMounted" value="">
    <input type="hidden" name="replicaInfo.originalMP" value="">
    <input type="hidden" name="replicaInfo.onceConnected" value="">
    <input type="hidden" name="replicaInfo.volumeName" value="">
    <input type="hidden" name="replicaInfo.wpCode" value="">
    <input type="hidden" name="replicaInfo.snapKeepLimit" value="">
    <input type="hidden" name="replicaInfo.repliMethod" value="">
    <input type="hidden" name="replicaInfo.volSyncInFileset" value="">            
    <input type="hidden" name="delVolumeFlag" value="">
</html:form>
</body>
</html:html>