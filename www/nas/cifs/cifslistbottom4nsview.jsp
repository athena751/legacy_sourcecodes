<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: cifslistbottom4nsview.jsp,v 1.4 2005/10/11 00:43:05 key Exp $" -->


<%@ page import="java.io.*" %>
<%@ page import="com.nec.nsgui.exception.NSExceptionMessage,
                com.nec.sydney.framework.NSConstant,
                com.nec.sydney.framework.HTMLUtil" %>
<%@ page import="com.nec.nsgui.action.base.NSActionConst" %>

<%@ page contentType="text/html;charset=UTF-8" buffer="32kb"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>

<html>
<head>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript">
var popUpWinName1;
var popUpWinName2;
var popUpWinName3;

function onDetail(){
		if(window.parent.topframe.document.shareListForm.shareName){
		 popUpWinName1 = window.open("/nsadmin/common/commonblank.html","shareDetail",
                "resizable=yes,toolbar=no,menubar=no,scrollbars=yes,width=700,height=600");
          window.parent.topframe.dispatchShareInfo();
          window.parent.topframe.document.shareListForm.action = "setShare.do?operation=displayDetail";
          window.parent.topframe.document.shareListForm.target = "shareDetail";
          window.parent.topframe.document.shareListForm.submit();
          popUpWinName1.focus();
          return true;
        }else{
        	return false;
        }
}

function onSetAccessLog(){
   if(window.parent.topframe.document.shareListForm.shareName){
    <logic:equal name="hasSetAccessLog" value="true">
        popUpWinName2 = window.open("/nsadmin/common/commonblank.html","cifsAccessLog",
                "resizable=yes,toolbar=no,menubar=no,scrollbars=yes,width=700,height=600");
          window.parent.topframe.dispatchShareInfo();
          window.parent.topframe.document.shareListForm.action = "/nsadmin/nas/cifs/cifsshareaccesslogforward4nsview.jsp";
          window.parent.topframe.document.shareListForm.target = "cifsAccessLog";
          window.parent.topframe.document.shareListForm.submit();
          popUpWinName2.focus();
          return true;
    </logic:equal>
    <logic:notEqual name="hasSetAccessLog" value="true">
        alert('<bean:message key="cifs.alert.noSetAccessLog4nsview"/>');
        return false;
    </logic:notEqual>
    }else{
     return false;
    }
}

function onSetDirAccess(){
    
    if(window.parent.topframe.document.shareListForm.shareName){
        window.parent.topframe.dispatchShareInfo();
        if(window.parent.topframe.document.shareListForm.fsType.value!="sxfs"){
            alert('<bean:message key="cifs.alert.setDirAccessFor_sxfsfw"/>');
            return false;
        }else{
        	popUpWinName3 = window.open("/nsadmin/common/commonblank.html","cifsDirAccess",
                "resizable=yes,toolbar=no,menubar=no,scrollbars=yes,width=700,height=600");
            window.parent.topframe.dispatchShareInfo();
            window.parent.topframe.document.shareListForm.action = "dirAccessControl4nsview.do?operation=displayList";
            window.parent.topframe.document.shareListForm.target = "cifsDirAccess";
            window.parent.topframe.document.shareListForm.submit();
            popUpWinName3.focus();
            return true;
        }
    }
    return false;
}
function disableButtons(){
    document.shareListBottomForm.button_shareDetail.disabled=1;
    document.shareListBottomForm.button_setAccessLog_share.disabled=1;
    document.shareListBottomForm.button_setDirAccess.disabled=1;
}

function enableButtons(){
    document.shareListBottomForm.button_shareDetail.disabled=0;
    document.shareListBottomForm.button_setAccessLog_share.disabled=0;
    document.shareListBottomForm.button_setDirAccess.disabled=0;
}

function changeButtonStatus(){
    if(window.parent.topframe.document.shareListForm && window.parent.topframe.document.shareListForm.shareName){
        enableButtons();
    }else{
        disableButtons();
    }
}
function closeAllPopupWin(){
	if(popUpWinName1 && !(popUpWinName1.closed)){
	        popUpWinName1.close();
	    }
	if(popUpWinName2 && !(popUpWinName2.closed)){
	        popUpWinName2.close();
	    }
	if(popUpWinName3 && !(popUpWinName3.closed)){
	        popUpWinName3.close();
	    }
}
</script>
</head>
<body  onload="changeButtonStatus();" onUnload="closeAllPopupWin();" style="margin: 10px;">
<form method="POST"  name="shareListBottomForm">
<nobr>

    <input type="button" name="button_shareDetail" onclick="onDetail()"
        value="<bean:message key="cifs.button.shareDetail"/>"/>
    	
    &nbsp;
    <input type="button" name="button_setAccessLog_share" onclick="onSetAccessLog()"
        value="<bean:message key="cifs.button.setAccessLog_share_4nsview"/>"/>
    
    &nbsp;
    <input type="button" name="button_setDirAccess" onclick="onSetDirAccess()"
        value="<bean:message key="cifs.button.setDirAccessControl_4nsview"/>"/>
</nobr>
</form>
</body>
</html>