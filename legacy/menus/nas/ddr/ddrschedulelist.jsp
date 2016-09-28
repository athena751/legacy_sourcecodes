<!--
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<!-- "@(#) $Id: ddrschedulelist.jsp,v 1.4 2005/08/29 09:23:33 wangw Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java"
    import="java.util.Vector,java.text.DecimalFormat
            ,com.nec.sydney.beans.ddr.DdrCommonUtil
            ,com.nec.sydney.beans.base.AbstractJSPBean
            ,com.nec.sydney.atom.admin.ddr.DdrScheduleInfo
            ,com.nec.sydney.atom.admin.ddr.DdrConstants
            ,com.nec.sydney.atom.admin.base.*
            ,com.nec.sydney.framework.*" %>
<jsp:useBean id="schListBean" class="com.nec.sydney.beans.ddr.DdrSchListBean" scope="page"/>
<%AbstractJSPBean _abstractJSPBean = schListBean; %>
<%@include file="../../../menu/common/includeheader.jsp" %>
<%@taglib uri="taglib-nsgui" prefix="nsgui" %>

<HTML>
<HEAD>
<%@include file="../../../menu/common/meta.jsp" %>
<script language=JavaScript>
var singleaddexists = 1;
function onDdrPairingList(){
    window.location = "<%=response.encodeURL("ddrpairinglist.jsp")%>";
}
var singleAdd;
function onAddSchOpen(){
    singleAdd = window.open("<%=response.encodeURL("ddrsinglescheduleadd.jsp?mvName="+schListBean.getMvName()+"&rvName="+schListBean.getRvName())%>"
        ,"ddrsingleadd","resizable=yes,statusbar=no,locationbar=no,menubar=no,toolbar=no,scrollbars=yes,width=620,height=500");
    singleAdd.focus();
}

function onDelSchedule(timeStr,count){
    var confirmMsg = "<nsgui:message key="common/confirm"/>" +"\r\n"
                        +"<nsgui:message key="common/confirm/act"/>"
                        +"<nsgui:message key="common/button/delete"/>" +"\r\n"
                        +"<nsgui:message key="nas_ddrschedule/ddrschlist/confirm_sch"/>"
                        +schTime[count];
    if( isSubmitted()&&confirm(confirmMsg) ){
        setSubmitted();
        document.ddrSchListForm.delTimeStr.value=timeStr;
        document.ddrSchListForm.operation.value="delete";
        return true;
    }
    return false;
}

function closePopupWin(){
    if(singleAdd && !(singleAdd.closed)){
        singleAdd.close();
    }
}
    function reloadPage(){
        window.location = "<%=response.encodeURL("ddrschedulelist.jsp")%>?mvName=<%=schListBean.getMvName()%>&rvName=<%=schListBean.getRvName()%>";
    }    
