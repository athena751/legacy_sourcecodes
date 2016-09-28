<!--
        Copyright (c) 2001-2009 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: login.jsp,v 1.9 2009/04/10 09:17:20 liul Exp $" -->

<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ page import="com.nec.sydney.framework.*" %>
<%@ page import="com.nec.nsgui.model.biz.framework.*" %>

<bean:define id="curLang" name="currentLang" scope="request"/>
<%
    NSMessageDriver.getInstance().setCurrentLang((String)curLang);
    String contextPath = request.getContextPath();
    String checkProductName[] = LoginHandler.getInstance().checkProductName();
%>
	
<html:html lang="true">
<head>
<%@include file="/common/head.jsp" %>
<title><bean:message key="myname"/><bean:write name="titleHost"/></title>
<script language="JavaScript">
top.window.focus();
if (top.frames.length!=0){
    top.location=self.document.location;
}
var isSubmit = false;
var winName = new String(window.location.hostname);
winName = "win" + winName;
winName = winName.replace(/[^a-zA-Z0-9_]/g,"_");

function onReload(){
    if( isSubmit ){
        return false;
    }
    isSubmit = true;
    window.location = "<html:rewrite page='/../login.jsp'/>";
    return true;
}
function closeAll(WO) {
    var prevWindow = null;
    var	curWindow = WO;
    var i = 0 ;
    closeWin = new Array();
    prevWindow = curWindow.opener;
    while (prevWindow != null && !prevWindow.closed) {
    	try{
		    if (prevWindow.location != null 
		      && prevWindow.location.href != null
		      && prevWindow.document.indexForm == null) {
		        closeWin[i] = curWindow;
		        curWindow = prevWindow;
		        prevWindow = curWindow.opener;
		        i++;
		    }else {
		        break;
		    }
		}catch(e){
            break;
    	}
	} 
    if (closeWin.length > 0){
        alert("<bean:message key="session.timeout"/>"+"\n"+"<bean:message key="session.closewindow"/>");
    }
    try{
        if(curWindow.name != winName){
            curWindow = curWindow.top;
        }
        if(curWindow.name == winName){
            curWindow.location.href="/nsadmin/framework/loginShow.do";
        }else{
          	curWindow.close();
        }
    }catch(e){
        if(window.name == winName){
        
        }else{
            window.close();
        }    
    }
    for (i=closeWin.length-1; i>=0; i--){
        if (closeWin[i] != null && !closeWin[i].closed){
            closeWin[i].close();
        }
    }
}

var checkvalid;
try{ 
    //check whether the handler of opener is valid.
    checkvalid = (window.opener && !window.opener.closed && window.opener.document.indexForm == null);
}catch(e){
    if(window.name == winName){
        
    }else{
        window.close();
    }
}

if  (checkvalid)  {
    closeAll(window);
}


function check() {
    if(document.loginForm.username.value == "") {
      	alert('<bean:message key="login.error.nousername"/>');
        return false;
    }
    return true
}

function onHelp(){
    if (document.loginForm){
        Help('/nsadmin/help/'+"<bean:write name="currentLang"/>"+'/help.html#login')
    }
}

function Help(url){
    WO = window.open(url, "HELP", "width=800,height=640,resizable=yes,scrollbars=yes");
    WO.focus();
}

