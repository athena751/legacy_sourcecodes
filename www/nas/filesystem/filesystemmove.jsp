<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: filesystemmove.jsp,v 1.7 2007/08/23 05:37:11 xingyh Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld"   prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld"   prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld"  prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld"  prefix="displayerror" %>

<html:html lang="true">
<head>
<%@ include file="../../common/head.jsp" %>
<script language="JavaScript" src="<%=request.getContextPath()%>/common/common.js"></script>
<script language="JavaScript" src="<%=request.getContextPath()%>/common/validation.js"></script>
<script language="JavaScript">
var navigatorWin;
var heartBeatWin;

function onBack() {
    if (isSubmitted()) {
        return false;
    }
    lockMenu();
    setSubmitted();
    window.location="<html:rewrite page='/filesystemListAndDel.do?operation=display'/>";
}
function popupNavigator() {
    if (isSubmitted()){
       return false;
    }

    document.forms[1].fsType.value        = document.forms[0].elements["fsInfo.fsType"].value;
    document.forms[1].nowDirectory.value  = document.forms[1].rootDirectory.value;
    
    if(navigatorWin == null || navigatorWin.closed){
        navigatorWin = window.open("/nsadmin/common/commonblank.html", "fs_move_navigator", "resizable=yes,toolbar=no,menubar=no,scrollbar=no,width=400,height=400");
        window.mpPath = document.forms[0].mountPointShow;
        document.forms[1].submit();
    }else{
        navigatorWin.focus();
    }
}

function onMoveFS() {
    if (isSubmitted()){
       return false;
    }

    var mpShowObj = document.forms[0].elements["mountPointShow"];
    mpShowObj.value = compactPath(mpShowObj.value);
    var tmp_mp = mpShowObj.value;
    if(tmp_mp.charAt(0) == '/') {
        mpShowObj.value = tmp_mp.substring(1, tmp_mp.length);
    }
    var desMountPoint = document.forms[1].rootDirectory.value + "/"
                           + mpShowObj.value;

    if (checkMountPointName(desMountPoint) != true
        || mpShowObj.value == ""){
        alert('<bean:message key="msg.add.invalidMountpoint" bundle="volume/filesystem"/>');
        mpShowObj.focus();
        return false;
    }

    // the length of mount point full path can not over 2047.
    if (desMountPoint.length > 2047){
        alert("<bean:message key="msg.add.maxMPLength" bundle="volume/filesystem"/>");
        mpShowObj.focus();
        return false;
    }
    
    // the length of every level of mount point can not over 255.
    if (chkEveryLevel(desMountPoint) != true){
        alert("<bean:message key="msg.add.maxDirLength" bundle="volume/filesystem"/>");
        mpShowObj.focus();
        return false;
    }
    
    var srcMountPoint = document.forms[0].elements["fsInfo.mountPoint"].value;
    if(parseInt(getLevel(desMountPoint)) != parseInt(getLevel(srcMountPoint))) {
        alert("<bean:message key="filesystem.move.error.dirLevel"/>");
        mpShowObj.focus();
        return false;
    }

    if (confirm("<bean:message key="common.confirm" bundle="common" />" + "\r\n"
                + "<bean:message key="common.confirm.action" bundle="common"/>" 
                + "<bean:message key="filesystem.move.alert.action"/>"  + "\r\n")){
        setSubmitted();
        heartBeatWin = openHeartBeatWin();
        lockMenu();
        return true;
    }
    
    return false;                                                       
}

function getLevel(str) {
    var reg=/\//g;
    var tmpArray=str.split(reg);

    var level;    
   
    if (isIE()) {
    	level = tmpArray.length + 1;
    } else {
    	level = tmpArray.length;
    }

    return level;
}

</script>
</head> 
<body onLoad="displayAlert();" onUnload="unLockMenu();closePopupWin(navigatorWin);closePopupWin(heartBeatWin);closeDetailErrorWin();">
    <h1 class="title"><bean:message key="h1.filesystem"/></h1>
    <html:button property="backBtn" onclick="onBack();">
        <bean:message key="common.button.back" bundle="common"/>
    </html:button>
    <h2 class="title"><bean:message key="filesystem.move.h2"/></h2>
    <displayerror:error h1_key="h1.filesystem"/>
    <br>
    <!-- form for move file system -->
    <html:form action="moveFS.do" onsubmit="return onMoveFS();">
        <nested:nest property="fsInfo">
            <nested:hidden property="mountPoint"/>
            <nested:hidden property="fsType"/>
            <nested:hidden property="accessMode"/>
            <nested:hidden property="replication"/>
            <nested:hidden property="quota"/>
            <nested:hidden property="noatime"/>
            <nested:hidden property="dmapi"/>
            <nested:hidden property="norecovery"/> 
                        
            <table border="1" nowrap class="Vertical">
                <tr>
                    <th align=left><bean:message key="filesystem.move.th.sourceMP"/></th>
                    <td><nested:write property="mountPoint"/></td>
                </tr>
                <tr>
                    <th align=left><bean:message key="filesystem.move.th.destinationMP"/></th>
                    <td>
                        <bean:message key="filesystem.move.navigator.root"/>
                        <html:text property="mountPointShow" size="20" maxlength="2047"/>
                        <html:button property="select" onclick="popupNavigator();">
                            <bean:message key="common.button.browse2" bundle="common"/>
                        </html:button>
                    </td>    
                </tr>
            </table>
        </nested:nest>

        <br>
        <html:submit property="move">
            <bean:message key="common.button.submit" bundle="common"/>
        </html:submit>
    </html:form>
    
    <!--form for navigator -->
    <html:form target="fs_move_navigator" action="moveFSNavigator.do">
        <html:hidden property="operation"     value="call"/>
        <html:hidden property="rootDirectory" value="/export"/>
        <html:hidden property="nowDirectory"  value=""/>
        <html:hidden property="fsType"        value=""/>
    </html:form>
</body>
</html:html>