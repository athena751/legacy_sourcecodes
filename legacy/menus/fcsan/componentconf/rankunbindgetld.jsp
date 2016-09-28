<!--
        Copyright (c) 2001-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: rankunbindgetld.jsp,v 1.2304 2008/12/01 12:00:22 chenb Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %> 
<%@ page language="java" import="com.nec.sydney.beans.fcsan.common.*,com.nec.sydney.atom.admin.base.*,com.nec.sydney.beans.base.*,com.nec.sydney.framework.*,java.util.*,com.nec.nsgui.action.base.*"%>

<jsp:useBean id="RankAndLDReleaseBean" class="com.nec.sydney.beans.fcsan.componentconf.RankAndLDReleaseBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean=RankAndLDReleaseBean;%>
<%@include file="../../../menu/common/includeheader.jsp"%>

<html>
<head>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">

<%
int result=RankAndLDReleaseBean.getLDOfRank();
    
if (result!=0)
{
%>
<title><nsgui:message key="fcsan_common/title/page_title_error"/></title>
<script language="javaScript">
function enableButton() {
    if (window.opener && !window.opener.closed) {
        window.opener.document.forms[0].ok.disabled=false;
        window.opener.document.forms[0].cancel.disabled=false;
    }
}
</script>
</head>
<body onload="enableButton()">
    <%if(RankAndLDReleaseBean.setSpecialErrMsg()) {%>
        <h1 class="popup"><nsgui:message key="fcsan_componentconf/common/h1_configure"/></h1>
        <h2 class="popup"><%=RankAndLDReleaseBean.getErrMsg()%></h2>       
    <%}else{%>
        <h1 class="popupError"><nsgui:message key="fcsan_componentconf/rankunbindgetld/h2_errmsghead"/></h1>
        <h2 class="popupError"><%=RankAndLDReleaseBean.getErrMsg()%></h2>
    <%}%>
<form method="post">
<center>
<input type="button" value="<nsgui:message key="common/button/close"/>" onClick="window.close();">
</center>
</form>
<%
}
else
{
    
    boolean hasPairCreatingOnPool=NSActionUtil.hasActiveAsyncPair(request);
    
    boolean volResult=RankAndLDReleaseBean.hasVolCreatingInfoOnPool();    
    boolean volBatchResult=RankAndLDReleaseBean.hasBatchVolCreatingInfoOnPool(); 
    boolean hasVolCreatingOnPool=(volResult || volBatchResult);
    	
    Vector LDNoVec=RankAndLDReleaseBean.getLDNoVec();
    int size=LDNoVec.size();
    if (size==0 && hasVolCreatingOnPool==false && hasPairCreatingOnPool==false)
    {
        String rankno=request.getParameter("rankno");
        String pdgroupnumber = request.getParameter("pdgroupnumber");
        String diskarrayname = request.getParameter("diskarrayname");
        String diskarrayid = request.getParameter("diskarrayid");
        String arraytype=request.getParameter("arraytype");
%>
    <script language="javaScript">
    window.location="<%=response.encodeURL("rankunbindconfirmnold.jsp")%>?rankno=<%=rankno%>&pdgroupnumber=<%=pdgroupnumber%>&diskarrayname=<%=diskarrayname%>&diskarrayid=<%=diskarrayid%>&arraytype=<%=arraytype%>";

    </script>
<%
    } else if(RankAndLDReleaseBean.hasPairedLds(LDNoVec)){%>
       <script language="javaScript">
           window.location="<%=response.encodeURL("rankunbindconfirmhavepairedld.jsp")%>";
       </script>
<%  }else{
        String rankno=request.getParameter("rankno");
        String pdgroupnumber=request.getParameter("pdgroupnumber");
        String diskarrayname=request.getParameter("diskarrayname");
        String diskarrayid=request.getParameter("diskarrayid");
        String arraytype=request.getParameter("arraytype");
        
//modify by maojb on 12.18 for LVM bind check
        String isMultiMachine = request.getParameter("isMultiMachine");

        String ldnodetail=new String();
        String ldnosummary=new String();
        
        if (size>0) {
	        int i;
	        for(i=0;i<size;i++) {
	            ldnodetail=ldnodetail+(String)LDNoVec.get(i)+",";
	            if(i<2) {
	                ldnosummary=ldnodetail;
	            } 
	        }
	        ldnodetail=ldnodetail.substring(0,ldnodetail.length()-1);
	        ldnosummary=ldnosummary.substring(0,ldnosummary.length()-1);
	        if(i>2) {
	            ldnosummary=ldnosummary+"...";
	        }
        }
        
        if(hasVolCreatingOnPool || hasPairCreatingOnPool){
%>
            <script language="javaScript">
            window.location="<%=response.encodeURL("rankunbindhasvolumeorpaircreating.jsp")%>?rankno=<%=rankno%>&pdgroupnumber=<%=pdgroupnumber%>&diskarrayname=<%=diskarrayname%>&diskarrayid=<%=diskarrayid%>&arraytype=<%=arraytype%>&ldnodetail=<%=ldnodetail%>&isMultiMachine=<%=isMultiMachine%>&hasVolCreatingOnPool=<%=hasVolCreatingOnPool%>&hasPairCreatingOnPool=<%=hasPairCreatingOnPool%>"; 
            </script> 
<%
    	}
%>
</head>
<body>
<form method="post" action="<%=response.encodeURL("rankunbindconfirmhaveld.jsp")%>">
<input type="hidden" name="ldnosummary" value="<%=ldnosummary%>">
<input type="hidden" name="ldnodetail" value="<%=ldnodetail%>">
<input type="hidden" name="rankno" value="<%=rankno%>">
<input type="hidden" name="pdgroupnumber" value="<%=pdgroupnumber%>">
<input type="hidden" name="diskarrayname" value="<%=diskarrayname%>">
<input type="hidden" name="diskarrayid" value="<%=diskarrayid%>">
<input type="hidden" name="arraytype" value="<%=arraytype%>">
<input type="hidden" name="ldsize" value="<%=size%>">
<input type="hidden" name="isMultiMachine" value="<%=isMultiMachine%>">
</form>
    <script language="javaScript">
    
    document.forms[0].submit();
    </script>
<%
    }
}
%>
</body>
</html>