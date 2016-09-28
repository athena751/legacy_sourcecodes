<!--
        Copyright (c) 2004-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: volumelistbottom.jsp,v 1.19 2008/04/19 13:40:38 jiangfx Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>
<%@ page import="com.nec.nsgui.action.volume.VolumeActionConst"%>
<%@ page import="com.nec.nsgui.action.ddr.DdrActionConst"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>

<bean:define id="isNashead" value='<%=NSActionUtil.isNashead(request)?"true":"false"%>'/>
<bean:define id="ldCount" name="ldCount" scope="session"/>
<html:html lang="true">
<head>
<%@include file="/common/head.jsp" %>
<script language="JavaScript" src="/nsadmin/common/common.js"></script>
<script language="JavaScript" src="/nsadmin/common/validation.js"></script>
<script language="JavaScript">

var heartbeatWin;
function onFormSubmit(){
    if (isSubmitted()){
        return false;
    }
    
    document.forms[0].target = "ACTION";
    if (document.forms[0].operation.value == "delete"){
        if (document.forms[0].elements["volumeInfo.replicType"].value != ""){
            alert("<bean:message key="msg.del.hasReplic"/>");
            return false;
	    }
        if (document.forms[0].elements["volumeInfo.wpPeriod"].value != "-1" 
            && document.forms[0].elements["volumeInfo.wpPeriod"].value != "--"){
            alert("<bean:message key="alert.del.haswriteprotect"/>");
            return false;
        }
	    var confirmMsg = "<bean:message key="common.confirm" bundle="common" />" + "\r\n"
	            + "<bean:message key="common.confirm.action" bundle="common" />" 
	            + "<bean:message key="button.del"/>"  + "\r\n"
	            + "<bean:message key="info.volumeName"/> : " 
	            + document.forms[0].elements["volumeInfo.volumeName"].value.replace("NV_LVM_","") + "\r\n"
	            + "<bean:message key="msg.del.warning"/>" + "\r\n\r\n"
                + "<bean:message key="msg.longTimeWait"/>";
        
        if (document.forms[0].elements["volumeInfo.useCode"].value == "0x1080001a"){
            confirmMsg = "<bean:message key="msg.delmp.useftp"/>"
                       + "\r\n\r\n"
                       + "<bean:message key="msg.longTimeWait"/>";
        }        
	    if (confirm(confirmMsg)){
	        setSubmitted();
	        heartbeatWin = openHeartBeatWin();
	        document.forms[0].action="/nsadmin/volume/volumeDel.do";
	        lockMenu();
	        return true;
	    }
    }
    if (document.forms[0].operation.value == "extend"){
<logic:notEqual name="isNashead" value="true" scope="page">  
	    if (<%=ldCount%> >= 512) {
	        alert("<bean:message key="alert.info.ld512"/>");
	        return false;
	    }
</logic:notEqual>	    
        setSubmitted();
        document.forms[0].action="/nsadmin/volume/volumeExtendShow.do";
        return true;
    }
    
    if (document.forms[0].operation.value == "umount"){
        if (document.forms[0].elements["volumeInfo.replicType"].value != ""){
	        alert("<bean:message key="msg.umount.hasReplic"/>");
	        return false;
	    }
	    if (confirm("<bean:message key="common.confirm" bundle="common" />" + "\r\n"
	            + "<bean:message key="common.confirm.action" bundle="common" />" 
	            + "<bean:message key="button.umount"/>"  + "\r\n"
	            + "<bean:message key="info.volumeName"/> : " 
	            + document.forms[0].elements["volumeInfo.volumeName"].value.replace("NV_LVM_","") + "\r\n"
	            )){
	        setSubmitted();
	        document.forms[0].action="/nsadmin/volume/volumeUmount.do";
	        return true;
	    }
    }
    
    if (document.forms[0].operation.value == "modify"){
        setSubmitted();
        document.forms[0].action="/nsadmin/volume/volumeModifyShow.do";
        return true;
	}
    
    if (document.forms[0].operation.value == "mount"){
        if (confirm("<bean:message key="common.confirm" bundle="common" />" + "\r\n"
	            + "<bean:message key="common.confirm.action" bundle="common" />" 
	            + "<bean:message key="button.mount" />"  + "\r\n"
	            + "<bean:message key="info.volumeName"/> : " 
	            + document.forms[0].elements["volumeInfo.volumeName"].value.replace("NV_LVM_","") + "\r\n"
	            )){
	        setSubmitted();
	        document.forms[0].action="/nsadmin/volume/volumeMount.do";
	        lockMenu();
	        return true;
	    }
    }
  
    return false;
}

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
    <logic:equal name="<%=VolumeActionConst.SESSION_NV_ASYNC%>" value="true" scope="session">
        disableBtns();
    </logic:equal> 
    <logic:equal name="<%=DdrActionConst.SESSION_DDR_ASYNCPAIR%>" value="true" scope="session">
        disableBtns();
    </logic:equal>      
}

function disableBtns() {
    document.forms[0].mountBtn.disabled    = true;
    document.forms[0].modifyBtn.disabled   = true;
    document.forms[0].extendBtn.disabled   = true;
    document.forms[0].delBtn.disabled      = true;
}

</script>
</head>
<body onload="init();" onUnload="unLockMenu();closePopupWin(heartbeatWin);closePopupWin(volumeDetailWin);">
    <html:form action="/volumeDel.do" onsubmit="return onFormSubmit();" target="ACTION">
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
        </html:button>&nbsp;    
        <html:submit property="mountBtn" onclick="document.forms[0].operation.value='mount';">
           <bean:message key="button.mount"/>
        </html:submit>&nbsp;
        <html:submit property="modifyBtn" onclick="document.forms[0].operation.value='modify';">
		   <bean:message key="common.button.modify2" bundle="common"/>
		</html:submit>&nbsp;
		<html:submit property="extendBtn" onclick="document.forms[0].operation.value='extend';">
		   <bean:message key="button.extend"/><bean:message key="button.dot"/>
		</html:submit>&nbsp;&nbsp;&nbsp;&nbsp;
	    <html:submit property="delBtn" onclick="document.forms[0].operation.value='delete';">
	       <bean:message key="button.del"/>
	    </html:submit>&nbsp;
<!--
	    <html:submit property="umountBtn" onclick="document.forms[0].operation.value='umount';">
	       <bean:message key="button.umount"/>
	    </html:submit>
-->
    </html:form>
</body>
</html:html>