</script>
<jsp:include page="../../../menu/common/wait.jsp"/>
</HEAD>
<BODY onload="displayAlert();" onUnload="closePopupWin();">
    <h1 class="title"><nsgui:message key="nas_ddrschedule/common/h1"/></h1>
    <form name="ddrSchListForm" method="post" action="../../../menu/common/forward.jsp">
        <input type="button" value="<nsgui:message key="common/button/back"/>"
                                    onclick="onDdrPairingList();" />
        <input type="button" name="refresh" value="<nsgui:message key="common/button/reload"/>" onclick="reloadPage()" />
        <br>
        <h2 class="title"><nsgui:message key="nas_ddrschedule/common/h2_ddrschList"/>
            [MV : <%=schListBean.getMvName()%> RV : <%=schListBean.getRvName()%>]
        </h2>
        <input type="button" name="addSchedule" value="<nsgui:message key="common/button/add2"/>" 
                                    onclick="onAddSchOpen();"/>
        <br><br>
        <input type="hidden" name="beanClass" value="<%=schListBean.getClass().getName()%>" />
        <input type="hidden" name="alertFlag" value="enable" />
        <input type="hidden" name="operation" />
        <% Vector schList=schListBean.getDdrSchInfoList();
         if(schList==null||schList.isEmpty()){%>
            <br><br><nsgui:message key="nas_ddrschedule/ddrschlist/msg_noschedule"/>
            <script language=JavaScript>
                var schTime=new Array(0);
            </script>
        <%}else{%>
            <script language=JavaScript>
                var schTime=new Array(<%=schList.size()%>);
            </script>
            <input type="hidden" name="mvName" value="<%=schListBean.getMvName()%>" />
            <input type="hidden" name="rvName" value="<%=schListBean.getRvName()%>" />
            <input type="hidden" name="delTimeStr" />
            <table border="1">
            <tr>
            <th nowrap>&nbsp;</th>
            <th colspan="5" nowrap><nsgui:message key="nas_ddrschedule/ddrschlist/th_schTime"/></th>
            <th nowrap><nsgui:message key="nas_ddrschedule/ddrschlist/th_action"/></th>
            </tr>
            <%
             DdrScheduleInfo ddrSch;
             String scheduleMode;
             String scheduleAction;
             String dateStr;
             int schSize = schList.size();
             for(int i=0; i<schSize; i++){
                ddrSch = (DdrScheduleInfo)schList.get(i);%>
            <tr>
                <td nowrap>
                    <input type="submit" name="delSchedule" value="<nsgui:message key="common/button/delete"/>"
                        onclick="return onDelSchedule('<%=ddrSch.getDirectEditInfo()%>','<%=i%>')" />
                </td>
                <%String[] displayTimeStr = DdrCommonUtil.DdrSchedule4Display(ddrSch,session);
                if(displayTimeStr.length==5){%>
                    <td nowrap>&nbsp;<%=displayTimeStr[0]%>&nbsp;</td>
                    <td nowrap>&nbsp;<%=displayTimeStr[1]%>&nbsp;</td>
                    <td nowrap>&nbsp;<%=displayTimeStr[2]%>&nbsp;</td>
                    <td nowrap>&nbsp;<%=displayTimeStr[3]%>&nbsp;</td>
                    <td nowrap>&nbsp;<%=displayTimeStr[4]%>&nbsp;</td>
                    <script language=JavaScript>
                        schTime[<%=i%>]="<%=displayTimeStr[0]+"("+displayTimeStr[1]+") "
                                            +displayTimeStr[2]+"("+displayTimeStr[3]
                                            +displayTimeStr[4]+")"%>";
                    </script>
                <%}else if(displayTimeStr.length==4){%>
                    <td colspan=2 nowrap><%=displayTimeStr[0]%></td>
                    <td nowrap>&nbsp;<%=displayTimeStr[1]%>&nbsp;</td>
                    <td nowrap>&nbsp;<%=displayTimeStr[2]%>&nbsp;</td>
                    <td nowrap>&nbsp;<%=displayTimeStr[3]%>&nbsp;</td>
                    <script language=JavaScript>
                        schTime[<%=i%>]="<%=displayTimeStr[0]+" "
                                            +displayTimeStr[1]+"("+displayTimeStr[2]
                                            +displayTimeStr[3]+")"%>";
                    </script>
                <%}else{%>
                    <td colspan="5" nowrap>&nbsp;<%=displayTimeStr[0]%>&nbsp;</td>
                    <script language=JavaScript>
                        schTime[<%=i%>]="<%=displayTimeStr[0]%>";
                    </script>
                <%}%>
                <td nowrap>
                    <%=NSMessageDriver.getInstance().getMessage(session,"nas_ddrschedule/ddrschlist/td_"+ddrSch.getAction())%>
                    <%if(ddrSch.getSyncMode() != null ){%>
                        (<%=NSMessageDriver.getInstance().getMessage(session,"nas_ddrschedule/ddrschlist/td_"+ddrSch.getSyncMode())%>)
                    <%}%>
                </td>
            </tr>
            <%}//end of for circle%>
            </table>
       <% }//end of else%>
    </form>
</BODY>
</HTML>
