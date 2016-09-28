<!--
        Copyright (c) 2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: schedulescanaddusermapping.jsp,v 1.4 2008/05/16 04:59:00 chenjc Exp $" -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<html>
<head>
<%@include file="../../common/head.jsp" %>
<script language="JavaScript" src="../common/common.js"></script>
<script type="text/javascript">
var i=0;
var j=0;
var timer4SetValue;
setHelpAnchor("policy_user_mapping_native");
function submit(){
    i++;
    if(window.frames[0].document &&
       window.frames[0].document.mapdnativeform){
        window.clearInterval(timer4Submit);
        var selectObj=window.frames[0].document.mapdnativeform.nativeTypeSelectBox;
        var selectOption=selectObj.options;
        for(var i=0;i<selectOption.length;i++){
            if(selectOption[i].value=="NativePWDDomain4Win"){
                selectOption[i].selected=true;
                break;
            }
        }
        window.frames[0].document.mapdnativeform.target="scheduleScanAddUserBottom";
        window.frames[0].typeChange();
        timer4SetValue=window.setInterval(setValue,50);
        window.frames[0].location="/nsadmin/common/commonblank.html";
    }else if(window.frames[0].document.displayLogform || i>300){
        window.clearInterval(timer4Submit);
        //document.body.rows="100%,*";
        document.getElementById("userFrameSet").rows="100%,*";
    }
}
var timer4Submit=window.setInterval(submit,50);

function setValue(){
    j++;
    if(window.frames[1].document &&
       window.frames[1].document.mapdnativeform){
        window.clearInterval(timer4SetValue);
        window.frames[1].document.mapdnativeform.winDomain.value="<bean:write name="schedulescan_domainName" scope="session"/>";
        window.frames[1].document.mapdnativeform.netbiosName.value="<bean:write name="schedulescan_virtualComputerName" scope="session"/>";
        window.frames[1].document.mapdnativeform.target="_parent";
    }else if(window.frames[1].document.displayLogform || j>400){
        window.clearInterval(timer4SetValue);
    }
}

</script>
</head>
<Frameset id="userFrameSet" rows="0,*" border="0">
    <frame name="scheduleScanAddUserTop" src="../menu/nas/mapdnative/mapdnative.jsp?addType=win" frameborder="0" noresize="noresize">
    <frame name="scheduleScanAddUserBottom" src="/nsadmin/common/commonblank.html" frameborder="0">
</Frameset>
</html>