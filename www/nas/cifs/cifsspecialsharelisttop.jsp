<!--
        Copyright (c) 2007-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: cifsspecialsharelisttop.jsp,v 1.4 2008/12/18 08:56:40 chenbc Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" buffer="32kb"%>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>
<%@ taglib uri="/WEB-INF/tld/nssorttab.tld" prefix="nssorttab" %>

<%@ page import="java.io.*" %>
<%@ page import="com.nec.nsgui.exception.NSExceptionMessage,
                java.util.ArrayList,
                com.nec.nsgui.taglib.nssorttab.ListSTModel" %>
<%@ page import="com.nec.nsgui.action.base.NSActionConst" %>

<html>
<head>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript">

function onReload(){
    if (isSubmitted()){
        return false;
    }
    setSubmitted();
    window.parent.location="specialShare.do";
}
function onAddShare(){
    if (isSubmitted()){
        return false;
    }
    <logic:equal name="hasAvailableNicForCIFS" value="false" scope="request">
        alert('<bean:message key="cifs.alert.availableServiceNIC_null"/>');
        return false;
    </logic:equal>
    <logic:equal name="interfaceWanted" value="true" scope="request">
        alert('<bean:message key="cifs.alert.interfaceIsWanted"/>');
        return false;
    </logic:equal>
    <logic:notEqual name="canAddShare" value="true" scope="request">
        alert('<bean:message key="cifs.alert.noMpForSpecialShare"/>');
        return false;
    </logic:notEqual>
    <logic:equal name="canAddShare" value="true" scope="request">
        setSubmitted();
        window.parent.location="loadSetSpecialShare.do?shareAction=add";
    </logic:equal>
}

function init(){
    <logic:notEmpty name="shareList" scope="request">
        enableBottomButton();
    </logic:notEmpty>
    <logic:empty name="shareList" scope="request">
        disableBottonButton();
    </logic:empty>
    <logic:equal name="<%=NSActionConst.SESSION_USERINFO %>"
	    value="<%=NSActionConst.NSUSER_NSADMIN %>" scope="session">
      <logic:equal name="needAlert_hasSetAntiVirusScan" value="true" scope="request">
          alert("<bean:message key="cifs.alert.hasSetAntiVirusScan_whenDelete"/>");
          enableBottomButton();
      </logic:equal>
      
      <logic:equal name="needAlert_hasSetScheduleScan" value="true" scope="request">
          alert("<bean:message key="cifs.alert.hasSetScheduleScan_whenDelete"/>");
          enableBottomButton();
      </logic:equal>
 
      displayAlert();
      <logic:equal name="hasAvailableNicForCIFS" value="false" scope="request">
      alert('<bean:message key="cifs.alert.availableServiceNIC_null"/>');
        return false;
      </logic:equal>     
    </logic:equal> 

}

function dispatchShareInfo(){
    <logic:notEmpty name="shareList" scope="request">
        var checkedShareInfo = getCheckedRadioValue(document.shareListForm.shareInfo);
        var firstSeparatorIndex = checkedShareInfo.indexOf(",");
        var secondSeparatorIndex = checkedShareInfo.indexOf(",", firstSeparatorIndex+1);
        var thirdSeparatorIndex = checkedShareInfo.indexOf(",", secondSeparatorIndex+1);
        document.shareListForm.shareName.value=checkedShareInfo.substring(0, firstSeparatorIndex);
        document.shareListForm.fsType.value=checkedShareInfo.substring(firstSeparatorIndex+1, secondSeparatorIndex);
        document.shareListForm.sharePurpose.value=checkedShareInfo.substring(secondSeparatorIndex+1, thirdSeparatorIndex);
        document.shareListForm.sharedDirectory.value=checkedShareInfo.substring(thirdSeparatorIndex+1);
    </logic:notEmpty>
}

function enableBottomButton(){

    if(window.parent.bottomframe.document && window.parent.bottomframe.document.shareListBottomForm) {
        if(window.parent.bottomframe.document.shareListBottomForm.button_shareDetail){
            window.parent.bottomframe.document.shareListBottomForm.button_shareDetail.disabled=0;
        }
        if(window.parent.bottomframe.document.shareListBottomForm.button_modifyShare){
            window.parent.bottomframe.document.shareListBottomForm.button_modifyShare.disabled=0;
        }
        if(window.parent.bottomframe.document.shareListBottomForm.button_deleteShare){
            window.parent.bottomframe.document.shareListBottomForm.button_deleteShare.disabled=0;
        }
    }
}

function disableBottonButton(){
    
    if(window.parent.bottomframe.document && window.parent.bottomframe.document.shareListBottomForm) {
        if (window.parent.bottomframe.document.shareListBottomForm.button_shareDetail){
            window.parent.bottomframe.document.shareListBottomForm.button_shareDetail.disabled=1;
        }
        if(window.parent.bottomframe.document.shareListBottomForm.button_modifyShare){
            window.parent.bottomframe.document.shareListBottomForm.button_modifyShare.disabled=1;
        }
        if(window.parent.bottomframe.document.shareListBottomForm.button_deleteShare){
            window.parent.bottomframe.document.shareListBottomForm.button_deleteShare.disabled=1;
        }
    }
}
</script>
</head>
<body onload="init();setHelpAnchor('network_cifs_18');" onUnload="closeDetailErrorWin();">

<displayerror:error h1_key="cifs.common.h1"/>

<form method="POST"  name="shareListForm">

	<html:button property="reload" onclick="onReload()">
        <bean:message key="common.button.reload" bundle="common"/>
    </html:button>
    &nbsp;
    <logic:equal name="<%=NSActionConst.SESSION_USERINFO %>"
	    value="<%=NSActionConst.NSUSER_NSADMIN %>" scope="session">
      <html:button property="addShare" onclick="onAddShare()">
          <bean:message key="common.button.add2" bundle="common"/>
      </html:button>
    </logic:equal>
    
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
        <nssorttab:column name="sharePurpose" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                        td="com.nec.nsgui.taglib.nssorttab.STDataRender"
                                                sortable="yes">
                <bean:message key="cifs.sharePurpose"/>
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
    <input name="sharePurpose" type="hidden" value="" >
</logic:notEmpty>

<logic:empty name="shareList" scope="request">
    <bean:message key="cifs.message.noSpecialShares"/>
</logic:empty>
    <input name="interfaceWanted" type="hidden" value="<bean:write name="interfaceWanted"/>" />
    <input name="hasAvailableNicForCIFS" type="hidden" value="<bean:write name="hasAvailableNicForCIFS"/>" />
</form>
</body>
</html>