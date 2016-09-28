<!--
        Copyright (c) 2001-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: ldlistmid.jsp,v 1.3 2004/06/04 08:03:38 baiwq Exp" -->

<%@ page contentType="text/html;charset=EUC-JP" buffer="32kb"%>
<%@ page language="java"  import="com.nec.sydney.beans.base.*" %>
<%@ page import="com.nec.sydney.beans.base.AbstractJSPBean
                 ,com.nec.sydney.atom.admin.nashead.*
                 ,com.nec.sydney.atom.admin.base.*
                 ,com.nec.sydney.framework.*
                 ,java.util.*
                 ,java.lang.*"%>
<%@ page import="com.nec.nsgui.action.base.NSActionUtil"%>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>

<jsp:useBean id="bean" class="com.nec.sydney.beans.nashead.NasHeadListBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean = bean; %>
<jsp:setProperty name="bean" property="*" />
<%@ include file="../../../menu/common/includeheader.jsp" %>

<html>
<head>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=EUC-JP">
<script src="../common/general.js"></script>
<script language="javaScript">
function selectlun(obj){
    document.luninfo.selectedLun.value=obj.value;
}
function loadTmpFrame(){
    parent.frames[2].document.location="ldlistbottom_empty.html";
}

</script>
</head>
<body onload="displayAlert();loadTmpFrame();">
<%String forH3="";
String wwnn=bean.getWwnn();
String storageName=bean.getStorageName();
if (!wwnn.equals("")){
    if (storageName.equals("")){
        forH3 = "( "+wwnn+" -- ";
    }else{
        forH3 = "( "+storageName+" -- ";
    }
    forH3 = forH3+wwnn+" )";
}
%>

<h3 class="title"><nsgui:message key="nas_nashead/common/h3_lun"/><%=forH3%></h3>
<form name="luninfo" method="post" action="../../../menu/common/forward.jsp">
<input type="hidden" name="alertFlag" value="enable">
<input type="hidden" name="beanClass" value="<%=bean.getClass().getName()%>">
<input type="hidden" name="selectedLun" value="">
<input type="hidden" name="wwnn" value="<%=wwnn%>">
<%if (!bean.getGetddmapSuccess()){%>
    <br><nsgui:message key="nas_nashead/storage/getddmapfaild"/>
<%}else{
    Vector LunList = bean.getLunList();
    int lunNum = LunList.size();
    if (0 == lunNum){%>
        <br><nsgui:message key="nas_nashead/lun/nolun"/>
    <%}else{
        LunInfo lun= new LunInfo();%>
        <table border="1">
        <tr>
            <th><nsgui:message key="nas_nashead/lun/lun"/></th>
            <th><nsgui:message key="nas_nashead/lun/devicepath"/></th>
            <th><nsgui:message key="nas_nashead/lun/status"/></th>
            <th><nsgui:message key="nas_nashead/lun/lvm"/></th>
        </tr>
        <%for (int j=0;j<lunNum;j++){
        lun = (LunInfo)LunList.get(j);
        String lunN=lun.getLun();
        String lunForShow = NSActionUtil.getHexString(4, lunN);
        String connectStatus = lun.getConnectStatus().equals("y")?NSMessageDriver.getInstance().getMessage(session, "nas_nashead/lun/use")
                                :NSMessageDriver.getInstance().getMessage(session, "nas_nashead/lun/unuse");
        String lvm = lun.getLvm().equals("y")?NSMessageDriver.getInstance().getMessage(session, "nas_nashead/lun/use")
                                :NSMessageDriver.getInstance().getMessage(session, "nas_nashead/lun/unuse");
        
        String checked = "";
        if(0 == j){
            checked = "checked";
            %>
            <script language="javaScript">
            document.luninfo.selectedLun.value="<%=lunForShow%>,<%=lun.getDevicePath()%>,<%=lun.getLvm()%>,<%=lun.getPairStatus()%>";
            </script>
            <%
        }
        %>
        <tr>
            <td align="center"><label for="storageID<%=j%>"><%=lunForShow%></td>
            <td align="center"><%=lun.getDevicePath()%></td>
            <td align="center"><%=connectStatus%></td>
            <td align="center"><%=lvm%></label></td>
           
        </tr>
        <%}%>
        </table>
    <%}
}%>

</body>
</html>