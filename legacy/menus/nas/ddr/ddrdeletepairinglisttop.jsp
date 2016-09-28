<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: ddrdeletepairinglisttop.jsp,v 1.1 2004/08/24 09:49:51 wangw Exp $" -->
<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java"  import="com.nec.sydney.beans.base.AbstractJSPBean
                                ,com.nec.sydney.atom.admin.base.*
                                ,com.nec.sydney.atom.admin.ddr.DdrInfo
                                ,com.nec.sydney.framework.*
                                ,java.util.Vector"%>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<jsp:useBean id="ddrDelPairingbean" class="com.nec.sydney.beans.ddr.DdrDelPairingListBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean = ddrDelPairingbean; %>
<%@ include file="../../../menu/common/includeheader.jsp" %>

<html>
<head>
<%@include file="../../../menu/common/meta.jsp" %>
<script language="javaScript">
function onDeleteone(delpairing){
    var displayPairing = delpairing.replace(/\s+/g,",");
    var confirmMsg = "<nsgui:message key="common/confirm"/>" +"\r\n"
                        +"<nsgui:message key="common/confirm/act"/>"
                        +"<nsgui:message key="common/button/delete"/>" +"\r\n"
                        +"<nsgui:message key="nas_ddrschedule/delpairinglist/confirm_pairing"/>"
                        +displayPairing;
    if( isSubmitted()&&confirm(confirmMsg) ){
        setSubmitted();
        document.ddrDelPairingTopForm.onepairing.value=delpairing;
        document.ddrDelPairingTopForm.operation.value="deleteone";
        return true;
    }
    return false;
}

function onDeleteall(){
    var confirmMsg = "<nsgui:message key="common/confirm"/>" +"\r\n"
                        +"<nsgui:message key="common/confirm/act"/>"
                        +"<nsgui:message key="nas_ddrschedule/delpairinglist/button_alldelete"/>";
    if( isSubmitted()&&confirm(confirmMsg) ){
        setSubmitted();
        document.ddrDelPairingTopForm.operation.value="deletemulti";
        return true;
    }
    return false;
}
</script>
<jsp:include page="../../common/wait.jsp" />
</head>
<body onload="displayAlert();">
<h1 class="title"><nsgui:message key="nas_ddrschedule/common/h1"/></h1>
<h2 class="title"><nsgui:message key="nas_ddrschedule/common/h2_ddrdelpairing"/></h2>
<form name="ddrDelPairingTopForm" target="ddrDeletedPairing" method="post" action="ddrdeletepairingforward.jsp">
    <input type="hidden" name="alertFlag" value="enable" />
<%Vector pairingInfo = ddrDelPairingbean.getDdrDelPairingist();
if(pairingInfo==null||pairingInfo.isEmpty()){%>
    <br><p><nsgui:message key="nas_ddrschedule/delpairinglist/msg_nopairing"/></p>
    <br>
<%}else{%>
    <input type="hidden" name="operation" />
    <input type="hidden" name="onepairing" />
    <input type="submit" name="deleteall" 
        value="<nsgui:message key="nas_ddrschedule/delpairinglist/button_alldelete"/>"
        onClick="return onDeleteall();" />
    <br><br>
    <table border="1">
        <tr>
            <th>&nbsp;&nbsp;</th>
            <th><nsgui:message key="nas_ddrschedule/delpairinglist/th_mv"/></th>
            <th><nsgui:message key="nas_ddrschedule/delpairinglist/th_rv"/></th>
        </tr>
        <%int pairingNum = pairingInfo.size();
        for (int i=0; i<pairingNum; i++){
            DdrInfo oneInfo = (DdrInfo)pairingInfo.get(i);
            String mvAndRv = oneInfo.getMvName()+" "+oneInfo.getRvName();
        %>
            <tr>
                <input type="hidden" name="multipairing" value="<%=mvAndRv%>" />
                <td align="center">
                    <input type="submit" name="deleteone" value="<nsgui:message key="common/button/delete"/>"
                        onclick="return onDeleteone('<%=mvAndRv%>');" />
                </td>
                <td align="center"><%=oneInfo.getMvName()%></td>
                <td align="center"><%=oneInfo.getRvName()%></td>
            </tr>
        <%}%>
    </table>
<%}//end of else%>
</form>
</body>
</html>
