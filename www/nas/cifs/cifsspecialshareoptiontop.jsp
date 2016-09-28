<!--
        Copyright (c) 2007-2008 NEC Corporation
 
        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: cifsspecialshareoptiontop.jsp,v 1.12 2008/12/18 08:15:11 chenbc Exp $" -->

<%@ page import="java.io.*" %>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil" %>
<%@ page import="com.nec.nsgui.action.cifs.CifsActionConst" %>

<%@ page contentType="text/html;charset=UTF-8" buffer="32kb"%>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>

<html>
<head>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript" src="../common/validation.js"></script>
<script language="JavaScript" src="../nas/cifs/cifscommon.js"></script>
<script language="JavaScript">
var sharePurpose = "<bean:write name="shareOptionForm" property="shareOption.sharePurpose"/>";
var fsType = "<bean:write name="shareOptionForm" property="shareOption.fsType"/>";
<% String exportGroup = NSActionUtil.getExportGroupPath(request);%>

var shareNameForRealtime_scan = "";
var connectForRealtime_scan = "yes";
var commentForRealtime_scan = "";
var accessModeForRealtime_scan = "rw";
var writeListForRealtime_scan = "";
var browseableForRealtime_scan = "no";
var setButtonForRealtime_scan = "no";

var shareNameForBackup = "";
var connectForBackup = "yes";
var commentForBackup = "";
var accessModeForBackup = "rw";
var writeListForBackup = "";
var browseableForBackup = "no";
var setButtonForBackup = "no";

function init() {
    setHelpAnchor(document.shareOptionForm.helpLocation.value);
    if(sharePurpose == "backup") {
        initTempPath();
        displayBackup();
        initShareSnap();
    } else {
        displayScan();
    }
    changetext();
    initUsersAndServers();
    <logic:notEmpty name="<%=CifsActionConst.SESSION_ALLBACKUPUSER%>">
        setButtonForBackup = "yes";
    </logic:notEmpty>
    <logic:notEmpty name="<%=CifsActionConst.SESSION_AVAILABLEDIRFORSCAN%>">
        setButtonForRealtime_scan = "yes";
    </logic:notEmpty>
    <logic:equal name="cifs_shareOptionAction" value="modify">
        setButtonForRealtime_scan = "yes";
    </logic:equal>
    enableBottomButton();
    <logic:equal name="cifs_needConfirm4ScheduleShare" value="yes">
        if(confirm('<bean:message key="cifs.confirm.hasScheduleScanCconnection"/>')){
            setSubmitted();
            document.shareOptionForm.elements["operation"].value = "addOrmodify_Share";
            document.shareOptionForm.submit();
            return true;
        }
        <% NSActionUtil.setSessionAttribute(request, "cifs_needConfirm4ScheduleShare", null) ;%>
    </logic:equal>
  //added for 0805 cifs limit
    <logic:equal name="<%=CifsActionConst.SESSION_DIRECTORY_TOOLONG_BY_EXPORTENCODING%>" value="yes">
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
              + "<bean:message key="cifs.alert.invalidLength.fullPath.over1000"/>" + "\r\n"
              + "<bean:message key="cifs.alert.invalidLength.exportEncoding"/>");
        document.shareOptionForm.temppath.focus();
        <%session.setAttribute(CifsActionConst.SESSION_DIRECTORY_TOOLONG_BY_EXPORTENCODING, null);%>
    </logic:equal>
  //
    displayAlert();
}

function upCaseShareName(){
    document.shareOptionForm.elements["shareOption.shareName"].value=document.shareOptionForm.elements["shareOption.shareName"].value.toUpperCase();
}

function displayScan() {
    document.getElementById("directory_forBackup").style.display = "none";
    document.getElementById("directory_forRealtime_scan").style.display = "inline";
    document.getElementById("user_forBackup_th").style.display = "none";
    document.getElementById("user_forRealtime_scan_th").style.display = "inline";
    document.getElementById("user_forBackup_td").style.display = "none";
    document.getElementById("user_forRealtime_scan_td").style.display = "inline";
    document.getElementById("server_forBackup_th").style.display = "none";
    document.getElementById("server_forRealtime_scan_th").style.display = "inline";
    document.getElementById("server_forBackup_td").style.display = "none";
    document.getElementById("server_forRealtime_scan_td").style.display = "inline";
    document.shareOptionForm.userForRealtimeScan.value = document.shareOptionForm.elements["shareOption.validUserForRealtimeScan"].value;
    document.shareOptionForm.hostForRealtimeScan.value = document.shareOptionForm.elements["shareOption.allowHostForRealtimeScan"].value;
    document.shareOptionForm.elements["shareOption.shareName"].maxLength = 12;
    var sched_user_tr = document.getElementById("user_forSchedule_scan_tr");
    var sched_server_tr = document.getElementById("server_forSchedule_scan_tr");
    sched_user_tr.style.display = "";
    sched_server_tr.style.display = "";
    document.getElementById("accessMode_tr").style.display = "none";
    toDetermineUserTrStatus(true);
}

