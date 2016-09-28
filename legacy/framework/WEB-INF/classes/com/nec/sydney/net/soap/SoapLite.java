/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package	com.nec.sydney.net.soap;

import	java.net.URL;
import	java.util.Vector;

import	org.apache.soap.server.DeploymentDescriptor;
import	org.apache.soap.encoding.SOAPMappingRegistry;
import	org.apache.soap.Constants;
import	org.apache.soap.rpc.*;
import	org.apache.soap.encoding.*;
import	org.apache.soap.encoding.soapenc.*;
import	org.apache.soap.util.xml.*;

import	com.nec.sydney.net.soap.*;
import	com.nec.sydney.framework.*;

public class	SoapLite {
	private static final String	cvsid = "@(#) SoapLite.java,v 1.2001 2003/08/05 01:06:01 changhs Exp";
	public SoapLite() {
		call = null;
		param = null;
		nParam = 0;
	}
	public boolean	init(String urn) throws Exception {
		SoapManager	sm = SoapManager.getInstance();
		DeploymentDescriptor	dd = sm.getDeploymentDescriptor(urn);
		call = new Call();
		SOAPMappingRegistry	smr;
		smr = sm.getMappingRegistry(dd);
		if (smr != null)
			call.setSOAPMappingRegistry(smr);
		call.setEncodingStyleURI(Constants.NS_URI_SOAP_ENC);
		call.setTargetObjectURI(urn);
		return true;
	}
	public boolean	setParameter(int n, Class c, Object o) {
		if (param == null) 
			param = new Vector();
		if (n > nParam) {
			nParam = n;
			param.setSize(nParam);
		}
		String	var = "param" + n;
		param.setElementAt(new Parameter(var, c, o, null), n-1);
		return true;
	}
	public boolean	call(String server, String method) throws Exception {
		Soap4Cluster.checkAlive(server);
		URL	url = SoapManager.getInstance().getRouterByTarget(server);
		return callTheTarget(url, method);
	}
	public boolean	callByIPAddress(String addr, String method) throws Exception {
		URL	url = SoapManager.getInstance().getRouterByAddress(addr);
		return callTheTarget(url, method);
	}
	public boolean	callForce(String server, String method) throws Exception {
		URL	url = SoapManager.getInstance().getRouterByTarget(server);
		return callTheTarget(url, method);
	}
	public boolean	callClusterNodeN(String target, String method, int n, boolean force) throws Exception {
		if (!force) {
			Soap4Cluster.checkAlive(target);
		}
		String	nodeN = Soap4Cluster.getClusterNode(target, n);
		URL router = SoapManager.getInstance().getRouterByAddress(nodeN);
		return callTheTarget(router, method);
	}
	public boolean	callFirstNode(String target, String method, boolean force) throws Exception {
		return callClusterNodeN(target, method, 0, force);
	}
	public boolean	callFirstNode(String target, String method) throws Exception {
		return callFirstNode(target, method, false);
	}
	public boolean	callSecondNode(String target, String method, boolean force) throws Exception {
		return callClusterNodeN(target, method, 1, force);
	}
	public boolean	callSecondNode(String target, String method) throws Exception {
		return callSecondNode(target, method, false);
	}
	public boolean	callTheTarget(URL url, String method) throws Exception {
		if (param != null)
			call.setParams(param);
		call.setMethodName(method);
		resp = call.invoke(url, "");
		NSReporter.getInstance().report(NSReporter.DEBUG, "SOAP Response: "+resp);
		retval = resp.getReturnValue();
		if (retval == null) {
			reason = resp.getFault().toString();
			NSReporter.getInstance().report(NSReporter.ERROR,
				"SOAP Failed: "+reason);
			return false;
		} else {
			return true;
		}
	}
	public boolean	callClusterGroupN(String target, String method, int n) throws Exception {
		String	nodeN = Soap4Cluster.getClusterGroup(target, n);
		NSReporter.getInstance().report(NSReporter.DEBUG,
			"callClusterGroupN(" + target + ", "+ method + ") --> "+ nodeN);
		if (nodeN == null || nodeN.equals("")) {
			Soap4Cluster.throwNSClusterException("group"+n, "nogroup");
			return false;
		}
		URL router = SoapManager.getInstance().getRouterByAddress(nodeN);
		return callTheTarget(router, method);
	}
	public Object	getValue() {
		return retval.getValue();
	}
	public String	getFaultReason() {
		return reason;
	}
	private Call	call;
	private Response	resp;
	private Parameter	retval;
	private Vector	param;
	private int	nParam;
	private String	reason;
}
