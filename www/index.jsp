<!--
        Copyright (c) 2005-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: index.jsp,v 1.3 2007/06/25 01:31:53 liul Exp $" -->

<link rel="stylesheet" href="/nsadmin/lib/default.css" type="text/css">
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ page import="java.io.*" %>
<%! File flag_File = new File( "/opt/nec/nsadmin/.wait_sanity" );  %>

<%
boolean waitFlag = false;

if ( flag_File.exists() ){
  waitFlag = true;
}
%>

<html>
<head>
<title>
</title>
<script>
<!--
var timer = "10000";
var actionWin;
var winName = new String(window.location.hostname);
winName = "win" + winName;
winName = winName.replace(/[^a-zA-Z0-9_]/g,"_");

function openOperationWin(){
  if (actionWin != null && !actionWin.closed){
    actionWin.focus();
  }else{
    var hori;
    var verti;
    if(navigator.appName.indexOf("Microsoft") != -1){
      hori = document.body.clientWidth;
      verti = document.body.clientHeight;
    }else{
      hori = window.innerWidth;
      verti = window.innerHeight;
    }

    actionWin = window.open('/nsadmin/login.jsp',winName,'width='+hori+',height='+verti+',left=0,top=0,fullscreen=0,scrollbars=1,resizable=1,status=1,menubar=0,toolbar=0,addressbar=0');

    if(actionWin != null){
      actionWin.focus();
    }
  }
}


function cleanSon(){
  if (actionWin != null && !actionWin.closed){
    actionWin.opener = null;
  }
}

function ReloadAddr(){
	window.location.reload();
}

<%if(waitFlag){%>
  setTimeout(ReloadAddr, timer);
<%}%>

-->
</script>

<meta http-equiv="Pragma" content="no-cache">
</head>

<%if(waitFlag){%>

<body>
<center>
  <table>
    <tr>
      <td>
        <bean:message bundle="common" key="common.mess.tomcatwait" />
      </td>
    </tr>
  </table>
</center>

<%}else{%>

<body onLoad="openOperationWin();" onUnload="cleanSon();">
<form name="indexForm"></form>
<center>
<table border="1" bordercolor="black" cellspacing="1">
	<tr><td>
	<a href="#" onClick="openOperationWin(); return false;">
	<image src="images/nation/index_new.gif" alt="Open login window" align="middle" border="0">
	</a></td></tr>
</table>
<table align="center" class="Login">
	<tr><td>
	<a href="#" onClick="openOperationWin(); return false;">
	<font size="2" color="#0000ff"><p><bean:message bundle="common" key="common.index.openlogin" /></p></font>
	</a></td></tr>
</table>
</center>

<%}%>

</body>
</html>

