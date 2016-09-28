<!--
        Copyright (c) 2001-2006 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: datasetdestroy.jsp,v 1.2301 2006/02/20 00:35:05 zhangjun Exp $" -->

<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page language="java" import="com.nec.sydney.beans.base.*"%>

<jsp:useBean id="dsDelBean" class="com.nec.sydney.beans.dirquota.DatasetDestroyBean" scope="page"/>
<%AbstractJSPBean _abstractJSPBean = dsDelBean; %>
<%@include file="../../../menu/common/includeheader.jsp" %>

function checkButton(){
    document.forms[0].dirquota.disabled = true;
    if (parent.frames[1].document.forms[0]
        && parent.frames[1].document.forms[0].radiobutton){
        document.forms[0].dirquota.disabled = false;
        parent.frames[0].document.forms[0].datasetlist.disabled = false;
        parent.frames[0].document.forms[0].datasetadd.disabled = false;
        parent.frames[0].document.forms[0].datasetdel.disabled = false;
        if (parent.frames[1].document.forms[0].radiobutton.length){
            document.forms[0].dataset.value = parent.frames[1].forms[0].radiobutton[0].value;
        } else{
            document.forms[0].dataset.value = parent.frames[1].document.forms[0].radiobutton.value;
        }
    }
    
}