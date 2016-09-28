<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: ddrschedulelist4nsview.jsp,v 1.1 2005/08/29 04:44:57 wangzf Exp $" -->


<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java"
    import="java.util.Vector,java.text.DecimalFormat
            ,com.nec.sydney.beans.ddr.DdrCommonUtil
            ,com.nec.sydney.beans.base.AbstractJSPBean
            ,com.nec.sydney.atom.admin.ddr.DdrScheduleInfo
            ,com.nec.sydney.atom.admin.ddr.DdrConstants
            ,com.nec.sydney.atom.admin.base.*
            ,com.nec.sydney.framework.*
            ,com.nec.nsgui.taglib.nssorttab.*" %>
<jsp:useBean id="schListBean" class="com.nec.sydney.beans.ddr.DdrSchListBean" scope="page"/>
<%AbstractJSPBean _abstractJSPBean = schListBean; %>
<%@include file="../../../menu/common/includeheader.jsp" %>
<%@taglib uri="taglib-nsgui" prefix="nsgui" %>
<%@ taglib uri="taglib-sorttable" prefix="nssorttab" %>
<HTML>
<HEAD>
<%@include file="../../../menu/common/meta.jsp" %>
<script language=JavaScript>
    function onDdrPairingList(){
        window.location = "<%=response.encodeURL("ddrpairinglist4nsview.jsp")%>";
    }

    function reloadPage(){
        if( !isSubmitted() ){
            return false;
        }
        setSubmitted();
        window.location = "<%=response.encodeURL("ddrschedulelist4nsview.jsp")%>?mvName=<%=schListBean.getMvName()%>&rvName=<%=schListBean.getRvName()%>";
    }    
</script>
<jsp:include page="../../../menu/common/wait.jsp"/>
</HEAD>
<BODY onload="displayAlert();">
    <h1 class="title"><nsgui:message key="nas_ddrschedule/common/h1"/></h1>
    <form name="ddrSchListForm" method="post">
        <input type="button" value="<nsgui:message key="common/button/back"/>"
                                    onclick="onDdrPairingList();" />
    <input type="button" name="refresh" value="<nsgui:message key="common/button/reload"/>" onclick="reloadPage()">
        <br>
        <h2 class="title"><nsgui:message key="nas_ddrschedule/common/h2_ddrschList"/>
            [MV : <%=schListBean.getMvName()%> RV : <%=schListBean.getRvName()%>]
        </h2>
        <br><br>
        <input type="hidden" name="beanClass" value="<%=schListBean.getClass().getName()%>" />
        <input type="hidden" name="alertFlag" value="enable" />
        <input type="hidden" name="operation" />
        <% Vector schList=schListBean.getDdrSchInfoList();
        if(schList==null||schList.isEmpty()){%>
            <br><br><nsgui:message key="nas_ddrschedule/ddrschlist/msg_noschedule"/>
        <%}else{%>
            <nssorttab:table tablemodel="<%=new ListSTModel(schList)%>" id="scheduleTable"
                    table="BORDER=1" sortonload="name">
                <nssorttab:column name="day" th="com.nec.sydney.beans.ddr.DdrScheduleTHeaderRender"
                                                  td="com.nec.sydney.beans.ddr.DdrScheduleTDataRender"
                                                  sortable="no">
                        <nsgui:message key="nas_snapshot/snapschedule/th_day"/>
                </nssorttab:column>
                <nssorttab:column name="hour" th="com.nec.sydney.beans.ddr.DdrScheduleTHeaderRender"
                                                  td="com.nec.sydney.beans.ddr.DdrScheduleTDataRender"
                                                  sortable="no">
                        <nsgui:message key="nas_snapshot/snapschedule/th_time"/>
                </nssorttab:column>                        
                <nssorttab:column name="action" th="com.nec.sydney.beans.ddr.DdrScheduleTHeaderRender"
                                                  td="com.nec.sydney.beans.ddr.DdrScheduleTDataRender"
                                                  sortable="no">
                        <nsgui:message key="nas_ddrschedule/ddrschlist/th_action"/>
                </nssorttab:column>
            </nssorttab:table>
        <%}//end of else%>
    </form>
</BODY>
</HTML>
