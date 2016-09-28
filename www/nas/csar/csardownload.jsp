<% 
/*
 *      Copyright (c) 2008-2009 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
 
String cvsid = "@(#) $Id: csardownload.jsp,v 1.6 2009/02/11 10:04:51 wanghui Exp $"; 

String fname = (String)session.getAttribute("csar_filename");
com.nec.nsgui.action.base.NSActionUtil.setSessionAttribute(request,"csar_filename",null);

response.reset();
response.setContentType("application/x-compressed"); 
response.setHeader("Content-Disposition","attachment; filename="+fname); 

java.io.OutputStream output = null;
java.io.FileInputStream fis = null;

String root="/var/crash/.nsgui/";

try 
{ 
    output = response.getOutputStream(); 
    try{
	    long filesize = 0;
	    java.io.File file = new java.io.File(root + fname);
	    filesize = file.length();
	    response.setHeader("Content-Length",Long.toString(filesize)); 
	    if(filesize >= 2147483648L){
	        response.setHeader("Connection","close"); 
	    }
    }catch(Exception e){
        //download without displaying total length.
    }
    
    fis = new java.io.FileInputStream(root + fname);  
    byte[] b = new byte[1024]; 
    int k = 0; 
    while ( (k = fis.read(b)) > 0 ) 
    { 
        output.write(b, 0, k); 
    }     
    output.flush();   
    
} catch ( Exception e ) { 
	e.printStackTrace();    
} finally {
    try{
        if(fis != null){
            fis.close();        
            fis = null;
        }
    }catch(Exception e){
    }
    
    try{
        if(output != null){
            output.close();
            output = null;
        }
    }catch(Exception e){
    }
    
    String[] cmds =  {  
                com.nec.nsgui.model.biz.base.CmdExecBase.CMD_SUDO,
                "/bin/rm", "-f", root + fname                
                };
    com.nec.nsgui.model.biz.base.CmdExecBase.execCmdForce(cmds, true);    
}
%>