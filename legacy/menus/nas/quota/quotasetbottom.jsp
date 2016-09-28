<!--
        Copyright (c) 2001-2007 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->



<!-- "@(#) $Id: quotasetbottom.jsp,v 1.2306 2007/09/18 00:47:28 yangxj Exp $" -->

<%@ page contentType="text/html;charset=EUC-JP"%>
<%@ page language="java"  import="com.nec.sydney.beans.base.*"%>
<%@ page import="com.nec.sydney.beans.base.*"%>
<%@ page import="com.nec.sydney.atom.admin.base.*"%>
<%@ page import="com.nec.sydney.framework.*" %>
<%@ taglib uri="taglib-nsgui" prefix="nsgui" %>
<script src="../common/general.js"></script>

<jsp:useBean id="QuotaSetBean" class="com.nec.sydney.beans.quota.QuotaSetBean" scope="page"/>
<jsp:useBean id="GetReport4SetBean" class="com.nec.sydney.beans.quota.GetReport4SetBean" scope="page"/>
<%AbstractJSPBean _abstractJSPBean = QuotaSetBean; %>
<%@include file="../../../menu/common/includeheader.jsp" %>
<%
    String idnumber = request.getParameter("idnumber");
    String flagUser = request.getParameter("flagUser");
    String blockSoft = request.getParameter("blockSoft");
    String blockHard = request.getParameter("blockHard");
    String fileSoft = request.getParameter("fileSoft");
    String fileHard = request.getParameter("fileHard");
%>

<html>
<head>
<title>Set quota</title>
<link rel="stylesheet" href="<%= NSConstant.DefaultCSS %>" type="text/css">
<META HTTP-EQUIV="content-type" CONTENT="text/html; charset=EUC-JP">
<jsp:include page="../../common/wait.jsp" />
<script language="javaScript">
function init()
{
    <%if(blockSoft != null){
        if(idnumber.equals("0") && flagUser.equals("true")){%>
            document.forms[0].radio[0].checked=1;
        <%}
        if(idnumber.equals("0") && flagUser.equals("false")){%>
            document.forms[0].radio[1].checked=1;
        <%}
        if((!idnumber.equals("0"))&& flagUser.equals("true")){%>
            document.forms[0].radio[2].checked=1;
            document.forms[0].username.value="<%=idnumber%>";
        <%}
        if((!idnumber.equals("0"))&& flagUser.equals("false")){%>
            document.forms[0].radio[3].checked=1;
            document.forms[0].groupname.value="<%=idnumber%>";
        <%}%>
        
        <%if(blockSoft.equals("0") && blockHard.equals("0")){%>
         //   document.forms[0].boxofblock.checked=1;
         //   document.forms[0].blocksoft.disabled=true;
         //   document.forms[0].blockhard.disabled=true;
         //   document.forms[0].unitofblock.disabled=true;
        <%} else {
            if(!blockSoft.equals("0")){%>
                document.forms[0].blocksoft.value="<%=GetReport4SetBean.changeUnit4SetShow((new Long(blockSoft)).longValue()*1024,"M")%>";
            <%}
            if(!blockHard.equals("0")){%>
                document.forms[0].blockhard.value="<%=GetReport4SetBean.changeUnit4SetShow((new Long(blockHard)).longValue()*1024,"M")%>";
            <%}%>
        <%}%>  
        
        <%if(fileSoft.equals("0") && fileHard.equals("0")){%>
            //document.forms[0].boxoffile.checked=1;
           // document.forms[0].filesoft.disabled=true;
           // document.forms[0].filehard.disabled=true;
        <%} else {
            if(!fileSoft.equals("0")){%>
                document.forms[0].filesoft.value="<%=fileSoft%>";
            <%}
            if(!fileHard.equals("0")){%>
                document.forms[0].filehard.value="<%=fileHard%>";
            <%}%>
        <%}
    }%>
    
}

