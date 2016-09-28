<!--
        Copyright (c) 2001 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->


<!-- "@(#) $Id: displaycharstylejs.jsp,v 1.2301 2003/12/24 07:40:03 zhangjx Exp $" -->

<script language=javascript>
function display(key,content)
{
    if (content=="null"||content=="")
        return;
    if(key.toLowerCase()=="<%=FCSANConstants.FCSAN_STATE_ATTN.toLowerCase()%>"
        || key.toLowerCase()=="<%=FCSANConstants.FCSAN_STATE_UNKNOWN.toLowerCase()%>"
        ||key.toLowerCase()=="-")
    {
        document.write(content);
        return;
    }
    if(key.toLowerCase()=="<%=FCSANConstants.FCSAN_STATE_REDAY.toLowerCase()%>")
    {
        document.write('<font color=green>'+content+'</font>');
        return;
    }else{
        document.write('<font color=red>'+content+'</font>');
    }
}
</script>