function displayBackup() {
    document.getElementById("directory_forRealtime_scan").style.display = "none";
    document.getElementById("directory_forBackup").style.display = "inline";
    document.getElementById("user_forRealtime_scan_th").style.display = "none";
    document.getElementById("user_forBackup_th").style.display = "inline";
    document.getElementById("user_forRealtime_scan_td").style.display = "none";
    document.getElementById("user_forBackup_td").style.display = "inline";
    document.getElementById("server_forRealtime_scan_th").style.display = "none";
    document.getElementById("server_forBackup_th").style.display = "inline";
    document.getElementById("server_forRealtime_scan_td").style.display = "none";
    document.getElementById("server_forBackup_td").style.display = "inline";
    document.shareOptionForm.elements["shareOption.shareName"].maxLength = 80;
    var sched_user_tr = document.getElementById("user_forSchedule_scan_tr");
    var sched_server_tr = document.getElementById("server_forSchedule_scan_tr");
    sched_user_tr.style.display = "none";
    sched_server_tr.style.display = "none";
    document.getElementById("accessMode_tr").style.display = "";
    toDetermineUserTrStatus(true);
}

function initShareSnap(){
    var path = document.shareOptionForm.temppath.value;
    var hasSnap = path.lastIndexOf("/.Snap");
    if ((hasSnap != -1) && (hasSnap == path.length-6)){
        document.shareOptionForm.sharesnap.checked = true;
        blurReadWrite();
        disableShadowCopy();
    }else {
        document.shareOptionForm.sharesnap.checked = false;
        enableReadWrite();
        enableShadowCopy();
    }
}

function initTempPath(){
    var exportGroup = "<%=exportGroup%>"+"/";
    var fullPath = "<bean:write name="shareOptionForm" property="shareOption.directory"/>";
    if(fullPath.indexOf(exportGroup)==0 && fullPath.length>exportGroup.length){
        var pathForDisplay = fullPath.substring(exportGroup.length, fullPath.length);
        document.shareOptionForm.temppath.value = pathForDisplay;
    }
}

function getFullDirectory(tempPath){
    return ("<%=exportGroup%>" + "/" + tempPath);
}

var pupUpWinName;
function onNavigator(){
    if (pupUpWinName == null || pupUpWinName.closed){
        window.mpPath = document.shareOptionForm.temppath;
        document.sharePathForm.nowDirectory.value=compactPath(getFullDirectory(getCorrectPath(document.shareOptionForm.temppath.value)));
        pupUpWinName = window.open("/nsadmin/common/commonblank.html","selectBackupSharePath_navigator",
                "resizable=yes,toolbar=no,menubar=no,scrollbar=no,width=500,height=500");
        document.sharePathForm.submit();
    }else{
        pupUpWinName.focus();
    }
}

function onBack(){
    if (isSubmitted()){
        return false;
    }
    setSubmitted();
    window.parent.location="specialShare.do";
    return true;
}

function getCorrectPath(rawPath){
	var tmp = deleteMutipleSlash(rawPath);
    tmp = tmp.replace(/(^[\/\s]*)/g,"");      //delete the first "/" or space
    tmp = tmp.replace(/([\/])$/g,"");         //delete the last "/"
    tmp = tmp.replace(/^[\.]([\.])?$/g,"");   //delete the ".." or "."
    //tmp = tmp.replace(/(\/\.Snap)+$/g,"/.Snap"); //only keep one last "/.Snap"
    return tmp;
}

function showShareSnap(){
    if (trim(document.shareOptionForm.temppath.value)=="") {
        document.shareOptionForm.sharesnap.checked=false;
        return false;
    }
    document.shareOptionForm.temppath.value=getCorrectPath(document.shareOptionForm.temppath.value);
    if (document.shareOptionForm.sharesnap.checked){
        document.shareOptionForm.temppath.value=document.shareOptionForm.temppath.value + "/.Snap";
        //document.shareOptionForm.temppath.value=document.shareOptionForm.temppath.value.replace(/(\/\.Snap)+$/g,"/.Snap");
        blurReadWrite();
        disableShadowCopy();
    }else {
        document.shareOptionForm.temppath.value=document.shareOptionForm.temppath.value.replace(/(\/\.Snap)$/g,"");
        enableReadWrite();
        enableShadowCopy();
    }
}

function blurReadWrite(){
    document.shareOptionForm.elements["shareOption.readOnly"][1].checked=true;
    document.shareOptionForm.elements["shareOption.readOnly"][0].checked=false;
    document.shareOptionForm.elements["shareOption.readOnly"][0].disabled=true;
    document.shareOptionForm.elements["shareOption.writeList"].disabled=true;
}

