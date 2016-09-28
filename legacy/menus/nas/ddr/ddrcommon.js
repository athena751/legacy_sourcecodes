<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: ddrcommon.js,v 1.1 2004/08/24 09:49:51 wangw Exp $" -->

<script language="JavaScript" src="../common/general.js"></script>
<script language="JavaScript">
function disableSyncMode(){
    document.forms[0].mode[0].disabled=true;
    document.forms[0].mode[1].disabled=true;
    document.forms[0].mode[2].disabled=true;
}

function enableSyncMode(){
    document.forms[0].mode[0].disabled=false;
    document.forms[0].mode[1].disabled=false;
    document.forms[0].mode[2].disabled=false;
}

function selectIndirectEdit(){
    document.forms[0].radio_day[0].disabled     = false;
    document.forms[0].radio_day[1].disabled     = false;
    document.forms[0].radio_day[2].disabled     = false;
    if(document.forms[0].radio_day[0].checked==1){
        for(var i=0; i<7;i++){
            document.forms[0].weekday[i].disabled = false;
        }
    }else if(document.forms[0].radio_day[1].checked==1){
        document.forms[0].text_monthday.disabled    = false;
    }
    document.forms[0].text_hour.disabled        = false;
    document.forms[0].text_minute.disabled      = false;
    document.forms[0].text_directedit.disabled  = true;
}

function selectWeekDay(){
    for(var i=0; i<7;i++){
        document.forms[0].weekday[i].disabled = false;
    }
    document.forms[0].radio_day[0].disabled = false;
    document.forms[0].radio_day[1].disabled = false;
    document.forms[0].radio_day[2].disabled = false;
    document.forms[0].text_hour.disabled    = false;
    document.forms[0].text_minute.disabled  = false;
    document.forms[0].text_monthday.disabled    = true;
    document.forms[0].text_directedit.disabled  = true;
}

function selectMonthDay(){
    document.forms[0].radio_day[0].disabled     = false;
    document.forms[0].radio_day[1].disabled     = false;
    document.forms[0].radio_day[2].disabled     = false;
    document.forms[0].text_monthday.disabled    = false;
    document.forms[0].text_hour.disabled        = false;
    document.forms[0].text_minute.disabled      = false;
    for(var i=0; i<7;i++){
        document.forms[0].weekday[i].disabled   = true;
    }
    document.forms[0].text_directedit.disabled  = true;
}

function selectDaily(){
    document.forms[0].radio_day[0].disabled = false;
    document.forms[0].radio_day[1].disabled = false;
    document.forms[0].radio_day[2].disabled = false;
    document.forms[0].text_hour.disabled    = false;
    document.forms[0].text_minute.disabled  = false;
    for(var i=0; i<7;i++){
        document.forms[0].weekday[i].disabled   = true;
    }
    document.forms[0].text_monthday.disabled    = true;
    document.forms[0].text_directedit.disabled  = true;
}

function selectDirectEdit(){
    for(var i=0; i<7;i++){
        document.forms[0].weekday[i].disabled = true;
    }
    document.forms[0].radio_day[0].disabled     = true;
    document.forms[0].radio_day[1].disabled     = true;
    document.forms[0].radio_day[2].disabled     = true;
    document.forms[0].text_monthday.disabled    = true;
    document.forms[0].text_hour.disabled        = true;
    document.forms[0].text_minute.disabled      = true;
    document.forms[0].text_directedit.disabled = false;
}

function checkWeekDay(form){
    for(var i=0; i<7; i++){
        if(form.weekday[i].checked == 1){
            return true;
        }
    }
    return false;
}

function checkMonthDay(form){
    var monthDayNum = trim(form.text_monthday.value);
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
        form.text_monthday.value = numArray[0];
    }else{
        form.text_monthday.value = numArray.join(",");
    }
    return true;
}

function checkHour(form){
    var hourNum = trim(form.text_hour.value);
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
        form.text_hour.value = numArray[0];
    }else{
        form.text_hour.value = numArray.join(",");
    }
    return true;
}

function checkMinute(form){
    var minuteNum = trim(form.text_minute.value);
    form.text_minute.value = minuteNum;
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
    form.text_minute.value = tmpMinute;
    return true;
}

