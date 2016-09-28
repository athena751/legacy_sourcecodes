<!--
        Copyright (c) 2001-2008 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: snapSchedule.jsp,v 1.2314 2008/07/01 07:22:16 liy Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java" import="java.util.* , java.text.*
                    ,com.nec.sydney.beans.snapshot.SnapScheduleBean
                    ,com.nec.sydney.beans.base.AbstractJSPBean
                    ,com.nec.sydney.atom.admin.snapshot.*
                    ,com.nec.sydney.atom.admin.base.*" %>
<%@ page import="com.nec.sydney.framework.*" %>
<%@ page import="com.nec.nsgui.taglib.nssorttab.*"%>

<%@ taglib uri="taglib-nsgui" prefix="nsgui"%>
<%@ taglib uri="taglib-sorttable" prefix="nssorttab"%>

<jsp:useBean id="bean" class="com.nec.sydney.beans.snapshot.SnapScheduleBean" scope="page"/>
<%AbstractJSPBean _abstractJSPBean = bean; %>
<%@include file="../../../menu/common/includeheader.jsp" %>
<%String fromWhere = request.getParameter("fromWhere");
    if(fromWhere == null){
        fromWhere = "";
    }
%>
<HTML>
<HEAD>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=EUC-JP">
<script src="../common/general.js"></script>
<script src="/nsadmin/common/common.js"></script>
<script language=JavaScript>
var scheduleNameOutCrontab = new Array();
var scheduleOutCrontabNumber = new Array();
var maxGeneration;
var schForm;
var schName;

function selectIndirectEdit(){
    schForm.radio_day[0].disabled     = false;
    schForm.radio_day[1].disabled     = false;
    schForm.radio_day[2].disabled     = false;
    if(schForm.radio_day[0].checked==1){
        for(var i=0; i<7;i++){
            schForm.weekday[i].disabled = false;
        }
    }else if(schForm.radio_day[1].checked==1){
        schForm.text_monthday.disabled    = false;
    }
    schForm.text_hour.disabled        = false;
    schForm.text_minute.disabled      = false;
    schForm.text_directedit.disabled  = true;
}

function selectWeekDay(){
    for(var i=0; i<7;i++){
        schForm.weekday[i].disabled = false;
    }
    schForm.radio_day[0].disabled = false;
    schForm.radio_day[1].disabled = false;
    schForm.radio_day[2].disabled = false;
    schForm.text_hour.disabled    = false;
    schForm.text_minute.disabled  = false;
    schForm.text_monthday.disabled    = true;
    schForm.text_directedit.disabled  = true;
}

function selectMonthDay(){
    schForm.radio_day[0].disabled     = false;
    schForm.radio_day[1].disabled     = false;
    schForm.radio_day[2].disabled     = false;
    schForm.text_monthday.disabled    = false;
    schForm.text_hour.disabled        = false;
    schForm.text_minute.disabled      = false;
    for(var i=0; i<7;i++){
        schForm.weekday[i].disabled   = true;
    }
    schForm.text_directedit.disabled  = true;
}

function selectDaily(){
    schForm.radio_day[0].disabled = false;
    schForm.radio_day[1].disabled = false;
    schForm.radio_day[2].disabled = false;
    schForm.text_hour.disabled    = false;
    schForm.text_minute.disabled  = false;
    for(var i=0; i<7;i++){
        schForm.weekday[i].disabled   = true;
    }
    schForm.text_monthday.disabled    = true;
    schForm.text_directedit.disabled  = true;
}

function selectDirectEdit(){
    for(var i=0; i<7;i++){
        schForm.weekday[i].disabled = true;
    }
    schForm.radio_day[0].disabled     = true;
    schForm.radio_day[1].disabled     = true;
    schForm.radio_day[2].disabled     = true;
    schForm.text_monthday.disabled    = true;
    schForm.text_hour.disabled        = true;
    schForm.text_minute.disabled      = true;
    schForm.text_directedit.disabled = false;
}

function selectWeekDay4DelSche(){
    for(var i=0; i<7;i++){
        schForm.delSche_weekday[i].disabled = false;
    }
    schForm.delSche_text_monthday.disabled  = true;
}

