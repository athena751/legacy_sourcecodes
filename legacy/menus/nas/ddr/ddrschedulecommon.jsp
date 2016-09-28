<% 
/*
        Copyright (c) 2001-2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.

        "@(#) $Id: ddrschedulecommon.jsp,v 1.2 2005/08/29 09:33:49 wangw Exp $"
*/ 
%>

<%@page import="com.nec.sydney.framework.*"%>
<table border="1">
    <tr>
        <th align=left><nsgui:message key="nas_ddrschedule/schedule_add/action"/></th>
        <td>
        <%String act = request.getParameter("act");
        act = (act == null)?"replicate":act;
        %>
            <input type=radio <%=act.equals("replicate")?"checked":""%> name="act" value="replicate" 
                        id="actRepli" onclick="enableSyncMode()" />
            <label for="actRepli"><nsgui:message key="nas_ddrschedule/schedule_add/action_repli"/>
            </label>
            <input type=radio <%=act.equals("separate")?"checked":""%> name="act" value="separate"
                        id="actSep" onclick="disableSyncMode()" />
            <label for="actSep"><nsgui:message key="nas_ddrschedule/schedule_add/action_sepa"/>
            </label>
            <input type=radio name="act" <%=act.equals("repliandsper")?"checked":""%> value="repliandsper"
                        id="actRepAndSep" onclick="enableSyncMode()" />
            <label for="actRepAndSep"><nsgui:message key="nas_ddrschedule/schedule_add/action_repliandsepa"/>
            </label>
        </td>
    </tr>
    <tr>
        <th align=left><nsgui:message key="nas_ddrschedule/schedule_add/mode"/></th>
        <td>
            <%String mode = request.getParameter("mode");
            mode = (mode == null)?"sync":mode;
            %>
            <input type=radio <%=mode.equals("sync")?"checked":""%> name="mode" id="syncmode" value="sync" />
            <label for="syncmode"><nsgui:message key="nas_ddrschedule/schedule_add/mode_sync"/>
            </label>
            <input type=radio name="mode" <%=mode.equals("semi")?"checked":""%> id="semimode" value="semi" />
            <label for="semimode"><nsgui:message key="nas_ddrschedule/schedule_add/mode_semi"/>
            </label>
            <input type=radio name="mode" <%=mode.equals("bg")?"checked":""%> id="bgmode" value="bg" />
            <label for="bgmode"><nsgui:message key="nas_ddrschedule/schedule_add/mode_bg"/>
            </label>
        </td>
    </tr>
