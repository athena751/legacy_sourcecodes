<!--
        Copyright (c) 2001-2006 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: dirquotareport.jsp,v 1.2303 2006/12/08 02:42:25 zhangjun Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page language="java" import="com.nec.sydney.beans.base.*,java.util.*,com.nec.sydney.atom.admin.base.*,com.nec.sydney.atom.admin.quota.*"%>
<%@ page import="com.nec.sydney.framework.*" %>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>

<jsp:useBean id="reportBean" class="com.nec.sydney.beans.quota.GetReportBean" scope="page"/>
<%AbstractJSPBean _abstractJSPBean = reportBean; %>
<%@include file="../../../menu/common/includeheader.jsp" %>

<%
  String unit = request.getParameter("unit");
  String displayControl = request.getParameter("displayControl");

  if (unit == null || unit.equals("")){
    unit = "--";
  } 
  Vector reports = reportBean.getReports();
%>
<html>
<head>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=UTF-8">

</head>

<body topmargin="0" marginwidth="0" marginheight="0" onload="displayAlert();">
<form method="post" action="">
<h2 class="title"><nsgui:message key="nas_quota/quotasettop/href_5_dir"/></h2>

  <table>
    <tr>
        <td><%=NSUtil.space2nbsp(reportBean.getTitle())%></td>
    </tr>
    <tr>
        <td><%=reportBean.getBlocktime()%></td>
    </tr>
    <tr>
        <td><%=reportBean.getFiletime()%></td>
    </tr>
  </table>

<br>
 <%if (reports.size() >0){%>
  <table width="100%" border=1 >
    <tr>
      <th colspan="4"><nsgui:message key="nas_quota/userreport/td_limits1"/><%if (!unit.equals("--")) out.print("["+unit+"]");%></th>
      <th colspan="4"><nsgui:message key="nas_quota/userreport/td_limits2"/></th>
    </tr>
    <tr>
      <td align="center">
        <nsgui:message key="nas_quota/userreport/href_used"/>
      </td>
      <td align="center">
        <nsgui:message key="nas_quota/userreport/href_soft"/>
      </td>
      <td align="center">
        <nsgui:message key="nas_quota/userreport/href_hard"/>
      </td>
      <td align="center">
        <nsgui:message key="nas_quota/userreport/href_grace"/>
      </td>
      <td align="center">
        <nsgui:message key="nas_quota/userreport/href_used"/>
      </td>
      <td align="center">
        <nsgui:message key="nas_quota/userreport/href_soft"/>
      </td>
      <td align="center">
        <nsgui:message key="nas_quota/userreport/href_hard"/>
      </td>
      <td align="center">
        <nsgui:message key="nas_quota/userreport/href_grace"/>
      </td>
    </tr>
    <%for(int i=0; i<reports.size(); i++){
      
      QuotaInfo report = (QuotaInfo)reports.get(i);
      boolean bexceed = false;
      boolean fexceed = false;
      long busedInt = (new Long(report.getBlockUsed())).longValue();
      long bsoftInt = (new Long(report.getBlockSoftLimit())).longValue();
      long bhardInt = (new Long(report.getBlockHardLimit())).longValue();
      Long fusedInt = new Long(report.getFileUsed());
      Long fsoftInt = new Long(report.getFileSoftLimit());
      if((busedInt>bsoftInt)&&(bsoftInt != 0 ))
            bexceed = true;
      if((fusedInt.longValue()>fsoftInt.longValue())&&(fsoftInt.longValue() !=0 ))
            fexceed = true;
      String blockGraceTime = report.getBlockGraceTime();
      String fileGraceTime = report.getFileGraceTime();
      if (!blockGraceTime.equals("&nbsp;") && blockGraceTime.indexOf(":") < 0){
        if (blockGraceTime.indexOf("days") > 0){
            blockGraceTime = blockGraceTime.substring(0,blockGraceTime.indexOf("days"));
            blockGraceTime = reportBean.changeUnit((new Long(blockGraceTime)).longValue(),"--") + "days";
        }
        
      } 
      if (!fileGraceTime.equals("&nbsp;") && fileGraceTime.indexOf(":") < 0){
        if (fileGraceTime.indexOf("days") > 0){
            fileGraceTime = fileGraceTime.substring(0,fileGraceTime.indexOf("days"));
            fileGraceTime = reportBean.changeUnit((new Long(fileGraceTime)).longValue(),"--") + "days";
        }
      }
      %>
    <tr>
      <%if(bexceed){%>
      <td bgcolor=RED align="right"><%=reportBean.changeUnit(busedInt*NasConstants.BLOCK_SIZE,unit)%></td>
      <%}else{%>
      <td align="right"><%=reportBean.changeUnit(busedInt*NasConstants.BLOCK_SIZE,unit)%></td>
      <%}%>
      <td align="right"><%=reportBean.changeUnit(bsoftInt*NasConstants.BLOCK_SIZE,unit)%></td>
      <td align="right"><%=reportBean.changeUnit(bhardInt*NasConstants.BLOCK_SIZE,unit)%></td>
      <%if(bexceed){%>
      <td bgcolor=RED align="right"><%=blockGraceTime%></td>
      <%}else{%>
      <td align="right"><%=blockGraceTime%></td>
      <%}
      if(fexceed){%>
      <td bgcolor=RED align="right"><%=reportBean.changeUnit((new Long(report.getFileUsed())).longValue(),"--")%></td>
      <%}else{%>
      <td align="right"><%=reportBean.changeUnit((new Long(report.getFileUsed())).longValue(),"--")%></td>
      <%}%>
      <td align="right"><%=reportBean.changeUnit((new Long(report.getFileSoftLimit())).longValue(),"--")%></td>
      <td align="right"><%=reportBean.changeUnit((new Long(report.getFileHardLimit())).longValue(),"--")%></td>
      <%if(fexceed){%>
      <td bgcolor=RED align="right"><%=fileGraceTime%></td>
      <%}else{%>
      <td align="right"><%=fileGraceTime%></td>
      <%}%>
    </tr>
    <%}%>
  </table>
<%}%>
  <p></p>
         <input type="hidden" name="alertFlag" value="enable">
         <input type="hidden" name="pageFlag" value="dir">
</form>
</body>
</html>

