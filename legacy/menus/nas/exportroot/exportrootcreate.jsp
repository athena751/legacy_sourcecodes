<!--
        Copyright (c) 2001-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: exportrootcreate.jsp,v 1.7 2007/06/28 01:32:45 wanghb Exp $" -->
<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java" import="java.util.*
                    ,com.nec.sydney.beans.exportroot.ExportRootBean
            	    ,com.nec.sydney.framework.*
                    ,com.nec.sydney.beans.base.AbstractJSPBean
                    ,com.nec.sydney.atom.admin.base.*
                    ,com.nec.nsgui.model.entity.framework.FrameworkConst"%>

<%@ taglib uri="taglib-nsgui" prefix="nsgui" %> 
<jsp:useBean id="exportRootCreateBean" class="com.nec.sydney.beans.exportroot.ExportRootCreateBean" scope="page"/>
<%AbstractJSPBean _abstractJSPBean =exportRootCreateBean; %>
<%@include file="../../../menu/common/includeheader.jsp" %>
<HTML>
<HEAD>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<script src="../common/general.js"></script>
<!-- for displaying the waitting page -->
<jsp:include page="../../common/wait.jsp" /> 

<script language="JavaScript">
    function onAddExportRoot(){
        document.createForm.exportGroupName.value = trim(document.createForm.exportGroupName.value);
	var ername = document.createForm.exportGroupName.value;
        if(checkName(ername)){
            alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
                   +<nsgui:message key="nas_exportroot/alert/invalidexport" firstReplace="ername" separate="true"/>
            );
            return false;
        }else {
            var codePage = document.createForm.codePage[document.createForm.codePage.selectedIndex].text;
            if(isSubmitted() 
                && confirm ("<nsgui:message key="common/confirm"/>"+ "\r\n"
                             + "<nsgui:message key="common/confirm/act"/>"
                             + "<nsgui:message key="common/button/submit"/>" + "\r\n"
                             + <nsgui:message key="nas_exportroot/alert/confrim_add" 
                                    firstReplace="ername" separate="true"/>
			                 + "\r\n" + "<nsgui:message key="nas_exportroot/exportroot/th_codepage"/>"
			                 + " : " + codePage) ) {
                setSubmitted();
                return true;
            }
            return false;
        }
    }

    function checkName(str){
        if (str == ""){
             return true;
         }
        var valid = /[^0-9a-zA-Z_]/g;
        var flag=str.search(valid);
        if(flag!=-1){
            return true;
        }else{
            return false;
        }  
    }
    
    function onBack(){
        window.location = "<%=response.encodeURL("exportRoot.jsp")%>";
        return false;
    }
</script>
</HEAD>
<BODY onload="displayAlert();">
<h1 class="title"><nsgui:message key="nas_exportroot/exportroot/h1"/></h1>
<form  method="post" name="createForm" action="../../common/forward.jsp" 
        onsubmit="return onAddExportRoot()">
    <input type="hidden" name="operation" value="set">
    <input type="hidden" name="alertFlag" value="enable">
    <input type="hidden" name="beanClass" value="<%=exportRootCreateBean.getClass().getName()%>">
    <input type="button" name="btnBack" value="<nsgui:message key="common/button/back"/>" onclick="return onBack();">
<h2 class="title"><nsgui:message key="nas_exportroot/exportroot/h2_create"/></h2> 
    <table border="1">
        <tr>
            <th align="left"><nsgui:message key="nas_exportroot/exportroot/th_path"/></th>
            <td><input type="text" name="exportGroupName" value="<%=exportRootCreateBean.getHostName()%>" maxlength="15"></td>
        </tr>
        <tr>
            <th align="left"><nsgui:message key="nas_exportroot/exportroot/th_codepage"/></th>
            <td>
            <select name="codePage">
                <option value="UTF8-NFC" selected><nsgui:message key="nas_exportroot/exportroot/radio_utf_nfc"/></option>
                    <% String machine = (String) session.getAttribute(FrameworkConst.SESSION_MACHINE_SERIES);
                       if (machine.equals(FrameworkConst.MACHINE_SERIES_CALLISTO)){%>
                        <option value="UTF-8"><nsgui:message key="nas_exportroot/exportroot/radio_utf"/></option>
                    <%}else{%>
                        <option value="UTF-8"><nsgui:message key="nas_exportroot/exportroot/radio_utf_mac"/></option>
                    <%}%>
                <option value="EUC-JP"><nsgui:message key="nas_exportroot/exportroot/radio_euc"/></option>
                <option value="SJIS"><nsgui:message key="nas_exportroot/exportroot/radio_sjis"/></option>
                <option value="English"><nsgui:message key="nas_exportroot/exportroot/radio_english"/></option>
            </select>
            </td>
        </tr>
    </table>
    <br>
    <table border="0">
        <tr>
        <td><nsgui:message key="nas_exportroot/exportroot/encoding_notes"/></td>
        </tr>
    </table>
    <br>
    <input type="submit" name="formAct" value="<nsgui:message key="common/button/submit"/>">

</form>

</BODY>
</HTML>

