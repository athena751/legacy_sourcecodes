<!--
        Copyright (c) 2006-2007 NEC Corporation
		
        NEC SOURCE CODE PROPRIETARY
		
        Use, duplication and disclosure subject to a source code 
        license agreement with NEC Corporation.
-->

<!--  "@(#) $Id: ndmpsessiontop.jsp,v 1.5 2007/05/09 06:44:20 wanghui Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" buffer="32kb"%>
<%@ page import="java.util.ArrayList,java.util.List,com.nec.nsgui.action.ndmpv4.NdmpActionConst,
                com.nec.nsgui.taglib.nssorttab.ListSTModel"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>
<%@ taglib uri="/WEB-INF/tld/nssorttab.tld" prefix="nssorttab" %>
<html:html lang="true">
<head>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="../common/common.js"></script>
<script language="JavaScript">

function init(){
    setHelpAnchor("backup_ndmp_1");
    <logic:notEmpty name="<%=NdmpActionConst.SESSION_INFO_LIST%>">
       if(document.forms[0].sessionRadioId.length){    
            document.forms[0].sessionRadioId[0].checked=true;
        }else{
            document.forms[0].sessionRadioId.checked=true;
        }
        enableBottomButton();
    </logic:notEmpty>
}
function setSessionId(){
    <logic:notEmpty name="<%=NdmpActionConst.SESSION_INFO_LIST%>">
        var checkedSessionInfo = getCheckedRadioValue(document.forms[0].sessionRadioId);
        document.forms[0].sessionID.value=checkedSessionInfo;
    </logic:notEmpty>
}
function refreshGraph(){
    if(window.parent.frames[1]&&window.parent.frames[1].isSubmitted()){
        return false;
    }
    window.parent.frames[1].setSubmitted();
    window.parent.location="ndmpSessionAction.do?operation=entrySessionInfo";
    
}
function enableBottomButton(){
    if(window.parent.frames[1] && window.parent.frames[1].document.sessionInfoBottom && window.parent.frames[1].document.sessionInfoBottom.sessionDetail){
        window.parent.frames[1].document.sessionInfoBottom.sessionDetail.disabled = false;
    }
}
</script>
</head>
<body onload="init();displayAlert();">
<html:form action="ndmpSessionAction.do?operation=entrySessionInfo" method="POST">
<displayerror:error h1_key="ndmp.common.h1"/>
<input type="button" name="refresh"
         value="<bean:message key='common.button.reload' bundle='common'/>" onclick="return refreshGraph()"/>
<table style="background-image: url('blank.gif');background-color: White;" width="100%">
  <tr><td align="right">
    <bean:write name="<%=NdmpActionConst.REQUEST_NDMP_SYSDATE%>" scope="request" />&nbsp;
    <bean:message key="ndmp.session.nowtime"/>
  </td></tr>
<logic:notEmpty name="<%=NdmpActionConst.SESSION_DATA_LIST%>">
<tr><td><h3 class="title"><bean:message key="ndmp.session.title.type.data"/></h3>
</td></tr>
<tr><td>
    <bean:define id="ndmp_sessionDataList" name="<%=NdmpActionConst.SESSION_DATA_LIST%>" type="java.util.List"/>
    <nssorttab:table tablemodel="<%=new ListSTModel((ArrayList)ndmp_sessionDataList)%>" id="session_DataList"
            table="border=\"1\" width=\"100%\"" sortonload="sessionId">
        <nssorttab:column name="sessionRadioId" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                            td="com.nec.nsgui.taglib.nssorttab.STCommonRadioRender"
                                            sortable="no">
        </nssorttab:column>
        <nssorttab:column  name="sessionId" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                        td="com.nec.nsgui.taglib.nssorttab.STDataRenderAlignRight"
                                        sortable="yes">
                <bean:message key="ndmp.session.id"/>
        </nssorttab:column>
        <nssorttab:column  name="sessionTypeJob" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                        td="com.nec.nsgui.taglib.nssorttab.STDataRenderAlignCenter"
                                        sortable="yes">
                <bean:message key="ndmp.session.type.job"/>
        </nssorttab:column>
        <nssorttab:column name="dataState" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                           td="com.nec.nsgui.taglib.nssorttab.STDataRenderAlignCenter"
                                                sortable="yes">
                <bean:message key="ndmp.session.dataStatus"/>
        </nssorttab:column>
        <nssorttab:column name="dataIp" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                        td="com.nec.nsgui.taglib.nssorttab.STDataRenderAlignCenter"
                                                sortable="yes">
                <bean:message key="ndmp.session.dataIp"/>
        </nssorttab:column>
        <nssorttab:column name="moverIp" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                        td="com.nec.nsgui.taglib.nssorttab.STDataRenderAlignCenter"
                                        sortable="yes">
                <bean:message key="ndmp.session.moverIp"/>
        </nssorttab:column>
        <nssorttab:column name="MBytesTxferred" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                        td="com.nec.nsgui.taglib.nssorttab.STDataRenderAlignRight"
                                        sortable="yes">
                <bean:message key="ndmp.session.finishData"/>
        </nssorttab:column>
        <nssorttab:column name="startTime" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                        td="com.nec.nsgui.taglib.nssorttab.STDataRenderAlignCenter"
                                        sortable="yes">
                <bean:message key="ndmp.session.startTime"/>
        </nssorttab:column>
        <nssorttab:column name="dmaIp" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                        td="com.nec.nsgui.taglib.nssorttab.STDataRenderAlignCenter"
                                        sortable="yes">
                <bean:message key="ndmp.session.dma"/>
        </nssorttab:column>
    </nssorttab:table>