function enableReadWrite(){
    document.shareOptionForm.elements["shareOption.readOnly"][0].disabled=false;
    if (document.shareOptionForm.elements["shareOption.readOnly"][1].checked){
        document.shareOptionForm.elements["shareOption.writeList"].disabled=false;
    }
}

function disableShadowCopy(){
    document.shareOptionForm.elements["shareOption.shadowCopy"].checked=false;
    document.shareOptionForm.elements["shareOption.shadowCopy"].disabled=true;
}

function enableShadowCopy(){
    document.shareOptionForm.elements["shareOption.shadowCopy"].disabled=false;
}

function changetext(){
    if (sharePurpose == "backup" && document.shareOptionForm.sharesnap 
            && document.shareOptionForm.sharesnap.checked){
        document.shareOptionForm.elements["shareOption.readOnly"][1].checked=true;
        return;
    }
    if (document.shareOptionForm.elements["shareOption.readOnly"][1].checked){
        document.shareOptionForm.elements["shareOption.writeList"].disabled=false;
    }else{
        document.shareOptionForm.elements["shareOption.writeList"].disabled=true;
    }
}

function enableWriteList(flag) {
    if (sharePurpose == "backup" && document.shareOptionForm.sharesnap.checked){
        document.shareOptionForm.elements["shareOption.readOnly"][1].checked=true;
        return;
    }
    if(flag == "1") {
        document.shareOptionForm.elements["shareOption.writeList"].disabled=false;
    } else {
        document.shareOptionForm.elements["shareOption.writeList"].disabled=true;
    }
}

function onChangePurpose() {
    var selectedIndex = document.shareOptionForm.elements["shareOption.sharePurpose"].selectedIndex;
    if(document.shareOptionForm.elements["shareOption.sharePurpose"].options[selectedIndex].value == "realtime_scan") {
        sharePurpose = "realtime_scan";
        shareNameForBackup = document.shareOptionForm.elements["shareOption.shareName"].value;
        if(document.shareOptionForm.elements["shareOption.connection"].checked) {
            connectForBackup = "yes";
        } else {
            connectForBackup = "no";
        }
        commentForBackup = document.shareOptionForm.elements["shareOption.comment"].value;
        if(document.shareOptionForm.elements["shareOption.readOnly"][0].checked) {
            accessModeForBackup = "rw";
        } else if (document.shareOptionForm.elements["shareOption.readOnly"][1].checked) {
            accessModeForBackup = "r";
        }
        writeListForBackup = document.shareOptionForm.elements["shareOption.writeList"].value;
        if(document.shareOptionForm.elements["shareOption.browseable"].checked) {
            browseableForBackup = "yes";
        } else {
            browseableForBackup = "no";
        }
        
        document.shareOptionForm.elements["shareOption.shareName"].value = shareNameForRealtime_scan;
        if(connectForRealtime_scan == "yes") {
            document.shareOptionForm.elements["shareOption.connection"].checked = true;
        } else {
            document.shareOptionForm.elements["shareOption.connection"].checked = false;
        }
        document.shareOptionForm.elements["shareOption.comment"].value = commentForRealtime_scan;
        document.shareOptionForm.elements["shareOption.readOnly"][0].disabled = false;
        if(accessModeForRealtime_scan == "rw") {
            document.shareOptionForm.elements["shareOption.readOnly"][0].checked = true;
            document.shareOptionForm.elements["shareOption.writeList"].disabled = true;
        } else if (accessModeForRealtime_scan == "r") {
            document.shareOptionForm.elements["shareOption.readOnly"][1].checked = true;
            document.shareOptionForm.elements["shareOption.writeList"].disabled = false;
        }
        document.shareOptionForm.elements["shareOption.writeList"].value = writeListForRealtime_scan;
        if(browseableForRealtime_scan == "yes") {
            document.shareOptionForm.elements["shareOption.browseable"].checked = true;
        } else {
            document.shareOptionForm.elements["shareOption.browseable"].checked = false;
        }
        displayScan();
    } else if (document.shareOptionForm.elements["shareOption.sharePurpose"].options[selectedIndex].value == "backup") {
        sharePurpose = "backup";
        shareNameForRealtime_scan = document.shareOptionForm.elements["shareOption.shareName"].value;
        if(document.shareOptionForm.elements["shareOption.connection"].checked) {
            connectForRealtime_scan = "yes";
        } else {
            connectForRealtime_scan = "no";
        }
        commentForRealtime_scan = document.shareOptionForm.elements["shareOption.comment"].value;
        if(document.shareOptionForm.elements["shareOption.readOnly"][0].checked) {
            accessModeForRealtime_scan = "rw";
        } else if (document.shareOptionForm.elements["shareOption.readOnly"][1].checked) {
            accessModeForRealtime_scan = "r";
        }
        writeListForRealtime_scan = document.shareOptionForm.elements["shareOption.writeList"].value;
        if(document.shareOptionForm.elements["shareOption.browseable"].checked) {
            browseableForRealtime_scan = "yes";
        } else {
            browseableForRealtime_scan = "no";
        }
        
        document.shareOptionForm.elements["shareOption.shareName"].value = shareNameForBackup;
        if(connectForBackup == "yes") {
            document.shareOptionForm.elements["shareOption.connection"].checked = true;
        } else {
            document.shareOptionForm.elements["shareOption.connection"].checked = false;
        }
        document.shareOptionForm.elements["shareOption.comment"].value = commentForBackup;
        if(accessModeForBackup == "rw") {
            document.shareOptionForm.elements["shareOption.readOnly"][0].checked = true;
            document.shareOptionForm.elements["shareOption.writeList"].disabled = true;
        } else if (accessModeForBackup == "r") {
            document.shareOptionForm.elements["shareOption.readOnly"][1].checked = true;
            if(!document.shareOptionForm.sharesnap.disabled && document.shareOptionForm.sharesnap.checked) {
                document.shareOptionForm.elements["shareOption.writeList"].disabled = true;
            } else {
                document.shareOptionForm.elements["shareOption.writeList"].disabled = false;
            }
        }
        if(document.shareOptionForm.sharesnap.checked) {
            document.shareOptionForm.elements["shareOption.readOnly"][0].disabled = true;
        }
        document.shareOptionForm.elements["shareOption.writeList"].value = writeListForBackup;
        if(browseableForBackup == "yes") {
            document.shareOptionForm.elements["shareOption.browseable"].checked = true;
        } else {
            document.shareOptionForm.elements["shareOption.browseable"].checked = false;
        }
        displayBackup();
    }
    enableBottomButton();
}

