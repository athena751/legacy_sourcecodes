/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package	com.nec.sydney.net.soap;

import	java.io.*;
import	java.net.URL;
import	java.util.*;

import	org.apache.soap.server.DeploymentDescriptor;
import	org.apache.soap.server.TypeMapping;
import  org.apache.soap.server.ServiceManagerClient;
import	org.apache.soap.encoding.SOAPMappingRegistry;
import	org.apache.soap.util.xml.Serializer;
import	org.apache.soap.util.xml.Deserializer;

import	com.nec.sydney.framework.*;
import	com.nec.sydney.system.*;

public class SoapManager {
	private static final String	cvsid = "@(#) $Id: SoapManager.java,v 1.2300 2003/11/24 00:54:34 nsadmin Exp $";
	protected	SoapManager() {
		descriptors = null;
	}
	static private SoapManager	_instance = null;
	static private String		path;
	static public SoapManager	getInstance() {
		if (_instance == null) {
			_instance = new SoapManager();
			path = new String(NSConstant.SoapServices);
		}
		return _instance;
	}
	public void	init(String p) {
		if (p != null)
			path = new String(p);
	}
	public void	init() {
		init(NSConstant.SoapServices);
	}
	public void	deployToMyself() {
		try {
			URL router = getRouterByTarget("localhost");
			File dir = new File(NSConstant.SoapServices + "/myself");
			String[]	files = dir.list();
			for (int i = 0; i < files.length; ++i) {
				String	file = files[i];
				if (file.endsWith(".xml")) {	
					/* This is a Deployment Descriptor XML */
					deploy(router, NSConstant.SoapServices + "/myself/" + file);
				}
			}
		} catch (Exception ex) {
			NSReporter.getInstance().report(NSReporter.ERROR,
							ex.getMessage());
		}
	}
	public DeploymentDescriptor	getDeploymentDescriptor(String urn) 
						throws NSException {
		if (descriptors == null) {
			descriptors = new HashMap();
		}
		DeploymentDescriptor	dd = null;
		dd = (DeploymentDescriptor)descriptors.get(urn);
		if (dd != null)
			return dd;
		FileReader	xml;
		try {
			xml = new FileReader(path + "/" + urn + ".xml"); 
			dd = DeploymentDescriptor.fromXML(xml);
		} catch (Exception ex) {
			NSException	e = new NSException("no such service for: " + urn);
			e.setReason(ex.getMessage());
			e.setCategory(this.getClass());
			throw e;
		}
		descriptors.put(urn, dd);
		return dd;
	}
	SOAPMappingRegistry	getMappingRegistry(DeploymentDescriptor dd) {
		TypeMapping[] tm = dd.getMappings();
		if (tm == null || tm.length <= 0) 
			return null;
		SOAPMappingRegistry     smr = new SOAPMappingRegistry();
		try {
			Serializer      java2xml;
			Deserializer	xml2java;
			for (int i = 0; i < tm.length; ++i) {
				TypeMapping     type = tm[i];
				String	ser = type.java2XMLClassName;
				String	deser = type.xml2JavaClassName;
				java2xml = (Serializer)Class.forName(ser).newInstance();
				xml2java = (Deserializer)Class.forName(deser).newInstance();
				smr.mapTypes(type.encodingStyle,
						type.elementType,
						Class.forName(type.javaType),
						java2xml, xml2java);
			}
		} catch (Exception ex) {
			smr = null;
		}
		return smr;
	}
	static private String	getNASAddress(String nodeID, String clusterID, int n) {
		NSReporter.getInstance().report(NSReporter.DEBUG,
			"getNASAddress: "+nodeID +  "/" + clusterID+" - node:"+n);
		String	addr = null;
		Nas	nas;
		try {
			if (clusterID == null) {
				/* Single Node NAS */
				nas = NasManager.getInstance().getServerById(nodeID);
				addr = nas.getAddress();
			} else { 
				/* Clustered NAS */
				Cluster cluster = ClusterManager.getInstance().getServerById(clusterID);
				if (n == -1) {
					if (nodeID != null) {
						/* This is the NODE */
						nas = NasManager.getInstance().getServerById(nodeID);
						addr = nas.getAddress();
					} else {
						/* RIP */
						NSReporter.getInstance().report(NSReporter.DEBUG, "return RIP");
						addr = cluster.getAddress();
					}
				} else {
					/* Node # is specified */
					List	nodes = cluster.getNodeId();
					Iterator	it = nodes.iterator();
					while (it.hasNext()) {
						String candidate = (String)it.next();
						NSReporter.getInstance().report(NSReporter.DEBUG, 
							"node:"+n+":"+candidate);
						nas = NasManager.getInstance().getServerById(candidate);
						if (nas.getMyNode() == n) {
							addr =  nas.getAddress();
							NSReporter.getInstance().report(NSReporter.DEBUG, 
										"RIP("+n+"): "+addr);
							break;
						}
					}
				}
			}
		} catch (Exception ex) {
			NSReporter.getInstance().report(NSReporter.DEBUG, "getNASAddress: unknown");
			addr = null;
		}
		NSReporter.getInstance().report(NSReporter.DEBUG, "getNASAddress: "+addr);
		return addr;
	}
	static private String	getIPSANAddress(String nodeID, String clusterID, int n) {
		NSReporter.getInstance().report(NSReporter.DEBUG,
			"getIPSANAddress: "+nodeID +  "/" + clusterID+"node:"+n);
		if (clusterID == null)
			return null;
		Ipsan	ipsan;
		try {
			ipsan = IpsanManager.getInstance().getServerById(clusterID);
		} catch (Exception ex) {
			return null;
		}
		String	addr = null;
		Map	mps = ipsan.getNodeMap();
		if (n == -1) {
			if (nodeID != null) {
				/* for Node Menu */
				ServerInfo	mp = (ServerInfo)mps.get(nodeID);
				if (mp == null) {
					NSReporter.getInstance().report(NSReporter.DEBUG, "unknown MP: "+nodeID);
					return null;
				}
				addr = mp.getAddress();
				NSReporter.getInstance().report(NSReporter.DEBUG, "RIP: "+addr);
				return addr;
			} else {
				/* for CLUSTER menu */
				addr = ipsan.getAddress();
				NSReporter.getInstance().report(NSReporter.DEBUG, "FIP: "+addr);
				return addr;
			}
		} else {
			/* for 1st or 2nd Node Menu */
			Iterator	it = mps.values().iterator();
			while (it.hasNext()) {
				ServerInfo	mp = (ServerInfo)it.next();
				if (mp.getMyNode() == n) {
					addr = mp.getAddress();
					NSReporter.getInstance().report(NSReporter.DEBUG, 
							"RIP("+n+"): "+addr);
					return addr;
				}
			}
		}
		return null;
	}
	static private String	getAddress(String nodeID, String clusterID, String type, int n) {
		NSReporter.getInstance().report(NSReporter.DEBUG,
			"Type: "+type+
			", ClusterID: "+clusterID+
			", NodeID: " +nodeID+
			", #: " + n);
		if (type.equals("NAS")) {
			return getNASAddress(nodeID, clusterID, n);
		} else if (type.equals("IPSAN") || type.equals("NASIPSAN")) {
			return getIPSANAddress(nodeID, clusterID, n);
		}
		return null;
	}
	static public String	getAddress(String server, int n) {
		if (server == null || server.startsWith("localhost"))
			return "127.0.0.1";
		StringTokenizer	st = new StringTokenizer(server, NSConstant.SEPERATOR_TYPE);
		if (st.countTokens() != 2)
			return null; 
		String	node = st.nextToken();
		String	type = st.nextToken();
		String	nodeID;
		String	clusterID;
		if (node.indexOf(NSConstant.SEPERATOR_CLUSTER) == -1) {	/* Single Node NAS */
			nodeID = node;
			clusterID = null;
		} else if (node.startsWith(NSConstant.SEPERATOR_CLUSTER)) {	/* IPSAN */
			nodeID = null;
			clusterID = node.substring(1);
		} else {			
			/* MP of IPSAN or NAS node of Clusterd NAS */
			st = new StringTokenizer(node, NSConstant.SEPERATOR_CLUSTER);
			nodeID = st.nextToken();
			clusterID = st.nextToken();
		}
		return getAddress(nodeID, clusterID, type, n);
	}
	static public String	getFIPAddress(String target) {
		NSReporter      reporter = NSReporter.getInstance();
		reporter.report(NSReporter.DEBUG, "getFIPAddress("+target+")");
                int     index = target.indexOf(NSConstant.SEPERATOR_CLUSTER);
                if (index < 0)
                        return null;
                String clusterTarget = target.substring(index);
                return getAddress(clusterTarget, -1);
	}
	public URL	getRouter(String server) throws NSException {
		return getRouterByTarget(server);
	}
	public URL 	getRouterByTarget(String server) throws NSException {
		NSReporter.getInstance().report(NSReporter.DEBUG, "getRouterByTarget: "+server);
		String	addr = getAddress(server, -1);
		NSMessageDriver	md = NSMessageDriver.getInstance();
		if (addr == null) {
			NSException nex = new NSException(md.getMessage("framework/soap/noaddr"));
			nex.setCategory(this.getClass());
			nex.setReportLevel(NSReporter.ERROR);
			nex.setReason(md.getMessage("framework/soap/noserver") + "(" + server + ")");
			NSReporter.getInstance().report(nex);
			throw nex;
		}
		return getRouterByAddress(addr);
	}
	public URL	getRouterByAddress(String addr) throws NSException {
		String	router = "http://"+addr+":8585/soap/servlet/rpcrouter";
		NSReporter.getInstance().report(NSReporter.DEBUG, "getRouterByAddress: "+router);
		URL	url;
		try {
			url = new URL(router);
		} catch (Exception ex) {
			url = null;
		}
		return url;
	}
	public boolean	deploy(URL url, String xmlFile) throws Exception {
		NSReporter.getInstance().report(NSReporter.DEBUG, xmlFile);
		ServiceManagerClient	smc = new ServiceManagerClient(url);
		try {
			FileReader	xml = new FileReader(xmlFile);
			DeploymentDescriptor	dd = DeploymentDescriptor.fromXML(xml);
			smc.deploy(dd);
		} catch (Exception ex) {
			NSException	e = new NSException("could not deploy the service: " + xmlFile);
			e.setReason(ex.getMessage());
			e.setCategory(this.getClass());
			throw e;
		}
		return true;
	}
	public boolean undeploy(URL url, String xml) throws Exception {
		ServiceManagerClient	smc = new ServiceManagerClient(url);
		try {
			File	file = new File(xml);
			String	basename = file.getName();
			StringTokenizer	token = new StringTokenizer(basename, ".");
			String	urn = token.nextToken();
			smc.undeploy(urn);
		} catch (Exception ex) {
			NSException	e = new NSException("could not undeploy the service: " + xml);
			e.setReason(ex.getMessage());
			e.setCategory(this.getClass());
			throw e;
		}
		return true;
	}
	Map	descriptors;

/*
*Just for MP cluster
*parameter: 
*           target:  such as /[ipsanID]@IPSAN
*           ipaddr:  xxx.xxx.xxx.xxx
*return:   
*           [mpID]/[ipsanID]@IPSAN
*/
    public static String remakeTarget(String target, String ipaddr) throws Exception{
        NSReporter.getInstance().report(NSReporter.DEBUG,
			"remakeTarget: " + target +  "," + ipaddr);

        if (target == null 
                || ipaddr == null 
                || ipaddr.equals(""))
            return null;

        StringTokenizer	st = new StringTokenizer(
            target, NSConstant.SEPERATOR_TYPE);
        if (st.countTokens() != 2)
            return null;
        String	cluster = st.nextToken();
        int	index = cluster.indexOf(NSConstant.SEPERATOR_CLUSTER);
        if (index == -1)
            return null;
        String	clusterID = cluster.substring(index + 1);        
        
        Ipsan ipsan = IpsanManager.getInstance().getServerById(clusterID);
        Map mpmap;
        if (ipsan == null 
                || (mpmap = ipsan.getNodeMap()) == null)
            return null;

        Iterator it = mpmap.keySet().iterator();
        while(it.hasNext()){
            String key = (String)it.next();
            if (ipaddr.equals(
                        ((MpInfo)mpmap.get(key)).getAddress())){
                NSReporter.getInstance().report(NSReporter.DEBUG,
			"remakeTarget: " + key + target);
                return key + target;
            }
        }
        return null;
    }
}