function checktext()
{
    if(document.forms[0].radio[0].checked)
        document.forms[0].username.disabled=true;//2002/4/27 lhy add for disable logic
        document.forms[0].groupname.disabled=true;
    if(document.forms[0].radio[1].checked)
        document.forms[0].username.disabled=true;
        document.forms[0].groupname.disabled=true;//2002/4/27 lhy add for disable logic
    if(document.forms[0].radio[2].checked){
        //2002/4/27 lhy delfor disable logic document.forms[0].username.disabled=true;
         document.forms[0].groupname.disabled=true;
         document.forms[0].username.disabled=false;//2002/4/27 lhy add for disable logic
    }
    if(document.forms[0].radio[3].checked){
        document.forms[0].username.disabled=true;
        //2002/4/27 lhy del for disable logic  document.forms[0].groupname.disabled=true;
        document.forms[0].groupname.disabled=false;//2002/4/27 lhy add for disable logic
    }
}
function clickUser()
{
    document.forms[0].blocksoft.value="";
    document.forms[0].blockhard.value="";
    document.forms[0].filesoft.value="";
    document.forms[0].filehard.value="";
    document.forms[0].username.disabled=false;
    document.forms[0].groupname.disabled=true;
}

function clickGroup()
{
    document.forms[0].blocksoft.value="";
    document.forms[0].blockhard.value="";
    document.forms[0].filesoft.value="";
    document.forms[0].filehard.value="";
    document.forms[0].groupname.disabled=false;
    document.forms[0].username.disabled=true;
}

function clickTemplate()
{
    document.forms[0].blocksoft.value="";
    document.forms[0].blockhard.value="";
    document.forms[0].filesoft.value="";
    document.forms[0].filehard.value="";
    document.forms[0].username.disabled=true;
    document.forms[0].groupname.disabled=true;
}

function disableBlockProperty()
{
    if(document.forms[0].blocksoft.disabled)
    {
        document.forms[0].blocksoft.disabled=false;
        document.forms[0].blockhard.disabled=false;
        document.forms[0].unitofblock.disabled=false;
    }
    else
    {
        document.forms[0].blocksoft.disabled=true;
        document.forms[0].blockhard.disabled=true;
        document.forms[0].unitofblock.disabled=true;
    }
}
function disableFileProperty()
{
        if(document.forms[0].filesoft.disabled)
    {
        document.forms[0].filesoft.disabled=false;
        document.forms[0].filehard.disabled=false;
    }
    else
    {
        document.forms[0].filesoft.disabled=true;
        document.forms[0].filehard.disabled=true;
    }
}

function check(str)
{

    var avail = /[^0-9]/g;
    ifFind = str.search(avail);
    if(ifFind!=-1){
        return false;
    }else{
        return true;
    }
}

function checkFloat(str)
{
    str = str.replace(/,/g,'');
    var index = str.indexOf("\.");
    var lastindex = str.lastIndexOf("\.");
    if(index >= 0){
        if( index == 0 || index != lastindex || str.length-index-1 > 2 ){
            return false;
        }
    }
    var avail = /[^\.0-9]/g;
    ifFind = str.search(avail);
    if(ifFind!=-1){
        return false;
    }else{
        return true;
    }
}

function getRightSize4Set(str)
{
    str = str.replace(/,/g,'');
    var index=str.search("\\.");
    if(index > 0){
        if(str.length - index -1 == 2){
            str = str.substring(0,index)+str.substring(index+1,str.length);
        }else{
            str = str.substring(0,index)+str.substring(index+1,str.length)+"0";
        }
    }else {
        str = str + "00";
    }
    return str;
}

function checkID(str)
{
   <% if(QuotaSetBean.getFsType().equals(NasConstants.FILETYPE_NT)){%>
        return false;
   <%}%>

    var avail = /[^0-9]/g;
    ifFind = str.search(avail);
    if(ifFind!=-1){
        return false;
    }else{
        return true;
    }
}

function checkName(str)
{
    var invalid;
    var valid;
<% if(QuotaSetBean.getFsType().equals(NasConstants.FILETYPE_NT)){%>
    var validstr ="abcdefghijklmnopqrstuvwxyz0123456789~`!@#$%^&()_-\"\'.{} ";

    var i,j;
    for(i=0; i<str.length; i++) {
        for(j=0; j<validstr.length; j++) {
            if( str.charAt(i).toLowerCase()==validstr.charAt(j) ){
                break;
            }
        }
        if(j >= validstr.length){
            return false;
        }
    }
    return true;

//invalid character    \/[]:|<>+=;,?*
//ALL = a-zA-Z0-9~`!@#$%^&*()_-+=|\}]{["':;?/>.<,


<%}else{%>
    invalid = /[^a-zA-Z0-9._\-]/g;

    ifFind = str.search(invalid);
    if(ifFind!=-1){
        return false;
    }
    return true;
<%}%>
}