function checkShareName(str, purpose){
    if (str == "") {
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                    + "<bean:message key="cifs.alert.shareName_null"/>");
        return false;
    }

    if(purpose == "realtime_scan") {
        var invalidChar = /[^0-9a-zA-Z\$]/g;
        if(str.search(invalidChar) != -1) {
            alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                       + "<bean:message key="cifs.alert.shareName_scanInvalidChar"/>");
            return false;
        }
        if(!checkLength(str, 12)){
            alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                       + "<bean:message key="cifs.alert.shareName_invalidLen"/>" + "\r\n"
                       + "<bean:message key="cifs.alert.invalidLength" arg0='12'/>");
            return false;
        }
    } else {
        var invalidChar = /[<>|:\;\"\]\[,\/\\\*\?%]/g;
        if ( str.search(invalidChar) != -1){
            alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                        + "<bean:message key="cifs.alert.shareName_invalidChar"/>");
            return false;
        }
// modified for 0805 cifs limit
        if(!checkNFDLength(str, 80)){
            alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                       + "<bean:message key="cifs.alert.shareName_invalidLen"/>" + "\r\n"
                       + "<bean:message key="cifs.alert.invalidLength.utf8nfd" arg0='80'/>");
            return false;
        }
//
    }

    str = str.toLowerCase();
    if (str == "global" || str == "homes" || str == "printers"){
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                    + "<bean:message key="cifs.alert.shareName_useReservedName"/>");
        return false;
    }
    return true;
}

function checkAll() {
    sharePurpose = document.shareOptionForm.elements["shareOption.sharePurpose"].value;
    <logic:equal name="cifs_shareOptionAction" value="add">
        document.shareOptionForm.elements["shareOption.shareName"].value = trim(document.shareOptionForm.elements["shareOption.shareName"].value);
        if (!checkShareName(document.shareOptionForm.elements["shareOption.shareName"].value, sharePurpose)){
            document.shareOptionForm.elements["shareOption.shareName"].focus();
            return false;
        }
    </logic:equal>
    
    if(sharePurpose == "backup") {
        document.shareOptionForm.temppath.value=getCorrectPath(document.shareOptionForm.temppath.value);
        if(!checkTempPath(document.shareOptionForm.temppath.value)){
            document.shareOptionForm.temppath.focus();
            return false;
        }else{
            document.shareOptionForm.elements["shareOption.directory"].value=getFullDirectory(document.shareOptionForm.temppath.value);
        }
    } else {
        <logic:equal name="cifs_shareOptionAction" value="add">
					document.shareOptionForm.elements["shareOption.directory"].value=getFullDirectory(document.shareOptionForm.elements["shareOption.directoryForRealtimeScan"].value);
        </logic:equal>
    }
    
    if (!checkComment(document.shareOptionForm.elements["shareOption.comment"].value)){
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                            + "<bean:message key="cifs.alert.comment_invalidChar"/>");
        document.shareOptionForm.elements["shareOption.comment"].focus();
        return false;
    }
