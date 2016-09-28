<% 
/*
 *      Copyright (c) 2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
 
String cvsid = "@(#) $Id: logdownload.jsp,v 1.7 2008/07/21 10:06:32 yangxj Exp $"; 

String from = (String)request.getParameter("from");
if(from == null || from.trim().equals("")){
    from = (String)request.getAttribute("from");
}
String fileNames = "";
if(from.equals("logview")){
	fileNames = (String)session.getAttribute("logview_viewDownloadFile");	
}else if(from.equals("directDownload")){
	fileNames = (String)session.getAttribute("logview_directDownloadFile");
	session.removeAttribute("logview_directDownloadFile");
}

String logType = (String)request.getParameter("logType");
if(logType == null || logType.trim().equals("")){
    logType = (String)request.getAttribute("logType");
}

java.util.Calendar rightnow = java.util.Calendar.getInstance();
java.text.SimpleDateFormat sf = new java.text.SimpleDateFormat("yyyyMMdd"); 
String logTime = sf.format(rightnow.getTime());

String fname = logType + "-" + logTime + ".txt";

response.reset();

java.io.FileInputStream fis = null;

String [] fileNameList = fileNames.split("\\x00");
String noFilePage = "<html><body onload='window.parent.logviewframe.alertForNoTmpFile();'></body></html>";

boolean fileExists = true;
long filesize = 0;
try{
    for(int i = 0; i < fileNameList.length; i++){		
    	java.io.File file = new java.io.File(fileNameList[i]);
    	if(!file.exists()){
    		fileExists = false;
    		break;
    	}
    	filesize += file.length();
    }
}catch(Exception e){
	fileExists = false;
}
if(!fileExists && !from.equals("directDownload")){
	response.setContentType("text/html;charset=UTF-8");
	response.getWriter().println(noFilePage);
}else{
	java.io.OutputStream output = response.getOutputStream();
	try {   
		response.setContentType("application/text"); 
		response.setHeader("Content-Disposition","attachment; filename="+fname); 
		response.setHeader("Content-Length",Long.toString(filesize)); 
		//if the filesize large than 2GB, then set Connection header
		if(filesize >= 2147483648L){
			response.setHeader("Connection","close");
		}
		for(int i = 0; i < fileNameList.length; i++){		
		     fis = new java.io.FileInputStream(fileNameList[i]);  
		     byte[] b = new byte[1024]; 
		     int k = 0; 
		     while ( (k = fis.read(b)) > 0 ) 
		     { 
		         output.write(b, 0, k); 
		     }     
		     output.flush(); 
		 }  	    
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
	    if(from.equals("directDownload")){//need to delete temp file
	        for(int i = 0; i < fileNameList.length; i++){
	            String[] cmds =  {  
	                    com.nec.nsgui.model.biz.base.CmdExecBase.CMD_SUDO,
	                    "/bin/rm", "-f", fileNameList[i]                
	            };
	            com.nec.nsgui.model.biz.base.CmdExecBase.execCmdForce(cmds, true); 
	        }
	    }
	}
}
%>