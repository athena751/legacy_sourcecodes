<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: exportrootmplistbottom.jsp,v 1.2 2005/10/19 01:51:54 liyb Exp $" -->
<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page import="com.nec.sydney.framework.*" %>                            
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %> 
<html>
<head>
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=EUC-JP">
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<script language="javaScript">
var loaded = 0;
var mpInfo;
    
    function preparationForSubmit(hexString,mountPointName,filesetTypeName,fsType){
        document.forms[0].hexMountPoint.value = hexString;
        document.forms[0].mountPoint.value = mountPointName;
        document.forms[0].filesetType.value = filesetTypeName;
        document.forms[0].fsType.value = fsType;
    }
    
    var winhandler;
    var winhandler_ldap;
    function openWin(openLink,i)
    {
        var reg = /,/g;
        var mpArray = mpInfo.split(reg);
        
        preparationForSubmit(mpArray[0],mpArray[1],mpArray[2],mpArray[9]);

        if (i==5 && mpArray[8] == "LDAP"){
            if(winhandler_ldap==null ||winhandler_ldap.closed){
                winhandler_ldap=window.open("/nsadmin/common/commonblank.html","mpPop_ldap","toolbar=no,menubar=no,scrollbars=yes,width=550,height=500,resizable=yes");
            }
            winhandler_ldap.focus();
            document.forms[0].action=openLink;
            document.forms[0].target="mpPop_ldap";
        }
        else{
            if(winhandler==null ||winhandler.closed){
                if(i == 7){
                    winhandler=window.open("/nsadmin/common/commonblank.html","mpPop","toolbar=no,menubar=no,scrollbars=yes,width=700,height=300,resizable=yes");
                }else{
                    winhandler=window.open("/nsadmin/common/commonblank.html","mpPop","toolbar=no,menubar=no,scrollbars=yes,width=500,height=350,resizable=yes");
                } 
            }
            winhandler.focus();
            document.forms[0].action=openLink;
            document.forms[0].target="mpPop";
        }
        
        document.forms[0].submit();
    }

    function closePopupWin(){
        if (winhandler != null && !winhandler.closed){
            winhandler.close();
        }
        if (winhandler_ldap != null && !winhandler_ldap.closed){
            winhandler_ldap.close();
        }
    }
    
    function bottomFrameInit() {
        loaded = 1;
        if(parent.frames[0] && parent.frames[0].loaded == 1) {
            if(parent.frames[0].mplistLen==1){
                document.EGmountPointForm.mpRadio.click();
            }else{
                for(var i=0; i<parent.frames[0].mplistLen; i++){
                    if(parent.frames[0].document.EGmountPointForm.mpRadio[i].checked){
                        parent.frames[0].document.EGmountPointForm.mpRadio[i].click();
                        break;
                    }
                }
            }
            document.forms[0].localDomain.value = parent.frames[0].document.EGmountPointForm.localDomain.value;
            document.forms[0].netBios.value = parent.frames[0].document.EGmountPointForm.netBios.value;
            document.forms[0].securityMode.value = parent.frames[0].document.EGmountPointForm.securityMode.value;
            document.forms[0].codepage.value = parent.frames[0].document.EGmountPointForm.codepage.value;                  
        }
    }
       
</script>
<jsp:include page="../../common/wait.jsp" />
</head>
<body onload="bottomFrameInit();" onunload="closePopupWin();">
<form method="post">
    <input type="hidden" name="mountPoint">
    <input type="hidden" name="hexMountPoint">
    <input type="hidden" name="filesetType">
    <input type="hidden" name="fsType">
    <input type="hidden" name="localDomain">
    <input type="hidden" name="netBios">
    <input type="hidden" name="securityMode">
    <input type="hidden" name="codepage">   
    <input type="hidden" name="operation">    
    <input type="button" name="usermapping" disabled
        value="<nsgui:message key="nas_exportroot/exportroot/btn_userdb"/>" onclick="openWin('exportrootusermapping.jsp',5)"/>
    <input type="button" name="nfs" disabled
        value="<nsgui:message key="nas_exportroot/exportroot/btn_nfs"/>" onclick="openWin('exportrootnfs.jsp',3)"/>
    <input type="button" name="cifs" disabled
        value="<nsgui:message key="nas_exportroot/exportroot/btn_cifs"/>" onclick="openWin('exportrootcifs.jsp',4)"/>
    <input type="button" name="snapshot" disabled
        value="<nsgui:message key="nas_exportroot/exportroot/btn_snapshot"/>" onclick="openWin('exportrootsnapshot.jsp',6)"/>
    <input type="button" name="replication" disabled
        value="<nsgui:message key="nas_exportroot/exportroot/btn_replication"/>" onclick="openWin('exportrootfilesetlist.jsp',7)"/>
</form>
</body>
</html>