function selectMonthDay4DelSche(){
    for(var i=0; i<7;i++){
        schForm.delSche_weekday[i].disabled = true;
    }
    schForm.delSche_text_monthday.disabled  = false;
}

function selectDaily4DelSche(){
    for(var i=0; i<7;i++){
        schForm.delSche_weekday[i].disabled = true;
    }
    schForm.delSche_text_monthday.disabled  = true;
}

function selectIndirectEdit4DelSche(){
    schForm.delSche_radio_day[0].disabled = false;
    schForm.delSche_radio_day[1].disabled = false;
    schForm.delSche_radio_day[2].disabled = false;
    
    if(schForm.delSche_radio_day[0].checked==1){
        selectWeekDay4DelSche();
    }else if(schForm.delSche_radio_day[1].checked==1){
        selectMonthDay4DelSche();
    } else {
    	selectDaily4DelSche();
    }
    
    schForm.delSche_text_hour.disabled   = false;
    schForm.delSche_text_minute.disabled = false;
    
    schForm.delSche_text_directedit.disabled = true;
}

function selectDirectEdit4DelSche(){
    for(var i=0; i<7;i++){
        schForm.delSche_weekday[i].disabled = true;
    }
    schForm.delSche_radio_day[0].disabled    = true;
    schForm.delSche_radio_day[1].disabled    = true;
    schForm.delSche_radio_day[2].disabled    = true;
    schForm.delSche_text_monthday.disabled   = true;

    schForm.delSche_text_hour.disabled       = true;
    schForm.delSche_text_minute.disabled     = true;
    
    schForm.delSche_text_directedit.disabled = false;
}

function checkSchName(str){
    if (str == "" || str.match(/^\.+/)){
        return true;
    }
    var valid = /[^0-9a-zA-Z._\-]/g;
    var flag=str.search(valid);
    if(flag!=-1){
        return true;
    }else{
        return false;
    }
}

function checkSpecialSchName(str){
    if (str.match(/^MVDCKPT_/i)){
        return true;
    }else{
        return false;
    }
}

function checkGeneration(generationObj, min, max){
    var str = trim(generationObj.value);
    if (str == ""){
        return true;
    }
    var valid = /[^0-9]/g;
    var flag=str.search(valid);
    if(flag!=-1){
        return true;
    }else{
        var value=parseInt(str,10);
        
        if((value<min)||(value > max)){
            return true;
        } else {
            generationObj.value = value;
    		return false;
        }
    }
}

function checkWeekDay(formObj){
    for(var i=0; i<7; i++){
        if(formObj[i].checked == 1){
            return true;
        }
    }
    return false;
}

function checkMonthDay(formObj){
    var monthDayNum = trim(formObj.value);
    if(monthDayNum == ""){
        return false;
    }
    if(!monthDayNum.match(/^([0-9]+,)*[0-9]+$/)){
        return false;
    }
    var numArray = monthDayNum.split(",");
    for(var i=0; i<numArray.length; i++){
        numArray[i] = parseInt(numArray[i],"10");
        if(numArray[i] > 31 || numArray[i] < 1){
            return false;
        }
    }
    if(numArray.length==1){
        formObj.value = numArray[0];
    }else{
        formObj.value = numArray.join(",");
    }
    return true;
}

function checkHour(formObj){
    var hourNum = trim(formObj.value);
    if(hourNum == ""){
        return false;
    }
    if(hourNum.search(/[^0-9,\-]/)!=-1){
        return false;
    }
    var numArray = hourNum.split(",");
    var tmpHourNum;
    for(var i=0; i<numArray.length; i++){
        if( numArray[i].match(/^[0-9]+\-[0-9]+$/) ){
            tmpHourNum = numArray[i].split("-");
            tmpHourNum[0]=parseInt(tmpHourNum[0],"10");
            tmpHourNum[1]=parseInt(tmpHourNum[1],"10");               
            if(tmpHourNum[0] > 23 || tmpHourNum[0] < 0 
                    || tmpHourNum[1] > 23 || tmpHourNum[1] < 0){
                return false;
            }
            if(tmpHourNum[0]>=tmpHourNum[1]){
                return false;
            }
            numArray[i]=tmpHourNum.join("-");
        }else if(numArray[i].match(/^[0-9]+$/)){
            tmpHourNum=parseInt(numArray[i],"10");
            if(tmpHourNum > 23 || tmpHourNum < 0){
                return false;
            }
            numArray[i]=tmpHourNum;
        }else{
            return false;
        }              
    }
    if(numArray.length==1){
        formObj.value = numArray[0];
    }else{
        formObj.value = numArray.join(",");
    }
    return true;
}

