<!--
        Copyright (c) 2001-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: rankrebuildingtimechangeshow.jsp,v 1.2307 2007/09/07 08:59:25 liq Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java"  import="com.nec.sydney.beans.fcsan.common.*,com.nec.sydney.atom.admin.base.*,com.nec.sydney.beans.base.*,java.lang.*,java.util.*,com.nec.sydney.framework.*,com.nec.nsgui.action.disk.DiskCommon" %>

<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<jsp:useBean id="timechangshowBean" class="com.nec.sydney.beans.fcsan.componentconf.RankRebTimeChangeShowBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean = timechangshowBean; %>
<%@include file="../../../menu/common/includeheader.jsp" %>
<html>
<head>
<title><nsgui:message key="fcsan_componentconf/rebuildingtimechange/title_ct"/></title>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<%  String diskarrayid=request.getParameter("diskarrayid");
    String diskarrayname = request.getParameter("diskarrayname");
    String pdgroupnumber = request.getParameter("pdgroupnumber");
    Vector ranknumbers = timechangshowBean.getRanknumbers();
    DiskArrayRankInfo diskarrayrankinfo;
    
    String index = request.getParameter("index");
    if(index==null)
      index="0";
    int time=Integer.parseInt(((DiskArrayRankInfo)(ranknumbers.get(Integer.parseInt(index)))).getRebuildingTime());
    boolean isS=DiskCommon.isSSeries(request);
    boolean isD=DiskCommon.isCondorLiteSeries(request);
%>
<script language="JavaScript">
    var win;
    
    function onOk() {
        if(document.forms[0].ok.disabled==true)
            return false;
        var oldtime = <%=time%>;
        var newtime="";
        <%if (isD){%>
            var isinvalidtime="false";
            if (document.forms[0].rebuildingtime.value.match(/[^\d]/)){        
                isinvalidtime="true";
            }
            if (document.forms[0].rebuildingtime.value.match(/^0/) && document.forms[0].rebuildingtime.value.length>1){
                isinvalidtime="true";
            }
            newtime = parseInt(document.forms[0].rebuildingtime.value);
            if(isinvalidtime == "true" || isNaN(newtime)|| newtime <0 || newtime >255 ){
                alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="fcsan_componentconf/rebuildingtimechange/poolrebuild_time_error"/>");            document.forms[0].rebuildingtime.focus();
                return false;
            }
        <%}else if (isS){%>
            newtime = document.forms[0].rebuildingtime.options[document.forms[0].rebuildingtime.selectedIndex].value;
        <%}%>
        var msg=<nsgui:message key="fcsan_componentconf/rebuildingtimechange/msg_rebuildingtimechangeconfirm" separate="true">
                      <nsgui:replacement value="oldtime"/>
                      <nsgui:replacement value="newtime"/>
                 </nsgui:message>;
        if(!confirm(msg)){ 
            return false;   
        } 
        document.forms[0].ok.disabled=true;
        document.forms[0].cancel.disabled=true;
        var tmptext = document.forms[0].ranknumber.options[document.forms[0].ranknumber.selectedIndex].text;
        var tmpname = tmptext.substring(0,tmptext.indexOf("("));        
        win=window.open("<%=response.encodeURL("../common/fcsanwait.jsp")%>?diskarrayname=<%=diskarrayname%>&pdgroupnumber=<%=pdgroupnumber%>&poolname="+tmpname+"&rebuildingtime="+newtime+"&target_jsp="+document.forms[0].target_jsp.value,"rankrebuildingtimechange","toolbar=no,menubar=no,resizable=yes,scrollbars=yes,width=600,height=200")
        win.focus();
    }
    
    function onCancel() {
        if(document.forms[0].cancel.disabled==true)
            return false;
        window.close()
    }
    
    function changeselect(index) {
        if(!document.forms[0].cancel.disabled)
            window.location="<%=response.encodeURL("rankrebuildingtimechangeshow.jsp")%>?diskarrayid=<%=diskarrayid%>&diskarrayname=<%=diskarrayname%>&pdgroupnumber=<%=pdgroupnumber%>&index="+index;
    }
    function timedisp() {
        <%if (isS){%>
            document.forms[0].ok.focus();
            document.forms[0].rebuildingtime.selectedIndex=document.forms[0].ranknumber.options[<%=index%>].value;
        <%}%>
    }