// modified for 0805 cifs limit
    if (!checkNFDLength(document.shareOptionForm.elements["shareOption.comment"].value, 48)) {
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                            + "<bean:message key="cifs.alert.comment_invalidLen"/>" + "\r\n"
                            + "<bean:message key="cifs.alert.invalidLength.utf8nfd" arg0='48'/>");
        document.shareOptionForm.elements["shareOption.comment"].focus();
        return false;
    }
//
    
    if((document.shareOptionForm.elements["shareOption.readOnly"][1].checked && sharePurpose == "realtime_scan") || 
       (document.shareOptionForm.elements["shareOption.readOnly"][1].checked && sharePurpose == "backup" && !document.shareOptionForm.sharesnap.checked)) {
        document.shareOptionForm.elements["shareOption.writeList"].value=trim(document.shareOptionForm.elements["shareOption.writeList"].value);
        if (!checkUsers(document.shareOptionForm.elements["shareOption.writeList"].value)) {
            alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                            + "<bean:message key="cifs.alert.writeList_invalid"/>");
            document.shareOptionForm.elements["shareOption.writeList"].focus();
            return false;
        }
    }
    
    if(sharePurpose == "realtime_scan") {
        document.shareOptionForm.elements["shareOption.validUser_Group"].value = document.shareOptionForm.userForRealtimeScan.value;
        document.shareOptionForm.elements["shareOption.hostsAllow"].value = document.shareOptionForm.hostForRealtimeScan.value;
    } else if (sharePurpose == "backup") {
        if(!(document.shareOptionForm.elements["shareOption.validUserForBackup"] && 
           document.shareOptionForm.elements["shareOption.validUserForBackup"].selectedIndex != -1)) {
            alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                            + "<bean:message key="cifs.alert.specifyBackupUser"/>");
            document.shareOptionForm.elements["shareOption.validUserForBackup"].focus();
            return false;
        } else {
            var backupUser = "";
            var backupUserCount = document.shareOptionForm.elements["shareOption.validUserForBackup"].options.length;
            var backupUserNum = 0;
            for(var i = 0; i < backupUserCount; i ++) {
                if(document.shareOptionForm.elements["shareOption.validUserForBackup"].options[i].selected) {
                    backupUserNum ++;
                    if(document.shareOptionForm.elements["shareOption.validUserForBackup"].options[i].value.search(/[\s]/) != -1) {
                        backupUser += "\"" + document.shareOptionForm.elements["shareOption.validUserForBackup"].options[i].value + "\" ";
                    } else {
                        backupUser += document.shareOptionForm.elements["shareOption.validUserForBackup"].options[i].value + " ";
                    }
                }
            }
            if(backupUserNum > 10) {
                alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                            + "<bean:message key="cifs.alert.tooManyBackupUser"/>");
                document.shareOptionForm.elements["shareOption.validUserForBackup"].focus();
                return false;
            }
            backupUser = trim(backupUser);
            document.shareOptionForm.elements["shareOption.validUser_Group"].value = backupUser;
        }
        
        var backupHosts = trim(document.shareOptionForm.elements["shareOption.allowHostForBackup"].value);
        document.shareOptionForm.elements["shareOption.allowHostForBackup"].value = backupHosts;
        if(backupHosts != "") {
            if (!checkHosts(backupHosts)) {
                alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                           + "<bean:message key="cifs.specialShare.invalidBackupServer"/>");
                document.shareOptionForm.elements["shareOption.allowHostForBackup"].focus();
                return false;
            }
        }
        document.shareOptionForm.elements["shareOption.hostsAllow"].value = backupHosts;
    }
    return true;
}

function checkTempPath(str){
    if ((str == "") || (str == ".Snap")){
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                    + "<bean:message key="cifs.alert.path_null"/>");
        return false;
    }

    if(!checkPath4Win(str)){
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                    + "<bean:message key="cifs.alert.path_invalidChar"/>");
        return false;
    }
/* omitted for 0805 cifs limit
    if(!checkLength(getFullDirectory(str), 255)){
        alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                    + "<bean:message key="cifs.alert.shareDir_toolong_wholeDir"/>");
        return false;
    }

    var a = new Array();
    a = str.split("/");
    for(var i=0; i< a.length; i++){
        if(a[i]){
            if(!checkLength(a[i], 64)){
                alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n"
                            + "<bean:message key="cifs.alert.toolong_eachDir"/>");
                return false;
            }
        }
    }
*/
    return true;
}

function enableBottomButton(){
	if(parent.frames[1].document && 
	    parent.frames[1].document.forms[0] && 
	    parent.frames[1].document.forms[0].button_submit){
	    if(sharePurpose == "backup") {
	        if(setButtonForBackup == "yes") {
	            parent.frames[1].document.forms[0].button_submit.disabled = false;
	        } else {
	            parent.frames[1].document.forms[0].button_submit.disabled = true;
	        }
	    }else if(sharePurpose == "realtime_scan") {
            if(setButtonForRealtime_scan == "yes") {
                parent.frames[1].document.forms[0].button_submit.disabled = false;
            } else {
                parent.frames[1].document.forms[0].button_submit.disabled = true;
            }
        }
	}
}