function checkMinute(formObj){
    var minuteNum = trim(formObj.value);
    formObj.value = minuteNum;
    if(minuteNum == ""){
        return false;
    }
    if(minuteNum.search(/[^0-9]/)!=-1){
        return false;
    }
    var tmpMinute = parseInt(minuteNum,"10");
    if( tmpMinute > 59 || tmpMinute < 0){
        return false;
    }
    formObj.value = tmpMinute;
    return true;
}

function checkDirectEdit(formObj){
    var directInfo = trim(formObj.value);
    formObj.value = directInfo;
    if(directInfo == ""){
        return false;
    }
    var info = directInfo.split(/[\s]+/);
    if(info.length != 5){
        return false;
    }
    //minute,hour,day's legal charactor's check
    for(var j=0; j<3; j++){
        var mode = /[^0-9,\-\*\/]/;
        if(info[j].search(mode)!=-1){
            return false;
        }
    }
    //month,week's legal check
    for(var k=3; k<5; k++){
        var mode = /[^0-9a-zA-Z,\-\*\/]/;
        if(info[k].search(mode)!=-1){
            return false;
        }
    }
    return true;
}

// check schedule, return false or confirm message
function checkSchedule(form, scheTable) {
    // check day and time
    var schedule, timesetRadio, dayRadio, weekdayObj, monthdayObj, hourObj, minuteObj, directEditObj;
    
    if (scheTable == "scheofDeleting") {
	    schedule      = "<nsgui:message key="nas_snapshot/delschedule/inScheofDeleting"/>";
	    timesetRadio  = form.delSche_timeset;
	    dayRadio      = form.delSche_radio_day;
	    weekdayObj    = form.delSche_weekday;
	    monthdayObj   = form.delSche_text_monthday;
	    hourObj       = form.delSche_text_hour;
	    minuteObj     = form.delSche_text_minute;
	    directEditObj = form.delSche_text_directedit;    
    } else {
    	schedule      = "<nsgui:message key="nas_snapshot/delschedule/inScheofCreating"/>";
    	timesetRadio  = form.timeset;
        dayRadio      = form.radio_day;
    	weekdayObj    = form.weekday;
    	monthdayObj   = form.text_monthday;
    	hourObj       = form.text_hour;
    	minuteObj     = form.text_minute;
    	directEditObj = form.text_directedit;    
    }
    
    if(timesetRadio[0].checked == 1){
        if(dayRadio[0].checked == 1 && !checkWeekDay(weekdayObj)){
            alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
                    + <nsgui:message key="nas_snapshot/alert/invalid_weekday" firstReplace="schedule" separate="true"/>);
            return false;
        }else if(dayRadio[1].checked == 1 && !checkMonthDay(monthdayObj)){
            alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
                    + <nsgui:message key="nas_snapshot/alert/invalid_monthday" firstReplace="schedule" separate="true"/>);
            monthdayObj.focus();
            return false;
        }
        if(!checkHour(hourObj)){
            alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
                    + <nsgui:message key="nas_snapshot/alert/invalid_hour" firstReplace="schedule" separate="true"/>);
            hourObj.focus();
            return false;
        }
        if(!checkMinute(minuteObj)){
            alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
                    + <nsgui:message key="nas_snapshot/alert/invalid_minute" firstReplace="schedule" separate="true"/>);
            minuteObj.focus();
            return false;
        }
    } else {
        if (!checkDirectEdit(directEditObj)) { 
	        alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
	                    + <nsgui:message key="nas_snapshot/alert/error_direct" firstReplace="schedule" separate="true"/>);
	        directEditObj.focus();
	    	return false;
    	}
    }

	// get confirm message
    var confirmMsg;
    if(timesetRadio[0].checked == 1) {
        if (dayRadio[0].checked == 1){
	    	confirmMsg = "<nsgui:message key="nas_snapshot/snapschedule/td_weekday"/>(";
	        var weekdayArray = new Array(
	                            "<nsgui:message key="nas_snapshot/snapschedule/display_sun"/>",
	                            "<nsgui:message key="nas_snapshot/snapschedule/display_mon"/>",
	                            "<nsgui:message key="nas_snapshot/snapschedule/display_tue"/>",
	                            "<nsgui:message key="nas_snapshot/snapschedule/display_wed"/>",
	                            "<nsgui:message key="nas_snapshot/snapschedule/display_thu"/>",
	                            "<nsgui:message key="nas_snapshot/snapschedule/display_fri"/>",
	                            "<nsgui:message key="nas_snapshot/snapschedule/display_sat"/>"
	                           );
	        for(var i=0; i<7; i++){
	            if(weekdayObj[i].checked == 1){
	                confirmMsg = confirmMsg + weekdayArray[i] 
	                                        + "<nsgui:message key="nas_snapshot/snapschedule/separateSign"/>";
	            }        
	        }
	        confirmMsg = confirmMsg.substr(0,confirmMsg.length-1) + ") ";
	    }else if(dayRadio[1].checked == 1 ){
	    	confirmMsg = "<nsgui:message key="nas_snapshot/snapschedule/td_monthday"/>"
	    	             + "(" + monthdayObj.value + ") ";
	    } else {
	    	confirmMsg = "<nsgui:message key="nas_snapshot/snapschedule/td_daily"/> ";
    	}
		
		confirmMsg = confirmMsg + "<nsgui:message key="nas_snapshot/snapschedule/th_time"/>("
	                            + hourObj.value + "<nsgui:message key="nas_snapshot/snapschedule/td_hour"/>"
	                            + minuteObj.value + "<nsgui:message key="nas_snapshot/snapschedule/td_minute"/>)";
    }else{
    	confirmMsg = "<nsgui:message key="nas_snapshot/snapschedule/th_directedit"/>"
    	             + "(" + directEditObj.value + ")";
    }
    return confirmMsg;
}

