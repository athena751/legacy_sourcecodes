<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: exportRootTop4nsview.jsp,v 1.1 2005/08/22 05:39:17 wangzf Exp $" -->
<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java" import="java.util.*
                    ,com.nec.sydney.beans.exportroot.ExportRootBean
            	    ,com.nec.sydney.framework.*
                    ,com.nec.sydney.beans.base.AbstractJSPBean
                    ,com.nec.sydney.atom.admin.exportroot.*
                    ,com.nec.sydney.atom.admin.base.*
                    ,com.nec.nsgui.action.base.NSActionConst" %>

<%@ taglib uri="taglib-nsgui" prefix="nsgui" %> 
<jsp:useBean id="exportRootBean" class="com.nec.sydney.beans.exportroot.ExportRootBean" scope="page"/>
<%AbstractJSPBean _abstractJSPBean =exportRootBean; %>
<%@include file="../../../menu/common/includeheader.jsp" %>

<%
    Vector exportList = exportRootBean.getExportRootList();
    int exportNumber = exportList.size();
%>
<HTML>
<HEAD>
<%@include file="../../../menu/common/meta.jsp" %>
<script src="../common/general.js"></script>
<!-- for displaying the waitting page -->
<jsp:include page="../../common/wait.jsp" /> 

<script language="JavaScript">
    var loaded = 0;
    function topFrameInit(){
        loaded = 1;
        <%if(exportNumber==0){%>
            if(parent.frames[1].loaded){
                parent.frames[1].document.forms[0].btnDetail.disabled=1;
                parent.frames[1].document.forms[0].btnModify.disabled=1;
            }
        <%}else{%>
            if(parent.frames[1].loaded){
                parent.frames[1].document.forms[0].btnDetail.disabled=0;
                parent.frames[1].document.forms[0].btnModify.disabled=0;
            }
        <%}%>
    }

    function onSelect (exportgroup, codepage, userdb, ntdomain, netbios, mounted){
        document.mainForm.exportgroup.value = exportgroup;    
        document.mainForm.codepage.value = codepage;    
        document.mainForm.userdb.value = userdb;    
        document.mainForm.ntdomain.value = ntdomain;    
        document.mainForm.netbios.value = netbios;    
        document.mainForm.mounted.value = mounted;     
    }

    function reloadPage() {
        if( !isSubmitted() ){
            return false;
        }
        setSubmitted();     
        window.location="<%=response.encodeURL("exportRootTop4nsview.jsp")%>";
    }
</script>
</HEAD>
<BODY onload="topFrameInit();setHelpAnchor('export_setup')">
<form  method="post" name="mainForm" action="" target="_parent">
<h1 class="title"><nsgui:message key="nas_exportroot/exportroot/h1"/></h1>
<input type="button" name="refresh" value="<nsgui:message key="common/button/reload"/>" onclick="reloadPage()">
<h2 class="title"><nsgui:message key="nas_exportroot/exportroot/h2"/></h2>

    <input type="hidden" name="act"> 
    <input type="hidden" name="exportgroup">
    <input type="hidden" name="codepage">
    <input type="hidden" name="userdb">
    <input type="hidden" name="ntdomain">
    <input type="hidden" name="netbios">
    <input type="hidden" name="mounted">
    

    <%if(exportNumber==0){%>
        <br><nsgui:message key="nas_exportroot/exportroot/msg_noexport"/>
    <%} else {%>
        <input type="hidden" name="hasExportGroup" value="1">
        <table border="1">
            <tr align="center">
                <th>&nbsp;</th>
                <th><nsgui:message key="nas_exportroot/exportroot/th_path"/></th>
                <th><nsgui:message key="nas_exportroot/exportroot/th_codepage"/></th>
                <th><nsgui:message key="nas_mapd/common/h1_mapd"/></th>
            </tr>
        <%
        ExportGroupInfo exportRootInformation;
        String exportRootName;
        String codepage;
        String codepageForDisplay;
        String userDB;
        String ntDomain;
        String netBios;
        String mounted;
        for(int i=0;i<exportNumber;i++){
            exportRootInformation = (ExportGroupInfo)exportList.get(i);
            exportRootName = exportRootInformation.getExportGroupName();
            codepage = exportRootInformation.getEncoding();
            userDB = exportRootInformation.getUserDB();
            ntDomain = exportRootInformation.getNtDomain();
            netBios = exportRootInformation.getNetBios();
            mounted = exportRootInformation.getMounted();
            codepageForDisplay = exportRootBean.codepageToDisplay(codepage);         
        %>

            <tr>
                  <td>
                    <script language="JavaScript">
                        if("<%=i%>"=="0"){
                            document.mainForm.exportgroup.value="<%=exportRootName%>"; 
                            document.mainForm.codepage.value="<%=codepage%>";
                            document.mainForm.userdb.value = "<%=userDB%>";
                            document.mainForm.ntdomain.value = "<%=ntDomain%>";
                            document.mainForm.netbios.value = "<%=netBios%>";
                            document.mainForm.mounted.value = "<%=mounted%>";
                        }
                    </script>
                    <input type="radio" id="egId<%=i%>" name="egRadio" 
                            <%=i == 0?"checked":""%>
                            onclick="onSelect('<%=exportRootName%>','<%=codepage%>','<%=userDB%>','<%=ntDomain%>','<%=netBios%>','<%=mounted%>')">
                  </td>
                <td>
	            <label for="egId<%=i%>">
                    <%=exportRootName%>
                    </label>
                </td>
                <td>
                    <%=codepageForDisplay%>
                </td>
                <td align="center">
		    <%=(userDB).equals("true")?"<img border=\"0\" src=\""+ NSActionConst.PATH_OF_CHECKED_GIF +"\" />":"<br>"%>
                </td>
            </tr> 
            <%
            }
            %>
            </table>
    <%
    }
    %>    
</form>

</BODY>
</HTML>

