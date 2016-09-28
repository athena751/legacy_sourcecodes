<!--
        Copyright (c) 2004-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: volumelistmiddle.jsp,v 1.22 2008/04/19 13:40:38 jiangfx Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nec.nsgui.taglib.nssorttab.*"%>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>
<%@ page import="com.nec.nsgui.action.volume.VolumeActionConst"%>
<%@ page import="com.nec.nsgui.action.ddr.DdrActionConst"%>
<%@ page import="com.nec.nsgui.action.volume.StorageLunComparator"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/nssorttab.tld" prefix="nssorttab" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>

<html:html lang="true">
<head>
<%@include file="/common/head.jsp" %>
<bean:define id="isNashead" value='<%=NSActionUtil.isNashead(request)?"true":"false"%>'/>
<bean:define id="ldCount" name="ldCount" scope="session"/>
<bean:define id="lvCount" name="lvCount" scope="session"/>
<script language="JavaScript" src="/nsadmin/common/common.js"></script>
<script language="JavaScript">

function onRadioClick(value){
    if (!parent || !parent.bottomframe || !parent.bottomframe.document.forms[0]
        || !parent.bottomframe.document.forms[0].elements["volumeInfo.volumeName"]){
        return false;
    }
    var tmp = value.split("#");
    parent.bottomframe.document.forms[0].elements["volumeInfo.volumeName"].value = tmp[0];
    parent.bottomframe.document.forms[0].elements["volumeInfo.mountPoint"].value = tmp[1];
    parent.bottomframe.document.forms[0].elements["volumeInfo.capacity"].value = tmp[2];
    parent.bottomframe.document.forms[0].elements["volumeInfo.quota"].value = tmp[3];
    parent.bottomframe.document.forms[0].elements["volumeInfo.noatime"].value = tmp[4];
    parent.bottomframe.document.forms[0].elements["volumeInfo.snapshot"].value = tmp[5];
    parent.bottomframe.document.forms[0].elements["volumeInfo.accessMode"].value = tmp[6];
    parent.bottomframe.document.forms[0].elements["volumeInfo.mountStatus"].value = tmp[7];
    parent.bottomframe.document.forms[0].elements["volumeInfo.replication"].value = tmp[8];
    parent.bottomframe.document.forms[0].elements["volumeInfo.replicType"].value = tmp[9];
    parent.bottomframe.document.forms[0].elements["volumeInfo.norecovery"].value = tmp[10];
    parent.bottomframe.document.forms[0].elements["volumeInfo.dmapi"].value = tmp[11];
    parent.bottomframe.document.forms[0].elements["volumeInfo.fsType"].value = tmp[12];
    parent.bottomframe.document.forms[0].elements["volumeInfo.useRate"].value = tmp[13];
    parent.bottomframe.document.forms[0].elements["volumeInfo.useGfs"].value = tmp[14];
    parent.bottomframe.document.forms[0].elements["volumeInfo.replication4Show"].value = tmp[15];    
    
    <logic:equal name="isNashead" value="true" scope="page">
        parent.bottomframe.document.forms[0].elements["volumeInfo.lun"].value = tmp[16];
        parent.bottomframe.document.forms[0].elements["volumeInfo.storage"].value = tmp[17];
        var newIndex = 18;
    </logic:equal>        
    <logic:notEqual name="isNashead" value="true" scope="page">    
		parent.bottomframe.document.forms[0].elements["volumeInfo.raidType"].value = tmp[16];
		parent.bottomframe.document.forms[0].elements["volumeInfo.poolNameAndNo"].value = tmp[17];
		parent.bottomframe.document.forms[0].elements["volumeInfo.aid"].value = tmp[18];
		parent.bottomframe.document.forms[0].elements["volumeInfo.aname"].value = tmp[19];
		parent.bottomframe.document.forms[0].elements["volumeInfo.asyncStatus"].value = tmp[20];
		parent.bottomframe.document.forms[0].elements["volumeInfo.errCode"].value = tmp[21];
		var newIndex = 22;
    </logic:notEqual>
    parent.bottomframe.document.forms[0].elements["volumeInfo.useCode"].value = tmp[newIndex];
    parent.bottomframe.document.forms[0].elements["volumeInfo.fsSize"].value = tmp[newIndex + 1];
    parent.bottomframe.document.forms[0].elements["volumeInfo.wpPeriod"].value = tmp[newIndex + 2];

    <logic:equal name="<%=VolumeActionConst.SESSION_NV_ASYNC%>" value="true" scope="session">
        return;
    </logic:equal>
    <logic:equal name="<%=DdrActionConst.SESSION_DDR_ASYNCPAIR%>" value="true" scope="session">
        return;
    </logic:equal>    
    
    if(tmp[2] == "--"){
        parent.bottomframe.document.forms[0].extendBtn.disabled = true;
        parent.bottomframe.document.forms[0].delBtn.disabled = true;
        parent.bottomframe.document.forms[0].mountBtn.disabled = true;
        parent.bottomframe.document.forms[0].modifyBtn.disabled = true;
        //parent.bottomframe.document.forms[0].umountBtn.disabled = true;
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
        parent.bottomframe.document.forms[0].modifyBtn.disabled = false;
        //parent.bottomframe.document.forms[0].umountBtn.disabled = false;
        parent.bottomframe.document.forms[0].delBtn.disabled = false;
    }else{
        parent.bottomframe.document.forms[0].extendBtn.disabled = true;
        parent.bottomframe.document.forms[0].delBtn.disabled = true;
        parent.bottomframe.document.forms[0].mountBtn.disabled = false;
        parent.bottomframe.document.forms[0].modifyBtn.disabled = true;
        //parent.bottomframe.document.forms[0].umountBtn.disabled = true;
    }
    
    if((tmp[6] == "ro") && (tmp[15] == "--")){
        parent.bottomframe.document.forms[0].extendBtn.disabled = true;
    }
}

