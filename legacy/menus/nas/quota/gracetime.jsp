<!--
        Copyright (c) 2001-2006 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: gracetime.jsp,v 1.2307 2006/11/27 06:19:57 zhangjun Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java"  import="com.nec.sydney.atom.admin.base.*,java.util.*"%>
<%@ page import="com.nec.sydney.framework.*" %>
<%@ page import="com.nec.sydney.beans.base.*"%>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>

<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<jsp:useBean id="setTimeBean" class="com.nec.sydney.beans.quota.GraceTimeLimitSetBean" scope="page"/>
<%AbstractJSPBean _abstractJSPBean = setTimeBean; %>
<%@include file="../../../menu/common/includeheader.jsp" %>

<%
    Vector graceTime = setTimeBean.getGraceTime();
    String usrBlock = (String)graceTime.get(0);
    String usrInode = (String)graceTime.get(1);
    String grpBlock = (String)graceTime.get(2);
    String grpInode = (String)graceTime.get(3);
    boolean isNsview = NSActionUtil.isNsview(request);
%>


<html>
<head>
<script src="../common/general.js"></script>
<jsp:include page="../../common/wait.jsp" />
<script language="JavaScript">
<%if(!isNsview){%>
function onSet()
{
    if((Check(document.forms[0].userblock.value)==false)||(Check(document.forms[0].userfile.value)==false)
        || (Check(document.forms[0].groupblock.value)==false)||(Check(document.forms[0].groupfile.value)==false))
    {
        alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="nas_quota/alert/grace_2"/>" );
        return false;
    }
    var confMsg = "<nsgui:message key="common/confirm" />" + "\r\n" + "<nsgui:message key="common/confirm/act" />" 
                  + "<nsgui:message key="nas_quota/quotasettop/href_4"/>" + "\r\n"
                  + "<nsgui:message key="nas_quota/quotasetbottom/td_user" />" + " " 
                  + "<nsgui:message key="nas_quota/gracetime/th_grace"/>" + " : " 
                  + document.forms[0].userblock.value + "<nsgui:message key="nas_quota/gracetime/text_days"/>"+"\r\n"
                  + "<nsgui:message key="nas_quota/quotasetbottom/td_user" />" + " " 
                  + "<nsgui:message key="nas_quota/gracetime/text_limit"/>" + " : " 
                  + document.forms[0].userfile.value + "<nsgui:message key="nas_quota/gracetime/text_days"/>"+ "\r\n"
                  + "<nsgui:message key="nas_quota/quotasetbottom/td_group" />" + " " 
                  + "<nsgui:message key="nas_quota/gracetime/th_grace"/>" + " : " 
                  + document.forms[0].groupblock.value + "<nsgui:message key="nas_quota/gracetime/text_days"/>"+ "\r\n"
                  + "<nsgui:message key="nas_quota/quotasetbottom/td_group" />" + " " 
                  + "<nsgui:message key="nas_quota/gracetime/text_limit"/>" + " : " 
                  + document.forms[0].groupfile.value + "<nsgui:message key="nas_quota/gracetime/text_days"/>";
                  
    if(isSubmitted() && confirm(confMsg))
    {
        setSubmitted();
        window.location="<%=response.encodeURL("setgracetime.jsp")%>?"
                        +"userblock="+URLEncoder(document.forms[0].userblock.value)
                        +"&userfile="+URLEncoder(document.forms[0].userfile.value)
                        +"&groupblock="+URLEncoder(document.forms[0].groupblock.value)
                        +"&groupfile="+URLEncoder(document.forms[0].groupfile.value)
                        +"&act=set";
        return true;
    }
}
function Check(str)
{
   if (str == "")
     return false;  
   var avail = /[^0-9]/g;
   ifFind = str.search(avail);
    if(ifFind!=-1)
    return false;
   if((str < 1)||(str > 10950)){
        return false
   }else{return true}         
}
<%}%>
</script>
<title>Set Grace Limit Time</title>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=EUC-JP">
</head>
<body onload="displayAlert()">
<form name="gracetimeform" method="post" action="">
    <h2 class="title"><nsgui:message key="nas_quota/quotasettop/href_4"/></h2>

<table width ="100%" border="1">
    <tr>
        <th colspan="2"><nsgui:message key="nas_quota/quotasetbottom/td_user" /> </th>
        <th colspan="2"><nsgui:message key="nas_quota/quotasetbottom/td_group" /> </th>
    </tr>    
<%if(isNsview){%>
    <tr>
        <th><nsgui:message key="nas_quota/gracetime/th_grace"/> </th>
        <th><nsgui:message key="nas_quota/gracetime/text_limit"/> </th>
        <th><nsgui:message key="nas_quota/gracetime/th_grace"/> </th>
        <th><nsgui:message key="nas_quota/gracetime/text_limit"/> </th>
    </tr>
    <tr>
        <td>
            <%=usrBlock%>
            <nsgui:message key="nas_quota/gracetime/text_days"/>
        </td>
        <td>
            <%=usrInode%>
            <nsgui:message key="nas_quota/gracetime/text_days"/>
        </td>
        <td>
            <%=grpBlock%>
            <nsgui:message key="nas_quota/gracetime/text_days"/>
        </td>
        <td>
            <%=grpInode%>
            <nsgui:message key="nas_quota/gracetime/text_days"/>
        </td>
    </tr>
<%}else{%>
    <tr>
        <th align="left"><nsgui:message key="nas_quota/gracetime/th_grace"/> </th>
        <th align="left"><nsgui:message key="nas_quota/gracetime/text_limit"/> </th>
        <th align="left"><nsgui:message key="nas_quota/gracetime/th_grace"/> </th>
        <th align="left"><nsgui:message key="nas_quota/gracetime/text_limit"/> </th>
    </tr>
    <tr>
        <td><input type="text" name="userblock" size="15" value="<%=usrBlock%>" maxlength="5">
            <nsgui:message key="nas_quota/gracetime/text_days"/>
        </td>
        <td><input type="text" name="userfile" size="15" value="<%=usrInode%>" maxlength="5">
            <nsgui:message key="nas_quota/gracetime/text_days"/>
        </td>
        <td><input type="text" name="groupblock" size="15" value="<%=grpBlock%>" maxlength="5">
            <nsgui:message key="nas_quota/gracetime/text_days"/>
        </td>
        <td><input type="text" name="groupfile" size="15" value="<%=grpInode%>" maxlength="5">
            <nsgui:message key="nas_quota/gracetime/text_days"/>
        </td>
    </tr>
<%}%>

</table>
<br>

<%if(!isNsview){%>
    <input type="button" name="set" value="<nsgui:message key="common/button/submit"/>" onClick="onSet()">
<%}%>

<input type="hidden" name="alertFlag" value="enable">
<input type="hidden" name="pageFlag" value="graceperiod">
</form>

</body>
</html>

