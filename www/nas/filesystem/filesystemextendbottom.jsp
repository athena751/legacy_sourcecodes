<!--
        Copyright (c) 2005-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: filesystemextendbottom.jsp,v 1.12 2008/02/29 12:18:54 wanghb Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nec.nsgui.action.filesystem.FilesystemConst"%>
<%@ page import="com.nec.nsgui.action.volume.VolumeActionConst"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld"   prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld"   prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested"%>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld"  prefix="logic" %>

<html:html lang="true">
<head>
<%@ include file="../../common/head.jsp" %>
<script language="JavaScript" src="<%=request.getContextPath()%>/common/common.js"></script>
<script language="javaScript">
var heartBeatWin;
function onExtend(){
    if (isSubmitted()) {
        return false;
    }
    
    var tmp;
    var ldCheckBoxValue;
    var ldList = "";
    var ldSize=0;
    
    var checkSize = 0;
    var differentSize = 0;

    var maxSize = <%=VolumeActionConst.VOLUME_MAX_SIZE%>;
    var alertMsg = "<bean:message key="msg.exceedMaxSize" bundle="volume/filesystem"/>";
    var hasSnapshot = "<bean:write name="hasSnapshot" scope="session"/>";
    var hasReplication = "<bean:write name="hasReplication" scope="session"/>";
    if (hasSnapshot == "yes" && hasReplication == "yes"){
        maxSize = <%=VolumeActionConst.VOLUME_SIZE_20TB%>;
        alertMsg = "<bean:message key="msg.exceed20TB.snapshotMVDSync" bundle="volume/filesystem"/>";
    }else if(hasSnapshot == "yes"){
        maxSize = <%=VolumeActionConst.VOLUME_SIZE_20TB%>;
        alertMsg = "<bean:message key="msg.exceed20TB.snapshot" bundle="volume/filesystem" />";        
    }else if(hasReplication == "yes"){
        maxSize = <%=VolumeActionConst.VOLUME_SIZE_20TB%>;
        alertMsg = "<bean:message key="msg.exceed20TB.MVDSync" bundle="volume/filesystem" />";        
    }

    if(!(parent.middleFrame.document.forms[0].ldCheckbox.length)) {
        if(parent.middleFrame.document.forms[0].ldCheckbox.checked) {
             tmp = parent.middleFrame.document.forms[0].ldCheckbox.value;
             ldCheckBoxValue = tmp.split("#")
             ldList = ldCheckBoxValue[0];
             ldSize = parseFloat(ldCheckBoxValue[1]);
        }
    }else{
        for(var i=0; i < parent.middleFrame.document.forms[0].ldCheckbox.length; i++) {
            if (parent.middleFrame.document.forms[0].ldCheckbox[i].checked) {
                tmp = parent.middleFrame.document.forms[0].ldCheckbox[i].value;
                ldCheckBoxValue = tmp.split("#")
                if (ldList == "") {
                    ldList = ldCheckBoxValue[0];
                    ldSize = parseFloat(ldCheckBoxValue[1]);
                    
                    checkSize = parseFloat(ldCheckBoxValue[1]);
                } else {
                    ldList += "," + ldCheckBoxValue[0];
                    ldSize += parseFloat(ldCheckBoxValue[1]);
                    
                    if (checkSize != parseFloat(ldCheckBoxValue[1])) {
                        differentSize = 1;
                    }
                }
             }
        }
    }

    if (parent.topFrame
        && parent.topFrame.document
        && parent.topFrame.document.getElementById("striping")
        && !parent.topFrame.document.getElementById("striping").disabled
        && parent.topFrame.document.getElementById("striping").checked) {
        if (differentSize == 1) {
            alert("<bean:message key="error.extend.striping.different.size"/>");
            return false;
        }
        document.forms[0].elements["fsInfo.striping"].value = "true";
    } else {
        document.forms[0].elements["fsInfo.striping"].value = "false";
    }

    var lvSize = parseFloat(document.forms[0].elements["capacity"].value) + parseFloat(ldSize);
    if (parseFloat(lvSize) > maxSize){
        alert(alertMsg);
        return false;
    }
    document.forms[0].elements["fsInfo.mountPoint"].value = document.forms[0].mountPoint.value;
    document.forms[0].elements["fsInfo.volumeName"].value = document.forms[0].volumeName.value;
    document.forms[0].elements["ldList"].value = ldList;

    // add for volume license by jiangfx, 2007.7.5
    var licenseAlert = "";
    <logic:equal name="<%=VolumeActionConst.SESSION_MACHINE_PROCYON%>" value="true" scope="session">
        // get license capacity and total created volume capacity
        var licenseCap = '<bean:write name="<%=VolumeActionConst.SESSION_VOL_LIC_LICENSECAP%>" scope="session"/>';
        var totalFSCap = '<bean:write name="<%=VolumeActionConst.SESSION_VOL_LIC_TOTALFSCAP%>" scope="session"/>';

        // get cofirm message for exceed license capacity
    	if ((totalFSCap != "<%=VolumeActionConst.DOUBLE_HYPHEN%>" )
    	    && (licenseCap != "<%=VolumeActionConst.DOUBLE_HYPHEN%>" )
    	    && (parseFloat(totalFSCap) <= parseFloat(licenseCap)) 
    	    && (parseFloat(ldSize) + parseFloat(totalFSCap)) >  parseFloat(licenseCap)) {
    		licenseAlert = "<bean:message key="volumeLicense.exceed.fsExtend"/>" + "\r\n\r\n";
    	}
    </logic:equal>
    
    if (confirm(licenseAlert + "<bean:message key="common.confirm" bundle="common" />" + "\r\n"
                + "<bean:message key="common.confirm.action" bundle="common"/>" 
                + "<bean:message key="button.extend" bundle="volume/filesystem"/>"  + "\r\n")){
            setSubmitted();
            heartBeatWin = openHeartBeatWin();
            lockMenu();
            return true;
    }     
    
    return false;
}

