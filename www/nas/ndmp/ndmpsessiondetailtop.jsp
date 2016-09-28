<!--
        Copyright (c) 2006-2007 NEC Corporation
		
        NEC SOURCE CODE PROPRIETARY
		
        Use, duplication and disclosure subject to a source code 
        license agreement with NEC Corporation.
-->

<!--  "@(#) $Id: ndmpsessiondetailtop.jsp,v 1.5 2007/05/09 06:44:08 wanghui Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" buffer="32kb"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<html:html lang="true">
<head>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="../common/common.js"></script>
<title><bean:message key="ndmp.session.title.sessionDetail"/></title>
</head>
<body onload="setHelpAnchor('backup_ndmp_2');" onUnload="setHelpAnchor('backup_ndmp_1');">
<h1 class="popup"><bean:message key="ndmp.common.h1"/></h1>
<h2 class="popup"><bean:message key="ndmp.session.sessionDetail"/></h2>
<bean:define id="sessionType" name="ndmpSessionForm" property="sessionDetail.sessionType"/>
<logic:equal name="sessionType" value="LOCAL">
<h3 class="title"><bean:message key="ndmp.session.title.type.local"/></h3>
</logic:equal>
<logic:equal name="sessionType" value="MOVER">
<h3 class="title"><bean:message key="ndmp.session.title.type.mover"/></h3>
</logic:equal>
<logic:equal name="sessionType" value="DATA">
<h3 class="title"><bean:message key="ndmp.session.title.type.data"/></h3>
</logic:equal>
<logic:equal name="sessionType" value="IDLE">
<h3 class="title"><bean:message key="ndmp.session.title.type.unknown"/></h3>
</logic:equal>
<table border="1" class="Vertical">
    <tr>
    <th><bean:message key="ndmp.session.id"/></th>
    <td><bean:write name="ndmpSessionForm" property="sessionDetail.sessionId"/>&nbsp;</td>
    </tr>
    <tr>
        <th><bean:message key="ndmp.session.type.job"/></th>
        <td><bean:write name="ndmpSessionForm" property="sessionDetail.sessionTypeJob"/>&nbsp;</td>
    </tr>
    <logic:equal name="sessionType" value="DATA">
    <tr>
  	<th><bean:message key="ndmp.session.dataStatus"/></th>
  	<td><bean:write name="ndmpSessionForm" property="sessionDetail.dataState"/>&nbsp;</td>
    </tr>
    <tr>
  	<th><bean:message key="ndmp.session.dataIp"/></th>
  	<td><bean:write name="ndmpSessionForm" property="sessionDetail.dataIp"/>&nbsp;</td>
    </tr>
    <tr>
  	<th><bean:message key="ndmp.session.moverIp"/></th>
  	<td><bean:write name="ndmpSessionForm" property="sessionDetail.moverIp"/>&nbsp;</td>
    </tr>
    </logic:equal>
    <logic:equal name="sessionType" value="MOVER">
    <tr>
  	<th><bean:message key="ndmp.session.moverStatus"/></th>
  	<td><bean:write name="ndmpSessionForm" property="sessionDetail.moverState"/>&nbsp;</td>
    </tr>
    <tr>
  	<th><bean:message key="ndmp.session.moverIp"/></th>
  	<td><bean:write name="ndmpSessionForm" property="sessionDetail.moverIp"/>&nbsp;</td>
    </tr>
    <tr>
  	<th><bean:message key="ndmp.session.dataIp"/></th>
  	<td><bean:write name="ndmpSessionForm" property="sessionDetail.dataIp"/>&nbsp;</td>
    </tr>
    </logic:equal>
    <logic:equal name="sessionType" value="LOCAL">
    <tr>
  	<th><bean:message key="ndmp.session.dataStatus"/></th>
  	<td><bean:write name="ndmpSessionForm" property="sessionDetail.dataState"/>&nbsp;</td>
    </tr>
    <tr>
  	<th><bean:message key="ndmp.session.moverStatus"/></th>
  	<td><bean:write name="ndmpSessionForm" property="sessionDetail.moverState"/>&nbsp;</td>
    </tr>
    </logic:equal>
    <logic:equal name="sessionType" value="IDLE">
    <tr>
  	<th><bean:message key="ndmp.session.dataStatus"/></th>
  	<td><bean:write name="ndmpSessionForm" property="sessionDetail.dataState"/>&nbsp;</td>
    </tr>
    <tr>
  	<th><bean:message key="ndmp.session.moverStatus"/></th>
  	<td><bean:write name="ndmpSessionForm" property="sessionDetail.moverState"/>&nbsp;</td>
    </tr>
    </logic:equal>
    <tr>
  	<th><bean:message key="ndmp.session.finishData2"/></th>
  	<td><bean:write name="ndmpSessionForm" property="sessionDetail.bytesTxferred"/>&nbsp;</td>
    </tr>
    <tr>
  	<th><bean:message key="ndmp.session.transRate"/></th>
  	<td><bean:write name="ndmpSessionForm" property="sessionDetail.currentThruput"/>&nbsp;</td>
    </tr>
    <tr>
  	<th><bean:message key="ndmp.session.startTime"/></th>
  	<td><bean:write name="ndmpSessionForm" property="sessionDetail.startTime"/>&nbsp;</td>
    </tr>
    <tr>
  	<th><bean:message key="ndmp.session.dma"/></th>
  	<td><bean:write name="ndmpSessionForm" property="sessionDetail.dmaIp"/>&nbsp;</td>
    </tr>
    <logic:notEmpty name="ndmpSessionForm" property="sessionDetail.scsiDevice">
    <tr>
  	<th><bean:message key="ndmp.session.scsiDeviceName"/></th>
  	<td><bean:write  name="ndmpSessionForm" property="sessionDetail.scsiDevice"/>&nbsp;</td>
    </tr>
    </logic:notEmpty>
    <logic:notEmpty name="ndmpSessionForm" property="sessionDetail.tapeDevice">
    <tr>
  	<th><bean:message key="ndmp.session.tapeDeviceName"/></th>
  	<td><bean:write name="ndmpSessionForm" property="sessionDetail.tapeDevice"/>&nbsp;</td>
    </tr>
    </logic:notEmpty>
    <logic:notEmpty name="ndmpSessionForm" property="sessionDetail.tapeOpenMode">
    <tr>
  	<th><bean:message key="ndmp.session.tapeOpenMode"/></th>
  	<td><bean:write name="ndmpSessionForm" property="sessionDetail.tapeOpenMode"/>&nbsp;</td>
    </tr>
    </logic:notEmpty>
</table>
</body>
</html:html>