/**
*  Function: display the element(id=user_tr) or not
*  Parameter: show_flag: true = display, false = hide
*  Return: none
**/
function displayUserTR(show_flag){
    var user_tr = document.getElementById("user_tr");
    if(show_flag){
        user_tr.style.display = "";
    }else{
        user_tr.style.display = "none";
    }
}

/**
*  Function: to determine if the type of anti-virus share directory is "sxfs"
*            This function can be only used while adding shares.
*  Parameter: none
*  Return: true/false
**/
function sxfsDirectorySelected(){
    var directorySelect = document.shareOptionForm.elements["shareOption.directoryForRealtimeScan"];
    var fsTypeElement = document.shareOptionForm.elements["shareOption.fsType"];
    if(directorySelect){
        var selectedOption = directorySelect.options[directorySelect.selectedIndex];
        if(selectedOption.innerHTML.match("\\(sxfs\\)\s*$")){
            fsTypeElement.value = "sxfs";
            return true;
        }
        fsTypeElement.value = "sxfsfw";
    }
    return false;
}

/**
*  Function: to determine if the the element(id=user_tr) should be displayed.
*            And then, display or hide it.
*  Parameter: toModify: true = refresh the status of element(id=user_tr), false = remain it
*  Return: true = display, false = hide
**/
function toDetermineUserTrStatus(toModify){
    var toDisplay = true;
    if(sharePurpose == "realtime_scan"){
        var operation = document.shareOptionForm.elements["shareOption.settingOperation"].value;
        if( (operation == "add" && sxfsDirectorySelected()) || (operation == "modify" && fsType == "sxfs") ){
            toDisplay = false;
        }
    }
    if(toModify){
        displayUserTR(toDisplay);
    }
    return toDisplay;
}

function onChangeAntivirusDirectory(){
    toDetermineUserTrStatus(true);
}

function createOrSave(){
    if(isSubmitted()){
        return false;
    }
    if(!checkAll()) {
        return false;
    }
    
    var confirmMessage = '<bean:message key="common.confirm" bundle="common"/>' + '\r\n'+
                         '<bean:message key="common.confirm.action" bundle="common"/>'+ 
                         '<bean:message key="common.button.submit" bundle="common"/>';
    var operation = document.shareOptionForm.elements["shareOption.settingOperation"].value;
    if(operation == "add" && toDetermineUserTrStatus() == false){
        confirmMessage = '<bean:message key="cifs.confirm.antiVirusShare.sxfsDirectory"/>\r\n' + confirmMessage;
    }
    
    if(!confirm(confirmMessage)){
        return false;
    }
  // added for 0805
    document.shareOptionForm.elements["shareOption.shadowCopy"].checked = false;
    if(sharePurpose == "realtime_scan"){
        document.shareOptionForm.elements["shareOption.readOnly"][0].checked = true;
        document.shareOptionForm.elements["shareOption.readOnly"][0].onclick();
        document.shareOptionForm.elements["shareOption.writeList"].value = "";
        if(toDetermineUserTrStatus() == false){
            document.shareOptionForm.elements["shareOption.validUser_Group"].value = "";
        }
    }
  //
  	setSubmitted();
  	if(document.shareOptionForm && 
  	   document.shareOptionForm.elements["shareOption.settingOperation"].value == "modify" &&
  	   document.shareOptionForm.elements["shareOption.sharePurpose"].value == "realtime_scan" ){ // this means antivirus-share
  	   document.shareOptionForm.elements["operation"].value = "checkScheduleScanConnection";
    }
    document.shareOptionForm.submit();
    
} 

function checkLength4Cifs(str, maxlen) {
    str = str.replace(/[^\x00-\x7f\uff61-\uff9f]/g, "  ");
    return (str.length <= maxlen);
}

function initUsersAndServers(){
    var realtimeUser = document.shareOptionForm.userForRealtimeScan;
    var realtimeHost = document.shareOptionForm.hostForRealtimeScan;
    var scheduleUser = document.shareOptionForm.elements["shareOption.validUserForScheduleScan"];
    var scheduleHost = document.shareOptionForm.elements["shareOption.allowHostForScheduleScan"];
    var elements = [ realtimeUser, realtimeHost, scheduleUser, scheduleHost ];
    for(var i = 0; i < elements.length; i++){
        if(trim(elements[i].value) == ""){
            elements[i].style.backgroundColor = "#E0E0E0";
        }
    }
}

</script>
</head>

<body onload="init();" onUnload="closeDetailErrorWin();closePopupWin(pupUpWinName);">
<html:form action="setSpecialShare.do" method="post">
<nested:nest property="shareOption">
<nested:hidden property="validUser_Group"/>
<nested:hidden property="hostsAllow"/>
<nested:hidden property="fsType"/>
<html:button property="goBack" onclick="return onBack()">
    <bean:message key="common.button.back" bundle="common"/>
