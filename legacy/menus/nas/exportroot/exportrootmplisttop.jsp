<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: exportrootmplisttop.jsp,v 1.1 2005/08/22 05:39:17 wangzf Exp $" -->
<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java" import="java.util.*,com.nec.sydney.beans.exportroot.EGMountPointListBean
                            ,com.nec.sydney.beans.base.AbstractJSPBean
                            ,com.nec.sydney.atom.admin.base.*
                            ,com.nec.sydney.atom.admin.exportroot.*
                            ,com.nec.nsgui.action.base.NSActionConst
                            ,com.nec.nsgui.action.base.NSActionUtil" %>
<%@ page import="com.nec.sydney.framework.*" %>

<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<jsp:useBean id="EGMPListBean" class="com.nec.sydney.beans.exportroot.EGMountPointListBean" scope="page"/>
<jsp:setProperty name="EGMPListBean" property="*" />
<% AbstractJSPBean _abstractJSPBean = EGMPListBean; %>
<%@include file="../../../menu/common/includeheader.jsp" %>

<%
    boolean isNsview = NSActionUtil.isNsview(request);
    int mountPointNumber = 0;
    Vector mountPointList = EGMPListBean.getMountPointList();
    if(mountPointList!=null){
        mountPointNumber = mountPointList.size();
    }
    String localDomain = EGMPListBean.getLocalDomain();
    String netBios =  EGMPListBean.getNetBios();
    String securityMode = EGMPListBean.getSecurityMode();
    String selectedCodePage = EGMPListBean.getSelectedCodePage();
    String exportGroup = EGMPListBean.getExportRootPath();
    String exportGroupName = exportGroup.replaceFirst("/export/", "");
%>

<HTML>
<head>
<title><nsgui:message key="nas_filesystem/FSMountPoint/h3_mp"/></title>
<%@include file="../../../menu/common/meta.jsp" %>
<script language="JavaScript">
var loaded = 0;
var mplistLen = <%=mountPointNumber%>;
    function gotoEGList(){
        if( !isSubmitted() ){
            return false;
        }
        setSubmitted();  
        <% if(isNsview) {%>
            parent.location="<%= response.encodeURL("exportRoot4nsview.jsp") %>";
        <% } else {%>
            parent.location="<%= response.encodeURL("exportRoot.jsp") %>";
        <% } %>
    }

    function reloadPage(){
        if( !isSubmitted() ){
            return false;
        }
        setSubmitted();
        window.location="<%= response.encodeURL("exportrootmplisttop.jsp?exportgroup=" + exportGroupName + "&codepage=" + selectedCodePage) %>";
    }
 
    function checkStatus(radioBtn, nfsDetail,cifsDetail,authDetail,scheduleDetail,filesetDetail){
        if(!parent.frames[1] || parent.frames[1].loaded != 1) {
            return;
        }
        parent.frames[1].mpInfo = radioBtn.value;
        if(nfsDetail == "true"){
            enableButton(parent.frames[1].document.forms[0].nfs);
        }
        else{
            disableButton(parent.frames[1].document.forms[0].nfs);
        }
        if(cifsDetail == "true"){
            enableButton(parent.frames[1].document.forms[0].cifs);
        }
        else{
            disableButton(parent.frames[1].document.forms[0].cifs);
        }
        if(authDetail == "true"){
            enableButton(parent.frames[1].document.forms[0].usermapping);
        }
        else{
            disableButton(parent.frames[1].document.forms[0].usermapping);
        }
        if(scheduleDetail == "true"){
            enableButton(parent.frames[1].document.forms[0].snapshot);
        }
        else{
            disableButton(parent.frames[1].document.forms[0].snapshot);
        }
        if(filesetDetail == "true"){
            enableButton(parent.frames[1].document.forms[0].replication);
        }
        else{
            disableButton(parent.frames[1].document.forms[0].replication);
        }
    }

    function enableButton(bName){
        bName.disabled=0;
    }
    function disableButton(bName){
        bName.disabled=1;
    }
    
    function init() {
        loaded = 1;
        if(mplistLen==1){
            document.EGmountPointForm.mpRadio.click();
        }else{
            for(var i=0; i<mplistLen; i++){
                if(document.EGmountPointForm.mpRadio[i].checked){
                    document.EGmountPointForm.mpRadio[i].click();
                    break;
                }
            }
        }
        if(parent.frames[1] && parent.frames[1].loaded == 1) {
            parent.frames[1].document.forms[0].localDomain.value = document.EGmountPointForm.localDomain.value;
            parent.frames[1].document.forms[0].netBios.value = document.EGmountPointForm.netBios.value;
            parent.frames[1].document.forms[0].securityMode.value = document.EGmountPointForm.securityMode.value;
            parent.frames[1].document.forms[0].codepage.value = document.EGmountPointForm.codepage.value;
        }        
    }
