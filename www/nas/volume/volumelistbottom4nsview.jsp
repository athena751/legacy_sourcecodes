<!--
        Copyright (c) 2004-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: volumelistbottom4nsview.jsp,v 1.8 2007/08/23 06:03:06 xingyh Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>

<bean:define id="isNashead" value='<%=NSActionUtil.isNashead(request)?"true":"false"%>'/>
<html:html lang="true">
<head>
<%@include file="/common/head.jsp" %>
<script language="JavaScript" src="/nsadmin/common/common.js"></script>
<script language="JavaScript">
var volumeDetailWin;
function onDetail(){
    if (isSubmitted()){
       return false;
    }
    
    if ((volumeDetailWin == null) || (volumeDetailWin.closed)) {
	    volumeDetailWin = window.open("/nsadmin/common/commonblank.html", "volume_detail_navigator",
	                                  "left=1,top=1,width=500,height=550,resizable=yes,scrollbars=yes");
	    document.forms[0].target = "volume_detail_navigator";
	    document.forms[0].action = "/nsadmin/volume/volumeDetailShow.do?from=volume";
	    document.forms[0].submit();  
    } else {
        volumeDetailWin.focus();
        document.forms[0].submit();
    }
    return true;
}

function init(){
    var radioBtn;
    if (parent.middleframe.document.forms[0] && parent.middleframe.document.forms[0].elements["volumeRadio"] != null){
        radioBtn = parent.middleframe.document.forms[0].elements["volumeRadio"];
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
    
}


</script>
</head>
<body onload="init();" onUnload="unLockMenu();closePopupWin(volumeDetailWin);">
    <html:form action="/volumeDel.do" target="ACTION">
        <input type="hidden" name="operation" value="">
        <input type="hidden" name="volumeInfo.volumeName" value="">
        <input type="hidden" name="volumeInfo.mountPoint" value="">
        <input type="hidden" name="volumeInfo.capacity" value="">
        <input type="hidden" name="volumeInfo.quota" value="">
        <input type="hidden" name="volumeInfo.noatime" value="">
        <input type="hidden" name="volumeInfo.snapshot" value="">
        <input type="hidden" name="volumeInfo.accessMode" value="">
        <input type="hidden" name="volumeInfo.mountStatus" value="">
        <input type="hidden" name="volumeInfo.replication" value="">
        <input type="hidden" name="volumeInfo.replicType" value="">
        <input type="hidden" name="volumeInfo.norecovery" value="">
        <input type="hidden" name="volumeInfo.dmapi" value="">
        <input type="hidden" name="volumeInfo.fsType" value="">        
        <input type="hidden" name="volumeInfo.useRate" value="">
        <input type="hidden" name="volumeInfo.useGfs" value="">
        <input type="hidden" name="volumeInfo.replication4Show" value="">
        <logic:equal name="isNashead" value="true" scope="page">
	        <input type="hidden" name="volumeInfo.lun" value="">
	        <input type="hidden" name="volumeInfo.storage" value="">
	    </logic:equal>
	    <logic:notEqual name="isNashead" value="true" scope="page">           
	        <input type="hidden" name="volumeInfo.raidType" value=""> 
	        <input type="hidden" name="volumeInfo.poolNameAndNo" value="">                   
	        <input type="hidden" name="volumeInfo.aid" value="">
	        <input type="hidden" name="volumeInfo.aname" value="">  
            <input type="hidden" name="volumeInfo.asyncStatus" value="">
            <input type="hidden" name="volumeInfo.errCode" value="">
        </logic:notEqual>
        <input type="hidden" name="volumeInfo.useCode" value="">
        <input type="hidden" name="volumeInfo.fsSize" value="">
        <input type="hidden" name="volumeInfo.wpPeriod" value="">

        <html:button property="detailBtn" onclick="return onDetail()">
           <bean:message key="common.button.detail2" bundle="common"/>
        </html:button>   

    </html:form>
</body>
</html:html>