<br></td></tr>
</logic:notEmpty>
<logic:notEmpty name="<%=NdmpActionConst.SESSION_MOVER_LIST%>">
<tr><td><h3 class="title"><bean:message key="ndmp.session.title.type.mover"/></h3>
</td></tr>
<tr><td>
    <bean:define id="ndmp_sessionMoverList" name="<%=NdmpActionConst.SESSION_MOVER_LIST%>" type="java.util.List"/>
    <nssorttab:table tablemodel="<%=new ListSTModel((ArrayList)ndmp_sessionMoverList)%>" id="session_MoverList"
            table="border=\"1\" width=\"100%\"" sortonload="sessionId">
        <nssorttab:column name="sessionRadioId" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                            td="com.nec.nsgui.taglib.nssorttab.STCommonRadioRender"
                                            sortable="no">
        </nssorttab:column>
        <nssorttab:column  name="sessionId" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                        td="com.nec.nsgui.taglib.nssorttab.STDataRenderAlignRight"
                                        sortable="yes">
                <bean:message key="ndmp.session.id"/>
        </nssorttab:column>
        <nssorttab:column  name="sessionTypeJob" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                        td="com.nec.nsgui.taglib.nssorttab.STDataRenderAlignCenter"
                                        sortable="yes">
                <bean:message key="ndmp.session.type.job"/>
        </nssorttab:column>
        <nssorttab:column name="moverState" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                        td="com.nec.nsgui.taglib.nssorttab.STDataRenderAlignCenter"
                                        sortable="yes">
                <bean:message key="ndmp.session.moverStatus"/>
        </nssorttab:column>
        <nssorttab:column name="moverIp" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                        td="com.nec.nsgui.taglib.nssorttab.STDataRenderAlignCenter"
                                        sortable="yes">
                <bean:message key="ndmp.session.moverIp"/>
        </nssorttab:column>
        <nssorttab:column name="dataIp" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                        td="com.nec.nsgui.taglib.nssorttab.STDataRenderAlignCenter"
                                                sortable="yes">
                <bean:message key="ndmp.session.dataIp"/>
        </nssorttab:column>
        <nssorttab:column name="MBytesTxferred" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                        td="com.nec.nsgui.taglib.nssorttab.STDataRenderAlignRight"
                                        sortable="yes">
                <bean:message key="ndmp.session.finishData"/>
        </nssorttab:column>
        <nssorttab:column name="startTime" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                        td="com.nec.nsgui.taglib.nssorttab.STDataRenderAlignCenter"
                                        sortable="yes">
                <bean:message key="ndmp.session.startTime"/>
        </nssorttab:column>
        <nssorttab:column name="dmaIp" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                        td="com.nec.nsgui.taglib.nssorttab.STDataRenderAlignCenter"
                                        sortable="yes">
                <bean:message key="ndmp.session.dma"/>
        </nssorttab:column>
    </nssorttab:table>
