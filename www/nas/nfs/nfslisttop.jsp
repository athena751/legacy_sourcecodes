<!--
        Copyright (c) 2001-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: nfslisttop.jsp,v 1.14 2007/05/09 06:08:46 caows Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %> 
<%@ page import="com.nec.nsgui.taglib.nssorttab.*,java.util.*"%>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-html" prefix="html" %>
<%@ taglib uri="struts-logic" prefix="logic" %>
<%@ taglib uri="struts-nested" prefix="nested" %>
<%@ taglib uri="taglib-sorttable" prefix="nssorttab" %>
<%@ taglib uri="nsgui-displayerror" prefix="displayerror" %>

<html:html lang="true">
<head>
<title><bean:message key="title"/></title>
<%@include file="../../common/head.jsp" %>
<html:base/>
<script language="JavaScript" src="../../common/common.js"></script>
<script language="javascript">
var loaded = 0;
function init() {
    loaded = 1;
    <logic:empty name="entryList" scope="request">
        if(parent.frames[1].loaded){
            parent.frames[1].document.forms[0].detail.disabled=1;
            parent.frames[1].document.forms[0].modify.disabled=1;
            parent.frames[1].document.forms[0].deleteEntry.disabled=1;
        }   
    </logic:empty>
 
    <logic:notEmpty name="entryList" scope="request">
        if(parent.frames[1].loaded){
            parent.frames[1].document.forms[0].detail.disabled=0;
            parent.frames[1].document.forms[0].modify.disabled=0;
            parent.frames[1].document.forms[0].deleteEntry.disabled=0;
        }
    </logic:notEmpty>
    if(document.forms[0].entryRadio != null && document.forms[0].entryRadio != undefined){
        var dirAndIsNormal;
        if(document.forms[0].entryRadio[0] != null && document.forms[0].entryRadio != undefined){
            for(var i = 0 ; i < document.forms[0].entryRadio.length; i++){
                if(document.forms[0].entryRadio[i].checked == true){
                    dirAndIsNormal = document.forms[0].entryRadio[i].value.split("#"); 
                    break;
                }
            }
        }else{
            dirAndIsNormal = document.forms[0].entryRadio.value.split("#");
        }
        document.forms[0].selectedDir.value = dirAndIsNormal[0];
        document.forms[0].isNormal.value = dirAndIsNormal[1];
    }
}

function onSelect(selectedDir,isNormal) {
    document.forms[0].isNormal.value = isNormal;
    document.forms[0].selectedDir.value = selectedDir;
}

function onAdd(){
    if (isSubmitted()){
        return false;
    }
    setSubmitted();
    parent.location="<html:rewrite page='/nfsDetail.do?opType=add'/>";
}

function reloadPage(){
    if (isSubmitted()){
        return false;
    }
    setSubmitted();
    window.location="<html:rewrite page='/nfsListTop.do?operation=display'/>";
}
</script>
<html:base/>
</head>
<body onload="init();displayAlert();setHelpAnchor('network_nfs_1');" onUnload="closeDetailErrorWin()">
<html:form action="nfsListTop.do?operation=delete" target="_parent">
<input type="button" name="refresh" value="<bean:message key="common.button.reload" bundle="common"/>" onclick="reloadPage()"/>
&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" name="add" value="<bean:message key="common.button.add2" bundle="common"/>" onclick="onAdd()"/>
<br>
<displayerror:error h1_key="title.nfs"/>
<br>
<logic:empty name="entryList" scope="request">
  <bean:message key="list.noexports"/>
</logic:empty>
<logic:notEmpty name="entryList" scope="request">
  <input type="hidden" name="isNormal"/>
  <input type="hidden" name="selectedDir"/>
  <bean:define id="entryList" name="entryList" scope="request"/>
  <nssorttab:table  tablemodel="<%=new ListSTModel((Vector)entryList)%>" 
                      id="list1"
                      table="border=1" 
                      sortonload="directory:ascend" >
                      
            <nssorttab:column name="entryRadio" 
                              th="STHeaderRender" 
                              td="com.nec.nsgui.action.nfs.NfsTRadioRender"
                              sortable="no">

            </nssorttab:column>
            <nssorttab:column name="directory" 
                              th="STHeaderRender" 
                              td="com.nec.nsgui.action.nfs.NfsDirTDataRender"
                              sortable="yes">
               <bean:message key="table.directory"/>
            </nssorttab:column>
            
            <nssorttab:column name="clientoption" 
                              th="com.nec.nsgui.action.nfs.NfsClientTHeaderRender" 
                              td="com.nec.nsgui.action.nfs.NfsClientTDataRender"
                              sortable="no">
               <bean:message key="table.client"/>,<bean:message key="table.option"/> 
            </nssorttab:column>
        </nssorttab:table>
  
</logic:notEmpty>
</html:form>
</body>
</html:html>