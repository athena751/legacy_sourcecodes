<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: ldbindunbindtop.jsp,v 1.2306 2005/12/26 11:35:52 wangli Exp $" -->

<html>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<%@ page contentType="text/html;charset=EUC-JP"%>
<title><nsgui:message key="fcsan_componentconf/ldbindunbind/ldbindunbind_title" /></title>
<%@ page language="java"  import="java.lang.*,java.util.*,com.nec.sydney.beans.fcsan.common.*,com.nec.sydney.beans.base.*,com.nec.sydney.framework.*" %>
<jsp:useBean id="pdInfoBean" class="com.nec.sydney.beans.fcsan.componentconf.LDBindUnbindBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean = pdInfoBean; %>
<%@ include file="../../../menu/common/includeheader.jsp" %>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">

<%
    String monitoringstate = "null";
%>
    <%    if (pdInfoBean.getErrMsg()!=null 
                    || (monitoringstate=pdInfoBean.getDiskArrayMonState()) == null || monitoringstate.trim().equals("")){%>
                    <body>
                    <%
                    String errMsgForMiddle = "";
                    if(monitoringstate!=null && monitoringstate.trim().equals("")) 
                    	errMsgForMiddle = "<h2 class='title'>"+NSMessageDriver.getInstance().getMessage(session,"fcsan_common/specialmessage/msg_disk_err")+"</h2>";
                    else	
                    	errMsgForMiddle = pdInfoBean.getErrMsg();
                    %>
                    <h1 class="title"><nsgui:message key="fcsan_componentconf/common/h1_ldmenu"/></h1>
                    <input type="button" name="back" value="<nsgui:message key="common/button/back" />" onclick="parent.location='<%=response.encodeURL("ldmenu.jsp")%>'" >                    
                    <input type="button" value="<nsgui:message key="common/button/reload" />" onclick="window.location='<%=response.encodeURL("ldbindunbinrefresh.jsp")%>?action=refresh&diskarrayid=<%=request.getParameter("diskarrayid")%>&arraytype=<%=request.getParameter("arraytype")%>&diskarrayname=<%=request.getParameter("diskarrayname")%>&PDGroups=<%=request.getParameter("PDGroups")%>'" >
                    <h2 class="title"><nsgui:message key="fcsan_componentconf/ldbindunbind/ldbindunbind_title" /></h2>
                    <h3 class="title"><nsgui:message key="fcsan_componentconf/table/th_dan" />&nbsp;:&nbsp;<%=request.getParameter("diskarrayname")%></h3>
                    <form action="<%=response.encodeURL("ldbindunbindmiddle.jsp")%>" target="mainframe">
                    <input type="hidden" name="ldbindunbind_check" value="">
                    <input type="hidden" name="ErrMsgForMiddle" value="<%=errMsgForMiddle%>">
                    <input type="hidden" name="diskarrayid" value="<%=request.getParameter("diskarrayid")%>">
                    <input type="hidden" name="action" value="RankInfo">
                    </form>
                    </body>
                    <script>
                    document.forms[0].submit();
                    parent.bottomframe.location = "<%=response.encodeURL("ldbindunbindbottom.jsp")%>";
                    </script>
    <%}else{
        String diskArrayName =  pdInfoBean.getDiskArrayName(request.getParameter("diskarrayid"));
        //pdgroups is a List contain the all PD's ranks.
        Map pdGroupNos=pdInfoBean.getPDGroups();
        if (pdGroupNos.size() == 0){
            pdGroupNos.put("","");
        }
    
    %>    
    
    
<script>
var PDGroups="<%=request.getParameter("PDGroups")%>";
function choosePDGroup()
{
    //if (document.forms[0].selectPDGroup.disabled == true)
    //    return;
      var No=document.forms[0].PDGroups.value;
    //if(No=="") {
    //    document.forms[0].selectPDGroup.disabled = true;
    //}
    parent.mainframe.location="<%=response.encodeURL("ldbindunbindmiddle.jsp")%>?action=RankInfo&diskarrayid=<%=request.getParameter("diskarrayid")%>&arraytype=<%=request.getParameter("arraytype")%>&diskarrayname=<%=diskArrayName%>&PDNo="+No+"&monitoringstate=<%=monitoringstate%>";
    
}

function submitSelf(){
	PDGroups=document.forms[0].PDGroups.value;
    parent.frames[0].location = "<%=response.encodeURL("ldbindunbindtop.jsp")%>?action=PDGroup&diskarrayid=<%=request.getParameter("diskarrayid")%>&diskarrayname=<%=diskArrayName%>&arraytype=<%=request.getParameter("arraytype")%>&PDGroups="+PDGroups;
}
function onReload() {
	window.location="<%=response.encodeURL("ldbindunbinrefresh.jsp")%>?action=refresh&diskarrayid=<%=request.getParameter("diskarrayid")%>&arraytype=<%=request.getParameter("arraytype")%>&diskarrayname=<%=diskArrayName%>&monitoringstate=<%=monitoringstate%>&PDGroups="+PDGroups
}

</script>
<body onload=" choosePDGroup();">
<h1 class="title"><nsgui:message key="fcsan_componentconf/common/h1_ldmenu"/></h1>
<input type="button" name="back" value="<nsgui:message key="common/button/back" />" onclick="parent.location='<%=response.encodeURL("ldmenu.jsp")%>'" >
<input type="button" value="<nsgui:message key="common/button/reload" />" onclick="onReload()">
<h2 class="title"><nsgui:message key="fcsan_componentconf/ldbindunbind/ldbindunbind_title" /></h2>
<h3 class="title"><nsgui:message key="fcsan_componentconf/table/th_dan" />&nbsp;:&nbsp;<%=diskArrayName%>
&nbsp;&nbsp;<nsgui:message key="fcsan_common/label/monitoring"/>&nbsp;:&nbsp;<%=NSMessageDriver.getInstance().getMessage(session,"fcsan_hashvalue/hashvalue/"+monitoringstate)%></h3>
<form method="post">
<input type="hidden" name="ldbindunbind_check" value="">
<%
    String PDGroup = request.getParameter("PDGroups");
    Iterator listPDGroups = pdGroupNos.keySet().iterator();
    while(listPDGroups.hasNext()){
        String PDGNo  = (String)listPDGroups.next();
        %>
        <input type="hidden" name="PDGroups" value="<%=PDGNo%>">
        <%
    }
%>
</form>
</body>
<%}//end of else%>
</html>