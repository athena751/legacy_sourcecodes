<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: ranksparetop.jsp,v 1.2305 2005/12/16 06:45:01 wangli Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %> 
<%@ page language="java" import="com.nec.sydney.beans.fcsan.common.*,com.nec.sydney.atom.admin.base.*,com.nec.sydney.beans.base.*,com.nec.sydney.framework.*,java.util.*"%>

<jsp:useBean id="getPDAndRankBean" class="com.nec.sydney.beans.fcsan.componentconf.GetPDAndRankBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean=getPDAndRankBean;%>
<%
String errorMsg = request.getParameter("errorMsg");
String specialOrNot = request.getParameter("specialOrNot");
if (errorMsg == null) {
%>
<%@include file="../../../menu/common/includeheader.jsp"%>
<%
}
%>
<%
    String diskarrayid=request.getParameter("diskarrayid");
    String diskarrayname=request.getParameter("diskarrayname");
    String arraytype=request.getParameter("arraytype");
    String pdgroupnumber=request.getParameter("pdgroupnumber");
    String reload = request.getParameter("reload");
    String monitoringstate = null;
%>
<html>
<head>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">

<script language="javaScript">
var pdgroupnumber="<%=pdgroupnumber%>";
function onRefresh()
{
	var diskarrayname="<%=diskarrayname%>";
	if(document.forms[0].diskarrayname)
            diskarrayname=document.forms[0].diskarrayname.value;
	window.location="<%=response.encodeURL("ranksparetoprefresh.jsp")%>?diskarrayid=<%=diskarrayid%>&diskarrayname="+diskarrayname+"&arraytype=<%=arraytype%>&pdgroupnumber="+pdgroupnumber;
}

function loadMiddleleftframe()
{
        if(!document.forms[0].pdgroup)  {  
            document.forms[0].submit();
            parent.middlerightframe.location="../common/blank.htm";
            parent.bottomframe.location="<%=response.encodeURL("ranksparebottom.jsp")%>";
        }  else   {
            var pdgroupnumber=document.forms[0].pdgroup.value;
            var monitoringstate=""
            if(document.forms[0].monitoring)
            	monitoringstate=document.forms[0].monitoring.value;
            var diskarrayname="<%=diskarrayname%>";
            if(document.forms[0].diskarrayname)
                diskarrayname=document.forms[0].diskarrayname.value;
            parent.middleleftframe.location="<%=response.encodeURL("ranksparemiddleleft.jsp")%>?diskarrayid=<%=diskarrayid%>&diskarrayname="+diskarrayname+"&arraytype=<%=arraytype%>&pdgroupnumber="+pdgroupnumber+"&monitoringstate="+monitoringstate;
        }
}

function onChoose()
{
 	pdgroupnumber=document.forms[0].pdgroup.value;
	var diskarrayname="<%=diskarrayname%>";
        if(document.forms[0].diskarrayname)
            diskarrayname=document.forms[0].diskarrayname.value;
    window.location="<%=response.encodeURL("ranksparetop.jsp")%>?diskarrayid=<%=diskarrayid%>&diskarrayname="+diskarrayname+"&arraytype=<%=arraytype%>&pdgroupnumber="+pdgroupnumber;
}

function onBack()
{
    parent.location="<%=response.encodeURL("configurationmenu.jsp")%>";
}
</script>
</head>