</html:button>
<br /><br />
<displayerror:error h1_key="cifs.common.h1"/>
<br />
<input type="hidden" name="operation" value="addOrmodify_Share">
<logic:equal name="cifs_shareOptionAction" value="add">
    <h3 class="title"><bean:message key="cifs.specialShareOption.h2_add"/></h3>
    <input type="hidden" name="shareOption.settingOperation" value="add">
    <input type="hidden" name="helpLocation" value="network_cifs_20">
</logic:equal>
<logic:equal name="cifs_shareOptionAction" value="modify">
    <h3 class="title">
      <nested:equal property="sharePurpose" value="realtime_scan">
        <bean:message key="cifs.realtimeScan.h2_modify"/>
      </nested:equal>
      <nested:equal property="sharePurpose" value="backup">
        <bean:message key="cifs.backup.h2_modify"/>
      </nested:equal>
    </h3>
    <input type="hidden" name="shareOption.settingOperation" value="modify">
    <input type="hidden" name="helpLocation" value="network_cifs_21">
</logic:equal>
    <input type="hidden" name="helpLocation_navigator" value="network_cifs_22">

<logic:equal name="cifs_shareOptionAction" value="add">
<table border="1" class="Vertical">
  <tr>
    <th><bean:message key="cifs.sharePurpose"/></th>
    <td>
      <nested:select property="sharePurpose" onchange="onChangePurpose()">
        <html:option value="realtime_scan"><bean:message key="cifs.sharePurpose.realtime_scan"/></html:option>
        <html:option value="backup"><bean:message key="cifs.sharePurpose.backup"/></html:option>
      </nested:select>
    </td>
  </tr>
</table>
<hr>
</logic:equal>
<logic:equal name="cifs_shareOptionAction" value="modify">
  <nested:hidden property="sharePurpose"/>