function onSet()
{
    var flagUser;
    var flagName=false;
    var idnumber;
    var confMsg1;

    if (document.forms[0].radio[2].checked)
    {
        flagUser="true";
        <% if(QuotaSetBean.getFsType().equals(NasConstants.FILETYPE_NT)){%>
            if( trim(document.forms[0].username.value)=="" ) {
                alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="nas_quota/alert/nt_non_username"/>");
                return false;
            }
        <%}else{%>
            if( trim(document.forms[0].username.value)=="" ){
                alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="nas_quota/alert/non_username"/>");
                return false;
            }
            if( document.forms[0].username.value==0 || document.forms[0].username.value=="root") {
                alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="nas_quota/alert/inputUser"/>");
                return false;
            }
        <%}%>
        idnumber = document.forms[0].username.value;     

        //add begin:2002/06/17 lhy add for mail[nas-dev-02931]
        if(checkID(idnumber)==true){  //user input ID
            if(idnumber>4294967295){
                alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="nas_quota/alert/userIDLimit"/>");
                return false;
            }
            idnumber = parseInt(idnumber,10).toString();
        }else if (checkName(idnumber)){ //else user input name and the name is valid; hj add 8/7/2002
            flagName="true";
        }else{//the user input name and the name is invalid
            <% if(QuotaSetBean.getFsType().equals(NasConstants.FILETYPE_NT)){%>
                alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="nas_quota/alert/nt_nameError"/>");
            <%}else{%>

                alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="nas_quota/alert/nameError"/>");
            <%}%>
            return false;
        }
        confMsg1 = "<nsgui:message key="nas_quota/quotasetbottom/td_user"/>" + " : " + idnumber;
    }
    else if (document.forms[0].radio[3].checked)
    {
        flagUser="false";
        <% if(QuotaSetBean.getFsType().equals(NasConstants.FILETYPE_NT)){%>
            if( trim(document.forms[0].groupname.value)=="" ) {
                alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="nas_quota/alert/nt_non_groupname"/>");
                return false;
            }
        <%}else{%>
            if( trim(document.forms[0].groupname.value)=="" ){
                alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="nas_quota/alert/non_groupname"/>");
                return false;
            }
            if( document.forms[0].groupname.value==0 || document.forms[0].groupname.value=="root") {
                alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="nas_quota/alert/inputGroup"/>");
                return false;
            }
        <%}%>

        idnumber = document.forms[0].groupname.value;
        //add begin:2002/06/17 lhy add for mail[nas-dev-02931]
        if(checkID(idnumber)==true){  //user input ID
            if(idnumber>4294967295){
                alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="nas_quota/alert/groupIDLimit"/>");
                return false;
            }
            idnumber = parseInt(idnumber,10).toString();
        }else if (checkName(idnumber)){ //else user input name and the name is valid; hj add 8/7/2002
            flagName="true";
        }else{//the user input name and the name is invalid
            <% if(QuotaSetBean.getFsType().equals(NasConstants.FILETYPE_NT)){%>
                alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="nas_quota/alert/nt_groupNameError"/>");
            <%}else{%>

                alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="nas_quota/alert/groupNameError"/>");
            <%}%>
            return false;
        }
        //add end:2002/06/17 lhy add for mail[nas-dev-02931]
        confMsg1 = "<nsgui:message key="nas_quota/quotasetbottom/td_group"/>" + " : " + idnumber;
    }
    else if (document.forms[0].radio[0].checked)
    {
        flagUser="true";
        idnumber = 0;
        flagName="false";//2002/06/17 lhy add for mail[nas-dev-02931]
        confMsg1 = "<nsgui:message key="nas_quota/quotasetbottom/td_user"/>" + " : "
                   + "<nsgui:message key="nas_quota/quotasetbottom/td_usert"/>";
    }
    else if (document.forms[0].radio[1].checked)
    {
        flagUser="false";
        idnumber = 0;
        flagName="false";//2002/06/17 lhy add for mail[nas-dev-02931]
        confMsg1 = "<nsgui:message key="nas_quota/quotasetbottom/td_group"/>" + " : "
                   + "<nsgui:message key="nas_quota/quotasetbottom/td_groupt"/>";

    }
    else
    {
        alert ("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="nas_quota/alert/nullradio"/>");
        return;
    }

    var bs_unlimited = 0;
    var bh_unlimited = 0;
    var fs_unlimited = 0;
    var fh_unlimited = 0;

    if (document.forms[0].boxofblock.checked)
    {
        document.forms[0].blocksoft.value="0";
        document.forms[0].blockhard.value="0";
    }
    if (document.forms[0].boxoffile.checked)
    {
        document.forms[0].filesoft.value="0";
        document.forms[0].filehard.value="0";
    }
    if (document.forms[0].blocksoft.value =="")
    {
        bs_unlimited = 1;
        document.forms[0].blocksoft.value = "0";
    }
    else
    {
        if (checkFloat(document.forms[0].blocksoft.value)==false)
        {
            alert ("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="nas_quota/alert/error1"/>");
            return false;
        }
    }
    if (document.forms[0].blockhard.value =="")
    {
        bh_unlimited = 1;
        document.forms[0].blockhard.value = "0";
    }
    else
    {
        if (checkFloat(document.forms[0].blockhard.value)==false)
        {
            alert ("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="nas_quota/alert/error2"/>");
            return false;
        }
    }
    if (document.forms[0].filesoft.value =="")
    {
        fs_unlimited = 1;
        document.forms[0].filesoft.value = "0";
    }
    else
    {
        if (check(document.forms[0].filesoft.value)==false)
        {
            alert ("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="nas_quota/alert/error3"/>");
            return false;
        }
    }
    if (document.forms[0].filehard.value =="")
    {
        fh_unlimited = 1;
        document.forms[0].filehard.value = "0";
    }
    else
    {
        if (check(document.forms[0].filehard.value)==false)
        {
            alert ("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="nas_quota/alert/error4"/>");
            return false;
        }
    }

    var blocksoft = document.forms[0].blocksoft.value;
    var blockhard = document.forms[0].blockhard.value;
    var filesoft = document.forms[0].filesoft.value;
    var filehard = document.forms[0].filehard.value;

    //add begin: 2002/4/27 lhy add for checking relationship of soft and hard
    //blocksoft=parseInt(blocksoft,10);
    //blockhard=parseInt(blockhard,10);
    filesoft=parseInt(filesoft,10);
    filehard=parseInt(filehard,10);
    blocksoft=getRightSize4Set(blocksoft);//blocksoft 's size has been multiplied by 100
    blockhard=getRightSize4Set(blockhard);//blocksoft 's size has been multiplied by 100
    blocksoft=parseInt(blocksoft,10);
    blockhard=parseInt(blockhard,10);
    
    //var upLimit= 1099511627776; //2002/8/7 hj modify for mail[nas-dev-necas-3208] the max is 1TB
    //var upLimit= 1048576;//The old uplimit is 1TB
    //var upLimit= 134217728;//The old uplimit is 128TB
    var upLimit= 13421772800;//modify by cuihw fo compare for reference
    var blockValidFlag=0;
    var confMsg2;
    var limitMsg;
    if(document.forms[0].unitofblock.options[document.forms[0].unitofblock.selectedIndex].value=="/M"){
        //upLimit=upLimit/(1024*1024);
        confMsg2 = " MB";
        //limitMsg = "1048576MB";
        limitMsg = "134217728MB";
    }else{
        if(document.forms[0].unitofblock.options[document.forms[0].unitofblock.selectedIndex].value=="/G"){
            //upLimit=upLimit/(1024*1024*1024);
            upLimit=upLimit/1024;
            confMsg2 = " GB";
            //limitMsg = "1024GB";
            limitMsg = "131072GB";
        }
    }
    var ret;
    if(blockhard>upLimit){
         ret=confirm(<nsgui:message key="nas_quota/alert/blockupLimit" firstReplace="limitMsg" separate="true" />);
         if(!ret){
            return false;
         }else{
            if(blocksoft>upLimit){
                blocksoft=upLimit;
            }
            blockhard=upLimit;
         }
    }

    if(blockhard !=0 && blocksoft>blockhard){
        alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="nas_quota/alert/blockLimitErr1"/>");
        return false;
    }else if(blocksoft>upLimit){
         ret=confirm(<nsgui:message key="nas_quota/alert/blockupLimit" firstReplace="limitMsg" separate="true" />);
         if(!ret){
            return false;
         }
         blocksoft=upLimit;
    }

    /*else if (blocksoft == blockhard && blocksoft != 0 ){
        alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="nas_quota/alert/blockLimitErr2"/>");
        return false;
    }*/// reference: (nas 4009) [nas-dev-necas:03442]

    //add end: 2002/4/27 lhy add for checking relationship of soft and hard,limit
    //add begin:2002/5/9 lhy add for checking relationship of file soft,hard and uplimit
    upLimit=2000000000;  //modify by hj 2002/8/7, mail [nec-necas-dev-3208
    if(filehard>upLimit){
         ret=confirm("<nsgui:message key="nas_quota/alert/fileupLimit"/>");
         if(!ret){
            return false;
         }else{
            if(filesoft>upLimit){
                filesoft=upLimit;
            }
            filehard=upLimit;
         }
    }
    //add end:2002/5/9 lhy add for checking relationship of file soft,hard and uplimit

    if(filehard != 0 && filesoft > filehard){
        alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="nas_quota/alert/fileLimitErr1"/>");
        return false;
    }else if(filesoft>upLimit){
        ret=confirm("<nsgui:message key="nas_quota/alert/fileupLimit"/>");
        if(!ret){
            return false;
        }
        filesoft=upLimit;
    }

    /*else if (filesoft == filehard && filesoft != 0 ){
        alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="nas_quota/alert/fileLimitErr2"/>");
        return false;
    }*/// reference: (nas 4009) [nas-dev-necas:03442]

    var blockConfMsg;
    var fileConfMsg;
    blocksoft = blocksoft/100;//modify by cuihw
    blockhard = blockhard/100;//modify by cuihw
    var msg_blocksoft = "";
    var msg_blockhard = "";
    var msg_filesoft = "";
    var msg_filehard = "";
    
    if (blocksoft != 0){
        msg_blocksoft = "<nsgui:message key="nas_quota/quotasetbottom/td_211" />" + " : " + blocksoft + confMsg2 + "\r\n";
    }else if(bs_unlimited == 0){
        msg_blocksoft = "<nsgui:message key="nas_quota/quotasetbottom/td_211" />" + " : " + "<nsgui:message key="nas_quota/quotasetbottom/td_214" />" + "\r\n";
    }
    if (blockhard != 0){
        msg_blockhard = "<nsgui:message key="nas_quota/quotasetbottom/td_212" />" + " : " + blockhard + confMsg2 + "\r\n";
    }else if(bh_unlimited == 0){
        msg_blockhard = "<nsgui:message key="nas_quota/quotasetbottom/td_212" />" + " : " + "<nsgui:message key="nas_quota/quotasetbottom/td_214" />" + "\r\n";
    }

    if (filesoft != 0){
        msg_filesoft = "<nsgui:message key="nas_quota/quotasetbottom/td_231" />" + " : " + filesoft + "\r\n";
    }else if(fs_unlimited == 0){
        msg_filesoft = "<nsgui:message key="nas_quota/quotasetbottom/td_231" />" + " : " + "<nsgui:message key="nas_quota/quotasetbottom/td_214" />" + "\r\n";
    }

    if (filehard != 0){
        msg_filehard = "<nsgui:message key="nas_quota/quotasetbottom/td_232" />" + " : " + filehard;
    }else if(fh_unlimited == 0){
        msg_filehard = "<nsgui:message key="nas_quota/quotasetbottom/td_232" />" + " : " + "<nsgui:message key="nas_quota/quotasetbottom/td_214" />" + "\r\n";
    }   
    
    var confMsg = "<nsgui:message key="common/confirm" />" + "\r\n"
                  + "<nsgui:message key="common/confirm/act" />"
                  + "<nsgui:message key="nas_quota/quotasettop/href_3" />" + "\r\n"
                  + confMsg1 + "\r\n" + msg_blocksoft + msg_blockhard + msg_filesoft + msg_filehard;
                  
    if( bs_unlimited + bh_unlimited + fs_unlimited + fh_unlimited > 0 ){ 
        confMsg = "<nsgui:message key="nas_quota/alert/confirm_setspace" />"+ "\r\n" + confMsg;
    }
    
    if(isSubmitted() && confirm(confMsg))
    {   
        setSubmitted();
        var unitofblock = document.forms[0].unitofblock.options[document.forms[0].unitofblock.selectedIndex].value;
        if(bs_unlimited == 1){
            blocksoft="-1";
        }
        if(bh_unlimited == 1){
            blockhard="-1";
        }
        if(fs_unlimited == 1){
            filesoft="-1";
        }
        if(fh_unlimited == 1){
            filehard="-1";
        }
        window.location="<%=response.encodeURL("quotasetactually.jsp")%>?"
                         +"idnumber="+URLEncoder(idnumber)
                         +"&flagUser="+URLEncoder(flagUser)
                         +"&flagName="+URLEncoder(flagName)
                         +"&blockSoftLimit="+URLEncoder(blocksoft)
                         +"&blockHardLimit="+URLEncoder(blockhard)
                         +"&fileSoftLimit="+URLEncoder(filesoft)
                         +"&fileHardLimit="+URLEncoder(filehard)
                         +"&unitOfBlock="+URLEncoder(unitofblock);
    }
}