<br></td></tr>
</logic:notEmpty>
<logic:notEmpty name="<%=NdmpActionConst.SESSION_LOCAL_LIST%>"> 
<tr><td><h3 class="title"><bean:message key="ndmp.session.title.type.local"/></h3>
</td></tr>
<tr><td>
    <bean:define id="ndmp_sessionLocalList" name="<%=NdmpActionConst.SESSION_LOCAL_LIST%>" type="java.util.List"/>
    <nssorttab:table tablemodel="<%=new ListSTModel((ArrayList)ndmp_sessionLocalList)%>" id="session_LocalList"
            table="border=\"1\" width=\"100%\"" sortonload="sessionId">
        <nssorttab:column name="sessionRadioId" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                            td="com.nec.nsgui.taglib.nssorttab.STCommonRadioRender"
                                            sortable="no">
        </nssorttab:column>
        <nssorttab:column  name="sessionId" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                        td="com.nec.nsgui.taglib.nssorttab.STDataRenderAlignRight"
                                        sortable="yes">
                <bean:message key="ndmp.session.id"/>
        </nssorttab:column>
        <nssorttab:column  name="sessionTypeJob" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                        td="com.nec.nsgui.taglib.nssorttab.STDataRenderAlignCenter"
                                        sortable="yes">
                <bean:message key="ndmp.session.type.job"/>
        </nssorttab:column>
        <nssorttab:column name="dataState" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                           td="com.nec.nsgui.taglib.nssorttab.STDataRenderAlignCenter"
                                                sortable="yes">
                <bean:message key="ndmp.session.dataStatus"/>
        </nssorttab:column>
        <nssorttab:column name="moverState" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                        td="com.nec.nsgui.taglib.nssorttab.STDataRenderAlignCenter"
                                        sortable="yes">
                <bean:message key="ndmp.session.moverStatus"/>
        </nssorttab:column>
        <nssorttab:column name="MBytesTxferred" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                        td="com.nec.nsgui.taglib.nssorttab.STDataRenderAlignRight"
                                        sortable="yes">
                <bean:message key="ndmp.session.finishData"/>
        </nssorttab:column>
        <nssorttab:column name="startTime" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                        td="com.nec.nsgui.taglib.nssorttab.STDataRenderAlignCenter"
                                        sortable="yes">
                <bean:message key="ndmp.session.startTime"/>
        </nssorttab:column>
        <nssorttab:column name="dmaIp" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                        td="com.nec.nsgui.taglib.nssorttab.STDataRenderAlignCenter"
                                        sortable="yes">
                <bean:message key="ndmp.session.dma"/>
        </nssorttab:column>
    </nssorttab:table>
<br></td></tr>
</logic:notEmpty>
<logic:notEmpty name="<%=NdmpActionConst.SESSION_UNKNOWN_LIST%>"> 
<tr><td><h3 class="title"><bean:message key="ndmp.session.title.type.unknown"/></h3>
</td></tr>
<tr><td>
    <bean:define id="ndmp_sessionUnknownList" name="<%=NdmpActionConst.SESSION_UNKNOWN_LIST%>" type="java.util.List"/>
    <nssorttab:table tablemodel="<%=new ListSTModel((ArrayList)ndmp_sessionUnknownList)%>" id="session_UnknownList"
            table="border=\"1\" width=\"100%\"" sortonload="sessionId">
        <nssorttab:column name="sessionRadioId" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                            td="com.nec.nsgui.taglib.nssorttab.STCommonRadioRender"
                                            sortable="no">
        </nssorttab:column>
        <nssorttab:column  name="sessionId" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                        td="com.nec.nsgui.taglib.nssorttab.STDataRenderAlignRight"
                                        sortable="yes">
                <bean:message key="ndmp.session.id"/>
        </nssorttab:column>
        <nssorttab:column  name="sessionTypeJob" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                        td="com.nec.nsgui.taglib.nssorttab.STDataRenderAlignCenter"
                                        sortable="yes">
                <bean:message key="ndmp.session.type.job"/>
        </nssorttab:column>
        <nssorttab:column name="dataState" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                           td="com.nec.nsgui.taglib.nssorttab.STDataRenderAlignCenter"
                                                sortable="yes">
                <bean:message key="ndmp.session.dataStatus"/>
        </nssorttab:column>
        <nssorttab:column name="moverState" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                        td="com.nec.nsgui.taglib.nssorttab.STDataRenderAlignCenter"
                                        sortable="yes">
                <bean:message key="ndmp.session.moverStatus"/>
        </nssorttab:column>
        <nssorttab:column name="MBytesTxferred" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                        td="com.nec.nsgui.taglib.nssorttab.STDataRenderAlignRight"
                                        sortable="yes">
                <bean:message key="ndmp.session.finishData"/>
        </nssorttab:column>
        <nssorttab:column name="startTime" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                        td="com.nec.nsgui.taglib.nssorttab.STDataRenderAlignCenter"
                                        sortable="yes">
                <bean:message key="ndmp.session.startTime"/>
        </nssorttab:column>
        <nssorttab:column name="dmaIp" th="com.nec.nsgui.taglib.nssorttab.STHeaderRender"
                                        td="com.nec.nsgui.taglib.nssorttab.STDataRenderAlignCenter"
                                        sortable="yes">
                <bean:message key="ndmp.session.dma"/>
        </nssorttab:column>
    </nssorttab:table>
</td></tr>
</logic:notEmpty>
</table>
<logic:empty name="<%=NdmpActionConst.SESSION_INFO_LIST%>">
    <bean:message key="ndmp.session.noSessionInfo"/>
</logic:empty>
<input type="hidden" name="sessionID" value="">
</html:form>
</body>
</html:html>