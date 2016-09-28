<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: userreport.jsp,v 1.2303 2005/09/08 08:22:55 cuihw Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java" import="com.nec.sydney.beans.base.*,java.util.*,com.nec.sydney.atom.admin.base.*,com.nec.sydney.atom.admin.quota.*"%>
<%@ page import="com.nec.sydney.framework.*" %>

<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<jsp:useBean id="reportBean" class="com.nec.sydney.beans.quota.GetReportBean" scope="page"/>
<%AbstractJSPBean _abstractJSPBean = reportBean; %>
<%@include file="../../../menu/common/includeheader.jsp" %>

<%String commandid = request.getParameter("commandid");
  String type = request.getParameter("type");
  String keyword = request.getParameter("keyword");
  String dispkey = "&nbsp;ID&nbsp;";
  String unit = request.getParameter("unit");
  String displayControl = request.getParameter("displayControl");  //added by maojb on 2003.8.4

  if (unit == null || unit.equals("")){
    unit = "--";
  } 
  if(type.equals("id")){
     dispkey = "&nbsp;ID&nbsp;";
  }else if(type.equals("name")){
    //dispkey = "Name";
    dispkey = NSMessageDriver.getInstance().getMessage(session, "nas_quota/userreport/th_name");
  }
  boolean reverse = Boolean.valueOf(request.getParameter("reverse")).booleanValue();
  Vector reports = reportBean.getReports();
  QuotaInfo template = reportBean.getTemplate();
  boolean byid = true;
  boolean bybused = true;
  boolean bybsoft = true;
  boolean bybhard = true;
  boolean bybgrace = true;
  boolean byfused = true;
  boolean byfsoft = true;
  boolean byfhard = true;
  boolean byfgrace = true;
  if(keyword.equals("id")){
                 byid = !reverse;
           }else if(keyword.equals("bused")){
                 bybused = !reverse;
           }else if(keyword.equals("bsoft")){
                 bybsoft = !reverse;
           }else if(keyword.equals("bhard")){
                 bybhard = !reverse;
           }else if(keyword.equals("bgrace")){
                 bybgrace = !reverse;
           }else if(keyword.equals("fused")){
                 byfused = !reverse;
           }else if(keyword.equals("fsoft")){
                 byfsoft = !reverse;
           }else if(keyword.equals("fhard")){
                 byfhard= !reverse;
           }else {  /*keyword = "fgrace" */
                 byfgrace = !reverse;
           }
%>
<html>
<head>
<title>User Report</title>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=EUC-JP">

<script language="JavaScript">
<%
    if(reportBean.getAlertFlag()){
%>
    var replace = "<%=reportBean.getExceedLimit()%>";
    var mess=<nsgui:message key="nas_quota/alert/exceed_limit" separate="true">
                  <nsgui:replacement value="replace"/>
              </nsgui:message>;
    alert(mess);
<%  } %>

/*added by maojb on 2003.8.1 */
var displayControl="<%=displayControl%>";


function onIDSort()
{
    window.location = "userreport.jsp?keyword=id&reverse=<%=byid%>&commandid=<%=commandid%>&type=<%=type%>&displayControl="+displayControl+"&unit=<%=unit%>";
}
function onByteUsedSort()
{
    window.location = "userreport.jsp?keyword=bused&reverse=<%=bybused%>&commandid=<%=commandid%>&type=<%=type%>&displayControl="+displayControl+"&unit=<%=unit%>";
}
function onByteSoftSort()
{
    window.location = "userreport.jsp?keyword=bsoft&reverse=<%=bybsoft%>&commandid=<%=commandid%>&type=<%=type%>&displayControl="+displayControl+"&unit=<%=unit%>";
}
function onByteHardSort()
{
    window.location = "userreport.jsp?keyword=bhard&reverse=<%=bybhard%>&commandid=<%=commandid%>&type=<%=type%>&displayControl="+displayControl+"&unit=<%=unit%>";
}
function onByteGraceSort()
{
    window.location = "userreport.jsp?keyword=bgrace&reverse=<%=bybgrace%>&commandid=<%=commandid%>&type=<%=type%>&displayControl="+displayControl+"&unit=<%=unit%>";
}

function onFileUsedSort()
{
    window.location = "userreport.jsp?keyword=fused&reverse=<%=byfused%>&commandid=<%=commandid%>&type=<%=type%>&displayControl="+displayControl+"&unit=<%=unit%>";
}
function onFileSoftSort()
{
    window.location = "userreport.jsp?keyword=fsoft&reverse=<%=byfsoft%>&commandid=<%=commandid%>&type=<%=type%>&displayControl="+displayControl+"&unit=<%=unit%>";
}
function onFileHardSort()
{
    window.location = "userreport.jsp?keyword=fhard&reverse=<%=byfhard%>&commandid=<%=commandid%>&type=<%=type%>&displayControl="+displayControl+"&unit=<%=unit%>";
}
function onFileGraceSort()
{
    window.location = "userreport.jsp?keyword=fgrace&reverse=<%=byfgrace%>&commandid=<%=commandid%>&type=<%=type%>&displayControl="+displayControl+"&unit=<%=unit%>";
}
</script>
</head>