function init(){
    <logic:equal name="<%=VolumeActionConst.SESSION_NV_ASYNC%>" value="true" scope="session">
        document.forms[0].batchAddBtn.disabled = true;
    </logic:equal>
    <logic:equal name="<%=DdrActionConst.SESSION_DDR_ASYNCPAIR%>" value="true" scope="session">
        document.forms[0].addBtn.disabled = true;
        document.forms[0].batchAddBtn.disabled = true;
    </logic:equal>
    
	<logic:notEmpty name="<%=VolumeActionConst.SESSION_VOLUME_TABLE_MODE%>" scope="session">
		parent.bottomframe.location = "/nsadmin/volume/volumeListBottom.do";
	</logic:notEmpty>
}

function onAdd(actionPath) {
    if (isSubmitted()) {
        return false;
    }
    
    if (<%=lvCount%> >= 256) {
        alert("<bean:message key="alert.info.lv256"/>");
        return false;
    }
<logic:notEqual name="isNashead" value="true" scope="page">    
    if (<%=ldCount%> >= 512) {
        alert("<bean:message key="alert.info.ld512"/>");
        return false;
    }
</logic:notEqual>    
    setSubmitted();
    parent.location=actionPath;
// When nashead machine , page move to next page using more than 3 seconds, lock menu.  
<logic:equal name="isNashead" value="true" scope="page">    
	lockMenu();
</logic:equal>  
    return true;
}

function onDelAsyncVol(volName) {
    if (isSubmitted()) {
        return false;
    }
    
    if (confirm("<bean:message key="info.confirm.delTmpFile"/>" + "\r\n"
                + "<bean:message key="info.volumeName"/> : " 
                + volName.replace("NV_LVM_","") + "\r\n")) {
        setSubmitted();  
        parent.location='/nsadmin/volume/clearTmpFile.do?volName=' + volName;
        return true;
    }
    return false;
}
</script>
</head>
<body onload="displayAlert();init();setHelpAnchor('volume_volume')" onUnload="unLockMenu();closeDetailErrorWin();">
<h1 class="title"><bean:message key="title.h1"/></h1>
<form>
<html:button property="reloadBtn" onclick="parent.location='/nsadmin/volume/volumeList.do';lockMenu();">
   <bean:message key="common.button.reload" bundle="common"/>
