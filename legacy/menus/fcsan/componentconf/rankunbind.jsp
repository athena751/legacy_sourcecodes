<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: rankunbind.jsp,v 1.2304 2005/12/26 12:33:51 wangli Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %> 
<%@ page language="java" import="com.nec.sydney.beans.fcsan.common.*,com.nec.sydney.atom.admin.base.*,com.nec.sydney.beans.base.*,com.nec.sydney.framework.*,java.util.*"%>

<jsp:useBean id="PDAndRankListBean" class="com.nec.sydney.beans.fcsan.componentconf.PDAndRankListBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean=PDAndRankListBean;%>
<%@include file="../../../menu/common/includeheader.jsp"%>

<%
String diskarrayname=request.getParameter("diskarrayname");
String diskarrayid=request.getParameter("diskarrayid");
String pdgroupnumber=request.getParameter("pdgroupnumber");

int size = 0; //rankStringVec's size

//modify by maojb on 10.28 for defect-206
String arraytype = request.getParameter("arraytype");
int arraytypeValue = Integer.parseInt(arraytype.substring(0,arraytype.length()-1),16);

PDAndRankListBean.setRankVec();

//modify by maojb on 12.18 for LVM bind check
String isMultiMachine = "no";
int returnValue = 0;
//if (arraytypeValue<=111 && arraytypeValue>=80) {
    if (PDAndRankListBean.isFirstArray(diskarrayid)){
        returnValue = PDAndRankListBean.delSpecialRank();
    }
    isMultiMachine = "yes";
//}

Vector rankStringVec=PDAndRankListBean.getRankStringVec();
%>
<html>
<head>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<title>
<nsgui:message key="fcsan_componentconf/rankunbind/title_rankunbind"/>
</title>
<script language="javaScript">
function onCancel()
{
    if(document.forms[0].cancel.disabled)
        return false;
    else
        window.close();
}

function onOk()
{
    if(document.forms[0].ok.disabled)
    {
        return false;
    } else {
        var win = window.open("<%=response.encodeURL("../common/fcsanwait.jsp")%>?arraytype=<%=arraytype%>&diskarrayname=<%=diskarrayname%>&pdgroupnumber=<%=pdgroupnumber%>&diskarrayid=<%=diskarrayid%>&isMultiMachine=<%=isMultiMachine%>&rankno="+document.forms[0].rankno.options[document.forms[0].rankno.selectedIndex].value+"&target_jsp=../componentconf/rankunbindgetld.jsp","winunbind","toolbar=no,menubar=no,width=750,height=240,resizable=yes,scrollbars=yes");
        win.focus();
        document.forms[0].ok.disabled=true;
        document.forms[0].cancel.disabled=true;
    }
}

function defaultFocus()
{
<%
    size=rankStringVec.size();
    if (size==0) {
%>
    document.forms[0].ok.disabled=true;
<%
    }
%>
    if (!document.forms[0].ok.disabled) {
        document.forms[0].ok.focus();
    }
}
</script>
</head>
<%
if (returnValue != 0) {
%>
<body>
    <%if(PDAndRankListBean.setSpecialErrMsg()) {%>
        <h1 class="popup"><nsgui:message key="fcsan_componentconf/common/h1_configure"/></h1>
        <h2 class="popup"><%=PDAndRankListBean.getErrMsg()%></h2>       
    <%}else{%>
        <h1 class="popupError"><nsgui:message key="fcsan_componentconf/rankunbindgetld/h2_errmsghead"/></h1>
        <h2 class="popupError"><%=PDAndRankListBean.getErrMsg()%></h2>
    <%}%>
<form>
<center>
<input type="button" value="<nsgui:message key="common/button/close"/>" onClick="window.close();">
</center>
</form>
<%
} else {
%>
<body onLoad="defaultFocus()">
<form>
<h1 class="popup"><nsgui:message key="fcsan_componentconf/common/h1_configure"/></h1>
<h2 class="popup"><nsgui:message key="fcsan_componentconf/rankunbind/h2_rankunbind"/></h2>
<table>
<tr><th align="left" nowrap>
<nsgui:message key="fcsan_componentconf/table/th_dan"/>
</th>
<td>
:
</td>
<td>
<%=diskarrayname%>
</td></tr>
<tr><th align="left" nowrap><nsgui:message key="fcsan_componentconf/table/th_rn"/>
</th>
<td>
:
</td>
<td>
<select name="rankno">
<%
String rankno;
String name;
for(int i=0 ; i<size ; i++)
{
    rankno=(String)rankStringVec.get(i);
    name=PDAndRankListBean.getPoolNameByNo(rankno);
%>
    <option value="<%=rankno%>"><%=name+"("+rankno+")"%></option>
<%
}
%>
</select>
</td></tr>
</table>
<br>
<center>
<input type="button" name="ok" value="<nsgui:message key="common/button/submit"/>" onClick="return onOk()">
<input type="button" name="cancel" value="<nsgui:message key="common/button/close"/>" onClick="return onCancel()">
</center>
</form>
<%
}
%>

</body>
</html>

