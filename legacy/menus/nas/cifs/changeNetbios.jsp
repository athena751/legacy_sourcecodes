<!--
        Copyright (c) 2003-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: changeNetbios.jsp,v 1.2306 2007/04/16 05:52:11 wanghb Exp $" -->
<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java" %>
<%@ page import="com.nec.sydney.beans.base.AbstractJSPBean,com.nec.sydney.framework.*" %>
<%@ page import="com.nec.nsgui.action.base.*" %>
<%@ page import="com.nec.nsgui.model.biz.domain.DomainHandler"%>

<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<jsp:useBean id="netbios" class="com.nec.sydney.beans.cifs.ChangeNetbiosBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean = netbios; %>
<%@include file="../../../menu/common/includeheader.jsp" %>
<%@include file="../../../menu/common/meta.jsp" %>
<jsp:include page="../../common/wait.jsp"/>

<script src="../common/general.js"></script>

<html>
<head>
<script language="javascript">
function onSave(){
    nb2upper();
    document.netbiosForm.newNetbios.value = gRTrim(document.netbiosForm.newNetbios.value);
    if (!checkNetbios(document.netbiosForm.newNetbios.value)){
       alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
                   +"<nsgui:message key="nas_cifs/alert/l_d_nb"/>");
       return false;    
    }

    if (!checkHead(document.netbiosForm.newNetbios.value)){
            alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"
                    +"<nsgui:message key="nas_common/alert/deny-"/>");
            return false;
     }

    <%  int groupNumber = NSActionUtil.getCurrentNodeNo(request);
        String[] hostName = DomainHandler.getHostName(groupNumber);
        for (int i=0 ; i<hostName.length ;i++){
            if(hostName[i] != null){%>
                if ( document.netbiosForm.newNetbios.value == "<%=hostName[i]%>"){
                    alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"
                        +"<nsgui:message key="nas_mapd/nt/msg_info_hostname"/>");
                    return false;
                }
        <%}%>
    <%}%>

     if(isSubmitted()&& confirm("<nsgui:message key="common/confirm"/>"+"\r\n"
                +"<nsgui:message key="common/confirm/act"/>"
                +"<nsgui:message key="nas_cifs/changeNetbios/h2_changebios"/>"+"\r\n"
                +<nsgui:message key="nas_cifs/alert/old_netbios_confirm" firstReplace="document.netbiosForm.oldNetbios.value" separate="true"/>+"\r\n"
                +<nsgui:message key="nas_cifs/alert/new_netbios_confirm" firstReplace="document.netbiosForm.newNetbios.value" separate="true"/>)){
               setSubmitted();
               document.netbiosForm.operation.value="set";
                return true;

     }
     return false;     
}

function checkNetbios(str){
    if (str == ""){
        return false;
    }
    var avail =/[^A-Za-z0-9\-]/g;
    ifFind = str.search(avail);
    return (ifFind==-1);
        
}
function checkHead(str){
  if (str.charAt(0) == '-'){
        return false;
   }
  return true; 
}

function deleteConfirm(){
<%  String warn = request.getParameter("warn");
    if ( warn!=null && !warn.equals("") ){  %>
    if (isSubmitted()&& confirm("<nsgui:message key="nas_cifs/alert/changeNetbios_check_withclients"/>")){
        setSubmitted();
        document.netbiosForm.action="<%=response.encodeURL("../../common/forward.jsp?hasWarned=true")%>";
        document.netbiosForm.operation.value="Set";
        document.netbiosForm.submit();
        return true;
    }
<% } %>
    return;
}

function nb2upper(){
        var msg=document.netbiosForm.newNetbios.value.toUpperCase();
        document.netbiosForm.newNetbios.value=msg;
}
function onBack(){
    <%String export=request.getParameter("exportrootname");%>
    window.location="<%=response.encodeRedirectURL("../mapd/userdbdomainconf.jsp")%>?fromWhere=export&dispMode="+" "+"&exportGroup=<%=export%>";
}
</script>
</head>
<body onload="displayAlert();deleteConfirm();setHelpAnchor('export_comname')">

<h1 class="title"><nsgui:message key="nas_mapd/common/h1_setup"/></h1>
<input type="button" name="cancel" onclick="onBack()" value="<nsgui:message key="common/button/back"/>">
<h2 class="title"><nsgui:message key="nas_mapd/nt/h2_changebios"/></h2>
<form name="netbiosForm" method="post" onSubmit="return onSave()" action="<%=response.encodeURL("../../common/forward.jsp")%>">
<input type="hidden" name="operation">
<input type="hidden" name="beanClass" value="<%= netbios.getClass().getName()%>">
<input type="hidden" name="alertFlag" value="enable">
<br>
<table border="1">
    <tr>
    <th align ="left"><nsgui:message key="nas_cifs/configfileselection/td_export"/></th>
        <td><%=netbios.getExportRoot()+"["+netbios.getLocalDomain()+"]"%></td>
    </tr>
         <input type="hidden" name="localDomain" value='<jsp:getProperty name="netbios" property="localDomain"/>'/>
         <input type="hidden" name="exportRoot" value='<jsp:getProperty name="netbios" property="exportRoot"/>'/>
    <tr>
    <th align ="left"><nsgui:message key="nas_cifs/changeNetbios/old_netbios"/></th>
         <td><%=netbios.getOldNetbios()%></td>
    </tr>
         <input type="hidden" name="oldNetbios" value='<jsp:getProperty name="netbios" property="oldNetbios"/>'/>
    <tr>
    <th align ="left"><nsgui:message key="nas_cifs/changeNetbios/new_netbios"/></th>
         <td><input type="text" name="newNetbios" value='<jsp:getProperty name="netbios" property="newNetbios" />'onchange="nb2upper()" maxlength="15"></td>
    </tr>
</table>
<br>
<input type="submit" name="set" value="<nsgui:message key="common/button/submit"/>">
</form>
</body>
</html>
