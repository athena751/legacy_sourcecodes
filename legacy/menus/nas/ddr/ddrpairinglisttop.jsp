<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: ddrpairinglisttop.jsp,v 1.6 2005/08/30 07:33:44 wangw Exp $" -->
<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java"  import="com.nec.sydney.beans.base.AbstractJSPBean
                                ,com.nec.sydney.atom.admin.ddr.DdrInfo
                                ,com.nec.sydney.atom.admin.base.*
                                ,com.nec.sydney.framework.*
                                ,com.nec.nsgui.taglib.nssorttab.SortTableModel
                                ,com.nec.nsgui.taglib.nssorttab.ListSTModel
                                ,java.util.Vector"%>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<%@ taglib uri="taglib-sorttable" prefix="nssorttab" %>
<jsp:useBean id="ddrPairingbean" class="com.nec.sydney.beans.ddr.DdrListBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean = ddrPairingbean; %>
<%@ include file="../../../menu/common/includeheader.jsp" %>

<html>
<head>
<%@include file="../../../menu/common/meta.jsp" %>
<script src="../../../common/common.js"></script>
<script language="javaScript">
var multiaddexists = 1;
var loaded = 0;
var addWin,delWin;
function onBatch(){
    addWin = window.open("<%=response.encodeURL("ddrmultischeduleadd.jsp")%>","DDRMultiAdd"
        ,"resizable=yes,statusbar=no,locationbar=no,menubar=no,toolbar=no,scrollbar=no,width=650,height=680");
    addWin.focus();
}
function onDelPairingList(){
    delWin = window.open("<%=response.encodeURL("ddrdeletepairinglist.jsp")%>","ddrDeletedPairing"
        ,"resizable=yes,statusbar=no,locationbar=no,menubar=no,toolbar=no,scrollbar=no,width=600,height=600");
    delWin.focus();
}
function topFrameInit(){
    loaded = 1;
    <%Vector pairingInfo = ddrPairingbean.getPairingInfo();
    if(pairingInfo==null||pairingInfo.isEmpty()){%>
        if(parent.frames[1].loaded){
            parent.frames[1].document.forms[0].openScheduleList.disabled=1;
        }
    <%}else{%>
        if(parent.frames[1].loaded){
            parent.frames[1].document.forms[0].openScheduleList.disabled=0;
        }
    <%}%>
    setHelpAnchor("ddr_schedule");
}

function closePopupWin(){
    if(addWin && !(addWin.closed)){
        addWin.close();
    }
    if(delWin && !(delWin.closed)){
        delWin.close();
    }
}
    function reloadPage(){
        parent.location = "ddrpairinglist.jsp";
    }    
