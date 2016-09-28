<script language="JavaScript">

function selectIndirectEdit(form){
    form.elements["schedule.day"][0].disabled     = false;
    form.elements["schedule.day"][1].disabled     = false;
    form.elements["schedule.day"][2].disabled     = false;
    if(form.elements["schedule.day"][0].checked==1){
        for(var i=0; i<7;i++){
            form.elements["schedule.weekday"][i].disabled = false;
        }
    }else if(form.elements["schedule.day"][1].checked==1){
        form.elements["schedule.monthday"].disabled    = false;
    }
    form.elements["schedule.hour"].disabled        = false;
    form.elements["schedule.minute"].disabled      = false;
    form.elements["schedule.directedit"].disabled  = true;
}

function selectWeekDay(form){
	for(var i=0; i<7;i++){
        form.elements["schedule.weekday"][i].disabled = false;
    }
    form.elements["schedule.day"][0].disabled = false;
    form.elements["schedule.day"][1].disabled = false;
    form.elements["schedule.day"][2].disabled = false;
    form.elements["schedule.hour"].disabled    = false;
    form.elements["schedule.minute"].disabled  = false;
    form.elements["schedule.monthday"].disabled    = true;
    form.elements["schedule.directedit"].disabled  = true;
}

function selectMonthDay(form){
	form.elements["schedule.day"][0].disabled     = false;
    form.elements["schedule.day"][1].disabled     = false;
    form.elements["schedule.day"][2].disabled     = false;
    form.elements["schedule.monthday"].disabled    = false;
    form.elements["schedule.hour"].disabled        = false;
    form.elements["schedule.minute"].disabled      = false;
    for(var i=0; i<7;i++){
        form.elements["schedule.weekday"][i].disabled   = true;
    }
    form.elements["schedule.directedit"].disabled  = true;
}

function selectDaily(form){
	form.elements["schedule.day"][0].disabled = false;
    form.elements["schedule.day"][1].disabled = false;
    form.elements["schedule.day"][2].disabled = false;
    form.elements["schedule.hour"].disabled    = false;
    form.elements["schedule.minute"].disabled  = false;
    for(var i=0; i<7;i++){
        form.elements["schedule.weekday"][i].disabled   = true;
    }
    form.elements["schedule.monthday"].disabled    = true;
    form.elements["schedule.directedit"].disabled  = true;
}

function selectDirectEdit(form){
	for(var i=0; i<7;i++){
        form.elements["schedule.weekday"][i].disabled = true;
    }
    form.elements["schedule.day"][0].disabled     = true;
    form.elements["schedule.day"][1].disabled     = true;
    form.elements["schedule.day"][2].disabled     = true;
    form.elements["schedule.monthday"].disabled    = true;
    form.elements["schedule.hour"].disabled        = true;
    form.elements["schedule.minute"].disabled      = true;
    form.elements["schedule.directedit"].disabled = false;
}

function checkWeekDay(form){
    for(var i=0; i<7; i++){
        if(form.elements["schedule.weekday"][i].checked == 1){
            return true;
        }
    }
    return false;
}

function checkMonthDay(form){
    var monthDayNum = trim(form.elements["schedule.monthday"].value);
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
        form.elements["schedule.monthday"].value = numArray[0];
    }else{
        form.elements["schedule.monthday"].value = numArray.join(",");
    }
    return true;
}

function checkHour(form){
    var hourNum = trim(form.elements["schedule.hour"].value);
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
        form.elements["schedule.hour"].value = numArray[0];
    }else{
        form.elements["schedule.hour"].value = numArray.join(",");
    }
    return true;
}

function checkMinute(form){
    var minuteNum = trim(form.elements["schedule.minute"].value);
    form.elements["schedule.minute"].value = minuteNum;
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
    form.elements["schedule.minute"].value = tmpMinute;
    return true;
}

function checkDirectEdit(form){
    var directInfo = trim(form.elements["schedule.directedit"].value);
    form.elements["schedule.directedit"].value = directInfo;
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
    //fix for firefox 's regular expression "\\s"     
    form.elements["schedule.directedit"].value = info.join(" ");
    return true;
}

function initSchedule(form){
    if(form.elements["schedule.timeset"][0].checked == 1 && form.elements["schedule.day"][0].checked == 1 ){
        selectWeekDay(form);
    }else if(form.elements["schedule.timeset"][0].checked == 1 && form.elements["schedule.day"][1].checked == 1 ){
        selectMonthDay(form);
    }else if(form.elements["schedule.timeset"][0].checked == 1 && form.elements["schedule.day"][2].checked == 1 ){
        selectDaily(form);
    }else{
        selectDirectEdit(form);
    }
}
</script>