<body topmargin="0" marginwidth="0" marginheight="0" onload="displayAlert();">
<form method="post" action="">
<h2 class="title"><nsgui:message key="nas_quota/userreport/td_status"/></h2>

  <table>
    <tr>
        <td><%=reportBean.getTitle()%></td>
    </tr>
    <tr>
        <td><%=reportBean.getBlocktime()%></td>
    </tr>
    <tr>
        <td><%=reportBean.getFiletime()%></td>
    </tr>
  </table>
  <br>
  <%if(template!=null){%>
  <table width="100%" border="1">
    <tr>
        <th>&nbsp;</th>
        <th colspan="2"><nsgui:message key="nas_quota/userreport/th_bytes"/><%if (!unit.equals("--")) out.print("["+unit+"]");%></th>
        <th colspan="2"><nsgui:message key="nas_quota/userreport/th_files"/></th>
    </tr>
    <tr>
      <th><%=dispkey%></th>
      <th><nsgui:message key="nas_quota/userreport/td_1"/></th>
      <th><nsgui:message key="nas_quota/userreport/td_2"/></th>
      <th><nsgui:message key="nas_quota/userreport/td_3"/></th>
      <th><nsgui:message key="nas_quota/userreport/td_4"/></th>
    </tr>
    <tr>
      <td ><%=template.getID()%></td>
      <%
          //int--->Long modified by liuhy 2002/4/27
          long BlockSoftLimit = (new Long(template.getBlockSoftLimit())).longValue();
          long BlockHardLimit = (new Long(template.getBlockHardLimit())).longValue();
      %>
      <td align="right"><%=reportBean.changeUnit(BlockSoftLimit*NasConstants.BLOCK_SIZE,unit)%></td>
      <td align="right"><%=reportBean.changeUnit(BlockHardLimit*NasConstants.BLOCK_SIZE,unit)%></td>
      <td align="right"><%=reportBean.changeUnit((new Long(template.getFileSoftLimit())).longValue(),"--")%></td>
      <td align="right"><%=reportBean.changeUnit((new Long(template.getFileHardLimit())).longValue(),"--")%></td>
    </tr>
  </table>
  <%}%>
<br>
 <%if (reports.size() >0){%>
  <table width="100%" border=1 >
    <tr>
      <td>&nbsp;</td>
      <th colspan="4"><nsgui:message key="nas_quota/userreport/td_limits1"/><%if (!unit.equals("--")) out.print("["+unit+"]");%></th>
      <th colspan="4"><nsgui:message key="nas_quota/userreport/td_limits2"/></th>
    </tr>
    <tr>
      <td align="center">
        <input type="button" name="idsort" value=<%=dispkey%> onclick="onIDSort()">
      </td>
      <td align="center">
        <input type="button" name="byteusedsort" value="<nsgui:message key="nas_quota/userreport/href_used"/>" onclick="onByteUsedSort()">
      </td>
      <td align="center">
        <input type="button" name="bytesoftsort" value="<nsgui:message key="nas_quota/userreport/href_soft"/>" onclick="onByteSoftSort()">
      </td>
      <td align="center">
        <input type="button" name="bytehardsort" value="<nsgui:message key="nas_quota/userreport/href_hard"/>" onclick="onByteHardSort()">
      </td>
      <td align="center">
        <input type="button" name="bytegracesort" value="<nsgui:message key="nas_quota/userreport/href_grace"/>" onclick="onByteGraceSort()">
      </td>
      <td align="center">
        <input type="button" name="fileusedsort" value="<nsgui:message key="nas_quota/userreport/href_used"/>" onclick="onFileUsedSort()">
      </td>
      <td align="center">
        <input type="button" name="filesoftsort" value="<nsgui:message key="nas_quota/userreport/href_soft"/>" onclick="onFileSoftSort()">
      </td>
      <td align="center">
        <input type="button" name="filehardsort" value="<nsgui:message key="nas_quota/userreport/href_hard"/>" onclick="onFileHardSort()">
      </td>
      <td align="center">
        <input type="button" name="filegracesort" value="<nsgui:message key="nas_quota/userreport/href_grace"/>" onclick="onFileGraceSort()">
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
      <td><%=NSUtil.space2nbsp(HTMLUtil.sanitize(report.getID()))%></td>
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
         <input type="hidden" name="pageFlag" value="user">
</form>
</body>
</html>