</table>
<br>
<table border=1>
    <%String timeType = request.getParameter("timeset");%>
    <tr><td rowspan="4" align="left">
            <%if (timeType == null){
                timeType = "indirectEdit";
            }%>
            <input type="radio" <%=timeType.equals("indirectEdit")?"checked":""%> id="timesetting0" 
                    name="timeset" value="indirectEdit" onclick="selectIndirectEdit()" />
        </td>
        <th rowspan="3" align="left">
            <label for="timesetting0"><nsgui:message key="nas_ddrschedule/schedule_add/td_day"/></label>
        </th>
        <td nowrap><% String selectedDay = request.getParameter("radio_day");
            if(selectedDay == null){
              	selectedDay = "weekday";
            }%>
            <input type="radio" <%=selectedDay.equals("weekday")?"checked":""%> id="day0" 
                name="radio_day" value="weekday" onclick="selectWeekDay();" />
            <label for="day0"><nsgui:message key="nas_ddrschedule/schedule_add/td_weekday"/></label>
        </td>
        <td nowrap><%
            String checkedSign;
            String[] selectedWeekDay = request.getParameterValues("weekday");
            String[] weekInfo = {
            	NSMessageDriver.getInstance().getMessage(session,"nas_ddrschedule/ddrschlist/display_sun"),
                NSMessageDriver.getInstance().getMessage(session,"nas_ddrschedule/ddrschlist/display_mon"),
                NSMessageDriver.getInstance().getMessage(session,"nas_ddrschedule/ddrschlist/display_tue"),
                NSMessageDriver.getInstance().getMessage(session,"nas_ddrschedule/ddrschlist/display_wed"),
                NSMessageDriver.getInstance().getMessage(session,"nas_ddrschedule/ddrschlist/display_thu"),
                NSMessageDriver.getInstance().getMessage(session,"nas_ddrschedule/ddrschlist/display_fri"),
                NSMessageDriver.getInstance().getMessage(session,"nas_ddrschedule/ddrschlist/display_sat")};
            for(int i=0; i < 7; i++){
                checkedSign = "";
                if(selectedWeekDay!=null && selectedWeekDay.length!=0){
                    for(int j=0; j<selectedWeekDay.length; j++){
                        if(selectedWeekDay[j].equals(""+i)){
                            checkedSign = "checked";
                            break;
                        }
                    }
                }%>
                <input type="checkbox" name="weekday" id="weekdayid<%=i%>" value="<%=i%>" <%=checkedSign%> />
                    <label for="weekdayid<%=i%>"><%=weekInfo[i]%></label>
            <%}%>
        </td>
    </tr>
    <tr>
        <td nowrap><input type="radio" <%=selectedDay.equals("monthday")?"checked":""%> id="day1" 
                name="radio_day" value="monthday" onclick="selectMonthDay();" />
            <label for="day1"><nsgui:message key="nas_ddrschedule/schedule_add/td_monthday"/></label>
        </td>
        <td><%String contentofmonthday = request.getParameter("text_monthday");
            if(contentofmonthday == null){
                contentofmonthday = "";
            }%>
            <input type="text" name="text_monthday" value="<%=contentofmonthday%>" size="30" maxlength="85" />
        </td>
    </tr>
    <tr><td colspan="2">
            <input type="radio" <%=selectedDay.equals("daily")?"checked":""%> id="day2" 
                name="radio_day" value="daily" onclick="selectDaily();" />
            <label for="day2"><nsgui:message key="nas_ddrschedule/schedule_add/td_daily"/></label>
        </td>
    </tr>
    <tr><th align="left" nowrap><label for="timesetting0"><nsgui:message key="nas_ddrschedule/schedule_add/td_time"/></label>
        </th>
        <td colspan="2"><%String contentofhour = request.getParameter("text_hour");
            String contentofminute = request.getParameter("text_minute");
            if(contentofhour == null){
                contentofhour = "0";
            }
            if(contentofminute == null){
                contentofminute = "0";
            }%>
            <input type="text" name="text_hour" value="<%=contentofhour%>" maxlength="120" size="25" />
            <nsgui:message key="nas_ddrschedule/schedule_add/td_hour"/>&nbsp;&nbsp;
            <input type="text" name="text_minute" value="<%=contentofminute%>" maxlength="2" size="15" />
            <nsgui:message key="nas_ddrschedule/schedule_add/td_minute"/>
        </td>
    </tr>
    <tr><td>
            <input type="radio" id="timesetting1" <%=timeType.equals("directedit")?"checked":""%> 
                name="timeset" value="directedit" onclick="selectDirectEdit();"/>
        </td>
        <th colspan="2" align="left">
            <label for="timesetting1"><nsgui:message key="nas_ddrschedule/schedule_add/td_directedit"/></label>
        </th>
        <td>
        <%String contentofdirect = request.getParameter("text_directedit");
          if(contentofdirect == null){
               contentofdirect = ""; 
          }%>
        <input type="text" name="text_directedit"  value="<%=contentofdirect%>" maxlength="395" size="40"/><br>
    </td></tr>
</table>
<br>
<input type="submit" name="addSchedule" value="<nsgui:message key="common/button/submit"/>" />
<input type="button" name="close" value="<nsgui:message key="common/button/close"/>" onclick="parent.close()" />