function onAdd(){
    maxGeneration = -1;
    schForm.scheduleName.value  = trim(schForm.scheduleName.value);
    var scheduleName            = schForm.scheduleName.value;
    
    for (var i = 0 ; i < scheduleNameOutCrontab.length; i++) {
        if (scheduleName.toUpperCase()==scheduleNameOutCrontab[i].toUpperCase()) {
            maxGeneration = scheduleOutCrontabNumber[i];
        }               
    }

    if(maxGeneration == -1) {
        maxGeneration = <%=bean.getAvailableNumber()%>;
    }
    
    if(maxGeneration <= 0){
        alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"
               +"<nsgui:message key="nas_snapshot/alert/schedule_invalid"/>");
        return false;
    }

    
    schForm.generation.value    = trim(schForm.generation.value);
    
    schForm.act.value           = "Add";
    
    if(checkSchName(scheduleName)){
        alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"
               +"<nsgui:message key="nas_snapshot/alert/invalidScheduleName"/>");
        schForm.scheduleName.focus();    
        return false;
    }
    if(checkSpecialSchName(scheduleName)){
        alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"
               +"<nsgui:message key="nas_snapshot/alert/schedule_contain_special_name"/>");
        schForm.scheduleName.focus();    
        return false;
    }
    
    if(checkGeneration(schForm.generation, 1, maxGeneration)){
        if(maxGeneration == 1){
            alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"
               + "<nsgui:message key="nas_snapshot/alert/invalidgenonly1allowed"/>");
        }
        else{
            alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"
               + <nsgui:message key="nas_snapshot/alert/invalidgen"
                    firstReplace="maxGeneration" separate="true"/>);
		}
		schForm.generation.focus();                    
        return false;
    }
    for(var i=0;i<schName.length;i++){
        if(scheduleName.toUpperCase()==schName[i].toUpperCase()){
            alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"
                   +<nsgui:message key="nas_snapshot/alert/schduleExist" firstReplace="scheduleName" separate="true"/>);
            return false;
        }
    }
    
    // check schedule of creating
    var cfmMsgofCreating = checkSchedule(schForm, "scheofCreating");
    if (cfmMsgofCreating == false) {
        return false;
    }
    
    var generation = schForm.generation.value;
    // check schedule of deleting
    var cfmMsgofDeleting;
	if (schForm.delScheChkbox.checked == 1) {
	   	var maxReservedGen = parseInt(generation, "10") - 1;
	   	var reservedGenObj = schForm.reservedGen;

	    if (checkGeneration(reservedGenObj, 0, maxReservedGen)) {
	    	if(maxReservedGen == 0){
	    	    alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"
	    	       + "<nsgui:message key="nas_snapshot/delschedule/invalidreservedgenonly0allowed"/>");
	    	}
	    	else{
	    	    alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"
	               + <nsgui:message key="nas_snapshot/delschedule/invalidreservedgen"
	                   firstReplace="maxReservedGen" separate="true"/>);
	        }
	    	reservedGenObj.focus();
	    	return false;
       }
       
       cfmMsgofDeleting = checkSchedule(schForm, "scheofDeleting");
	   if (cfmMsgofDeleting == false) {
           return false;
       }
	}
	
	// get all confirm message
    var mess = <nsgui:message key="nas_snapshot/alert/confirmschedulename" firstReplace="scheduleName" separate="true"/> + "\r\n";
    mess = mess + <nsgui:message key="nas_snapshot/alert/confirmgenerations" firstReplace="generation" separate="true"/> + "\r\n";
    mess = mess + "<nsgui:message key="nas_snapshot/alert/confirmschedule"/>" + cfmMsgofCreating;
    
    // get confirm message of schedule of deleting
    if (schForm.delScheChkbox.checked == 1) {
       var reservedGen = schForm.reservedGen.value;
    	mess = mess + "\r\n" + <nsgui:message key="nas_snapshot/delschedule/confirmReservedGen" firstReplace="reservedGen" separate="true"/> + "\r\n";
    	mess = mess + "<nsgui:message key="nas_snapshot/delschedule/confirmDelSche"/>" + cfmMsgofDeleting;
    }
    
    if( isSubmitted()&&confirm("<nsgui:message key="common/confirm"/>"
                                +"\r\n"
                                +"<nsgui:message key="common/confirm/act" />"
                                +"<nsgui:message key="common/button/add"/>"
                                +"\r\n"+mess) ){
        setSubmitted();
        return true;
    }
    return false;
}

