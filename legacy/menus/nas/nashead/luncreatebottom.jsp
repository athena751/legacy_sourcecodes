<!--
        Copyright (c) 2004-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: luncreatebottom.jsp,v 1.4 2005/10/24 01:13:39 liq Exp $" -->
<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java"  import="com.nec.sydney.beans.base.*" %>
<%@ page import="com.nec.sydney.framework.*
                 ,java.util.*
                 ,java.lang.*"%>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<%String src=request.getParameter("src");//the source module came from%>
<html>
<head>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=EUC-JP">
<script language="JavaScript" src="/nsadmin/common/common.js"></script>
<script src="../common/general.js"></script>
<script language="javaScript">
function initPage(){
    document.forms[0].lunset.disabled = true;
    if(parent.frames[1] 
       && parent.frames[1].document.forms[0]
       && parent.frames[1].document.forms[0].lun){
        document.forms[0].lunset.disabled = false;
    }
}
var heartBeatWin;
function onSub(){
    var src = "<%=request.getParameter("src")%>";
    if (src == "volume"||src=="replication"){
        if (parent.opener.isSubmitted()){
            return;
        }
    }
    if (src == "lvm"){
        if (!parent.opener.isSubmitted()){
            return;
        }
    }
    
    if(!isSubmitted()){
        var selectLunNum = 0;
        if(!parent.frames[1].document.forms[0].lun.length){
            //when only one lun existed
            if(parent.frames[1].document.forms[0].lun.checked){
                selectLunNum++;
            }
        }else{
            //Multiple lun existed
            var size = parent.frames[1].document.forms[0].lun.length;
            for(var i=0; i<size; i++){
                if(parent.frames[1].document.forms[0].lun[i].checked){
                    selectLunNum++;
                }
            }
        }
        if(selectLunNum == 0){
            alert("<nsgui:message key="nas_nashead/luninit/noselectlun"/>");
            return;
        }
        if(selectLunNum > parseInt(parent.frames[1].document.forms[0].nasHeadAvailableLun.value)){
            alert("<nsgui:message key="nas_nashead/luninit/exceedselectlun"/>");
            return;
        }
        if(confirm("<nsgui:message key="nas_nashead/luninit/confirmcreatelun"/>")){
            setSubmitted();
            heartBeatWin = openHeartBeatWin();
            if(src == "volume"||src=="replication"){
                parent.opener.heartBeatWin = heartBeatWin;
            }

            if ((!parent.opener ||!parent.opener.isSubmitted())&& (src == "link" || src == "init")){//from storage
                parent.frames[1].document.forms[0].submit();
            }else{ // from volume |lvm |replication
                if((src == "volume"||src=="replication")&&(!parent.opener.isSubmitted())){
                    parent.opener.setSubmitted();
                    parent.frames[1].document.forms[0].submit();   
                }
                if (src == "lvm" && parent.opener.isSubmitted()){
                    parent.opener.setSubmitted();
                    parent.frames[1].document.forms[0].submit();
                }
            }
        }
    }
}

function setParentActive(){
    var src = "<%=request.getParameter("src")%>";
    if(src == "volume"||src=="replication"){
        parent.opener.common_submitRecord = false;
    }
    if(src == "lvm"){
        parent.opener.submitRecord=true;
    }
}

</script>
</head>
<body onload="initPage()" onResize="resize();" onUnload="setParentActive();<%if(!src.equals("volume")||!src.equals("replication")){%>closePopupWin(heartBeatWin);<%}%>">
<form>
<input type=button name="lunset"  value="<nsgui:message key="common/button/submit"/>" onclick="onSub()" />
<%if(src.equals("volume")||src.equals("replication")||src.equals("lvm")){%>
<input type="button" name="cancel" value="<nsgui:message key="common/button/close"/>" onclick="parent.close()">
<%}%>
</form>
</body>
</html>