</script>
</head>
<body onload="topFrameInit();" onUnload="closePopupWin();">
<form name="ddrListTopForm" method="post">
<h1 class="title"><nsgui:message key="nas_ddrschedule/common/h1"/></h1>
<input type="button" name="refresh" value="<nsgui:message key="common/button/reload"/>" onclick="reloadPage()" />
<h2 class="title"><nsgui:message key="nas_ddrschedule/common/h2_ddrpairing"/></h2>
<%if(pairingInfo==null||pairingInfo.isEmpty()){%>
    <%if(ddrPairingbean.hasDeletedPairing()){%>       
        <input type="button" name="deletePairing" 
            value="<nsgui:message key="nas_ddrschedule/pairinglist/button_deletedpairing"/>"
            onClick="onDelPairingList();" />
    <%}%>
    <p><nsgui:message key="nas_ddrschedule/pairinglist/pairingIsEmpty"/></p>
    <br>
<%}else{%>
    <input type="hidden" name="ddrSign" value="ddrList">
    <%if(ddrPairingbean.hasUnSchPairing()){%>       
        <input type="button" name="batchSetting" 
            value="<nsgui:message key="nas_ddrschedule/pairinglist/button_batchsetting"/>"
            onClick="onBatch();" />
    <%}%>
    <%if(ddrPairingbean.hasDeletedPairing()){%>       
        <input type="button" name="deletePairing" 
            value="<nsgui:message key="nas_ddrschedule/pairinglist/button_deletedpairing"/>"
            onClick="onDelPairingList();" />
    <%}%>
    <br><br>
    <nssorttab:table tablemodel="<%=new ListSTModel(pairingInfo)%>" id="pairTable"
            table="BORDER=1" titleTrNum="2" sortonload="mvName">
        <nssorttab:column name="pairingRadio" th="com.nec.sydney.beans.ddr.DdrMVolumeTHeaderRender"
                                            td="com.nec.sydney.beans.ddr.DdrTRadioRender"
                                            sortable="no">
        </nssorttab:column>
        <nssorttab:column name="mvName" th="com.nec.sydney.beans.ddr.DdrMVolumeTHeaderRender"
                                        td="com.nec.nsgui.taglib.nssorttab.STDataRender"
                                        sortable="yes">
                <nsgui:message key="nas_ddrschedule/pairinglist/button_volume"/>
        </nssorttab:column>
        <nssorttab:column name="mvLogicalDisk" th="com.nec.sydney.beans.ddr.DdrOtherTHeaderRender"
                                                td="com.nec.sydney.beans.ddr.DdrDiskTDataRender"
                                                sortable="yes">
                <nsgui:message key="nas_ddrschedule/pairinglist/button_logicdisk"/>
        </nssorttab:column>
        <nssorttab:column name="mvDiskArray" th="com.nec.sydney.beans.ddr.DdrOtherTHeaderRender"
                                            td="com.nec.sydney.beans.ddr.DdrDiskarrayTDataRender"
                                            sortable="yes">
                <nsgui:message key="nas_ddrschedule/pairinglist/button_diskarray"/>
        </nssorttab:column>
        <nssorttab:column name="rvName" th="com.nec.sydney.beans.ddr.DdrRVolumeTHeaderRender"
                                        td="com.nec.nsgui.taglib.nssorttab.STDataRender"
                                        sortable="yes">
                <nsgui:message key="nas_ddrschedule/pairinglist/button_volume"/>
        </nssorttab:column>
        <nssorttab:column name="rvLogicalDisk" th="com.nec.sydney.beans.ddr.DdrOtherTHeaderRender"
                                                td="com.nec.sydney.beans.ddr.DdrDiskTDataRender"
                                                sortable="yes">
                <nsgui:message key="nas_ddrschedule/pairinglist/button_logicdisk"/>
        </nssorttab:column>
        <nssorttab:column name="rvDiskArray" th="com.nec.sydney.beans.ddr.DdrOtherTHeaderRender"
                                            td="com.nec.sydney.beans.ddr.DdrDiskarrayTDataRender"
                                            sortable="yes">
                <nsgui:message key="nas_ddrschedule/pairinglist/button_diskarray"/>
        </nssorttab:column>
        <nssorttab:column name="isMvRvusing" th="com.nec.sydney.beans.ddr.DdrOtherTHeaderRender"
                                            td="com.nec.sydney.beans.ddr.DdrBooleanTDataRender"
                                            sortable="yes">
                <nsgui:message key="nas_ddrschedule/pairinglist/button_mvrvusing"/>
        </nssorttab:column>
        <nssorttab:column name="status" th="com.nec.sydney.beans.ddr.DdrStatusTHeaderRender"
                                        td="com.nec.sydney.beans.ddr.DdrStatusTDataRender"
                                        sortable="yes">
                <nsgui:message key="nas_ddrschedule/pairinglist/button_status"/>
        </nssorttab:column>
        <nssorttab:column name="hasSchedule" th="com.nec.sydney.beans.ddr.DdrStatusTHeaderRender"
                                        td="com.nec.sydney.beans.ddr.DdrBooleanTDataRender"
                                        sortable="yes">
                <nsgui:message key="nas_ddrschedule/pairinglist/button_schedule"/>
        </nssorttab:column>
    </nssorttab:table>
<%}//end of else%>
</form>
</body>
</html>