function onReference()
{
    var flagUser;
    var flagName=false;
    var idnumber;
    if (document.forms[0].radio[2].checked)
    {
        flagUser="true";
        <% if(QuotaSetBean.getFsType().equals(NasConstants.FILETYPE_NT)){%>
            if( trim(document.forms[0].username.value)=="" ) {
                alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="nas_quota/alert/nt_non_username"/>");
                return false;
            }
        <%}else{%>
            if( trim(document.forms[0].username.value)=="" ){
                alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="nas_quota/alert/non_username"/>");
                return false;
            }
            if( document.forms[0].username.value==0 || document.forms[0].username.value=="root") {
                alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="nas_quota/alert/inputUser"/>");
                return false;
            }
        <%}%>
        idnumber = document.forms[0].username.value;     

        //add begin:2002/06/17 lhy add for mail[nas-dev-02931]
        if(checkID(idnumber)==true){  //user input ID
            if(idnumber>4294967295){
                alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="nas_quota/alert/userIDLimit"/>");
                return false;
            }
            idnumber = parseInt(idnumber,10).toString();
        }else if (checkName(idnumber)){ //else user input name and the name is valid; hj add 8/7/2002
            flagName="true";
        }else{//the user input name and the name is invalid
            <% if(QuotaSetBean.getFsType().equals(NasConstants.FILETYPE_NT)){%>
                alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="nas_quota/alert/nt_nameError"/>");
            <%}else{%>

                alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="nas_quota/alert/nameError"/>");
            <%}%>
            return false;
        }
    }
    else if (document.forms[0].radio[3].checked)
    {
        flagUser="false";
        <% if(QuotaSetBean.getFsType().equals(NasConstants.FILETYPE_NT)){%>
            if( trim(document.forms[0].groupname.value)=="" ) {
                alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="nas_quota/alert/nt_non_groupname"/>");
                return false;
            }
        <%}else{%>
            if( trim(document.forms[0].groupname.value)=="" ){
                alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="nas_quota/alert/non_groupname"/>");
                return false;
            }
            if( document.forms[0].groupname.value==0 || document.forms[0].groupname.value=="root") {
                alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="nas_quota/alert/inputGroup"/>");
                return false;
            }
        <%}%>

        idnumber = document.forms[0].groupname.value;
        //add begin:2002/06/17 lhy add for mail[nas-dev-02931]
        if(checkID(idnumber)==true){  //user input ID
            if(idnumber>4294967295){
                alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="nas_quota/alert/groupIDLimit"/>");
                return false;
            }
            idnumber = parseInt(idnumber,10).toString();
        }else if (checkName(idnumber)){ //else user input name and the name is valid; hj add 8/7/2002
            flagName="true";
        }else{//the user input name and the name is invalid
            <% if(QuotaSetBean.getFsType().equals(NasConstants.FILETYPE_NT)){%>
                alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="nas_quota/alert/nt_groupNameError"/>");
            <%}else{%>

                alert("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="nas_quota/alert/groupNameError"/>");
            <%}%>
            return false;
        }
        //add end:2002/06/17 lhy add for mail[nas-dev-02931]
    }
    else if (document.forms[0].radio[0].checked)
    {
        flagUser="true";
        idnumber = 0;
        flagName="false";//2002/06/17 lhy add for mail[nas-dev-02931]
    }
    else if (document.forms[0].radio[1].checked)
    {
        flagUser="false";
        idnumber = 0;
        flagName="false";//2002/06/17 lhy add for mail[nas-dev-02931]

    }
    else
    {
        alert ("<nsgui:message key="common/alert/failed"/>"+"\r\n"+"<nsgui:message key="nas_quota/alert/nullradio"/>");
        return;
    }

    if(isSubmitted())
    {
        setSubmitted();
        window.location="<%=response.encodeURL("quotasetreference.jsp")%>?"
                         +"idnumber="+URLEncoder(idnumber)
                         +"&flagUser="+URLEncoder(flagUser)
                         +"&flagName="+URLEncoder(flagName);
    }
}

