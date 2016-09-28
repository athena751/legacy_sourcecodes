<!--
        Copyright (c) 2005-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: filesystemlisttop.jsp,v 1.16 2008/04/19 13:46:06 jiangfx Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nec.nsgui.taglib.nssorttab.*"%>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>
<%@ page import="com.nec.nsgui.action.filesystem.FilesystemConst"%>
<%@ page import="com.nec.nsgui.action.volume.VolumeActionConst"%>
<%@ page import="com.nec.nsgui.action.ddr.DdrActionConst"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/nssorttab.tld" prefix="nssorttab" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>

<html:html lang="true">

<head>
<%@include file="/common/head.jsp" %>
<bean:define id="isNashead" value='<%=NSActionUtil.isNashead(request)?"true":"false"%>'/>

<script language="JavaScript" src="/nsadmin/common/common.js"></script>
<script language="JavaScript">
function onRadioClick(value){
    if (!parent || !parent.frames[1] || !parent.frames[1].document.forms[0]
        || !parent.frames[1].document.forms[0].elements["fsInfo.volumeName"]){
        return;
    }
    var tmp = value.split("#");
    parent.frames[1].document.forms[0].elements["fsInfo.volumeName"].value = tmp[0];
    parent.frames[1].document.forms[0].elements["fsInfo.mountPoint"].value = tmp[1];
    parent.frames[1].document.forms[0].elements["fsInfo.capacity"].value = tmp[2];
    parent.frames[1].document.forms[0].elements["fsInfo.quota"].value = tmp[3];
    parent.frames[1].document.forms[0].elements["fsInfo.noatime"].value = tmp[4];
    parent.frames[1].document.forms[0].elements["fsInfo.snapshot"].value = tmp[5];
    parent.frames[1].document.forms[0].elements["fsInfo.accessMode"].value = tmp[6];
    parent.frames[1].document.forms[0].elements["fsInfo.mountStatus"].value = tmp[7];
    parent.frames[1].document.forms[0].elements["fsInfo.replication"].value = tmp[8];
    parent.frames[1].document.forms[0].elements["fsInfo.replicType"].value = tmp[9];
    parent.frames[1].document.forms[0].elements["fsInfo.norecovery"].value = tmp[10];
    parent.frames[1].document.forms[0].elements["fsInfo.dmapi"].value = tmp[11];
    parent.frames[1].document.forms[0].elements["fsInfo.fsType"].value = tmp[12];
    parent.frames[1].document.forms[0].elements["fsInfo.useRate"].value = tmp[13];
    parent.frames[1].document.forms[0].elements["fsInfo.useGfs"].value = tmp[14];
    parent.frames[1].document.forms[0].elements["fsInfo.replication4Show"].value = tmp[15];    
    
    <logic:equal name="isNashead" value="true" scope="page">
        parent.frames[1].document.forms[0].elements["fsInfo.lun"].value = tmp[16];
        parent.frames[1].document.forms[0].elements["fsInfo.storage"].value = tmp[17];        
        var newIndex = 18;
    </logic:equal>        
    <logic:notEqual name="isNashead" value="true" scope="page">    
        parent.frames[1].document.forms[0].elements["fsInfo.raidType"].value = tmp[16];
        parent.frames[1].document.forms[0].elements["fsInfo.poolNameAndNo"].value = tmp[17];
        parent.frames[1].document.forms[0].elements["fsInfo.aid"].value = tmp[18];
        parent.frames[1].document.forms[0].elements["fsInfo.aname"].value = tmp[19];
        parent.frames[1].document.forms[0].elements["fsInfo.asyncStatus"].value = tmp[20];
        parent.frames[1].document.forms[0].elements["fsInfo.errCode"].value = tmp[21];
        var newIndex = 22;
    </logic:notEqual>
    parent.frames[1].document.forms[0].elements["fsInfo.useCode"].value = tmp[newIndex];
    parent.frames[1].document.forms[0].elements["fsInfo.fsSize"].value = tmp[newIndex + 1];
    parent.frames[1].document.forms[0].elements["fsInfo.wpPeriod"].value = tmp[newIndex + 2];

    <logic:equal name="<%=FilesystemConst.SESSION_NV_ASYNC%>" value="true" scope="session">
        return;
    </logic:equal>
    <logic:equal name="<%=DdrActionConst.SESSION_DDR_ASYNCPAIR%>" value="true" scope="session">
        return;
    </logic:equal>
  
    if(tmp[2] == "--"){
        parent.frames[1].document.forms[0].extendBtn.disabled = true;
        parent.frames[1].document.forms[0].delBtn.disabled = true;
        parent.frames[1].document.forms[0].mountBtn.disabled = true;
        if (parent.frames[1].document.forms[0].moveBtn){
        	parent.frames[1].document.forms[0].moveBtn.disabled = true;
        }
        parent.frames[1].document.forms[0].forceFlag.disabled = true;        
        return;
    }
    
    if (tmp[7] == "mount"){
        var maxSize = <%=VolumeActionConst.VOLUME_MAX_SIZE%>;

        if (parseFloat(tmp[2]) >= maxSize){
            parent.bottomframe.document.forms[0].extendBtn.disabled = true;    
        }else{
            parent.bottomframe.document.forms[0].extendBtn.disabled = false;
        }
        parent.bottomframe.document.forms[0].mountBtn.disabled = true;
        if (parent.frames[1].document.forms[0].moveBtn){
        	parent.bottomframe.document.forms[0].moveBtn.disabled = false;
        }
        parent.bottomframe.document.forms[0].forceFlag.disabled = false;
        parent.bottomframe.document.forms[0].delBtn.disabled = false;
    }else{
        parent.bottomframe.document.forms[0].mountBtn.disabled = false;
 		parent.frames[1].document.forms[0].extendBtn.disabled = true;
 		if (parent.frames[1].document.forms[0].moveBtn){
        	parent.frames[1].document.forms[0].moveBtn.disabled = true; 
        }   		
        parent.frames[1].document.forms[0].delBtn.disabled = true;
        parent.frames[1].document.forms[0].forceFlag.disabled = true;
    }
    
    if((tmp[6] == "ro") && (tmp[15] == "--")){
        parent.frames[1].document.forms[0].extendBtn.disabled = true;
    }
}

