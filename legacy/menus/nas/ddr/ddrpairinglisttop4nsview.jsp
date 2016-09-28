<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: ddrpairinglisttop4nsview.jsp,v 1.2 2005/08/30 07:04:47 wangw Exp $" -->

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

    function reloadPage(){
        if( isSubmitted() ){
            return false;
        }
        setSubmitted();
        parent.location = "ddrpairinglist4nsview.jsp";         
    }    
</script>
</head>
<body onload="topFrameInit();">
<form name="ddrListTopForm" method="post">
<h1 class="title"><nsgui:message key="nas_ddrschedule/common/h1"/></h1>
<input type="button" name="refresh" value="<nsgui:message key="common/button/reload"/>" onclick="reloadPage()">
<h2 class="title"><nsgui:message key="nas_ddrschedule/common/h2_ddrpairing"/></h2>
<%if(pairingInfo==null||pairingInfo.isEmpty()){%>
    <p><nsgui:message key="nas_ddrschedule/pairinglist/pairingIsEmpty"/></p>
    <br>
<%}else{%>
    <input type="hidden" name="ddrSign" value="ddrList">
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
