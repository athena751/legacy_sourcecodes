<!--
        Copyright (c) 2004-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: volumebatchresult.jsp,v 1.6 2007/05/09 05:18:47 liuyq Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*,com.nec.nsgui.action.base.*,
                 com.nec.nsgui.model.entity.volume.*,
                 com.nec.nsgui.action.volume.VolumeActionConst,
                 org.apache.struts.action.*,java.io.*" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>

<html:html lang="true">
<head>
<%@ include file="../../common/head.jsp" %>
<logic:equal scope="application" name="<%=VolumeActionConst.APPLICATION_VOLUME_PROCESS%>" value="msg.create.status.start" >
    <meta http-equiv="refresh" content="4;url=volumeBatchCreate.do?operation=result">
</logic:equal>
<script language="JavaScript">
function init(){
    <logic:notEmpty name="fromVolumeList" scope="request">
        <%if(!NSActionUtil.isCluster(request) || NSActionUtil.isOneNodeSirius(request)){%>
        alert("<bean:message key="alert.batchcreate.running.single" />");
        <%}else{%>
        <%String nodeNum = (String)application.getAttribute(VolumeActionConst.VOLUME_BATCH_CREATE_NODE_NUM);%>
        alert("<bean:message key="alert.batchcreate.running.cluster" arg0="<%=nodeNum%>"/>");
        <%}%>
    </logic:notEmpty>
}
</script>
</head>
<body onload="init()">
    <form>
    <h1><bean:message key="title.h1"/></h1>
    <h2><bean:message key="title.batchcreateshow.h2"/></h2>
    <h3><bean:message scope="application" name="<%=VolumeActionConst.APPLICATION_VOLUME_CREATE_RESULT_H3%>" /></h3>
    <bean:message scope="application" name="<%=VolumeActionConst.APPLICATION_VOLUME_PROCESS%>"/>
    <br>
    <%
    String[] tips = application.getAttribute(VolumeActionConst.APPLICATION_VOLUME_TIP).toString().split("\\s+");
    if(tips.length == 1){
    %>
    <logic:equal scope="application" name="<%=VolumeActionConst.APPLICATION_VOLUME_PROCESS%>" value="msg.create.status.start" >
    <bean:message key="<%=tips[0]%>" />
    </logic:equal>
    <%}else{
     String arg0 = tips[1];
    %>
    <bean:message key="<%=tips[0]%>" arg0="<%=arg0%>"/>
    <%}%>
    <br>
    <br>
    <table border=1>
        <tr>
        <%boolean isNasHead = NSActionUtil.isNashead(request);%>
        <%if(isNasHead) {%>
            <th><bean:message key="info.mountpoint"/></th>
            <th><bean:message key="info.storage"/></th>
            <th><bean:message key="info.lun"/></th>
            <th><bean:message key="msg.batch.volume"/></th>
        <%} else {%>
            <th><bean:message key="msg.batch.volume"/></th>
            <th><bean:message key="info.mountpoint"/></th>
        <%} %>
        <th><bean:message key="info.status"/></th>
        </tr>
        <logic:iterate id="volume" name="<%=VolumeActionConst.APPLICATION_VOLUME_VOLUMEINFO%>" scope="application" indexId="i" type="com.nec.nsgui.model.entity.volume.VolumeInfoBean">
            <tr>
        <%if(isNasHead) {%>
            <td><bean:write name="volume" property="mountPoint" /></td>
            <td><%=isNasHead?volume.getStorage():volume.getPoolName()%></td>
            <td><%=isNasHead?volume.getLunDisplay():volume.getPoolNo()%></td>
            <td><%=volume.getVolumeName().replaceFirst("NV_LVM_", "")%></td>
        <%} else {%>
            <td><%=volume.getVolumeName().replaceFirst("NV_LVM_", "")%></td>
            <td><bean:write name="volume" property="mountPoint" /></td>
        <%} %>       
            <td>
            <logic:notEmpty name="volume" property="status" >
                <%if(volume.getStatus().equals("msg.volume.status.success")){%>
                    <font color="blue">
                        <bean:message name="volume" property="status"/>
                    </font>
                <%}else if(volume.getStatus().equals("msg.volume.status.processing")){%>
                    <bean:message name="volume" property="status"/>
                <%}else{%>
                    <font color="red">
                        <bean:message name="volume" property="status"/>
                    </font>
                <%}%>
            </logic:notEmpty>
            <logic:empty name="volume" property="status" >
                &nbsp;
            </logic:empty>
            </td>
            </tr>
        </logic:iterate>
        
    </table>
    <br>
    <logic:notEqual scope="application" name="<%=VolumeActionConst.APPLICATION_VOLUME_PROCESS%>" value="msg.create.status.start" >
        <input type=button 
               name="back"
               value="<bean:message key="common.button.back" bundle="common"/>" 
               onclick="window.location='/nsadmin/volume/volumeList.do'"/>
        <%application.removeAttribute(VolumeActionConst.APPLICATION_VOLUME_VOLUMEINFO);%>
        <%application.removeAttribute(VolumeActionConst.APPLICATION_VOLUME_CREATE_RESULT_H3);%>
        <%application.removeAttribute(VolumeActionConst.APPLICATION_VOLUME_TIP);%>
        <%application.removeAttribute(VolumeActionConst.VOLUME_BATCH_CREATE_NODE_NUM);%>
        <%application.removeAttribute(VolumeActionConst.APPLICATION_VOLUME_PROCESS);%>               
    </logic:notEqual>
    </form>
</body>
</html:html>


