/*
 *      Copyright (c) 2004 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.model.biz.nashead;

import java.util.TreeMap;
import java.util.Vector;
import java.util.*;

import com.nec.nsgui.model.biz.base.NSCmdResult;
import com.nec.nsgui.model.biz.base.CmdExecBase;
import com.nec.nsgui.model.biz.base.NSModelUtil;

import com.nec.nsgui.model.entity.nashead.NasheadPortInfoBean;
import com.nec.nsgui.model.entity.nashead.NasheadLunInfoBean;

//get HBA information and port information
public class NasheadHandler {
    private static final String cvsid = "@(#) $Id: NasheadHandler.java,v 1.1 2004/11/12 03:08:48 jiangfx Exp $";

    private static final String NASHEAD_GETHBAINFO_PL = "/home/nsadmin/bin/nashead_gethbainfo.pl";
    
    private static final String PORT_TITLE = "Port#";
	
  	/**
      * get all port information of HBA card on specified node
      * @param  nodeNo -- int, specify on which node to execute cmd
      * @return hbaInfoVector -- Vector, element is object of NasheadPortInfoBean
      * 
      * output of "sudo NASHEAD_GETHBAINFO_PL":
      *		QLA2342 Port#1:
	  *	 	node-name=200000e08b12d95f
      *   	port-name=210000e08b12d95f
      *		QLA2342 Port#2:
	  *   	node-name=200100e08b32d95f
	  *   	port-name=210100e08b32d95f
      * @throws Exception
      */
    public Vector getHbaInfo(int nodeNo) throws Exception {
    	
    	//get HBA information
    	String[] cmd_getHbaInfo = {"sudo", NASHEAD_GETHBAINFO_PL};
    	NSCmdResult result = getCmdResult(cmd_getHbaInfo, nodeNo);
    	String[] hbaInfo = result.getStdout();
    	
        //get hbaInfoVector
    	Vector hbaInfoVector = new Vector();
	   	for (int i = 0; i < hbaInfo.length; i++) {
    		String line = hbaInfo[i];
     		if (line != null) {
    			line = line.trim();
    			if ((!(line.equals(""))) && (line.indexOf(PORT_TITLE) > -1)) {
    				//get portNo
    				String portNo = line.substring((line.length() - 2), (line.length() - 1));
    				
    				//get node-name
    				line = (hbaInfo[++i]).trim();
    				String nodeName = line.substring((line.indexOf("=") + 1), line.length());
    				
    				//get port-name
    				line = (hbaInfo[++i]).trim();
    				String portName = line.substring((line.indexOf("=") + 1), line.length());
    				                     
                	//create NasheadPortInfoBean object
                	NasheadPortInfoBean portInfoObj = new NasheadPortInfoBean();
                	portInfoObj.setPortNo(portNo);
                	portInfoObj.setNodeName(nodeName);
                	portInfoObj.setPortName(portName);     	
                    
                	//add NasheadPortInfoBean object to hbaInfoVector
                	hbaInfoVector.add(portInfoObj);			
    			} //if ((!(line.equals(""))) && (line.indexOf(PORT_TITLE) > -1))
    		} //if (line != null)
    	} //for
    				
    	//sort hbaInfoVector on portNo
        Collections.sort(hbaInfoVector,
                    new Comparator() { 
                        public int compare(Object o1, Object o2) { 
                            NasheadPortInfoBean portInfo1 = (NasheadPortInfoBean) o1; 
                            NasheadPortInfoBean portInfo2 = (NasheadPortInfoBean) o2;         
                            return portInfo1.getPortNo().compareTo(portInfo2.getPortNo()); 
                        } 
                    });  
    	
     	return hbaInfoVector;
    }
    	
         
    /**
      * get all LUN information of recognised by port of HBA card on specified node
      * @param  nodeNo -- int, specify on which node to execute cmd
      * @return portInfoTreeMap -- TreeMap, key is (String)portNo, 
      *                                     value is vector which element is object of NasheadLunInfoBean
      * 
      * output of "sudo NASHEAD_GETHBAINFO_PL -l":
      *	  QLA2300/2310: Port#1:
	  *	  dda   diskarray_1a  0    NML
 	  *	  ddb   diskarray_1a  1    NML
 	  *   ddb   diskarray_1a  2    NML
      *   
 	  *   QLA2300/2310: Port#2:
 	  *   dda   diskarray_1b  10    NML
 	  *   ddb   diskarray_1b  11    NML
 	  *   ddb   diskarray_1b  12    NML
 	  *   ddb   diskarray_1b  13    NML
 	  *   ddb   diskarray_1b  14    NML
 	  *   ddb   diskarray_1b  15    NML
      * @throws Exception
      */
    public TreeMap getPortConnectionInfo(int nodeNo) throws Exception {
    	
    	//get port connection information
    	String[] cmd_getLunInfo = {"sudo", NASHEAD_GETHBAINFO_PL, "-l"};
    	
        NSCmdResult result = getCmdResult(cmd_getLunInfo, nodeNo);
    	String[] portInfo = result.getStdout();
    	
    	//get portInfoTreeMap
        TreeMap portInfoTreeMap = new TreeMap();
    	for (int i = 0; i < portInfo.length; i++) {
    		String line = portInfo[i];
    		if (line != null) {
    			line = line.trim();
    		
    			//match Port#
    			if ((!line.equals("")) && (line.indexOf(PORT_TITLE) > -1)) {
    				//get port No
    				String portNo = line.substring((line.length() - 2), (line.length() - 1));
    			
    				//get lun info of port	
    				Vector lunInfoVector = new Vector();
    				i++;
    				while (i < portInfo.length) {
    					line = (portInfo[i]).trim();
    					if ((line != null) && (!line.equals("")) && (line.indexOf(PORT_TITLE) == -1)) {
    						line = NSModelUtil.perl2Page(line, NSModelUtil.EUC_JP);
    						StringTokenizer lineTokenizer = new StringTokenizer(line);
    						if (lineTokenizer.countTokens() == 4) {
    							lineTokenizer.nextToken();
    							NasheadLunInfoBean lunInfoObj = new NasheadLunInfoBean();
    							lunInfoObj.setStorage(lineTokenizer.nextToken());
    							lunInfoObj.setLUN(lineTokenizer.nextToken());
    							lunInfoObj.setState(lineTokenizer.nextToken());
    							lunInfoVector.add(lunInfoObj);
    						}
    					}  else {
    						break;
    					}
    					i++;
    				} //while
    				portInfoTreeMap.put(portNo, lunInfoVector);
    				i--;
    			} //if ((!line.equals("")) && (line.indexOf(PORT_TITLE) > -1))
    		} //if (line != null)
    	} //for 
       	return portInfoTreeMap;
	}

    //call CmdExecBase.execCmd to get cmd's result
    protected NSCmdResult getCmdResult(String[] cmds, int nodeNo) throws Exception {
            NSCmdResult cmdResult = CmdExecBase.execCmd(cmds, nodeNo);
            return cmdResult;
    }    

}
