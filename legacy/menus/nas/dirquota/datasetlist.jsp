<!--
        Copyright (c) 2001-2006 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: datasetlist.jsp,v 1.2309 2006/12/08 02:42:25 zhangjun Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page language="java" import="com.nec.sydney.beans.base.*,java.util.*,com.nec.sydney.atom.admin.quota.*,com.nec.sydney.atom.admin.base.*"%>
<%@ page import="com.nec.sydney.framework.*" %>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>

<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<jsp:useBean id="reportBean" class="com.nec.sydney.beans.quota.GetReportBean" scope="page"/>
<%AbstractJSPBean _abstractJSPBean = reportBean; %>
<%@include file="../../../menu/common/includeheader.jsp" %>

<%
  boolean isNsview = NSActionUtil.isNsview(request);
  String commandid = request.getParameter("commandid");
  String type = request.getParameter("type");
  String keyword = request.getParameter("keyword");
  if (keyword==null){
    keyword="id";
  }
  String dispkey = "&nbsp;ID&nbsp;";
  String unit = request.getParameter("unit");
  
  if (unit == null || unit.equals("")){
    unit = "--";
  } 

  boolean reverse = Boolean.valueOf(request.getParameter("reverse")).booleanValue();
  Vector reports = reportBean.getReports();
  QuotaInfo template = reportBean.getTemplate();
  boolean byid = true;
  boolean bydataset = true;
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
   }else if(keyword.equals("dataset")){
         bydataset = !reverse;
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
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=UTF-8">

<script language="JavaScript">
var loaded = 0;
<%
    if(reportBean.getAlertFlag()){
%>
    var replace = "<%=reportBean.getExceedLimit()%>";
    var mess=<nsgui:message key="nas_quota/alert/exceed_limit" separate="true">
                  <nsgui:replacement value="replace"/>
              </nsgui:message>;
    alert(mess);
<%  } %>

function onRadioClick(radio){
    var dataset = radio.value;
    if (radio.checked){
        if(parent.frames[2].document.forms[0]
           && parent.frames[2].document.forms[0].dataset
           && parent.frames[2].document.forms[0].dirquota){
            parent.frames[2].document.forms[0].dirquota.disabled = false;
            parent.frames[2].document.forms[0].dataset.value = dataset;
        }
        <%if(!isNsview){%>
        if(parent.frames[0].document.forms[0]
           && parent.frames[0].document.forms[0].dataset
           && parent.frames[0].document.forms[0].datasetdel){
            parent.frames[0].document.forms[0].datasetdel.disabled = false;
            parent.frames[0].document.forms[0].dataset.value = dataset;
        } 
        <%}else{%>
        if(parent.frames[0].document.forms[0]
           && parent.frames[0].document.forms[0].dataset){
            parent.frames[0].document.forms[0].dataset.value = dataset;
        } 
        <%}%>
    }   
}

function setDataSet(){
    loaded = 1;
    if (parent.frames[0].document.forms[0]
        && parent.frames[0].document.forms[0].dataset){
        parent.frames[0].document.forms[0].dataset.value = "";
    }
}

function onIDSort()
{
    if(!document.forms[0].idsort.disabled){
        window.location = "datasetlist.jsp?keyword=id&reverse=<%=byid%>";
    }
}
function onDataSetSort(){
    if(!document.forms[0].datasetsort.disabled){
        window.location = "datasetlist.jsp?keyword=dataset&reverse=<%=bydataset%>";
    }
}
function onByteUsedSort()
{
    if(!document.forms[0].byteusedsort.disabled){
        window.location = "datasetlist.jsp?keyword=bused&reverse=<%=bybused%>";
    }
}
function onByteSoftSort()
{
    if(!document.forms[0].bytesoftsort.disabled){
        window.location = "datasetlist.jsp?keyword=bsoft&reverse=<%=bybsoft%>";
    }
}
function onByteHardSort()
{
    if(!document.forms[0].bytehardsort.disabled){
        window.location = "datasetlist.jsp?keyword=bhard&reverse=<%=bybhard%>";
    }
}
function onByteGraceSort()
{
    if(!document.forms[0].bytegracesort.disabled){
        window.location = "datasetlist.jsp?keyword=bgrace&reverse=<%=bybgrace%>";
    }
}

function onFileUsedSort()
{
    if(!document.forms[0].fileusedsort.disabled){
        window.location = "datasetlist.jsp?keyword=fused&reverse=<%=byfused%>";
    }
}
function onFileSoftSort()
{
    if(!document.forms[0].filesoftsort.disabled){
        window.location = "datasetlist.jsp?keyword=fsoft&reverse=<%=byfsoft%>";
    }
}
function onFileHardSort()
{
    if(!document.forms[0].filehardsort.disabled){
        window.location = "datasetlist.jsp?keyword=fhard&reverse=<%=byfhard%>";
    }
}
function onFileGraceSort()
{
    if(!document.forms[0].filegracesort.disabled){
        window.location = "datasetlist.jsp?keyword=fgrace&reverse=<%=byfgrace%>";
    }
}
</script>
</head>

<body onload="displayAlert();parent.bottomframe.location='datasetbottom.jsp';setDataSet();">
<form method="post" action="">
<h2 class="title"><nsgui:message key="nas_dataset/datasetmiddle/h2_datasetlist"/></h2>
<%
String filesystem = (String)session.getAttribute(NasConstants.MP_SESSION_MOUNTPOINT);
%>
<h3><nsgui:message key="nas_quota/quotasettop/h2_filesystem"/>[<%=filesystem%>]</h3>
<%if (reports.size() > 0 ){%>

<table width="100%" border="1">
    <tr> 
      <th rowspan="2">&nbsp;</th>
      <th colspan="2"><nsgui:message key="nas_dataset/datasetmiddle/dataset"/></th>	  
      <th colspan="4"><nsgui:message key="nas_quota/userreport/td_limits1"/></th>
      <th colspan="4"><nsgui:message key="nas_quota/userreport/td_limits2"/></th>
    </tr>
    <tr> 
      <td align="center">
        <input type="button" name="idsort" value="<nsgui:message key="nas_dataset/datasetmiddle/id"/>" onclick="onIDSort()">
      </td>
      <td align="center">
        <input type="button" name="datasetsort" value="<nsgui:message key="nas_dataset/datasetmiddle/dir"/>" onclick="onDataSetSort()">
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
    <tr>      
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
      String dataset = report.getDataSet();
      String id = report.getID();
      %>
      <td>
        <input type="radio" name="radiobutton" id="radioID<%=i%>" value="<%=dataset%>" onClick="onRadioClick(this)" <%if(i==0) out.print("checked");%>>
      </td>
      <td align="right"><label for="radioID<%=i%>"><%=id%></label></td>
      <td><%=NSUtil.space2nbsp(HTMLUtil.sanitize(dataset))%></td>
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
<%} else{%>
    <nsgui:message key="nas_dataset/datasetmiddle/no_dataset"/>
<%}%>
<input type="hidden" name="alertFlag" value="enable"> 
</form>
</body>
</html>