</script>
</head>
<body onload="init();checktext();displayAlert()">
<form name="form1">
<h2 class="title"><nsgui:message key="nas_quota/quotasettop/href_3"/></h2>
<h3 class="title"><nsgui:message key="nas_quota/quotasetbottom/info_userorgroup"/></h3>

<table border="1">
    <tr>
        <td><input type="radio" name="radio" id="radioID1" onclick="clickTemplate()"></td>
        <td colspan=2><label for="radioID1"><nsgui:message key="nas_quota/quotasetbottom/td_usert"/></label></td>
        <!--<td></td>liuhy del at 2002/5/7 adding colspan=2-->
    </tr>
    <tr>
        <td><input type="radio" name="radio" id="radioID2" onclick="clickTemplate()"></td>
        <td colspan=2><label for="radioID2"><nsgui:message key="nas_quota/quotasetbottom/td_groupt"/></label></td>
        <!--<td></td>liuhy del at 2002/5/7 adding colspan=2-->
    </tr>
    <tr>
        <td><input type="radio" name="radio" id="radioID3" checked onclick="clickUser()"></td>
        <td><label for="radioID3"><nsgui:message key="nas_quota/quotasetbottom/td_user"/></label></td>
        <td><input type="text" name="username" maxlength="32" onfocus="if(this.disabled) this.blur()" ></td>
    </tr>
    <tr>
        <td><input type="radio" name="radio" id="radioID4" onclick="clickGroup()"></td>
        <td><label for="radioID4"><nsgui:message key="nas_quota/quotasetbottom/td_group"/></label></td>
        <td><input type="text" name="groupname" maxlength="32" onfocus="if(this.disabled) this.blur()" ></td>
    </tr>

