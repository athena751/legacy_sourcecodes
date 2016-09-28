 <!--
        Copyright (c) 2008 NEC Corporation
        NEC SOURCE CODE PROPRIETARY
        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tld/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tld/struts-nested.tld" prefix="nested" %>
<%@include file="../ddr/schedulecommon.js" %>
<%
	String moduleBundle = request.getParameter("moduleBundle");
%>
<script language="JavaScript">
function checkSchedule(form){
    if(form.elements["schedule.timeset"][0].checked==1){
        if(form.elements["schedule.day"][0].checked == 1 && !checkWeekDay(form)){
            alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n" +
        		"<bean:message key="ddr.alert.invalid_weekday" bundle="<%=moduleBundle%>"/>");
            return false;
        }else if(form.elements["schedule.day"][1].checked == 1 && !checkMonthDay(form)){           
            alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n" +
        		"<bean:message key="ddr.alert.invalid_monthday" bundle="<%=moduleBundle%>"/>");
            form.elements["schedule.monthday"].focus();
            return false;
        }
        if(!checkHour(form)){
            alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n" +
        		"<bean:message key="ddr.alert.invalid_hour" bundle="<%=moduleBundle%>"/>");
            form.elements["schedule.hour"].focus();
            return false;
        }
        if(!checkMinute(form)){       
            alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n" +
        		"<bean:message key="ddr.alert.invalid_minute" bundle="<%=moduleBundle%>"/>");
            form.elements["schedule.minute"].focus();
            return false;
        }
    }
    if(form.elements["schedule.timeset"][1].checked==1 && !checkDirectEdit(form)){
            alert("<bean:message key="common.alert.failed" bundle="common"/>" + "\r\n" +
        		"<bean:message key="ddr.alert.error_direct" bundle="<%=moduleBundle%>"/>");
        	form.elements["schedule.directedit"].focus();
    	return false;
    }
    return true;
}
</script>
<nested:nest property="schedule">
<table border=1 width="460px">
    <tr><td rowspan="4" align="left">
            <nested:radio styleId="timesetting0" 
                    property="timeset" value="indirectEdit" onclick="selectIndirectEdit(this.form);" />
        </td>
        <th rowspan="3" align="left">
            <label for="timesetting0"><bean:message key="ddr.schedule.th_day" bundle="<%=moduleBundle%>"/></label>
        </th>
        <td nowrap>
            <nested:radio styleId="day0" 
                property="day" value="weekday" onclick="selectWeekDay(this.form);"/>
            <label for="day0"><bean:message key="ddr.schedule.td_weekday" bundle="<%=moduleBundle%>"/></label>
        </td>
        <td nowrap>
        <%
        	String[] weekdayMsgKeys = {"sun","mon","tue","wed","thu","fri","sat"};
        %>
    	<logic:iterate id="currentDay" collection="<%=weekdayMsgKeys%>" indexId="indexId">
			<%String boxId="weekdayid" + indexId;%>
			<nested:multibox property="weekday" styleId="<%=boxId%>"><%=indexId%></nested:multibox>
		 	<label for="<%=boxId%>"><bean:message key="<%="ddr.schedule.display_"+currentDay%>" bundle="<%=moduleBundle%>"/></label>
   		</logic:iterate>
        </td>
    </tr>
    <tr>
        <td nowrap><nested:radio styleId="day1" 
                property="day" value="monthday" onclick="selectMonthDay(this.form);" />
            <label for="day1"><bean:message key="ddr.schedule.td_monthday" bundle="<%=moduleBundle%>"/></label>
        </td>
        <td>
            <nested:text property="monthday" size="30" maxlength="85" />
        </td>
    </tr>
    <tr><td colspan="2">
            <nested:radio styleId="day2" 
                property="day" value="daily" onclick="selectDaily(this.form);" />
            <label for="day2"><bean:message key="ddr.schedule.td_daily" bundle="<%=moduleBundle%>"/></label>
        </td>
    </tr>
    <tr><th align="left" nowrap><label for="timesetting0"><bean:message key="ddr.schedule.th_time" bundle="<%=moduleBundle%>"/></label>
        </th>
        <td colspan="2">
            <nested:text property="hour" maxlength="120" size="25" />
           <bean:message key="ddr.schedule.td_hour" bundle="<%=moduleBundle%>"/>&nbsp;&nbsp;
            <nested:text property="minute" maxlength="2" size="15" />
            <bean:message key="ddr.schedule.td_minute" bundle="<%=moduleBundle%>"/>
        </td>
    </tr>
    <tr><td>
            <nested:radio styleId="timesetting1"
                property="timeset" value="directedit" onclick="selectDirectEdit(this.form);"/>
        </td>
        <th colspan="2" align="left">
            <label for="timesetting1"><bean:message key="ddr.schedule.th_directedit" bundle="<%=moduleBundle%>"/></label>
        </th>
        <td>
        <nested:text property="directedit" maxlength="395" size="40"/><br>
    </td></tr>
</table>
</nested:nest>