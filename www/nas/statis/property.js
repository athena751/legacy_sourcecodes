/*
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
*/

/* "@(#) $Id: property.js,v 1.1 2005/10/19 05:08:17 zhangj Exp $" */

var loaded = 0;
var is4Survey = false;
var tyearStored,tmonthStored,fyearStored,fmonthStored,tdayStored,fdayStored;
var tyearTmp,tmonthTmp,fyearTmp,fmonthTmp;
function initialization(){
    disableElement();
    loaded = 1;
    if( window.parent && window.parent.bottomframe &&
    	(window.parent.bottomframe.document)
            &&(window.parent.bottomframe.document.forms[0]) ){
        window.parent.bottomframe.changeButtonStatus();
    }
    fyearStored=document.forms[0].elements["optionInfo.fromTimeInfo.year"].options[document.forms[0].elements["optionInfo.fromTimeInfo.year"].selectedIndex].value;
    fmonthStored=document.forms[0].elements["optionInfo.fromTimeInfo.month"].options[document.forms[0].elements["optionInfo.fromTimeInfo.month"].selectedIndex].value;
    tyearStored=document.forms[0].elements["optionInfo.toTimeInfo.year"].options[document.forms[0].elements["optionInfo.toTimeInfo.year"].selectedIndex].value;
    tmonthStored=document.forms[0].elements["optionInfo.toTimeInfo.month"].options[document.forms[0].elements["optionInfo.toTimeInfo.month"].selectedIndex].value;
    tdaySelectedIndex=document.forms[0].elements["optionInfo.toTimeInfo.day"].selectedIndex;
    fdaySelectedIndex=document.forms[0].elements["optionInfo.fromTimeInfo.day"].selectedIndex;
    toRelTimeSelectedIndex = document.forms[0].elements["optionInfo.toTimeInfo.time"].selectedIndex;
    fromRelTimeSelectedIndex = document.forms[0].elements["optionInfo.fromTimeInfo.time"].selectedIndex;
    tyearTmp = tyearStored;
    tmonthTmp = tmonthStored;
    fyearTmp = fyearStored;
    fmonthTmp = fmonthStored;
    swapFromDaySet(fmonthStored);
    swapToDaySet(tmonthStored);
}

function resetElement(){
    disableElement();
    tyearTmp = tyearStored;
    tmonthTmp = tmonthStored;
    fyearTmp = fyearStored;
    fmonthTmp = fmonthStored;
    swapFromDaySet(fmonthStored);
    swapToDaySet(tmonthStored);
    fromTimeSelection();
    toTimeSelection();
    document.forms[0].elements["optionInfo.toTimeInfo.day"].selectedIndex = tdaySelectedIndex;
    document.forms[0].elements["optionInfo.fromTimeInfo.day"].selectedIndex = fdaySelectedIndex;
    document.forms[0].elements["optionInfo.toTimeInfo.time"].selectedIndex = toRelTimeSelectedIndex;
	document.forms[0].elements["optionInfo.fromTimeInfo.time"].selectedIndex = fromRelTimeSelectedIndex;
}
function disableElement(){
    if( document.forms[0].elements["optionInfo.fromTimeInfo.flag"][0].checked ){
        enableFromAbs();
    }else{
        enableFromRelative();
    }
    if( document.forms[0].elements["optionInfo.toTimeInfo.flag"][0].checked ){
        enableToAbs();
    }else if( document.forms[0].elements["optionInfo.toTimeInfo.flag"][1].checked ){
        enableToRelative();
    }else{
        enableToNow();
    }
    if(document.forms[0].elements["optionInfo.sampleInfo.sample"] != null){
        if(document.forms[0].elements["optionInfo.sampleInfo.sample"][1].checked){
            enableSpecific();
        }else{
            enableAuto();
        }
    }
}
        