</html:button>&nbsp;&nbsp;&nbsp;&nbsp;
<html:button property="addBtn" onclick="return onAdd('/nsadmin/volume/volumeAddShow.do');">
   <bean:message key="common.button.create" bundle="common"/><bean:message key="button.dot"/>
</html:button>
<html:button property="batchAddBtn" onclick="return onAdd('/nsadmin/volume/volumeBatchDispatch.do?operation=display');">
   <bean:message key="button.batchCreate"/><bean:message key="button.dot"/>
</html:button>
<h2 class="title"><bean:message key="title.list.h2"/></h2>
<displayerror:error h1_key="title.h1"/>
<br>
<logic:empty name="<%=VolumeActionConst.SESSION_VOLUME_TABLE_MODE%>" scope="session">
    <bean:message key="msg.list.novolumes"/>
</logic:empty>
<logic:notEmpty name="<%=VolumeActionConst.SESSION_VOLUME_TABLE_MODE%>" scope="session">
    <bean:define id="tableMode" name="<%=VolumeActionConst.SESSION_VOLUME_TABLE_MODE%>" scope="session"/>
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
	           <bean:message key="info.volumeName"/>
	        </nssorttab:column>
	        
	        <nssorttab:column name="mountPoint" 
	                          th="STHeaderRender" 
	                          td="STDataRender"
                              sortable="yes">
	           <bean:message key="info.mountpoint"/>
	        </nssorttab:column>
	        
	        <nssorttab:column name="mountStatus" 
                              th="STHeaderRender" 
                              td="com.nec.nsgui.action.volume.STDataRender4Volume"
                              sortable="yes">
                <bean:message key="info.mountStatus"/>
            </nssorttab:column>
	        
            <nssorttab:column name="capacity" 
                              th="STHeaderRender" 
                              td="com.nec.nsgui.action.volume.STDataRender4Volume"
                              comparator="com.nec.nsgui.taglib.nssorttab.NumberStringComparator"
                              sortable="yes">
                <bean:message key="info.capacity"/>
            </nssorttab:column>
            
            <nssorttab:column name="fsSize" 
                              th="STHeaderRender" 
                              td="com.nec.nsgui.action.volume.STDataRender4Volume"
                              comparator="com.nec.nsgui.taglib.nssorttab.NumberStringComparator"
                              sortable="yes">
                <bean:message key="info.filesystem.capacity"/>
            </nssorttab:column>

            <nssorttab:column name="useRate" 
                              th="STHeaderRender" 
                              td="com.nec.nsgui.action.volume.STDataRender4Volume"
                              comparator="com.nec.nsgui.taglib.nssorttab.NumberStringComparator"
                              sortable="yes">
                <bean:message key="info.useRate"/>
            </nssorttab:column>
          
            <nssorttab:column name="fsType" 
                              th="STHeaderRender" 
                              td="STDataRender"
                              sortable="no">
                <bean:message key="info.fsType"/>
            </nssorttab:column>
            
	        <logic:notEqual name="isNashead" value="true" scope="page">
                <nssorttab:column name="raidType" 
                              th="STHeaderRender" 
                              td="STDataRender"
                              sortable="no">
                    <bean:message key="info.raidType"/>
                </nssorttab:column>
	            <logic:equal name="<%=VolumeActionConst.SESSION_CURRENT_EXPORTGROUP_ASYNC%>" value="true" scope="session">
	                <nssorttab:column name="asyncStatus" 
	                              th="STHeaderRender" 
	                              td="com.nec.nsgui.action.volume.STDataRender4Volume"
	                              sortable="no">
	                    <bean:message key="info.asyncStatus"/>
	                </nssorttab:column>
	                <logic:equal name="<%=VolumeActionConst.SESSION_ASYNC_ERROR%>" value="true" scope="session">
                        <%NSActionUtil.setSessionAttribute(request, VolumeActionConst.SESSION_FROM, "volume");%>
	                    <nssorttab:column name="errCode" 
	                                  th="STHeaderRender" 
	                                  td="com.nec.nsgui.action.volume.STDataRender4Volume"
	                                  sortable="no">
	                        <bean:message key="info.errCode"/>
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