function focusUserName(){
  top.window.name = winName;
  var focusControl = document.forms["loginForm"].elements["username"];

  if (focusControl.type != "hidden") {
     focusControl.focus();
  }
}
</script>
</head>
<%if (!checkProductName[0].equals("normal")){ %>
<body>
<table border="0">
    <tr>
    	<td class="ErrorInfo"><img border=0 src="/nsadmin/images/icon/png/icon_alert.png"></td>
        <td class="ErrorInfo"><bean:message key="error.td_error" bundle="errorDisplay"/>&nbsp;&nbsp;</td>
        <td class="ErrorInfo">
            <%if(checkProductName[1].equals("3") || checkProductName[1].equals("11")){ %>
			    <bean:message key="login.checknode.productname.error" arg0="<%=checkProductName[1]%>" />
			    <br/><br/>
			    <%if(!checkProductName[2].equals("")){%>
			        <bean:message key="login.checknode.productname.info" arg0="<%=checkProductName[2]%>" />
			    <%}else{%>
			        <bean:message key="login.checknode.productname.noinfo"/>
			    <%}%>
			<%}else{%>
			    <bean:message key="login.checknode.other.error" arg0="<%=checkProductName[1]%>" />
			<%}%>
        </td>
     </tr>
</table>
<br><br>
&nbsp;&nbsp;
<input type="button" onclick="onReload()"
       value="<bean:message key="common.button.reload" bundle="common"/>"/>
</body>
<%}else{%>
<body class="Login" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onload="focusUserName();"
onUnload="if((window.opener!=null) && !isSubmit) { try{window.opener.focus();}catch(e){}}">
<center>

<html:form action="login.do" onsubmit="if(isSubmit==true) return false; isSubmit = true;" >
    <input type="hidden" name="originalURI" value="<bean:write name="originalURI" scope="request"/>"/>
    <input type="hidden" name="currentLang" value="<bean:write name="currentLang" scope="request"/>"/>
    
	<table border="0" cellspacing="0" cellpadding="2" class="Login">
    <tr>
		<br><br><br><br><br>
		<td colspan="2">
	        <img src="<%=contextPath%>/images/nation/new_logo_login.gif" alt="<bean:message key="myname"/>"></td>
	</tr>

	<tr>
		<td align="right" nowrap>
			<bean:message key="login.username"/>
			<img src="<%=contextPath%>/images/nation/arrow.gif" width="12" height="11" align="middle" hspace="5" alt="&gt"/>
		</td>
		<td><html:text property="username" size="16"/></td>
	</tr>
	<tr>
		<td align="right" nowrap>
			<bean:message key="login.password"/>
			<img src="<%=contextPath%>/images/nation/arrow.gif" width="12" height="11" align="middle" hspace="5" alt="&gt"/>
		</td>
		<td>
			<!--<html:password property="_password" size="16"/>-->
			<input type="password" name="_password" size="16" value="">
		</td>
	</tr>
	<tr align="bottom" height="40">
		<td>&nbsp;</td>
        <td>
	        <input type="image"  border="0" onClick="return check();" src="<%=contextPath%>/images/nation/btn_login.gif" 
		        alt="<bean:message key="login.submit"/>">
	        &nbsp;&nbsp;
            <input type="image"  border="0" onClick="onHelp(); return false;" src="<%=contextPath%>/images/nation/btn_help.gif" 
		        alt="<bean:message key="button.help.tip"/>">
		</td>
	</tr>
    </table>

</html:form>
</center>

<hr>
<center>
<table border="0" class="Login">
<form name = "notice">
<tr>
<td>
    <h1><bean:message key="login.notice.environment"/></h1>
    <center>
    <table border="1">
	    <tr>
	        <th><bean:message key="login.notice.browser"/></th>
	        <td><bean:write name="userAgent"/></td>
	    </tr>
	    <tr>
	        <th><bean:message key="login.notice.from"/></th>
	        <td><bean:write name="from"/></td>
	    </tr>	
    </table>
    </center>
</td>
</tr>

<logic:present name="notesFile"> 
    <tr><td>
        <h1><bean:message key="login.notice.notes"/></h1> 
        <center>
        <textarea readonly name="notes" cols="80" rows="10" onFocus="this.blur()"><bean:write name="notesFile"/></textarea>
        </center>
    </td></tr>
</logic:present>

<logic:present name="othersFile"> 
    <tr><td>
        <h1><bean:message key="login.notice.others"/></h1> 
        <center>
        <textarea readonly name="notes" cols="80" rows="3" onFocus="this.blur()"><bean:write name="othersFile"/></textarea>
        </center>
    </td></tr>
</logic:present>
</form>
</table>
</center>
</body>
<%}%>
</html:html>