function onDelete(){

    schForm.act.value="Delete";
    var delSchedule = schForm.delSchedule.value;
    if( delSchedule == "" ){
        alert("<nsgui:message key="nas_snapshot/alert/noCheckSch"/>");
        return false;
    }
    if( isSubmitted()
        &&confirm("<nsgui:message key="common/confirm"/>"+"\r\n"
                   +"<nsgui:message key="common/confirm/act"/>"
                   +"<nsgui:message key="common/button/delete"/>"+"\r\n"
                   +<nsgui:message key="nas_snapshot/alert/confirmschedulename" firstReplace="delSchedule" separate="true"/>))
    {
        setSubmitted();
        schForm.submit();
        return true;
    }else{
        return false;
    }
}

function setDeleteName(name){
    schForm.delSchedule.value = name;
}
function onSnapshotList(){
    <%if(fromWhere.equals("cifs")){%>
        selectModule("apply.fileShare.cifs");
    <%}else{%>
        window.location="snapShow.jsp";
    <%}%>
}

function initSchedule(){
    if(schForm.timeset[0].checked == 1 && schForm.radio_day[0].checked == 1 ){
        selectWeekDay();
    }else if(schForm.timeset[0].checked == 1 && schForm.radio_day[1].checked == 1 ){
        selectMonthDay();
    }else if(schForm.timeset[0].checked == 1 && schForm.radio_day[2].checked == 1 ){
        selectDaily();
    }else{
        selectDirectEdit();
    }
}

function initScheduleNameOutCrontab() {
    var i = 0;
    <%
        Hashtable scheduleOutCrontab2Times = bean.getAvailableNumberDetail();
        Enumeration keys = scheduleOutCrontab2Times.keys();
        
        while (keys.hasMoreElements()) {
            String thisKey = (String)keys.nextElement();
    %>
        scheduleNameOutCrontab[i] ="<%=thisKey%>"; 
        scheduleOutCrontabNumber[i] = "<%=(String)(scheduleOutCrontab2Times.get(thisKey))%>";
        i++;
    <%
        }
    %>
}

