<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: ddrmultischeduleaddmiddle.jsp,v 1.2 2004/09/09 07:09:22 wangw Exp $" -->
<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java"  import="com.nec.sydney.beans.base.AbstractJSPBean
                                ,com.nec.nsgui.taglib.nssorttab.SortTableModel
                                ,com.nec.nsgui.taglib.nssorttab.ListSTModel
                                ,com.nec.sydney.framework.*
                                ,java.util.Vector"%>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<%@ taglib uri="taglib-sorttable" prefix="nssorttab" %>
<jsp:useBean id="ddrMultiAddBean" class="com.nec.sydney.beans.ddr.DdrScheduleAddBean" scope="page"/>
<% AbstractJSPBean _abstractJSPBean = ddrMultiAddBean; %>
<%@ include file="../../../menu/common/includeheader.jsp" %>

<html>
<head>
<%@include file="../../../menu/common/meta.jsp" %>
<%Vector unSchPairList = ddrMultiAddBean.getUnSchedulePair();%>
<script language="javaScript">
var loaded = 0;
function middleFrameInit(){
    loaded = 1;
    if(parent.topframe && parent.topframe.loaded
            && parent.topframe.document.forms[0].select
            && parent.topframe.document.forms[0].unselect){
        <%if(unSchPairList.isEmpty()){%>
            parent.topframe.document.forms[0].select.disabled = true;
            parent.topframe.document.forms[0].unselect.disabled = true;
        <%}else{%>
            parent.topframe.document.forms[0].select.disabled = false;
            parent.topframe.document.forms[0].unselect.disabled = false;
        <%}%>
    }
    if(parent.bottomframe && parent.bottomframe.loaded 
            && parent.bottomframe.document.forms[0].addSchedule){
        <%if(unSchPairList.isEmpty()){%>
            parent.bottomframe.document.forms[0].addSchedule.disabled = true;
        <%}else{%>
            parent.bottomframe.document.forms[0].addSchedule.disabled = false;
        <%}%>
    }
}
</script>
</head>
<body onload="middleFrameInit();">
<form name="ddrBatchMiddleForm" method="post">
    <%if(unSchPairList.isEmpty()){%>       
        <p><nsgui:message key="nas_ddrschedule/alert/no_unpair"/></p>
    <%}else{%>       
        <nssorttab:table tablemodel="<%=new ListSTModel(unSchPairList)%>" id="batchpairingTable"
                table="BORDER=1" titleTrNum="2" sortonload="mvName">
            <nssorttab:column name="pairCheckbox" th="com.nec.sydney.beans.ddr.DdrMVolumeTHeaderRender"
                                                td="com.nec.sydney.beans.ddr.DdrTChkBoxRender"
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
        </nssorttab:table>
    <%}//end of else%>
</form>
</body>
</html>
