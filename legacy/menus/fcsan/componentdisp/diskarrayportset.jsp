<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: diskarrayportset.jsp,v 1.2301 2004/07/14 08:42:44 nsadmin Exp $" -->


<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java"  import="com.nec.sydney.beans.base.*,com.nec.sydney.beans.fcsan.common.*,com.nec.sydney.atom.admin.base.*,java.util.*,com.nec.sydney.framework.*" %>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %> 
<jsp:useBean id="setPortNameBean" class="com.nec.sydney.beans.fcsan.componentdisp.PortNameSetBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean = setPortNameBean; %>
<%@include file="../../../menu/common/includeheader.jsp" %>
<HTML>
<%int result=setPortNameBean.getResult();%>

<HEAD>
<%
    if (result==0)
    {
%>
        <TITLE><nsgui:message key="fcsan_common/title/page_title_success"/></TITLE>
<%
    }
    else
    {
%>
        <TITLE><nsgui:message key="fcsan_common/title/page_title_error"/></TITLE>
<%
    }
%>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<script language="JavaScript">
function onOk()
{
   if(<%=result%>==0){
        if(window.opener&&!window.opener.closed)  
        window.opener.close();
   }
   window.close();
}
</script>



</HEAD>
<body>
<form>
<%
  if(result==0){
%> 
  <h1 class="popup"><nsgui:message key="common/alert/done"/></h1>
  <h2 class="popup"><nsgui:message key="fcsan_common/specialmessage/msg_refresh"/></h2>
<%}else{
      int errorCode=setPortNameBean.getErrorCode();%>
     
    <%if(errorCode==-18){%>
            <h1 class="popup"><nsgui:message key="common/alert/failed"/></h1>     
            <h2 class="popup"><nsgui:message key="fcsan_componentdisp/common/errmsg_alreadyexist"/></h2>        
       <%} else if(errorCode==-7 || errorCode==-8 || errorCode==-9 || errorCode==-20 || errorCode==-21 || errorCode==-22 )        {%>
             <h1 class="popup"><nsgui:message key="common/alert/failed"/></h1>
             <h2 class="popup"><nsgui:message key="fcsan_common/specialmessage/h3_specialerrmsg"/></h2>  
       <%} else if(setPortNameBean.setSpecialErrMsg()) {%>    
         <h1 class="popup"><nsgui:message key="common/alert/failed"/></h1>
         <h2 class="popup"><%=setPortNameBean.getErrMsg()%></h2>    
        <%
        }else {
%>
  <h1 class="popupError"><nsgui:message key="common/alert/failed"/></h1>
  <h2 class="popupError"><%=setPortNameBean.getErrMsg()%></h2>
    <%}%> 
    <script>
        if(window.opener&&!window.opener.closed){
            window.opener.document.forms[0].ok.disabled = false;
            window.opener.document.forms[0].cancel.disabled = false;
        }
    </script>
<%}%>
 <center>
    <input type="button" name="Button" value="<nsgui:message key="fcsan_common/button/button_ok"/>" onClick="onOk()">
 </center>
</form>
</body>
</html>
