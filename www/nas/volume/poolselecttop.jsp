<!--
        Copyright (c)2005-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY
 
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: poolselecttop.jsp,v 1.10 2008/04/19 12:38:59 jiangfx Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/displayerror.tld" prefix="displayerror" %>
<%@ page import="java.util.Vector"%>

<bean:parameter id="from" name="from" value="volumeCreate"/>
<%String title = "title.h1"; //from volume
  if (from.equals("replication")) {
  	title = "replication.h1";
  } else if (from.startsWith("ddr")) {
  	title = "ddr.h1";
  }
%>
<html:html lang="true">
<head>
<%@include file="/common/head.jsp" %>
<script language="JavaScript" src="/nsadmin/common/common.js"></script>
<script language="JavaScript">
<bean:define id="diskArrayVec" name="diskArrayVector" scope="session"/>
var diskArrayPdgArray = new Array(<%=((Vector)diskArrayVec).size()%>);
<logic:iterate id="diskArrayPdg" name="diskArrayPdgMap" indexId="diskNum" scope="session">
    diskArrayPdgArray[<%=diskNum%>] = new Array();
    <logic:notEmpty name="diskArrayPdg" property="value">
        <logic:iterate id="labelValueBean" name="diskArrayPdg" property="value" indexId="pdgNum">
            diskArrayPdgArray[<%=diskNum%>][<%=pdgNum%>] 
                            = new Option("<bean:write name="labelValueBean" property="label"/>",
                                         "<bean:write name="labelValueBean" property="value"/>");
        </logic:iterate>
    </logic:notEmpty>
</logic:iterate>

function changeDiskArray(obj) {
    var index = obj.selectedIndex;
    
    var pdGroupNumber = diskArrayPdgArray[index][0].value;
    document.forms[0].pdGroupNumber.value = pdGroupNumber;
    if(pdGroupNumber == "--"){
        document.forms[0].createPoolBtn.disabled = true;
        document.forms[0].extendPoolBtn.disabled = true;
    } else {
        document.forms[0].createPoolBtn.disabled = false;
        document.forms[0].extendPoolBtn.disabled = false;
    }
}

function createPool() {
    if (isSubmitted()) {
        return false;
    }
    
    
    var index = document.forms[0].aid.selectedIndex;
    var aname = document.forms[0].aid.options[index].text;
    var aid   = document.forms[0].aid.options[index].value;
    
    var pdGroupNumber = document.forms[0].pdGroupNumber.value;

    window.parent.location = "/nsadmin/disk/bindpooldisplay.do?diskarrayid=" + aid
                  + "&diskarrayname=" + aname + "&pdgroupnumber=" + pdGroupNumber + "&from=<%=from%>";
    setSubmitted();
    return true;
}

function extendPool() {
    if (isSubmitted()) {
        return false;
    }
    
    
    var index = document.forms[0].aid.selectedIndex;
    var aname = document.forms[0].aid.options[index].text;
    var aid   = document.forms[0].aid.options[index].value;
    
    var pdGroupNumber = document.forms[0].pdGroupNumber.value;

    window.parent.location = "/nsadmin/disk/expandpooldisplay.do?diskarrayid=" + aid
                  + "&diskarrayname=" + aname + "&pdgroupnumber=" + pdGroupNumber + "&from=<%=from%>";
    setSubmitted();
    return true;
}

function init() {
	<%if (from.startsWith("ddr")) {%>
    	document.forms[0].aid.value = parent.window.opener.aid.value;
    <%}%>
	changeDiskArray(document.forms[0].aid);
}
</script>
</head>
<body onload="displayAlert();init();">
    <h1 class="title"><bean:message key="<%=title%>"/></h1>
    <h2 class="title"><bean:message key="pool.h2.createAndExtend"/></h2>
    <displayerror:error h1_key="<%=title%>"/>
    
    <html:form action="/volumePoolSelect.do">
        <table border="1" nowrap>
            <tr>
                <th><bean:message key="pool.th.diskArrayName"/></th>
                <td>
                  <% boolean flagValue = false;
                     if (((String)from).startsWith("ddr")) {
                     	flagValue = true; 
                     } %>
                  	<html:select name="diskArrayInfoForm" property="aid" disabled="<%=flagValue%>" onchange="return changeDiskArray(this)">
                        <html:optionsCollection name="diskArrayVector"/>
                    </html:select>  
                    <html:hidden name="diskArrayInfoForm" property="pdGroupNumber"/>
               </td>
                <td>
                    <html:button property="createPoolBtn" onclick="return createPool();">
                        <bean:message key="btn.poolCreate"/>
                    </html:button>
                    <html:button property="extendPoolBtn" onclick="return extendPool();">
                        <bean:message key="btn.poolExtend"/>
                    </html:button>                    
                </td>
            </tr>
        </table>
    </html:form>
</body>
</html:html>