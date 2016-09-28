<!--
        Copyright (c) 2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: serverprotectdefaultextensiontop.jsp,v 1.1 2007/03/23 09:43:18 liul Exp $" -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="struts-bean" prefix="bean" %>
<%@ taglib uri="struts-html" prefix="html" %>
<html>
<head>
<%@include file="../../common/head.jsp" %>

<html:base/>
<script language="JavaScript" src="../../common/common.js"></script>
<script language="JavaScript">

function init(){
    if(window.parent.opener && !window.parent.opener.closed && window.parent.opener.document.forms[0]){
        
        var div=document.getElementById("extensionTable");
        var content='<table border="1" width="450">';
        var extensions=window.parent.opener.document.forms[0].elements["globalOption.defaultExtension"].value.split(',');
        var arr = new Array(); 
        for (var i = 0; i < extensions.length; i++){
            arr[i] = extensions[i]; 
        }
        arr.sort();
        var extension="";
        for(var i = 0; i < arr.length; i++){
            extension = arr[i];
            if(extension==""){
                continue;
            }
            extension=extension.replace(/^\./,"");
            if(extension==""){
                extension='<bean:message key="serverprotect.extension.none"/>';
            }      
            if(i%5==0){
                if(i==arr.length-1){
                    content=content+'<tr><td width="20%">'+extension+'</td><td width="20%">&nbsp;</td><td width="20%">&nbsp;</td><td width="20%">&nbsp;</td><td width="20%">&nbsp;</td></tr>';
                }else{
                    content=content+'<tr><td width="20%">'+extension+"</td>";
                }    
            }else if(i%5==1){
                if(i==arr.length-1){
                    content=content+'<td width="20%">'+extension+'</td><td width="20%">&nbsp;</td><td width="20%">&nbsp;</td><td width="20%">&nbsp;</td>';
                }else{
                    content=content+'<td width="20%">'+extension+"</td>";
                }
            }else if(i%5==2){
                if(i==arr.length-1){
                    content=content+'<td width="20%">'+extension+'</td><td width="20%">&nbsp;</td><td width="20%">&nbsp;</td></tr>';
                }else{
                    content=content+'<td width="20%">'+extension+"</td>";
                }
            }else if(i%5==3){
                if(i==arr.length-1){
                    content=content+'<td width="20%">'+extension+'</td><td width="20%">&nbsp;</td></tr>';
                }else{
                    content=content+'<td width="20%">'+extension+"</td>";
                }
            }else if(i%5==4){
                content=content+'<td width="20%">'+extension+"</td></tr>";
            }
        }
        content=content+"</table>";
        div.innerHTML=content;
        
    }
    return true;
}
</script>
</head>

<body onload="init();setHelpAnchor('nvavs_realtimescan_7');" onUnload="setHelpAnchor('nvavs_realtimescan_2');" >
<h1 class="title"><bean:message key="serverprotect.common.h1"/></h1>
<h2 class="title"><bean:message key="serverprotect.title.defaultlist"/></h2>

<div id="extensionTable"></div>

</body>
</html> 