</script>
<jsp:include page="../../../menu/common/wait.jsp"/>
</head>

<body onload="init();">
<h1 class="title"><nsgui:message key="nas_exportroot/exportroot/h1"/></h1>
  <form name="EGmountPointForm" method="post" action="" >
    <input type="hidden" name="localDomain" value="<%=localDomain%>">
    <input type="hidden" name="netBios" value="<%=netBios%>">
    <input type="hidden" name="securityMode" value="<%=securityMode%>">
    <input type="hidden" name="codepage" value="<%=selectedCodePage%>">
    <input type="button" name="eglist" value="<nsgui:message key="common/button/back"/>" onclick="gotoEGList()">
    <input type="button" name="refresh" value="<nsgui:message key="common/button/reload"/>" onclick="reloadPage()">
<h2 class="title"><nsgui:message key="nas_exportroot/exportroot/h2_exportdetail"/>
[<%=exportGroup%>]
</h2>

<h3 class="title"><nsgui:message key="nas_mapd/nt/domain_name"/></h3>
<table border=1>
    <TR>
    <TH align=left><nsgui:message key="nas_mapd/nt/domain_name"/></TH>
    <TD align=left>
    <%=(localDomain.equals(""))?NSMessageDriver.getInstance().getMessage(session, "nas_mapd/common/not_set"):localDomain%>&nbsp;&nbsp;&nbsp;&nbsp;
    </TD>
    </TR>
    <TR>
    <TH align=left><nsgui:message key="nas_mapd/nt/netbios"/></TH>
    <TD align=left>
    <%=(netBios.equals(""))?NSMessageDriver.getInstance().getMessage(session, "nas_mapd/common/not_set"):netBios%>&nbsp;&nbsp;&nbsp;&nbsp;
    </TD>
    </TR>
</table>

<h3 class="title"><nsgui:message key="nas_exportroot/exportroot/h3_volume"/></h3>
    
