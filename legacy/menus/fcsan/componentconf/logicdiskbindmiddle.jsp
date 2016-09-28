<!--
        Copyright (c) 2001-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
        modified:xh2005
-->


<!-- "@(#) $Id: logicdiskbindmiddle.jsp,v 1.2305 2007/09/07 08:58:34 liq Exp $" -->

<html>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java"  import="java.lang.*,java.util.*,com.nec.sydney.beans.fcsan.common.*,com.nec.sydney.beans.base.*,com.nec.sydney.framework.*,com.nec.nsgui.action.disk.DiskCommon" %>
<script src="../../../menu/nas/common/general.js"></script>
<jsp:useBean id="pdInfo" class="com.nec.sydney.beans.fcsan.componentconf.LDBindUnbindBean" scope="page"/>
<%@ page import="com.nec.sydney.beans.base.AbstractJSPBean" %>
<% AbstractJSPBean _abstractJSPBean = pdInfo; %>
<% _abstractJSPBean.setRequest(request); %>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<% boolean isS=DiskCommon.isSSeries(request);%>
<script>

function clickradio(radiovalue)
{    
    if (radiovalue.checked)
    {
            var msg=radiovalue.value.split(' ');
            document.forms[0].rankNo.value=msg[0];
            document.forms[0].poolName.value=msg[1];
            document.forms[0].raid.value=msg[2];
            document.forms[0].capacity.value=msg[3];
            document.forms[0].capacity_GB.value = msg[4];
            if (parent.frames[2].document.forms[0] && parent.frames[2].document.forms[0].rankNo) {
                parent.frames[2].document.forms[0].rankNo.value=msg[0];
                parent.frames[2].document.forms[0].poolName.value=msg[1];
                parent.frames[2].document.forms[0].raid.value=msg[2];
                parent.frames[2].document.forms[0].capacity.value=msg[3];
                parent.frames[2].document.forms[0].capacity_GB.value=msg[4];
                <%if (isS){%>
                    var raid = document.forms[0].raid.value;
                    if (raid == "6(4+PQ)" || raid == "6(8+PQ)"){
                        parent.frames[2].document.forms[0].bltime.disabled=true;
                    }else{
                        parent.frames[2].document.forms[0].bltime.disabled=false;
                    }
                <%}%>
            }
    }
}

function loadBottomFrame() {
    parent.bottomframe.location="<%=response.encodeURL("logicdiskbindbottom.jsp")%>?pdnum=<%=request.getParameter("pdnum")%>&diskarrayname=<%=request.getParameter("diskarrayname")%>&diskarrayid=<%=request.getParameter("diskarrayid")%>&arraytype=<%=request.getParameter("arraytype")%>";
}
</script>
<body onLoad="loadBottomFrame()" onResize="resize()">
<form method="post">
<table border="1">
<tr>
    <th>&nbsp;</th>
    <th align="middle"><nsgui:message key="fcsan_componentconf/table/th_rn" /></th>
    <th align="middle"><nsgui:message key="fcsan_componentconf/table/th_raid" /></th>
    <th align="middle"><nsgui:message key="fcsan_componentconf/table/available" /></th>
    <th align="middle"><nsgui:message key="fcsan_componentconf/table/th_unused_capacity" /></th>
</tr>
<%
List rankSummaryInfo=(List)session.getAttribute(FCSANConstants.SESSION_RANK_SUMMARY);
String s;
StringTokenizer st;
String size;
String raid;
String rankNo;
String poolName;
if (rankSummaryInfo!=null && rankSummaryInfo.size() > 0) {
    Collections.sort(rankSummaryInfo);

    for(int i=0; i<rankSummaryInfo.size(); i++)
    {
        s=(String)rankSummaryInfo.get(i);
        StringBuffer sb = new StringBuffer();
        st=new StringTokenizer(s);
        rankNo = st.nextToken();
        poolName = st.nextToken();
        raid = st.nextToken();
        size = st.nextToken();
        sb.append(rankNo+" ");
        sb.append(poolName+" ");
        sb.append(raid+" ");
        sb.append(size + " ");

%>

<%
double available_GB = Double.valueOf(size).doubleValue()/1024/1024/1024;
String capacity_GB = pdInfo.GetDouble(available_GB-0.05, 1, 1);
sb.append(capacity_GB);
        if (i == 0){
%>
<input type="hidden" name="rankNo" value="<%=rankNo%>">
<input type="hidden" name="poolName" value="<%=poolName%>">
<input type="hidden" name="raid" value="<%=raid%>">
<input type="hidden" name="capacity" value="<%=size%>">
<input type="hidden" name="capacity_GB" value="<%=capacity_GB%>">
<%}%>
<tr align="center">
    <td><input type="radio" name="radio" value="<%=sb.toString()%>" <%if(i==0) out.println("checked");%> onclick="clickradio(this)"></td>
    <td><%=poolName+"("+rankNo+")"%></td>
    <td><%=raid%></td>

    <td><%=pdInfo.GetDouble(available_GB-0.05, 1)%></td>
    <td><%=st.nextToken()%></td>
</tr>
<%
    }//end for
}//end of if
%>
</table>
<input type="hidden" name="pdgroupNo" value="<%=request.getParameter("pdnum")%>">
</form>
</body>
<html>
