<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: diskarrayportsetshow.jsp,v 1.2301 2004/07/14 08:42:44 nsadmin Exp $" -->
<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java"  import="com.nec.sydney.beans.fcsan.common.*,com.nec.sydney.atom.admin.base.*,com.nec.sydney.beans.base.*,com.nec.sydney.framework.*,java.util.*" %>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %> 
<jsp:useBean id="getPortBean" class="com.nec.sydney.beans.fcsan.componentdisp.DiskArrayPortGetBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean = getPortBean; %>
<%@include file="../../../menu/common/includeheader.jsp" %>
<HTML>
<HEAD>
<TITLE><nsgui:message key="fcsan_componentdisp/mod_portname/page_title"/></TITLE>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<script language="JavaScript">
//add by caoyh 2002-2002/9/27 for mail: nas 4636
String.prototype.Rtrim = function(){	
	var whitespace = new String(" \t\n\r");
    var s = new String(this);
    var i = s.length - 1;       
    while (i >= 0 && whitespace.indexOf(s.charAt(i)) != -1)
         i--;
     s = s.substring(0, i+1);
     return s;
}
//add end
var win;

function displayName()
{
    var strArr = document.forms[0].port.options[document.forms[0].port.selectedIndex].text.split("(");
    if (strArr.length == 2) {
        document.forms[0].portname.value = strArr[1].substring(0,strArr[1].length-1);   
    }
    
}
function onOk()
{  
    if (!document.forms[0].ok.disabled) {
        //delete by caoyh 2002-2002/9/27 for mail: nas 4636
        /* var tokens=document.setportform.port.options[document.setportform.port.selectedIndex].text.split("(");
       var  oldPortName=tokens[1].substring(0,tokens[1].length-1);
       if (document.setportform.portname.value==oldPortName)
        {
            alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="fcsan_componentdisp/common/err_same_name"/>");
            return false;
        } */
        //delete end
        //add by caoyh 2002-2002/9/27 for mail: nas 4636
        document.setportform.portname.value = document.setportform.portname.value.Rtrim();
        //add end
        if(check(document.setportform.portname.value)==false || document.setportform.portname.value.length>32)
        {
            alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="fcsan_componentdisp/common/err_invalid_name"/>");
            return false;
        }else{
            document.forms[0].ok.disabled = true;
            document.forms[0].cancel.disabled = true;
            return true;
         }
    }
}

function check(str)
{
 var avail
    if(str == "")
         return false;
    avail = /[^A-Za-z0-9_\/]/gi;
    ifFind = str.search(avail);
    return (ifFind==-1);
}

function init()
{
    if (document.forms[0].ok) {
        document.forms[0].ok.disabled = false;
    }

    if (document.forms[0].cancel) {
       document.forms[0].cancel.disabled = false; 
    }
    
}
</script>

</HEAD>

<body onload="init()">
<!--form name="setportform" onsubmit="return false;"-->
<form  name="setportform" method="post" onsubmit='if(onOk()) { popup=window.open("","changeport","width=600,height=200,toolbar=no,menubar=no,resizable=yes,scrollbars=yes"); popup.focus();}else return false;' target="changeport" action="<%=response.encodeURL("diskarrayportset.jsp")%>">
<%int result = getPortBean.getResult();
  String diskid=request.getParameter("diskid"); 
  Vector port = getPortBean.getPort();
 if(result==0){%>
<h1 class="popup"><nsgui:message key="fcsan_componentdisp/common/h1"/></h1>
<h2 class="popup"><nsgui:message key="fcsan_componentdisp/mod_portname/h2"/></h2>
<table border="0">
    <tr align="left"> 
        <th><nsgui:message key="fcsan_componentdisp/table/table_portnumber"/></th>
        <td>:</td>
        <td> 
              <select name="port" onChange="displayName()">
              <% DiskArrayPortInfo portinfo;
               for(int i=0;i<port.size();i++){
                    portinfo = (DiskArrayPortInfo)port.get(i);%>
                    <option value=<%=portinfo.getPortNo()%> <%=(i==0)?"selected":""%>><%=portinfo.getPortNo()%>(<%=portinfo.getName()%>)
                <%}%>            
              </select>
        </td>
    </tr>
    <tr align="left"> 
        <th><nsgui:message key="fcsan_componentdisp/table/table_portname"/></th>
        <td>:</td>
        <td > 
              <input type="text" name="portname" value="<%=((DiskArrayPortInfo)port.get(0)).getName()%>" size="24" maxlength="32">
        </td>
    </tr>
</table>
  <br>
<input type="hidden" name="id" value="<%=diskid%>">
  <center>
    <input type="submit" name="ok" value="<nsgui:message key="common/button/submit"/>"> 
    &nbsp;&nbsp;&nbsp;
    <input type="button" name="cancel" value="<nsgui:message key="common/button/close"/>" onClick='if(!this.disabled) window.close()'>
  </center>
<%}else{
    int errorCode=getPortBean.getErrorCode();
        if(getPortBean.setSpecialErrMsg()) {%>
         <h1 class="popup"><nsgui:message key="fcsan_componentdisp/common/h1"/></h1>
        <h2 class="popup"><%=getPortBean.getErrMsg()%></h2>       
        <%} else { %>
<h1 class="popupError"><nsgui:message key="fcsan_componentdisp/mod_portname/err_noport"/></h1>
<h2 class="popupError"><%=getPortBean.getErrMsg()%></h2>
        <%}%>
<center>
    <input type="button" name="ok" value="<nsgui:message key="common/button/close"/>" onClick="if(!this.disabled) window.close()"> 
</center>
<%}%>  
</form>
</body>
</html>

