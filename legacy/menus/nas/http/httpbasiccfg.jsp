<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: httpbasiccfg.jsp,v 1.2302 2004/08/18 03:51:57 xingh Exp" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java" %>
<%@ page import="com.nec.sydney.beans.base.*,
                 com.nec.sydney.framework.*,
                 com.nec.sydney.beans.http.*,
                 com.nec.sydney.atom.admin.base.*,
                 com.nec.sydney.atom.admin.http.* " %>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>

<%@ taglib prefix="nshtml" uri="nshtml-taglib" %>
<jsp:useBean id="basicInfo" class="com.nec.sydney.beans.http.HTTPBasicCfgBean" scope="page"/>
<jsp:setProperty name="basicInfo" property="*" />
<%AbstractJSPBean _abstractJSPBean = basicInfo; %>
<%@include file="../../common/includeheader.jsp" %>

<html>
<%  HTTPBasicInfo theBasicInfo = basicInfo.getHTTPBasicInfo() ;
    boolean oldServiceStatus = theBasicInfo.getServiceStatus() ;
    String strTemp = "000.000.000.000:00000" ;
%>
<head>
<%@include file="../../../menu/common/meta.jsp" %>
<jsp:include page="../../../menu/common/wait.jsp"/>
<%@include file="httpcommon.js" %>
<title>HTTP Basic Settings</title>

<script language="JavaScript">

//start usedPort string
//modified by zhangjx
var usedPort = "<%=theBasicInfo.getUsedPort()%>";
var usedPortAry = usedPort.split(" ");
//end
    function readyPage() {
        var selPorts = document.basicForm.selPorts ;
        if (selPorts.options[selPorts.length-1].text=="<%=strTemp%>") {
            selPorts.options[selPorts.length-1] = null ;
        }

        checkDelete() ;
    }

    function checkDelete() {
        if (document.basicForm.selPorts.options && document.basicForm.selPorts.length >= 2) {
            document.basicForm.portDelete.disabled= false;
        } else {
            document.basicForm.portDelete.disabled=true ;
        }
    }

    function checkOperation() {
        if (document.forms[0].operation.value=="") {
            return false ;
        } else {
            return true ;
        }
    }

    function appendPort() {
        var newPort = gInputTrim(document.basicForm.newPortNumber.value) ;
        if (newPort=="") {
                alert("<nsgui:message key="nas_http/alert/input_port"/>") ;
                document.basicForm.newPortNumber.focus() ;
                return false;
        } else {
            var selPorts = document.basicForm.selPorts ;
            for (var i=0;i<selPorts.length;i++) {
                if (selPorts.options[i].value==newPort) {
                    alert("<nsgui:message key="nas_http/alert/port_exist"/>" + "\n"
                            +"<nsgui:message key="nas_http/alert/input_other_port"/>") ;
                    document.basicForm.newPortNumber.focus() ;
                    return false;
                }
            }
            
            if (checkPort(document.basicForm.newPortNumber)
                && checkPortUse(usedPortAry,document.basicForm.newPortNumber, "basic")) {                
                selPorts.options[selPorts.length] = new Option (newPort, newPort, false, true) ;
                selPorts.options[selPorts.length-1].selected=true;
                document.basicForm.newPortNumber.value = "";
                checkDelete() ;
                return true ;
            }
        }
    }

    function deletePort() {
        var selPorts = document.basicForm.selPorts ;
        var index = selPorts.selectedIndex ;
        if (index >= 0) {
            selPorts.options[index] = null ;
            if (index==selPorts.length) {
                selPorts.options[index-1].selected=true ;
            } else {
                selPorts.options[index].selected=true ;
            }
            checkDelete() ;
        } else {
            alert("<nsgui:message key="nas_http/alert/select_port"/>") ;
            selPorts.focus() ;
        }
    }

    function setBasicInfo() {
        if (isSubmitted()) {
            var selPorts = document.basicForm.selPorts ;
            var thePorts = selPorts.options[0].value ;
            for (var i=1;i<selPorts.length;i++) {
                thePorts += " " + selPorts.options[i].value ;
            }
            document.basicForm.ports.value = thePorts ;
            document.basicForm.operation.value="send";
            //document.basicForm.submit();
            setSubmitted();
            return true;
        }
        return false;
    }
</script>
</head>

<body onLoad="readyPage()">
<h1><nsgui:message key="nas_http/common/h1"/></h1>
<h2><nsgui:message key="nas_http/basic/h2"/></h2>

<% String forwardJsp = response.encodeURL("../../../menu/common/forward.jsp"); %>
<nshtml:form name="basicForm" method="post" onsubmit="if (setBasicInfo()){return true;} else{ return false;}" action="<%=forwardJsp%>" >
<input type="button" name="goBack" value="<nsgui:message key="common/button/back"/>" onClick="window.location='<%= response.encodeURL("httpinfo.jsp?infoLocation=tmp") %>'">
<br><br>

<input type="hidden" name="operation" value="">
<input type="hidden" name="beanClass" value="<%=basicInfo.getClass().getName()%>">
<input type="hidden" name="alertFlag" value="enable">

<input type="hidden" name="ports" value="">

<table border="1" width="560">
<tr>
    <th width="170" align="left"><nsgui:message key="nas_http/basic/th_service"/></th>
    <td width="385"><input id="serviceStatus0" type="checkbox" name="serviceStatus" <% if (oldServiceStatus) out.print("checked"); %> value="true">
        <label for="serviceStatus0"><nsgui:message key="nas_http/basic/th_use"/></label>
    </td>
</tr>
<tr>
    <th align="left"><nsgui:message key="nas_http/basic/th_port"/></th>
    <td width="385">
        <table border="0" width="385">
        <tr>
            <td rowspan="2" width="165">
                <select name="selPorts" size="6" style="width: 165">
                 <% String[] portNumbers = (theBasicInfo.getPorts()).split(" ") ;
                    for (int i=0;i<portNumbers.length;i++) { %>
                        <option value="<%=portNumbers[i]%>"><%=portNumbers[i]%></option>
                 <% } %>
                    <option><%=strTemp%>
                </select>
            </td>
            <td nowrap width="215">
                <input type="button" name="append" value="&lt;&lt;<nsgui:message key="common/button/add"/>"
                        onClick="return appendPort()" >&nbsp;
                <input type="text" name="newPortNumber" value="" size="25" maxlength="21" onFocus="this.select()" >
            </td>
        </tr>
        <tr>
            <td>
                <% String btnDel = NSMessageDriver.getInstance().getMessage(session,"common/button/delete") + ">>" ; %>
                <nshtml:button name="portDelete" value="<%=btnDel%>" onclick="deletePort()" />
            </td>
        </tr>
        </table>
    </td>
</tr>
<tr>
    <td colspan="2"><%= theBasicInfo.getSelectableFunctions() %></td>
</tr>
<tr>
    <td colspan="2"><%= theBasicInfo.getDefaultOptions() %></td>
</tr>
</table>
<br>

<input type="submit" name="send" value="<nsgui:message key="common/button/submit"/>"
        onclick="">

</nshtml:form>
</body>
</html>