<body onLoad="loadMiddleleftframe()">
<%
    //String errorMsg = request.getParameter("errorMsg");

    if (errorMsg == null) {
        if(!getPDAndRankBean.getSuccess() || (monitoringstate = getPDAndRankBean.getDiskArrayMonState(diskarrayid)) == null || monitoringstate.trim().equals(""))
        {
            
            if (getPDAndRankBean.setSpecialErrMsg()) {
                if (reload != null && reload.equals("reload") 
                     && getPDAndRankBean.getErrorCode() == FCSANConstants.iSMSM_ENTRY_OVER){
                    errorMsg = NSMessageDriver.getInstance().getMessage(session,"fcsan_componentconf/common/errmsg_reload");        
                } else{
                    errorMsg = getPDAndRankBean.getErrMsg();
                } 
                specialOrNot = "yes";
            }else if(monitoringstate!=null && monitoringstate.trim().equals("")) {
            	errorMsg = NSMessageDriver.getInstance().getMessage(session,"fcsan_common/specialmessage/msg_disk_err");
            	specialOrNot = "yes";
            }else {
                 specialOrNot = "no1";
                 errorMsg = getPDAndRankBean.getErrMsg();
                
            }
            //errorMsg = new String(errorMsg.getBytes(),"EUC-JP");
        
%>
<form name="ranksparetop" action="<%=response.encodeURL("ranksparemiddleleft.jsp")%>" target="middleleftframe">
<input type="hidden" name="rankspare_check" value="">
<h1 class="title"><nsgui:message key="fcsan_componentconf/common/h1_configure"/></h1>
<input type="button" name="back" value="<nsgui:message key="common/button/back"/>" onClick="onBack()">
<input type="button" name="refresh" value="<nsgui:message key="common/button/reload"/>" onClick="onRefresh()">
<h2 class="title"><nsgui:message key="fcsan_componentconf/ranksparetop/h2_title"/></h2>
<h3 class="title">
<nsgui:message key="fcsan_componentconf/table/th_dan"/>&nbsp;:&nbsp;<%=diskarrayname%></h3>
<input type="hidden" name="errorMsg" value="<%=errorMsg%>">
<input type="hidden" name="specialOrNot" value="<%=specialOrNot%>">
</form>
<%
        } else {
           String dispMonitoringState = NSMessageDriver.getInstance().getMessage(session,"fcsan_hashvalue/hashvalue/"+monitoringstate);
            diskarrayname = getPDAndRankBean.getDiskArrayName(diskarrayid);
            
%>

<form name="ranksparetop">
<input type="hidden" name="rankspare_check" value="">
<h1 class="title"><nsgui:message key="fcsan_componentconf/common/h1_configure"/></h1>
<input type="button" name="back" value="<nsgui:message key="common/button/back"/>" onClick="onBack()">
<input type="button" name="refresh" value="<nsgui:message key="common/button/reload"/>" onClick="onRefresh()">
<h2 class="title"><nsgui:message key="fcsan_componentconf/ranksparetop/h2_title"/></h2>
<h3 class="title">
<nsgui:message key="fcsan_componentconf/table/th_dan"/>&nbsp;:&nbsp;<%=diskarrayname%>
&nbsp;&nbsp;<nsgui:message key="fcsan_common/label/monitoring"/>&nbsp;:&nbsp;<%=dispMonitoringState%></h3>
    <%
    Vector PDGroupNoVec=getPDAndRankBean.getPDGroupNoVec();
    int size=PDGroupNoVec.size();
    String displayPDGroupNo;
    for(int i=0 ; i<size ; i++)
    {
        displayPDGroupNo=(String)PDGroupNoVec.get(i);
    %>
        <input type="hidden" name="pdgroup" value="<%=displayPDGroupNo%>">
    <%
    }
    %>
<input type="hidden" name="monitoring" value="<%=monitoringstate%>">
<input type="hidden" name="diskarrayname" value="<%=diskarrayname%>">
</form>
<%
    }    
} else {
    errorMsg = new String(errorMsg.getBytes(),"EUC-JP");
%>
    <h1 class="title"><nsgui:message key="fcsan_componentconf/common/h1_configure"/></h1>
<input type="button" name="back" value="<nsgui:message key="common/button/back"/>" onClick="onBack()">
<input type="button" name="refresh" value="<nsgui:message key="common/button/reload"/>" onClick="onRefresh()">   
<h2 class="title"><nsgui:message key="fcsan_componentconf/ranksparetop/h2_title"/></h2>
<h3 class="title">
<nsgui:message key="fcsan_componentconf/table/th_dan"/>&nbsp;:&nbsp;<%=diskarrayname%></h3>
<form name="ranksparetop" action="<%=response.encodeURL("ranksparemiddleleft.jsp")%>" target="middleleftframe">
<input type="hidden" name="rankspare_check" value="">
<input type="hidden" name="errorMsg" value="<%=errorMsg%>">
<input type="hidden" name="specialOrNot" value="<%=specialOrNot%>">
</form>
<%
}
%>
</body>
</html>
