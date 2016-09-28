<%
Boolean isNasHead =
(Boolean)session.getAttribute(NSConstant.SESSION_ISNASHEAD);
String forNashead="";
if (isNasHead.booleanValue()){
    forNashead="/for_nashead";
}
%>