</table>
<br>
<input type="button" name="reference"
    value="<nsgui:message key="nas_quota/quotasetbottom/info_reference"/>" onClick="return onReference()">
<h3 class="title"><nsgui:message key="nas_quota/quotasetbottom/info_property"/></h3>

<table border="1">
    <tr>
        <th align="left" nowrap><nsgui:message key="nas_quota/quotasetbottom/td_211"/></th>
        <th align="left" nowrap><nsgui:message key="nas_quota/quotasetbottom/td_212"/></th>
        <th align="left" nowrap><nsgui:message key="nas_quota/quotasetbottom/td_213"/></th>
        <th align="left" nowrap><nsgui:message key="nas_quota/quotasetbottom/td_214"/></th>
    </tr>
    <tr>
        <td><input type="edit" name="blocksoft" maxlength="14" onfocus="if(this.disabled) this.blur()"></td>
        <td><input type="edit" name="blockhard" maxlength="14" onfocus="if(this.disabled) this.blur()"></td>
        <td><select name="unitofblock">
                <option selected value="/M">M
                <option value="/G">G
            </select>
        </td>
        <td><input type="checkbox" name="boxofblock" onClick="disableBlockProperty()" ></td>
    </tr>
    <tr>
        <th align="left" nowrap><nsgui:message key="nas_quota/quotasetbottom/td_231"/></th>
        <th align="left" nowrap colspan=2><nsgui:message key="nas_quota/quotasetbottom/td_232"/></th>
        <!--<td>&nbsp;&nbsp;&nbsp;&nbsp;</td> liuhy del at 2002/5/7 ading colspan=2-->
        <th align="left" nowrap><nsgui:message key="nas_quota/quotasetbottom/td_234"/></th>
    </tr>
    <tr>
        <td><input type="edit" name="filesoft" maxlength="10" onfocus="if(this.disabled) this.blur()"></td>
        <td colspan=2><input type="edit" name="filehard" maxlength="10" onfocus="if(this.disabled) this.blur()"></td>
        <!--<td></td> lhy del at 2002/5/7 adding colspan=2-->
        <td><input type="checkbox" name="boxoffile" onclick="disableFileProperty()"></td>
    </tr>
</table>
<br>
<input type="button" name="set"
    value="<nsgui:message key="common/button/submit"/>" onClick="return onSet()">
<input type="hidden" name="alertFlag" value="enable">

</form>

</body>
</html>