function init() {
    if (parent.middleFrame
        && parent.middleFrame.document
        && parent.middleFrame.document.forms[0]
        && parent.middleFrame.document.forms[0].ldCheckbox) {
	    if (!(parent.middleFrame.document.forms[0].ldCheckbox.length)) {
	        if(parent.middleFrame.document.forms[0].ldCheckbox.checked) {
	            document.forms[0].set.disabled = false;
	            return;
	        }
	    } else {
	        for (var i = 0; i < parent.middleFrame.document.forms[0].ldCheckbox.length; i++) {
	            if (parent.middleFrame.document.forms[0].ldCheckbox[i].checked) {
	                document.forms[0].set.disabled = false;
	                return;
	            }
	        }
	    }
	    
	    document.forms[0].set.disabled = true;
    }
}
</script>
</head> 
<body onload="init();" onUnload="unLockMenu();closePopupWin(heartBeatWin);">
<html:form action="extendFS.do" onsubmit="return onExtend();" target="ACTION">
    <bean:define id="fsInfo" name="<%=FilesystemConst.SESSION_FS_INFO_OBJ%>" scope="session"/>
        <nested:root name="fsInfo">
            <nested:hidden property="mountPoint"/>
            <nested:hidden property="volumeName"/>
            <nested:hidden property="capacity"/>
            <nested:hidden property="useGfs"/>
    </nested:root>   
    <html:hidden property="fsInfo.mountPoint" value=""/>
    <html:hidden property="fsInfo.volumeName" value=""/>
    <html:hidden property="ldList" value=""/>
    <html:hidden property="fsInfo.striping" value=""/>
       
    <html:submit property="set" disabled="true"><bean:message key="common.button.submit" bundle="common"/></html:submit>
</html:form>
</body>
</html:html>