<%
if(mountPointNumber == 0)
{
    out.print(NSMessageDriver.getInstance().getMessage(session, "nas_mapd/udb/nomountpoint"));
}
else{%>     
    <table border=1>
        <TR>
            <th>&nbsp;</th>
            <th><nsgui:message key="nas_exportroot/exportroot/th_volume"/></th>
            <th><nsgui:message key="nas_filesystem/mountPointConf/h2"/></th>
            <th><nsgui:message key="nas_filesystem/FSMountPoint/th_type"/></th>
            <th><nsgui:message key="nas_quota/quotasettop/h1"/></th>
            <th><nsgui:message key="nas_mapd/common/h1_mapd"/></th>
            <th><nsgui:message key="nas_nfs/common/h1"/></th>
            <th><nsgui:message key="nas_cifs/common/h1_cifs"/></th>
            <th><nsgui:message key="nas_http/common/h1"/></th>
            <th><nsgui:message key="nas_ftp/common/h1"/></th>
            <th><nsgui:message key="nas_snapshot/snapshow/h3_schedule"/></th>
            <th><nsgui:message key="nas_filesystem/FSVolumeSelect/h1_replication"/></th>
        </TR>
        <%
        EGMountPointInfo mountPointInformation;
        String hexMountPoint = "";
        String mountStatus = "";
        String fsType = "";
        boolean hasNFS = false;
        boolean hasCIFS = false;
        boolean hasAuth = false;
        boolean hasSchedule = false;
        String quotaStatus = "";
        String filesetType = "";
        String region = "";
        String domainType = "OtherDomain";
        boolean hasFTP=false;
        boolean hasHTTP=false;
        
        for(int i=0; i<mountPointNumber; i++) {
            String mountPointForDisplay = "";
            String mountStatusForDisplay = "<br>";
            String fsTypeForDisplay = "";
            String hasNFSForDisplay = "<br>";
            String hasCIFSForDisplay = "<br>";
            String hasAuthForDisplay = "<br>";
            String hasScheduleForDisplay = "<br>";
            String quotaStatusForDisplay = "<br>";
            String filesetTypeForDisplay = "<br>";
            String hasFTPForDisplay="<br>";
            String hasHTTPForDisplay="<br>";

            mountPointInformation = (EGMountPointInfo)mountPointList.get(i);
            hexMountPoint = mountPointInformation.getHexMountPoint();
            mountPointForDisplay = NSUtil.hStr2EncodeStr(hexMountPoint,selectedCodePage,NasConstants.BROWSER_ENCODE).trim();
            mountStatus = mountPointInformation.getMountStatus();
            if (mountStatus.equalsIgnoreCase("Mounted")) {
                mountStatusForDisplay = "<img border=\"0\" src=\""+ NSActionConst.PATH_OF_CHECKED_GIF +"\" />";
            }
            fsType = mountPointInformation.getFsType();
            if (fsType.equalsIgnoreCase("sxfs")) {
                fsTypeForDisplay = NSMessageDriver.getInstance().getMessage(session, "nas_filesystem/fileSystemConf/radio_unix");
            } else {
                fsTypeForDisplay = NSMessageDriver.getInstance().getMessage(session, "nas_filesystem/fileSystemConf/radio_nt");
            }
            hasNFS = mountPointInformation.getHasNFS();
            if (hasNFS) {
                hasNFSForDisplay = "<img border=\"0\" src=\""+ NSActionConst.PATH_OF_CHECKED_GIF +"\" />";
            }
            hasCIFS = mountPointInformation.getHasCIFS();
            if (hasCIFS) {
                hasCIFSForDisplay = "<img border=\"0\" src=\""+ NSActionConst.PATH_OF_CHECKED_GIF +"\" />";
            }
            hasAuth = mountPointInformation.getHasAuth();
            if (hasAuth) {
                hasAuthForDisplay = "<img border=\"0\" src=\""+ NSActionConst.PATH_OF_CHECKED_GIF +"\" />";
                if(mountPointInformation.getRegion().startsWith("ldu:")){
                    domainType = "LDAP";
                }
            }
            hasSchedule = mountPointInformation.getHasSchedule();
            if (hasSchedule) {
                hasScheduleForDisplay = "<img border=\"0\" src=\""+ NSActionConst.PATH_OF_CHECKED_GIF +"\" />";
            }
            quotaStatus = mountPointInformation.getQuotaStatus();
            if (quotaStatus.equalsIgnoreCase("on")) {
                quotaStatusForDisplay = "<img border=\"0\" src=\""+ NSActionConst.PATH_OF_CHECKED_GIF +"\" />";
            }
            filesetType = mountPointInformation.getFilesetType();
            if (!filesetType.equalsIgnoreCase("-")) {
                filesetTypeForDisplay = "<img border=\"0\" src=\""+ NSActionConst.PATH_OF_CHECKED_GIF +"\" />";
            }
            
            hasFTP=mountPointInformation.getHasFtp();
            if (hasFTP) {
                hasFTPForDisplay = "<img border=\"0\" src=\""+ NSActionConst.PATH_OF_CHECKED_GIF +"\" />";
            }
            
            hasHTTP=mountPointInformation.getHasHttp();
            if (hasHTTP) {
                hasHTTPForDisplay = "<img border=\"0\" src=\""+ NSActionConst.PATH_OF_CHECKED_GIF +"\" />";
            }
            
            
            String mpInfor =  hexMountPoint + "," + mountPointForDisplay + "," + filesetType + "," + 
            ((hasNFS)?"true":"false") + "," + ((hasCIFS)?"true":"false") + "," + 
            ((hasAuth)?"true":"false") + "," + ((hasSchedule)?"true":"false") + "," + 
            ((!filesetType.equals("-"))?"true":"false") + "," + domainType + "," + fsType;
        %>
        <tr>
            <td nowrap>
              <input type="radio" name="mpRadio" id="mpRadio<%=i%>" value="<%=mpInfor%>" <%=(i==0)?"checked":""%>
              onclick="checkStatus(this, '<%=hasNFS%>', '<%=hasCIFS%>', '<%=hasAuth%>', '<%=hasSchedule%>', '<%=(!filesetType.equals("-"))?true:false%>')">
            </td>
            <td nowrap>
                <label for="mpRadio<%=i%>"><%=mountPointForDisplay%></label>
            </td>
            <td nowrap>
               <center>
                <%=mountStatusForDisplay%>
               </center>
            </td>
            <td nowrap>
                <%=fsTypeForDisplay%>
            </td>
            <td nowrap>
                <center>
                <%=quotaStatusForDisplay%>
                </center>
            </td>
            <td nowrap>
                <center>
                <%=hasAuthForDisplay%>
                </center>
            </td>
            <td nowrap>
                <center>
                <%=hasNFSForDisplay%>
                </center>
            </td>
            <td nowrap>
                <center>
                <%=hasCIFSForDisplay%>
                </center>
            </td>
            <td nowrap>
                <center>
                <%=hasHTTPForDisplay%>
                </center>
            </td>
            <td nowrap>
                <center>
                <%=hasFTPForDisplay%>
                </center>
            </td>
            <td nowrap>
                <center>
                <%=hasScheduleForDisplay%>
                </center>
            </td>
            <td nowrap>
                <center>
                <%=filesetTypeForDisplay%>
                </center>
            </td>
        </tr>
        <% }  %>
    </table>
<%}%>        
    </form> 
</body>
</HTML>