function checkDirectEdit(form){
    var directInfo = trim(form.text_directedit.value);
    form.text_directedit.value = directInfo;
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

function checkSchedule(form){
    if(form.timeset[0].checked==1){
        if(form.radio_day[0].checked == 1 && !checkWeekDay(form)){
            alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
                    + "<nsgui:message key="nas_ddrschedule/alert/invalid_weekday"/>");
            return false;
        }else if(form.radio_day[1].checked == 1 && !checkMonthDay(form)){
            alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
                    + "<nsgui:message key="nas_ddrschedule/alert/invalid_monthday"/>");
            form.text_monthday.focus();
            return false;
        }
        if(!checkHour(form)){
            alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
                    + "<nsgui:message key="nas_ddrschedule/alert/invalid_hour"/>");
            form.text_hour.focus();
            return false;
        }
        if(!checkMinute(form)){
            alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
                    + "<nsgui:message key="nas_ddrschedule/alert/invalid_minute"/>");
            form.text_minute.focus();
            return false;
        }
    }
    if(form.timeset[1].checked==1 && !checkDirectEdit(form)){
        alert("<nsgui:message key="common/alert/failed"/>" + "\r\n"
                    + "<nsgui:message key="nas_ddrschedule/alert/error_direct"/>");
        form.text_directedit.focus();
    	return false;
    }
    var confirmMsg;
    if(form.timeset[0].checked == 1 && form.radio_day[0].checked == 1 ){
    	confirmMsg = "<nsgui:message key="nas_ddrschedule/schedule_add/td_weekday"/>(";
        var weekdayArray = new Array(
                            "<nsgui:message key="nas_ddrschedule/ddrschlist/display_sun"/>",
                            "<nsgui:message key="nas_ddrschedule/ddrschlist/display_mon"/>",
                            "<nsgui:message key="nas_ddrschedule/ddrschlist/display_tue"/>",
                            "<nsgui:message key="nas_ddrschedule/ddrschlist/display_wed"/>",
                            "<nsgui:message key="nas_ddrschedule/ddrschlist/display_thu"/>",
                            "<nsgui:message key="nas_ddrschedule/ddrschlist/display_fri"/>",
                            "<nsgui:message key="nas_ddrschedule/ddrschlist/display_sat"/>"
                           );
        for(var i=0; i<7; i++){
            if(form.weekday[i].checked==1){
                confirmMsg = confirmMsg + weekdayArray[i] 
                            + "<nsgui:message key="nas_ddrschedule/ddrschlist/separateSign"/>";
            }        
        }
        confirmMsg = confirmMsg.substr(0,confirmMsg.length-1);
        confirmMsg = confirmMsg +") "
                     + "<nsgui:message key="nas_ddrschedule/schedule_add/td_time"/>("
                     + form.text_hour.value + "<nsgui:message key="nas_ddrschedule/schedule_add/td_hour"/>"
                     + form.text_minute.value + "<nsgui:message key="nas_ddrschedule/schedule_add/td_minute"/>)";
    }else if(form.timeset[0].checked == 1 && form.radio_day[1].checked == 1 ){
    	confirmMsg = "<nsgui:message key="nas_ddrschedule/schedule_add/td_monthday"/>"
    		+ "(" + form.text_monthday.value + ") "
                + "<nsgui:message key="nas_ddrschedule/schedule_add/td_time"/>("
                + form.text_hour.value + "<nsgui:message key="nas_ddrschedule/schedule_add/td_hour"/>"
                + form.text_minute.value + "<nsgui:message key="nas_ddrschedule/schedule_add/td_minute"/>)";
    }else if(form.timeset[0].checked == 1 && form.radio_day[2].checked == 1 ){
    	confirmMsg = "<nsgui:message key="nas_ddrschedule/schedule_add/td_daily"/> "
                + "<nsgui:message key="nas_ddrschedule/schedule_add/td_time"/>("
                + form.text_hour.value + "<nsgui:message key="nas_ddrschedule/schedule_add/td_hour"/>"
                + form.text_minute.value + "<nsgui:message key="nas_ddrschedule/schedule_add/td_minute"/>)";
    }else{
    	confirmMsg = "<nsgui:message key="nas_ddrschedule/schedule_add/td_directedit"/>"
    		+ "(" + form.text_directedit.value + ")";
    }
    return confirm("<nsgui:message key="common/confirm"/>"
                    +"\r\n"
                    +"<nsgui:message key="common/confirm/act"/>"
                    +"<nsgui:message key="common/button/submit"/>"
                    +"\r\n"+"<nsgui:message key="nas_ddrschedule/ddrschlist/confirm_sch"/>" 
                    + confirmMsg);
}

function initSchedule(form){
    if(form.timeset[0].checked == 1 && form.radio_day[0].checked == 1 ){
        selectWeekDay();
    }else if(form.timeset[0].checked == 1 && form.radio_day[1].checked == 1 ){
        selectMonthDay();
    }else if(form.timeset[0].checked == 1 && form.radio_day[2].checked == 1 ){
        selectDaily();
    }else{
        selectDirectEdit();
    }
    if(form.act[1].checked==1){
        disableSyncMode();
    }
}
</script>