function onReload() {
    if (isSubmitted()) {
        return false;
    }
    
    setSubmitted();
    parent.location="/nsadmin/filesystem/filesystemListAndDel.do?operation=display";
    lockMenu();
    return true;
}

function onCreate(){
    if (isSubmitted()){
        return false;
    }
    setSubmitted();
	parent.location="/nsadmin/filesystem/addFS.do?operation=display";
	lockMenu();
}

function onDelAsyncVol(volName) {
    if (isSubmitted()) {
        return false;
    }

    if (confirm("<bean:message key="info.confirm.delTmpFile" bundle="volume/filesystem"/>" + "\r\n"
                + "<bean:message key="info.volumeName" bundle="volume/filesystem"/> : " 
                + volName.replace("NV_LVM_","") + "\r\n")) {
        setSubmitted();  
        parent.location='/nsadmin/volume/clearTmpFile.do?volName=' + volName;
        return true;
    }
    return false;
}

function init(){
    <logic:equal name="<%=FilesystemConst.SESSION_NV_ASYNC%>" value="true" scope="session">
        document.forms[0].create.disabled = true;
    </logic:equal>
    <logic:equal name="<%=DdrActionConst.SESSION_DDR_ASYNCPAIR%>" value="true" scope="session">
        document.forms[0].create.disabled = true;
    </logic:equal>
	<logic:notEmpty name="<%=FilesystemConst.SESSION_FS_TABLE_MODE%>" scope="session">
		parent.bottomframe.location = "/nsadmin/filesystem/filesystemListBottom.do";
	</logic:notEmpty>
}
</script>
</head>

<body onload="displayAlert();init();setHelpAnchor('volume_filesystem')" onUnload="unLockMenu();closeDetailErrorWin();">
<form>
<h1 class="title"><bean:message key="h1.filesystem"/></h1>
<html:button property="reloadBtn" onclick="return onReload();">
    <bean:message key="common.button.reload" bundle="common"/>
</html:button>&nbsp;&nbsp;&nbsp;&nbsp;
<html:button property="create" onclick="onCreate()">
	<bean:message key="common.button.create2" bundle="common"/>
</html:button>

<h2 class="title"><bean:message key="h2.fliesystem.list"/></h2>
<displayerror:error h1_key="h1.filesystem"/><br>
<logic:empty name="<%=FilesystemConst.SESSION_FS_TABLE_MODE%>" scope="session">
    <bean:message key="msg.no.filesystem"/>
</logic:empty>