</logic:equal>
<table border="1" class="Vertical">
  <tr>
    <th><bean:message key="cifs.shareOption.th_sharename"/></th>
    <td>
      <logic:equal name="cifs_shareOptionAction" value="add">
        <nested:text property="shareName" size="24" maxlength="12" onblur="upCaseShareName();"/>
      </logic:equal>
      <logic:equal name="cifs_shareOptionAction" value="modify">
        <nested:define id="shareName_td" property="shareName" type="java.lang.String"/>
        <%=NSActionUtil.sanitize(shareName_td)%>
        <nested:hidden property="shareName"/>
      </logic:equal>
    </td>
  </tr>
  <tr>
    <th><bean:message key="cifs.shareOption.th_connection"/></th>
    <td>
      <nested:checkbox property="connection" styleId="available" value="yes"/>
      <label for="available"><bean:message key="cifs.shareOption.checkbox_available"/></label>
    </td>
  </tr>
  <tr>
    <th><bean:message key="cifs.shareOption.th_directory"/></th>
    <td nowrap>
      <div id="directory_forRealtime_scan">
        <logic:equal name="cifs_shareOptionAction" value="add">
          <logic:notEmpty name="<%=CifsActionConst.SESSION_AVAILABLEDIRFORSCAN%>">
            <%=exportGroup%>/<nested:select property="directoryForRealtimeScan" onchange="onChangeAntivirusDirectory();">
              <nested:options name="<%=CifsActionConst.SESSION_AVAILABLEDIRFORSCAN_OPTION_VALUES%>" labelName="<%=CifsActionConst.SESSION_AVAILABLEDIRFORSCAN%>"/>
            </nested:select>
          </logic:notEmpty>
          <logic:empty name="<%=CifsActionConst.SESSION_AVAILABLEDIRFORSCAN%>">
              <bean:message key="cifs.specialShare.noAviailableDirForScan"/>
          </logic:empty>
        </logic:equal>
        <logic:equal name="cifs_shareOptionAction" value="modify">
          <nested:write property="directory"/>
        </logic:equal>
      </div>
      <div id="directory_forBackup">
        <%=exportGroup%>/<input type="text" name="temppath" size="48" value="" onblur="initShareSnap();" maxlength="1000"/>
        <html:button property="button_browse" onclick="onNavigator();">
          <bean:message key="common.button.browse2" bundle="common"/>
       </html:button>
       <br>
        <input type="checkbox" name="sharesnap" id="sharesnapD1"
          onclick="return showShareSnap()">
        <label for="sharesnapD1">
          <bean:message key="cifs.shareOption.checkbox_sharesnap"/>
        </label>
      </div>
      <nested:hidden property="directory"/>
    </td>
  </tr>
  <tr>
    <th><bean:message key="cifs.shareOption.th_comment"/></th>
    <td>
      <nested:text property="comment" size="64" maxlength="48"/>
    </td>
  </tr>
  <tr id="accessMode_tr"> <!-- modified for 0805 -->
    <th><bean:message key="cifs.shareOption.th_accessMode"/></th>
    <td>
      <table border="0">
        <tr>
          <td>
            <nested:radio property="readOnly" styleId="label_rw" value="no" onclick="enableWriteList('0')"/>
            <label for="label_rw"><bean:message key="cifs.shareOption.radio_rw"/></label>
          </td>
        </tr>
        <tr>
          <td>
            <nested:radio property="readOnly" styleId="label_ro" value="yes" onclick="enableWriteList('1')"/>
            <label for="label_ro"><bean:message key="cifs.shareOption.radio_ro"/></label>
          </td>
        </tr>
        <tr>
          <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <bean:message key="cifs.shareOption.td_wl"/>
            <nested:text property="writeList" maxlength="128" size="36"
                onfocus="if (this.disabled) this.blur();"/>
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr id="user_tr">
    <th>
      <div id="user_forRealtime_scan_th"><bean:message key="cifs.specialShare.scanUser"/></div>
      <div id="user_forBackup_th"><bean:message key="cifs.specialShare.backupUser"/></div>
    </th>
    <td>
      <div id="user_forRealtime_scan_td">
        <input type="text" name="userForRealtimeScan" size="64" maxlength="369" disabled="true">
      </div>
      <nested:hidden property="validUserForRealtimeScan"/>
      <div id="user_forBackup_td">
        <logic:notEmpty name="<%=CifsActionConst.SESSION_ALLBACKUPUSER%>">
          <nested:select property="validUserForBackup" multiple="true" size="4">
            <logic:iterate id="allBackupuser" name="<%=CifsActionConst.SESSION_ALLBACKUPUSER%>">
              <bean:define id="userForBackup" name="allBackupuser" type="java.lang.String"/>
              <html:option value="<%=userForBackup%>"><%=NSActionUtil.htmlSanitize(userForBackup)%></html:option>
            </logic:iterate>
          </nested:select>
        </logic:notEmpty>
        <logic:empty name="<%=CifsActionConst.SESSION_ALLBACKUPUSER%>">
          <nested:select property="validUserForBackup" multiple="true" size="4" onclick="{this.selectedIndex=-1;return;}">
            <option style="background-color:#C0C0C0"><bean:message key="cifs.specialShare.backupUserNotLogin"/></option>
          </nested:select>
        </logic:empty><br>
        [<font class="advice"><bean:message key="cifs.specialShare.selBackupUser"/></font>]
      </div>
    </td>
  </tr>
  <tr id="server_tr">
    <th>
      <div id="server_forRealtime_scan_th"><bean:message key="cifs.specialShare.scanServer"/></div>
      <div id="server_forBackup_th"><bean:message key="cifs.specialShare.backupServer"/></div>
    </th>
    <td>
      <div id="server_forRealtime_scan_td">
        <input type="text" name="hostForRealtimeScan" size="64" maxlength="511" disabled="true">
      </div>
      <nested:hidden property="allowHostForRealtimeScan"/>
      <div id="server_forBackup_td">
        <nested:text property="allowHostForBackup" size="64" maxlength="200"/>
        <br>[<font class="advice" ><bean:message key="cifs.common.assisInfoHosts_allow_deny"/></font>]
      </div>
    </td>
  </tr>
  
<!-- for schedule scan -->
  <tr id="user_forSchedule_scan_tr">
      <th><bean:message key="cifs.specialShare.scheduleScanUser"/></th>
      <td>
          <nested:text property="validUserForScheduleScan" size="64" maxlength="511" disabled="true"/>
      </td>
  </tr>
  <tr id="server_forSchedule_scan_tr">
      <th><bean:message key="cifs.specialShare.scheduleScanServer"/></th>
      <td>
          <nested:text property="allowHostForScheduleScan" size="64" maxlength="511" disabled="true"/>
      </td>
  </tr>
<!-- for schedule scan -->
  
  <tr>
    <th><bean:message key="cifs.common.th_otherOption"/></th>
    <td>
      <div id="shadowcopy_forBackup" style="display:none">
        <nested:checkbox property="shadowCopy" styleId="shadowCopy" value="yes"/>
          <label for="shadowCopy"><bean:message key="cifs.shareOption.checkbox_useShadowCopy"/></label><br>
      </div>
      <nested:checkbox property="browseable" styleId="browseable" value="yes"/>
        <label for="browseable"><bean:message key="cifs.specialShare.browse"/></label>
    </td>
  </tr>
</table>
</nested:nest>
</html:form>

<form name="sharePathForm" action="CSNavigatorList.do?notListfsType=sxfs" target="selectBackupSharePath_navigator" method="post">
  <input type="hidden" name="operation" value="callShare">
  <input type="hidden" name="rootDirectory" value="<%=exportGroup%>">
  <input type="hidden" name="nowDirectory" value="">
</form>
</body>
</html>