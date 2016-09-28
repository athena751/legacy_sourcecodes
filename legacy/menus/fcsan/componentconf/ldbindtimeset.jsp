<!--
        Copyright (c) 2001-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: ldbindtimeset.jsp,v 1.2307 2007/09/07 08:56:54 liq Exp $" -->

<html>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<%@ page contentType="text/html;charset=EUC-JP"%>
<title><nsgui:message key="fcsan_componentconf/ldbindtimeset/changetime_title"/></title>
<%@ page language="java"  import="java.lang.*,java.util.*,com.nec.sydney.beans.base.*,com.nec.sydney.framework.*,com.nec.nsgui.action.disk.DiskCommon" %>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<%boolean isS=DiskCommon.isSSeries(request);
  boolean isD=DiskCommon.isCondorLiteSeries(request);%>
<script>
function submitForm()
{
    if(document.forms[0].ok.disabled)
            return false;
    <%if (isD){%>
        var isinvalidtime="false";
        if (document.forms[0].bltime.value.match(/[^\d]/)){        
            isinvalidtime="true";
        }
        if (document.forms[0].bltime.value.match(/^0/) && document.forms[0].bltime.value.length>1){
      	    isinvalidtime="true";
        }
        var formattime=parseInt(document.forms[0].bltime.value);
        if (isinvalidtime == "true" || isNaN(formattime)|| formattime <0 || formattime >255 ){
            alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="fcsan_componentconf/logicdiskbind/ldbind_time_error" />");
            document.forms[0].bltime.focus();
            return false;
        }
    <%}%>
    document.forms[0].ok.disabled=true;
    document.forms[0].cancel.disabled=true;            
    var win_poputtimesetwin = window.open("/nsadmin/common/commonblank.html","popupTimeSetWin","width=600,height=180,toolbar=no,menubar=no,resizable=yes,scrollbars=yes");
    win_poputtimesetwin.focus();

    return true;
}
</script>
<body onload="document.forms[0].ok.focus();document.forms[0].ok.disabled=false;document.forms[0].cancel.disabled=false">
<h1 class="popup"><nsgui:message key="fcsan_componentconf/common/h1_ldmenu"/></h1>
<h2 class="popup"><nsgui:message key="fcsan_componentconf/ldbindtimeset/changetime_title"/></h2>
<form action="<%=response.encodeURL("../common/fcsanwait.jsp")%>" target="popupTimeSetWin" onsubmit='return submitForm();' method="post">
<%if (isD){%>
    <nsgui:message key="fcsan_componentconf/ldbindtimeset/tipinfo"/>
<%}else if (isS){%>
    <nsgui:message key="fcsan_componentconf/ldbindtimeset/tipinfo_Callisto"/>
<%}%>
<br><br>
<table>
<tr>
<th align="left">
    <nsgui:message key="fcsan_componentconf/table/th_dan"/>
</th>
<td>:</td>
    <td align="left">
        <%=request.getParameter("diskarrayname")%>
    </td>
</tr>

<tr>
<th align="left">
    <%if (isD){%>
        <nsgui:message key="fcsan_componentconf/table/th_format_time_procyon"/>
    <%}else if (isS){%>
        <nsgui:message key="fcsan_componentconf/table/th_format_time"/>
    <%}%>
</th>
<td>:</td>
<td align="left">
<%if (isD){%>
    <input type="text" name="bltime" value="24" maxlength="3" size="5" style="text-align:right">
    <nsgui:message key="fcsan_componentconf/common/hour"/>&nbsp;&nbsp;
    <I><nsgui:message key="fcsan_componentconf/table/th_time_fast"/></I>
<%}else if (isS){%>   
    <select name="bltime">
    <%for(int i=0;i<=24;i++){
        if (i == 0){
            out.println("<option value=\""+i+"\">"+i+NSMessageDriver.getInstance().getMessage(session,"fcsan_componentconf/common/fastest")+"</option>");
        } else {
            out.println("<option value=\""+i+"\">"+i+"</option>");
        }
    }%>
    </select>
    <nsgui:message key="fcsan_componentconf/common/hour"/>
<%}%>
</td>
</tr>
</table>
<br>
<center>
<input type="submit"  name="ok" value="<nsgui:message key="common/button/submit" />" >
<input type="button" name="cancel" value="<nsgui:message key="common/button/close" />" onclick="if(!this.disabled) window.close()">
</center>
<input type="hidden" name="operation" value="timeset">
<input type="hidden" name="diskarrayname" value="<%=request.getParameter("diskarrayname")%>">
<input type="hidden" name="target_jsp" value="../componentconf/bindunbindresult.jsp">
</form>
</body>

<html>