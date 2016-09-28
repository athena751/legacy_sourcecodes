<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: cifslisttop4nsview.jsp,v 1.2 2007/03/23 07:46:18 chenbc Exp $" -->


<%@ page import="java.io.*" %>
<%@ page import="com.nec.nsgui.exception.NSExceptionMessage,java.util.ArrayList,
                com.nec.nsgui.taglib.nssorttab.ListSTModel" %>
<%@ page import="com.nec.nsgui.action.base.NSActionConst" %>
<%@ page import="com.nec.nsgui.action.cifs.CifsActionConst" %>

<%@ page contentType="text/html;charset=UTF-8" buffer="32kb"%>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>
<%@ taglib uri="/WEB-INF/tld/nssorttab.tld" prefix="nssorttab" %>

<html>
<head>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript">

function init(){
    <logic:notEmpty name="shareList" scope="request">
        enableBottomButton();
    </logic:notEmpty>
    <logic:empty name="shareList" scope="request">
        disableBottonButton();
    </logic:empty>
   
}

function dispatchShareInfo(){
    <logic:notEmpty name="shareList" scope="request">
        var checkedShareInfo = getCheckedRadioValue(document.shareListForm.shareInfo);
        var firstSeparatorIndex = checkedShareInfo.indexOf(",");
        var secondSeparatorIndex = checkedShareInfo.indexOf(",", firstSeparatorIndex+1);
        document.shareListForm.shareName.value=checkedShareInfo.substring(0, firstSeparatorIndex);
        document.shareListForm.fsType.value=checkedShareInfo.substring(firstSeparatorIndex+1, secondSeparatorIndex);
        document.shareListForm.sharedDirectory.value=checkedShareInfo.substring(secondSeparatorIndex+1);
    </logic:notEmpty>
}

function enableBottomButton(){

        
    if(window.parent.bottomframe.document.shareListBottomForm && window.parent.bottomframe.document.shareListBottomForm.button_shareDetail){
        window.parent.bottomframe.document.shareListBottomForm.button_shareDetail.disabled=0;
    }
    
    if(window.parent.bottomframe.document.shareListBottomForm && window.parent.bottomframe.document.shareListBottomForm.button_setAccessLog_share){
        window.parent.bottomframe.document.shareListBottomForm.button_setAccessLog_share.disabled=0;
    }
    if(window.parent.bottomframe.document.shareListBottomForm && window.parent.bottomframe.document.shareListBottomForm.button_setDirAccess){
        window.parent.bottomframe.document.shareListBottomForm.button_setDirAccess.disabled=0;
    }
    
}

function disableBottonButton(){
    
    if(window.parent.bottomframe.document.shareListBottomForm && window.parent.bottomframe.document.shareListBottomForm.button_shareDetail){
        window.parent.bottomframe.document.shareListBottomForm.button_shareDetail.disabled=1;
    }
    if(window.parent.bottomframe.document.shareListBottomForm && window.parent.bottomframe.document.shareListBottomForm.button_setAccessLog_share){
        window.parent.bottomframe.document.shareListBottomForm.button_setAccessLog_share.disabled=1;
    }
    if(window.parent.bottomframe.document.shareListBottomForm && window.parent.bottomframe.document.shareListBottomForm.button_setDirAccess){
        window.parent.bottomframe.document.shareListBottomForm.button_setDirAccess.disabled=1;
    }
   
}
function onReload(){
	if (isSubmitted()){
	  	return false;
	}
	setSubmitted();
	window.parent.location="enterCifs4nsview.do";
}

</script>
</head>
<body onload="init();displayAlert();setHelpAnchor('network_cifs_1');" onUnload="closeDetailErrorWin();">

<displayerror:error h1_key="cifs.common.h1"/>

<form method="POST"  name="shareListForm">
    <html:button property="reload" onclick="onReload()">
        <bean:message key="common.button.reload" bundle="common"/>
    </html:button>
    
    <br><br>
<logic:notEmpty name="shareList" scope="request">
    <bean:define id="shareList" name="shareList" type="java.util.ArrayList"/>
    <nssorttab:table tablemodel="<%=new ListSTModel((ArrayList)shareList)%>" id="cifs_shareList"
            table="border=\"1\"" sortonload="shareName_td">
        <nssorttab:column name="shareInfo" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                            td="com.nec.nsgui.taglib.nssorttab.STCommonRadioRender"
                                            sortable="no">
                
        </nssorttab:column>
        <nssorttab:column name="shareName_td" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                        td="com.nec.nsgui.taglib.nssorttab.STDataRender"
                                        sortable="yes">
                <bean:message key="cifs.th.shareName"/>
        </nssorttab:column>
        <nssorttab:column name="directory" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                        td="com.nec.nsgui.taglib.nssorttab.STDataRender"
                                        sortable="yes">
                <bean:message key="cifs.th.directory"/>
        </nssorttab:column>
        <nssorttab:column name="fsType" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                        td="com.nec.nsgui.taglib.nssorttab.STDataRender"
                                        sortable="yes">
                <bean:message key="cifs.th.fsType"/>
        </nssorttab:column>
        <nssorttab:column name="connection" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                        td="com.nec.nsgui.taglib.nssorttab.STDataRender"
                                                sortable="yes">
                <bean:message key="cifs.shareOption.th_connection"/>
        </nssorttab:column>
        <nssorttab:column name="readOnly" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                        td="com.nec.nsgui.taglib.nssorttab.STDataRender"
                                                sortable="yes">
                <bean:message key="cifs.shareOption.th_accessMode"/>
        </nssorttab:column>
        <logic:equal name="<%=CifsActionConst.SESSION_SECURITY_MODE%>" value="<%=CifsActionConst.SECURITYMODE_ADS%>" scope="session">
          <logic:equal name="<%=CifsActionConst.SESSION_HASANTIVIRUSSCAN_LICENSE%>" value="yes" scope="session">
            <nssorttab:column name="antiVirus" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                            td="com.nec.nsgui.taglib.nssorttab.STDataRenderAlignCenter"
                                                    sortable="yes">
                    <bean:message key="cifs.antiVirus"/>
            </nssorttab:column>
          </logic:equal>
        </logic:equal>
        <nssorttab:column name="logging" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                        td="com.nec.nsgui.taglib.nssorttab.STCheckedImageDataRender"
                                                sortable="yes">
                <bean:message key="cifs.th.logging"/>
        </nssorttab:column>
        <nssorttab:column name="comment" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                        td="com.nec.nsgui.taglib.nssorttab.STDataRender"
                                        sortable="yes">
                <bean:message key="cifs.th.comment"/>
        </nssorttab:column>
    </nssorttab:table>
    <input type="hidden" name="shareName" value="" >
    <input type="hidden" name="fsType" value="" >
    <input type="hidden" name="sharedDirectory" value="" >
</logic:notEmpty>

<logic:empty name="shareList" scope="request">
    <bean:message key="cifs.message.noShares"/>
</logic:empty>
    <input name="needCheck" type="hidden" value="true" />
    <input name="interfaceWanted" type="hidden" value="<bean:write name="interfaceWanted"/>" />
</form>
</body>
</html>