//all below here are about disable
function enableFromAbs(){
    setFromAbs(false);
    setFromRelative(true);
}
function enableFromRelative(){
    setFromAbs(true);
    setFromRelative(false);
}
function enableToNow(){
   setToAbs(true);
   setToRelative(true);
}
function enableToAbs(){
   setToAbs(false);
   setToRelative(true);
}
function enableToRelative(){
    setToAbs(true);
    setToRelative(false);
}
function enableAuto(){
    document.forms[0].elements["optionInfo.sampleInfo.sampleInterval"].disabled=true;
    document.forms[0].elements["optionInfo.sampleInfo.sampleUnit"].disabled=true;
}
function enableSpecific(){
    document.forms[0].elements["optionInfo.sampleInfo.sampleInterval"].disabled=false;
    document.forms[0].elements["optionInfo.sampleInfo.sampleUnit"].disabled=false;
}
function setFromAbs(flag){
    document.forms[0].elements["optionInfo.fromTimeInfo.year"].disabled=flag;
    document.forms[0].elements["optionInfo.fromTimeInfo.month"].disabled=flag;
    document.forms[0].elements["optionInfo.fromTimeInfo.day"].disabled=flag;
    document.forms[0].elements["optionInfo.fromTimeInfo.hour"].disabled=flag;
    document.forms[0].elements["optionInfo.fromTimeInfo.minute"].disabled=flag;
    document.forms[0].elements["optionInfo.fromTimeInfo.second"].disabled=flag;
}
function setFromRelative(flag){
    document.forms[0].elements["optionInfo.fromTimeInfo.time"].disabled=flag;
    document.forms[0].elements["optionInfo.fromTimeInfo.timeUnit"].disabled=flag;
}
function setToAbs(flag){
    document.forms[0].elements["optionInfo.toTimeInfo.year"].disabled=flag;
    document.forms[0].elements["optionInfo.toTimeInfo.month"].disabled=flag;
    document.forms[0].elements["optionInfo.toTimeInfo.day"].disabled=flag;
    document.forms[0].elements["optionInfo.toTimeInfo.hour"].disabled=flag;
    document.forms[0].elements["optionInfo.toTimeInfo.minute"].disabled=flag;
    document.forms[0].elements["optionInfo.toTimeInfo.second"].disabled=flag;
}
function setToRelative(flag){
    document.forms[0].elements["optionInfo.toTimeInfo.time"].disabled=flag;
    document.forms[0].elements["optionInfo.toTimeInfo.timeUnit"].disabled=flag;
}
        
        
//For relative
function fromTimeSelection(){
	if(document.forms[0].elements["optionInfo.fromTimeInfo.timeUnit"].options[document.forms[0].elements["optionInfo.fromTimeInfo.timeUnit"].selectedIndex].value=="Hours"){
    	if(is4Survey){
  	    	setOptionTextForRelative(document.forms[0].elements["optionInfo.fromTimeInfo.time"],168,document.forms[0].elements["optionInfo.fromTimeInfo.time"].selectedIndex);
        }else{
 	    	setOptionTextForRelative(document.forms[0].elements["optionInfo.fromTimeInfo.time"],512,document.forms[0].elements["optionInfo.fromTimeInfo.time"].selectedIndex);
        }
    }else if(document.forms[0].elements["optionInfo.fromTimeInfo.timeUnit"].options[document.forms[0].elements["optionInfo.fromTimeInfo.timeUnit"].selectedIndex].value=="Days"){
    	if(is4Survey){
        	setOptionTextForRelative(document.forms[0].elements["optionInfo.fromTimeInfo.time"],7,document.forms[0].elements["optionInfo.fromTimeInfo.time"].selectedIndex);
        }else{
			setOptionTextForRelative(document.forms[0].elements["optionInfo.fromTimeInfo.time"],366,document.forms[0].elements["optionInfo.fromTimeInfo.time"].selectedIndex);
        }
    }else if(document.forms[0].elements["optionInfo.fromTimeInfo.timeUnit"].options[document.forms[0].elements["optionInfo.fromTimeInfo.timeUnit"].selectedIndex].value=="Weeks"){
    	if(is4Survey){
        	setOptionTextForRelative(document.forms[0].elements["optionInfo.fromTimeInfo.time"],1,document.forms[0].elements["optionInfo.fromTimeInfo.time"].selectedIndex);
    	}else{
    		setOptionTextForRelative(document.forms[0].elements["optionInfo.fromTimeInfo.time"],52,document.forms[0].elements["optionInfo.fromTimeInfo.time"].selectedIndex);
        }
    }else if(document.forms[0].elements["optionInfo.fromTimeInfo.timeUnit"].options[document.forms[0].elements["optionInfo.fromTimeInfo.timeUnit"].selectedIndex].value=="Months"){
        setOptionTextForRelative(document.forms[0].elements["optionInfo.fromTimeInfo.time"],12,document.forms[0].elements["optionInfo.fromTimeInfo.time"].selectedIndex);
    }else if(document.forms[0].elements["optionInfo.fromTimeInfo.timeUnit"].options[document.forms[0].elements["optionInfo.fromTimeInfo.timeUnit"].selectedIndex].value=="Years"){
        setOptionTextForRelative(document.forms[0].elements["optionInfo.fromTimeInfo.time"],1,document.forms[0].elements["optionInfo.fromTimeInfo.time"].selectedIndex);
    }
}
function toTimeSelection(){
    if(document.forms[0].elements["optionInfo.toTimeInfo.timeUnit"].options[document.forms[0].elements["optionInfo.toTimeInfo.timeUnit"].selectedIndex].value=="Hours"){
        if(is4Survey){
        	setOptionTextForRelative(document.forms[0].elements["optionInfo.toTimeInfo.time"],168,document.forms[0].elements["optionInfo.toTimeInfo.time"].selectedIndex);
        }else{
        	setOptionTextForRelative(document.forms[0].elements["optionInfo.toTimeInfo.time"],512,document.forms[0].elements["optionInfo.toTimeInfo.time"].selectedIndex);
        }
    }else if(document.forms[0].elements["optionInfo.toTimeInfo.timeUnit"].options[document.forms[0].elements["optionInfo.toTimeInfo.timeUnit"].selectedIndex].value=="Days"){
        if(is4Survey){
        	setOptionTextForRelative(document.forms[0].elements["optionInfo.toTimeInfo.time"],7,document.forms[0].elements["optionInfo.toTimeInfo.time"].selectedIndex);
        }else{
        	setOptionTextForRelative(document.forms[0].elements["optionInfo.toTimeInfo.time"],366,document.forms[0].elements["optionInfo.toTimeInfo.time"].selectedIndex);
        }
    }else if(document.forms[0].elements["optionInfo.toTimeInfo.timeUnit"].options[document.forms[0].elements["optionInfo.toTimeInfo.timeUnit"].selectedIndex].value=="Weeks"){
        if(is4Survey){
        	setOptionTextForRelative(document.forms[0].elements["optionInfo.toTimeInfo.time"],1,document.forms[0].elements["optionInfo.toTimeInfo.time"].selectedIndex);
        }else{
        	setOptionTextForRelative(document.forms[0].elements["optionInfo.toTimeInfo.time"],52,document.forms[0].elements["optionInfo.toTimeInfo.time"].selectedIndex);
        }
    }else if(document.forms[0].elements["optionInfo.toTimeInfo.timeUnit"].options[document.forms[0].elements["optionInfo.toTimeInfo.timeUnit"].selectedIndex].value=="Months"){
        setOptionTextForRelative(document.forms[0].elements["optionInfo.toTimeInfo.time"],12,document.forms[0].elements["optionInfo.toTimeInfo.time"].selectedIndex);
    }else if(document.forms[0].elements["optionInfo.toTimeInfo.timeUnit"].options[document.forms[0].elements["optionInfo.toTimeInfo.timeUnit"].selectedIndex].value=="Years"){
        setOptionTextForRelative(document.forms[0].elements["optionInfo.toTimeInfo.time"],1,document.forms[0].elements["optionInfo.toTimeInfo.time"].selectedIndex);
    }
    
}
function setOptionTextForRelative(the_select, days,index){
    for (var loop=0; loop < days; loop++){
       the_select.options[loop] = new Option(loop+1,loop+1);
    }
    the_select.length=days;
    if(index<0 || index>=days){
       index=0;
    }
    the_select.selectedIndex=index;
}