</script>
</head>
<body onload="timedisp()">
<form onsubmit="return false;">
<h1 class="popup"><nsgui:message key="fcsan_componentconf/common/h1_configure"/></h1>
<h2 class="popup"><nsgui:message key="fcsan_componentconf/rebuildingtimechange/h2_option"/></h2>
  <table border="0">
    <tr align="left">
      <th><nsgui:message key="fcsan_componentconf/table/th_dan"/></th>
      <td>:</td>
      <td><%=diskarrayname%></td>
    </tr>
    <tr align="left">
      <th><nsgui:message key="fcsan_componentconf/table/th_rn"/></th>
      <td>:</td>
      <td>
        <select name="ranknumber" onChange="changeselect(document.forms[0].ranknumber.selectedIndex)">       
        <%for(int i=0;i<ranknumbers.size();i++){
            diskarrayrankinfo = (DiskArrayRankInfo)ranknumbers.get(i);%>
            <option <%=(i==Integer.parseInt(index))?"selected":""%> value="<%=diskarrayrankinfo.getRebuildingTime()%>"><%=diskarrayrankinfo.getPoolName()+"("+diskarrayrankinfo.getPoolNo()+")"%></option>
        <%}%>
        </select>
      </td>
    </tr>
    <tr>
    <th align="left">
    <nsgui:message key="fcsan_componentconf/rebuildingtimechange/msg_ct"/> 
    </th>
    <td>:</td>
    <td>
       <%=time%>
    <%--moved to top  by liyb 20051220--int time=Integer.parseInt(((DiskArrayRankInfo)(ranknumbers.get(Integer.parseInt(index)))).getRebuildingTime());-----%>
    <%--deleted by liyb 20051220--((DiskArrayRankInfo)(ranknumbers.get(Integer.parseInt(index)))).getRebuildingTime()-----%>
    </td>
    </tr>
    <tr>
    <th align="left">
    <%if (isS){%>
        <nsgui:message key="fcsan_componentconf/common/msg_rt"/> 
    <%}else if (isD){%>
        <nsgui:message key="fcsan_componentconf/common/msg_rt_procyon"/> 
    <%}%>
    </th>
    <td>:
    </td>
    <td>
    <%if (isS){%>
        <select name="rebuildingtime">
        <option <%=(0==time)?"selected":""%> value="0">0<nsgui:message key="fcsan_componentconf/common/fastest"/></option>
        <%for(int i=1;i<25;i++) {%>
            <option <%=(i==time)?"selected":""%> value="<%=i%>"><%=i%></option>
        <%}%>
        </select>
        <nsgui:message key="fcsan_componentconf/common/hour"/> 
    <%}else if (isD){%>
        <input type="text" name="rebuildingtime" size="10" maxlength="3" value="<%=time%>" style="text-align:right">
        <nsgui:message key="fcsan_componentconf/common/hour"/>&nbsp;&nbsp;
        <I><nsgui:message key="fcsan_componentconf/table/th_time_fast"/></I>
    <%}%>
    </td>
    </tr>
    </table>
<br>
  <center> 
    <input type="button" name="ok" value="<nsgui:message key="common/button/submit"/>" onClick="onOk()">
    <input type="button" name="cancel" value="<nsgui:message key="common/button/close"/>" onClick="onCancel()">
    <input type="hidden" name="target_jsp" value="../componentconf/rankrebuildingtimechange.jsp">
  </center>
</form>
</body>
</html>