function initDelSche() {
	if (schForm.delScheChkbox.checked == 1) {
		document.getElementById("delScheDiv").style.display="block";
		
		if(schForm.delSche_timeset[0].checked == 1) {
	        selectIndirectEdit4DelSche();
	    }else{
	        selectDirectEdit4DelSche();
	    }		
	} else {
		document.getElementById("delScheDiv").style.display="none";
	}
}

function initialization(){
    schForm = document.scheduleForm;
    initSchedule();
    initDelSche();
    initScheduleNameOutCrontab();
    schForm.scheduleName.focus();
    
    if(schForm.delete0!=null) {
    	schForm.delete0.checked=true;
    	setDeleteName(schName[0]);
    }
}

function reloadPage(){
    if( !isSubmitted() ){
        return false;
    }
    setSubmitted();
    window.location="snapSchedule.jsp";
}
</script>
<jsp:include page="../../common/wait.jsp" />
</HEAD>
<BODY onload="displayAlert();initialization();">
    <h1 class="title"><nsgui:message key="nas_snapshot/common/h1"/></h1>
    <form name="scheduleForm" method="post" action="snapScheduleForward.jsp" onsubmit="return onAdd()">
    <input type="hidden" name="fromWhere" value="<%=fromWhere%>">
    <input type="button" name="snapshotList" value="<nsgui:message key="common/button/back"/>" OnClick="onSnapshotList()">
    <input type="button" name="refresh" value="<nsgui:message key="common/button/reload"/>" onclick="reloadPage()">
    <h2 class="title"><nsgui:message key="nas_snapshot/snapschedule/h2_schedule"/>[<%=bean.getMountPoint()%>]</h2>
    <h3 class="title"><nsgui:message key="nas_snapshot/snapschedule/h3_add"/></h3>
    <p></p>
    <table border="1">
        <tr>
        <th align="left"><nsgui:message key="nas_snapshot/snapschedule/th_schedulename"/></th>
        <td colspan="3"><input type="TEXT" name="scheduleName" maxLength="15" size="20" ></td>
        </tr>
        <tr>
        <th align="left"><nsgui:message key="nas_snapshot/snapschedule/th_gen"/></th>
        <td colspan="3"><input type="TEXT" name="generation" value="1" maxLength="3" size="3" ></td>
        </tr>
    </table>
    <br>
    <table border="1">
        <tr><td rowspan="4" align="left">
                <input type="radio" checked id="timesetting0" 
                        name="timeset" value="indirectEdit" onclick="selectIndirectEdit()" />
            </td>
            <th rowspan="3" align="left">
                <label for="timesetting0"><nsgui:message key="nas_snapshot/snapschedule/th_day"/></label>
            </th>
            <td><input type="radio" checked id="day0" 
                    name="radio_day" value="weekday" onclick="selectWeekDay();" />
                <label for="day0"><nsgui:message key="nas_snapshot/snapschedule/td_weekday"/></label>
            </td>
            <td><%String[] weekInfo = {
                    NSMessageDriver.getInstance().getMessage(session, "nas_snapshot/snapschedule/display_sun"),
                    NSMessageDriver.getInstance().getMessage(session, "nas_snapshot/snapschedule/display_mon"),
                    NSMessageDriver.getInstance().getMessage(session, "nas_snapshot/snapschedule/display_tue"),
                    NSMessageDriver.getInstance().getMessage(session, "nas_snapshot/snapschedule/display_wed"),
                    NSMessageDriver.getInstance().getMessage(session, "nas_snapshot/snapschedule/display_thu"),
                    NSMessageDriver.getInstance().getMessage(session, "nas_snapshot/snapschedule/display_fri"),
                    NSMessageDriver.getInstance().getMessage(session, "nas_snapshot/snapschedule/display_sat")};
                for(int i=0; i < 7; i++){%>
                    <input type="checkbox" name="weekday" id="weekdayid<%=i%>" value="<%=i%>" />
                        <label for="weekdayid<%=i%>"><%=weekInfo[i]%></label>
                <%}%>
            </td>
        </tr>
        <tr>
            <td><input type="radio" id="day1" name="radio_day" value="monthday" onclick="selectMonthDay();" />
                <label for="day1"><nsgui:message key="nas_snapshot/snapschedule/td_monthday"/></label>
            </td>
            <td><input type="text" name="text_monthday" value="" size="30" maxlength="85" />
            </td>
        </tr>
        <tr><td colspan="2">
                <input type="radio" id="day2" name="radio_day" value="daily" onclick="selectDaily();" />
                <label for="day2"><nsgui:message key="nas_snapshot/snapschedule/td_daily"/></label>
            </td>
        </tr>
        <tr><th align="left"><label for="timesetting0"><nsgui:message key="nas_snapshot/snapschedule/th_time"/></label>
            </th>
            <td colspan="2">
                <input type="text" name="text_hour" value="0" maxlength="120" size="25" />
                <nsgui:message key="nas_snapshot/snapschedule/td_hour"/>&nbsp;&nbsp;
                <input type="text" name="text_minute" value="0" maxlength="2" size="15" />
                <nsgui:message key="nas_snapshot/snapschedule/td_minute"/>
            </td>
        </tr>
        <tr><td>
                <input type="radio" id="timesetting1" name="timeset" value="directedit" onclick="selectDirectEdit();"/>
            </td>
            <th colspan="2" align="left">
                <label for="timesetting1"><nsgui:message key="nas_snapshot/snapschedule/th_directedit"/></label>
            </th>
            <td><input type="text" name="text_directedit"  value="" maxlength="395" size="40"/><br>
        </td></tr>
    </table>

    <br>
    <input type="checkbox" id="delScheChkboxId" name="delScheChkbox" value="on" onclick="initDelSche();"/>
    <label for="delScheChkboxId"><nsgui:message key="nas_snapshot/delschedule/setDelSche"/></label>
    <br><br>
    <div id="delScheDiv" style="display:none;">
	    <table border="1">
	        <tr>
	        	<th align="left">
	        		<nsgui:message key="nas_snapshot/delschedule/reservedGen"/>
	            </th>
	        	<td colspan="3">
	        		<input type="TEXT" name="reservedGen" value="" maxLength="3" size="3" >
	        	</td>
	        </tr>
	    </table>
	    <br>
	    <table border="1">
	        <tr>
	        	<td rowspan="4" align="left">
	                <input type="radio" checked id="delSche_timesetting0" 
	                        name="delSche_timeset" value="indirectEdit" onclick="selectIndirectEdit4DelSche()" />
	            </td>
	            <th rowspan="3" align="left">
	                <label for="delSche_timesetting0"><nsgui:message key="nas_snapshot/snapschedule/th_day"/></label>
	            </th>
	            <td><input type="radio" checked id="delSche_day0" 
	                    name="delSche_radio_day" value="weekday" onclick="selectWeekDay4DelSche();" />
	                <label for="delSche_day0"><nsgui:message key="nas_snapshot/snapschedule/td_weekday"/></label>
	            </td>
	            <td><%
	                for(int i=0; i < 7; i++){%>
	                    <input type="checkbox" name="delSche_weekday" id="delSche_weekdayid<%=i%>" value="<%=i%>" />
	                        <label for="delSche_weekdayid<%=i%>"><%=weekInfo[i]%></label>
	                <%}%>
	            </td>
	        </tr>
	        <tr>
	            <td><input type="radio" id="delSche_day1" name="delSche_radio_day" value="monthday" onclick="selectMonthDay4DelSche();" />
	                <label for="delSche_day1"><nsgui:message key="nas_snapshot/snapschedule/td_monthday"/></label>
	            </td>
	            <td><input type="text" name="delSche_text_monthday" value="" size="30" maxlength="85" />
	            </td>
	        </tr>
	        <tr>
	        	<td colspan="2">
	                <input type="radio" id="delSche_day2" name="delSche_radio_day" value="daily" onclick="selectDaily4DelSche();" />
	                <label for="delSche_day2"><nsgui:message key="nas_snapshot/snapschedule/td_daily"/></label>
	            </td>
	        </tr>
	        <tr>
	        	<th align="left">
	        		<label for="delSche_timesetting0"><nsgui:message key="nas_snapshot/snapschedule/th_time"/></label>
	            </th>
	            <td colspan="2">
	                <input type="text" name="delSche_text_hour" value="0" maxlength="120" size="25" />
	                <nsgui:message key="nas_snapshot/snapschedule/td_hour"/>&nbsp;&nbsp;
	                <input type="text" name="delSche_text_minute" value="0" maxlength="2" size="15" />
	                <nsgui:message key="nas_snapshot/snapschedule/td_minute"/>
	            </td>
	        </tr>
	        <tr>
	        	<td>
	                <input type="radio" id="delSche_timesetting1" name="delSche_timeset" value="directedit" onclick="selectDirectEdit4DelSche();"/>
	            </td>
	            <th colspan="2" align="left">
	                <label for="delSche_timesetting1"><nsgui:message key="nas_snapshot/snapschedule/th_directedit"/></label>
	            </th>
	            <td>
	            	<input type="text" name="delSche_text_directedit"  value="" maxlength="395" size="40"/><br>
	            </td>
	        </tr>
	    </table>
    </div>
    
    <br><input type="submit" name="add" value="<nsgui:message key="nas_snapshot/snapschedule/button_set"/>">
    <br>

    <h3 class="title"><nsgui:message key="nas_snapshot/snapschedule/h3_list"/></h3>
    <% Vector schList=bean.getSchedule();
   if(schList==null||schList.isEmpty()){%>
        <br><nsgui:message key="nas_snapshot/snapschedule/msg_noschedule"/>
        <script language=JavaScript>
            schName=new Array(0);
        </script>
        
    <%}else{%>
    	<script language=JavaScript>
            schName=new Array(<%=schList.size()%>);
        </script>
    <nssorttab:table
	tablemodel="<%=new ListSTModel(schList)%>" id="scheduleTable"
	table="BORDER=1" titleTrNum="1" sortonload="scheduleName">

	<nssorttab:column name="scheduleList"
		th="com.nec.sydney.beans.snapshot.SnapshotTHeaderRender"
		td="com.nec.sydney.beans.snapshot.SnapshotTDataRender">
		</nssorttab:column>
	<nssorttab:column name="scheduleName" 
		th="com.nec.sydney.beans.snapshot.SnapshotTHeaderRender" 
		td="com.nec.sydney.beans.snapshot.SnapshotTDataRender"
		sortable="yes">
		<nsgui:message key="nas_snapshot/snapshow/th_name" />
	</nssorttab:column>
	<nssorttab:column name="generation"
		th="com.nec.sydney.beans.snapshot.SnapshotTHeaderRender" 
		td="STDataRender"
		comparator="com.nec.nsgui.taglib.nssorttab.NumberStringComparator">
		<nsgui:message key="nas_snapshot/snapschedule/th_gen" />
	</nssorttab:column>
	<nssorttab:column name="time"
		th="com.nec.sydney.beans.snapshot.SnapshotTHeaderRender" 
		td="com.nec.sydney.beans.snapshot.SnapshotTDataRender">
		<nsgui:message key="nas_snapshot/snapschedule/th_method" />
	</nssorttab:column>
	<nssorttab:column name="deleteGeneration"
		th="com.nec.sydney.beans.snapshot.SnapshotTHeaderRender" 
		td="com.nec.sydney.beans.snapshot.SnapshotTDataRender"
		comparator="com.nec.nsgui.taglib.nssorttab.NumberStringComparator">
		<nsgui:message key="nas_snapshot/snapschedule/th_deleteGen" />
	</nssorttab:column>
	<nssorttab:column name="deleteTime"
		th="com.nec.sydney.beans.snapshot.SnapshotTHeaderRender"
		td="com.nec.sydney.beans.snapshot.SnapshotTDataRender">
		<nsgui:message key="nas_snapshot/snapschedule/th_method" />
	</nssorttab:column>
	


    </nssorttab:table><br>
    <input type="button" name="delete" value="<nsgui:message key="common/button/delete"/>"
     OnClick="return onDelete()">
    <input type="hidden" name="delSchedule" value="">
    <% }//end of else%>
    <input type="hidden" name="act">
    <input type="hidden" name="alertFlag" value="enable">
  </form>
</BODY>
</HTML>
 