//For absolute
function setOptionText(the_select, days,index){
    if(days<9){
        for (var loop=0; loop < days; loop++){
            the_select.options[loop]=new Option("0"+(loop+1),loop+1);
        }
    }else{
        for (var loop=0; loop < 9; loop++){
            the_select.options[loop]=new Option("0"+(loop+1),loop+1);
        }
        for (var loop=9; loop < days; loop++){
            the_select.options[loop]=new Option(loop+1,loop+1);
        }
    }
    the_select.length=days;
    if(index<0 || index>=days){
       index=0;
    }
    the_select.selectedIndex=index;
}

function onChangeFromYear(sey){
    fyearTmp=sey;
    if(fmonthTmp==2){
        if(isSpecialYear(sey)){
            setOptionText(document.forms[0].elements["optionInfo.fromTimeInfo.day"],29,document.forms[0].elements["optionInfo.fromTimeInfo.day"].selectedIndex );
        }else{
            setOptionText(document.forms[0].elements["optionInfo.fromTimeInfo.day"],28,document.forms[0].elements["optionInfo.fromTimeInfo.day"].selectedIndex );
        }
    }
}
function onChangeToYear(sey){
    tyearTmp=sey;
    if(tmonthTmp==2){
        if(isSpecialYear(sey)){
            setOptionText(document.forms[0].elements["optionInfo.toTimeInfo.day"],29,document.forms[0].elements["optionInfo.toTimeInfo.day"].selectedIndex );
        }else{
            setOptionText(document.forms[0].elements["optionInfo.toTimeInfo.day"],28,document.forms[0].elements["optionInfo.toTimeInfo.day"].selectedIndex );
        }
    }
}
function swapFromDaySet(month){
    var yearSelected=fyearTmp;
    var monthSelected=month;
    fmonthTmp=month;
    if(month==1||month==3||month==5||month==7||month==8||month==10||month==12){
        setOptionText(document.forms[0].elements["optionInfo.fromTimeInfo.day"],31,document.forms[0].elements["optionInfo.fromTimeInfo.day"].selectedIndex );
    }else if(month==4||month==6||month==9||month==11){
        setOptionText(document.forms[0].elements["optionInfo.fromTimeInfo.day"],30,document.forms[0].elements["optionInfo.fromTimeInfo.day"].selectedIndex );
    }else if(month=="2"&&isSpecialYear(yearSelected)){
        setOptionText(document.forms[0].elements["optionInfo.fromTimeInfo.day"],29,document.forms[0].elements["optionInfo.fromTimeInfo.day"].selectedIndex );
    }else{
        setOptionText(document.forms[0].elements["optionInfo.fromTimeInfo.day"],28,document.forms[0].elements["optionInfo.fromTimeInfo.day"].selectedIndex );
    }
}
function swapToDaySet(month){
    var yearSelected=tyearTmp;
    var monthSelected=month;
    tmonthTmp=month;
    if(month==1||month==3||month==5||month==7||month==8||month==10||month==12){
        setOptionText(document.forms[0].elements["optionInfo.toTimeInfo.day"],31,document.forms[0].elements["optionInfo.toTimeInfo.day"].selectedIndex );
    }else if(month==4||month==6||month==9||month==11){
        setOptionText(document.forms[0].elements["optionInfo.toTimeInfo.day"],30,document.forms[0].elements["optionInfo.toTimeInfo.day"].selectedIndex );
    }else if(month==2&&(isSpecialYear(yearSelected))){
        setOptionText(document.forms[0].elements["optionInfo.toTimeInfo.day"],29,document.forms[0].elements["optionInfo.toTimeInfo.day"].selectedIndex );
    }else{
        setOptionText(document.forms[0].elements["optionInfo.toTimeInfo.day"],28,document.forms[0].elements["optionInfo.toTimeInfo.day"].selectedIndex );
    }
}
function isSpecialYear(year){
    if(year % 4==0){
        if(year % 100!=0){
            return true;
        }else{
            if(year % 400==0){
                return true;
            }else{
                return false;
            }
        }
    }else{
        return false;
    }
}