<logic:notEmpty name="<%=FilesystemConst.SESSION_FS_TABLE_MODE%>" scope="session">
    <bean:define id="tableMode" name="<%=FilesystemConst.SESSION_FS_TABLE_MODE%>" scope="session"/>
      <nssorttab:table  tablemodel="<%=(SortTableModel)tableMode%>" 
                      id="list1"
                      table="border=1" 
                      sortonload="volumeName:ascend" >
                      
            <nssorttab:column name="radio" 
                              th="STHeaderRender" 
                              td="com.nec.nsgui.action.volume.STDataRender4Volume"
                              sortable="no">               
            </nssorttab:column>
	        <nssorttab:column name="volumeName" 
	                          th="STHeaderRender" 
	                          td="com.nec.nsgui.action.volume.STDataRender4Volume"
	                          sortable="yes">
	           <bean:message key="info.volumeName" bundle="volume/filesystem"/>
	        </nssorttab:column>
	        
	        <nssorttab:column name="mountPoint" 
	                          th="STHeaderRender" 
	                          td="STDataRender"
	                          sortable="yes">
	           <bean:message key="info.mountpoint" bundle="volume/filesystem"/>
	        </nssorttab:column>
            
            <nssorttab:column name="mountStatus" 
                              th="STHeaderRender" 
                              td="com.nec.nsgui.action.volume.STDataRender4Volume"
                              sortable="yes">
                <bean:message key="info.mountStatus" bundle="volume/filesystem"/>
            </nssorttab:column>	        

            <nssorttab:column name="capacity" 
                              th="STHeaderRender" 
                              td="com.nec.nsgui.action.volume.STDataRender4Volume"
                              comparator="com.nec.nsgui.taglib.nssorttab.NumberStringComparator"
                              sortable="yes">
                <bean:message key="info.capacity" bundle="volume/filesystem"/>
            </nssorttab:column>
            
            <nssorttab:column name="fsSize" 
                              th="STHeaderRender" 
                              td="com.nec.nsgui.action.volume.STDataRender4Volume"
                              comparator="com.nec.nsgui.taglib.nssorttab.NumberStringComparator"
                              sortable="yes">
                <bean:message key="info.filesystem.capacity" bundle="volume/filesystem"/>
            </nssorttab:column>

            <nssorttab:column name="useRate" 
                              th="STHeaderRender" 
                              td="com.nec.nsgui.action.volume.STDataRender4Volume"
                              comparator="com.nec.nsgui.taglib.nssorttab.NumberStringComparator"
                              sortable="yes">
                <bean:message key="info.useRate" bundle="volume/filesystem"/>
            </nssorttab:column>
          
            <nssorttab:column name="fsType" 
                              th="STHeaderRender" 
                              td="STDataRender"
                              sortable="no">
                <bean:message key="info.fsType" bundle="volume/filesystem"/>
            </nssorttab:column>
            
            <logic:notEqual name="isNashead" value="true" scope="page">
                <nssorttab:column name="raidType" 
                              th="STHeaderRender" 
                              td="STDataRender"
                              sortable="no">
                    <bean:message key="info.raidType" bundle="volume/filesystem"/>
                </nssorttab:column>
                <logic:equal name="<%=FilesystemConst.SESSION_CURRENT_EXPORTGROUP_ASYNC%>" value="true" scope="session">
                    <nssorttab:column name="asyncStatus" 
                                  th="STHeaderRender" 
                                  td="com.nec.nsgui.action.volume.STDataRender4Volume"
                                  sortable="no">
                        <bean:message key="info.asyncStatus"  bundle="volume/filesystem"/>
                    </nssorttab:column>
                    <logic:equal name="<%=FilesystemConst.SESSION_ASYNC_ERROR%>" value="true" scope="session">
                        <%NSActionUtil.setSessionAttribute(request, VolumeActionConst.SESSION_FROM, "fs");%>
                        <nssorttab:column name="errCode" 
                                      th="STHeaderRender" 
                                      td="com.nec.nsgui.action.volume.STDataRender4Volume"
                                      sortable="no">
                            <bean:message key="info.errCode"  bundle="volume/filesystem"/>
                        </nssorttab:column>
                        <nssorttab:column name="button" 
                                      th="STHeaderRender" 
                                      td="com.nec.nsgui.action.volume.STDataRender4Volume"
                                      sortable="no">

                        </nssorttab:column>
                    </logic:equal>
                </logic:equal>    
            </logic:notEqual>
        </nssorttab:table>    
</logic:notEmpty>
</form>
</body>
</html:html>