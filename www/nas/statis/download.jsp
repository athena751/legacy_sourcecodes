<% 
/*
 *      Copyright (c) 2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
 
String cvsid = "@(#) $Id: download.jsp,v 1.4 2008/07/21 10:06:39 yangxj Exp $"; 

String defaultFilename = (String)request.getAttribute("defaultFilename");
String tmpCsvFilename = (String)request.getAttribute("tmpCsvFilename");

response.reset();
response.setContentType("application/text"); 
response.setHeader("Content-Disposition","attachment; filename="+defaultFilename); 

java.io.OutputStream output = null;
java.io.FileInputStream fis = null;

try {   
	try{
		java.io.File file = new java.io.File(tmpCsvFilename);
		response.setHeader("Content-Length",Long.toString(file.length()));
		// if the filesize large than 2GB, then set Connection header
		if(file.length() >= 2147483648L){
			response.setHeader("Connection","close");
		}
	}catch(Exception e){
		//download without displaying total length.
	}
	output = response.getOutputStream();
	fis = new java.io.FileInputStream(tmpCsvFilename);  
	byte[] b = new byte[1024]; 
	int k = 0; 
	while ( (k = fis.read(b)) > 0 ) { 
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
        "/bin/rm", "-f", tmpCsvFilename };
    com.nec.nsgui.model.biz.base.CmdExecBase.execCmdForce(cmds, true); 
}
%>