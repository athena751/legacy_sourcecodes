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
import	java.util.*;
import	java.net.*;

import	com.nec.sydney.net.soap.*;
import	com.nec.sydney.framework.*;
import	com.nec.sydney.system.*;

public class	Soap4Cluster {
	private static final String	cvsid = "@(#) $Id: Soap4Cluster.java,v 1.2300 2003/11/24 00:54:34 nsadmin Exp $";
	static public String	getClusterNode(String target, int n) throws Exception {
		return SoapManager.getAddress(target, n);
	}
	static public String	whoIsMyFriend(String target) {
		NSReporter.getInstance().report(NSReporter.DEBUG,
					"whoIsMyFriend: "+target);
		if (target.indexOf(NSConstant.SEPERATOR_CLUSTER) == -1) {
			return null;	// Single Node!!
		}
		int	pos = target.indexOf(NSConstant.SEPERATOR_TYPE);
		if (pos == -1 || pos == 0) {
			return null;	// illegal or management server
		}
		StringTokenizer	tok = new StringTokenizer(target, NSConstant.SEPERATOR_TYPE);
		if (tok.countTokens() != 2)
			return null;
		String	node = tok.nextToken();
		String	type = tok.nextToken();
		tok = new StringTokenizer(node, NSConstant.SEPERATOR_CLUSTER);
		if (tok.countTokens() != 2)
			return null;
		String	nodeID = tok.nextToken();
		String	clusterID = tok.nextToken();
		NSReporter.getInstance().report(NSReporter.DEBUG,
			"nodeID: " + nodeID +
			", clusterID: " + clusterID +
			", type: " + type);
		if (nodeID == null || nodeID.length() == 0
		 || clusterID == null || clusterID.length() == 0) {
			return null;
		}
		List	nodes;
		try {
			if (type.equals("NAS")) {
				Cluster	cluster = ClusterManager.getInstance().getServerById(clusterID);
				nodes = cluster.getNodeId();
			} else {
				Ipsan	ipsan = IpsanManager.getInstance().getServerById(clusterID);
				nodes = ipsan.getNodeId();
			}
		} catch (Exception ex) {
			return null;
		}
		Iterator	it = nodes.iterator();
		while (it.hasNext()) {
			String	n = (String)it.next();
			NSReporter.getInstance().report(NSReporter.DEBUG,
				"Is he a friend, "+n+" ?");
			if (!nodeID.equals(n)) {
				String	friend = n 
					+ NSConstant.SEPERATOR_CLUSTER + clusterID
					+ NSConstant.SEPERATOR_TYPE + type;
				NSReporter.getInstance().report(NSReporter.DEBUG,
					target+"'s friend is " + friend);
				return friend;
			}
		}
		return null;
	}
	static private boolean	isAlive(URL router) {
		InputStream	con;
		try {
			con = router.openStream();
			con.close();
		} catch (Exception ex) {
			return false;
		}
		return true;	// He may be alive.
	}
	static protected boolean	isAlive(String addr) throws Exception {
		String	router = "http://"+addr+":8585/soap/servlet/rpcrouter";
		return isAlive(new URL(router));
	}
	static public boolean	checkAlive(String target) throws Exception {
		NSMessageDriver	md = NSMessageDriver.getInstance();
		NSReporter	reporter = NSReporter.getInstance();
		reporter.report(NSReporter.DEBUG, "checkAlive: "+target);
		/*
		 * 1st. Management Server
		 */
		reporter.report(NSReporter.DEBUG, "Step1: alive check for Management server friend");
		String	friend = AdminServer.getMyFriendIPAddress();
		reporter.report(NSReporter.DEBUG, 
				"checkAlive(ManagementServer): "+friend);
		if (friend != null && !isAlive(friend)) {
			throwNSClusterException(md.getMessage("framework/server/admin")+"(" + friend + ")", "dead");
		}
		if (target == null || target.startsWith("localhost")) {
			/* target is the Management Server. */
			return true;
		}
		/*
		 * 2nd. NAS/IP-SAN FIP, Node0, Node1
		 */
		reporter.report(NSReporter.DEBUG, "Step2: alive check for each node");
		int	index = target.indexOf(NSConstant.SEPERATOR_CLUSTER);
		if (index == -1) {
			reporter.report(NSReporter.DEBUG, target+": Single Node");
			URL	url;
			url  = SoapManager.getInstance().getRouterByTarget(target);
			if (!isAlive(url)) {
				throwNSClusterException(url.getHost(), "dead");
			}
			return true;
		}
		reporter.report(NSReporter.DEBUG, target+": Clustered");
		String	cluster = target.substring(index);
		String	node0Addr = SoapManager.getAddress(cluster, 0);
		reporter.report(NSReporter.DEBUG, "checkAlive(node0)"+node0Addr);
		String	node1Addr = SoapManager.getAddress(cluster, 1);
		reporter.report(NSReporter.DEBUG, "checkAlive(node1)"+node1Addr);
		if (node0Addr == null || node1Addr == null)
			return true;
		if (node0Addr.equals(node1Addr))
			return true;
		if (!isAlive(node0Addr))
			throwNSClusterException(node0Addr, "dead");
		if (!isAlive(node1Addr))
			throwNSClusterException(node1Addr, "dead");
		index = target.indexOf(NSConstant.SEPERATOR_TYPE);
		if (!target.substring(index).startsWith("@NAS"))
			return true;
		/*
		 * 3rd. NAS service
		 */
		reporter.report(NSReporter.DEBUG, "Step3: How many /etc/group?/setupinfo");
		int	n = ClusteredNASNode.howManySetupinfoDir(node0Addr);
		if (n < 0) {
			throwNSClusterException(node1Addr, "commondir");
		} else if (n == 1) {
			return true;
		} else {
			throwNSClusterException(node0Addr, "commondir");
		}
		return false;
	}
	static public boolean	throwNSClusterException(String host, String info) throws NSException {
		NSMessageDriver	md = NSMessageDriver.getInstance();
		NSException	ex = new NSException(host + ": " +md.getMessage("framework/error/notavailable"));
		ex.setReason(md.getMessage("framework/cluster/down")
			+ md.getMessage("framework/cluster/down/"+info));
		ex.setReportLevel(NSReporter.WARN);
		throw ex;
	}
	static public String	makeTargetN(String orgTarget, int n) {
		NSReporter	reporter = NSReporter.getInstance();
		reporter.report(NSReporter.DEBUG, 
				"makeTargetN: "+ orgTarget + ": " + n);
		StringTokenizer	tok = new StringTokenizer(orgTarget, NSConstant.SEPERATOR_TYPE);
		if (tok.countTokens() != 2) {
			return null;
		}
		String	cluster = tok.nextToken();
		String	type = tok.nextToken();
		int	index = cluster.indexOf(NSConstant.SEPERATOR_CLUSTER);
		if (index == -1)
			return null;
		String	clusterID = cluster.substring(index+1);
		reporter.report(NSReporter.DEBUG, 
				"type: "+type+", clusterID: "+clusterID);
		String	targetN = null;
	try {
		if (type.equals("NAS")) {
			Cluster	c = ClusterManager.getInstance().getServerById(clusterID);
			List	nodes = c.getNodeId();
			Iterator	it = nodes.iterator();
			while (it.hasNext()) {
				String	candidate = (String)it.next();
				Nas	nas = NasManager.getInstance().getServerById(candidate);
				if (nas.getMyNode() == n) {
					targetN = candidate;
					break;
				}
			}
		} else if (type.equals("IPSAN") || type.equals("NASIPSAN")) {
			Ipsan	ipsan = IpsanManager.getInstance().getServerById(clusterID);
			Collection	nodes = ipsan.getNodeMap().values();
			Iterator	it = nodes.iterator();
			while (it.hasNext()) {
				ServerInfo	mp = (ServerInfo)it.next();
				if(mp.getMyNode() == n) {
					targetN = mp.getId();
					break;
				}
			}
		}
	} catch (Exception ex) {
		// nothing to do
	}
		if (targetN == null)
			return null;
		String	newTarget = targetN 
				+ NSConstant.SEPERATOR_CLUSTER + clusterID 
				+ NSConstant.SEPERATOR_TYPE + type;
		reporter.report(NSReporter.DEBUG, "targetN " + newTarget);
		return newTarget;
	}
	static public String	getClusterGroup(String target, int n) throws Exception {
		NSReporter	reporter = NSReporter.getInstance();
		reporter.report(NSReporter.DEBUG, "getClusterGroup("+target+", "+n+")");
		String fip = SoapManager.getInstance().getFIPAddress(target);
		reporter.report(NSReporter.DEBUG, "getClusterGroup FIP: "+fip);
		if (fip == null)
			return null;
		if (n == -1 || n == 2) {
			URL	url = SoapManager.getInstance().getRouterByAddress(fip);
			if (isAlive(SoapManager.getInstance().getRouterByAddress(fip)))
				return fip;
			else
				return null;
		}
		SoapLite	sl = new SoapLite();
		sl.init(Soap4Cluster.URN_SOAPCLUSTER);
		sl.setParameter(1, Integer.class, new Integer(n));
		URL	fipurl = SoapManager.getInstance().getRouterByAddress(fip);
		if (sl.callTheTarget(fipurl, Soap4Cluster.GET_CLUSTER_GROUP_ADDR) == true) {
			ClusterGroupInfo	res = (ClusterGroupInfo)sl.getValue();
			reporter.report(NSReporter.DEBUG, "Group"+n +"'s address: "+res.isSuccessful()+": "+res.getAddress());
			if (res.isSuccessful()) {
				return res.getAddress();
			} 
		}
		reporter.report(NSReporter.ERROR, GET_CLUSTER_GROUP_ADDR+": "+ sl.getFaultReason());
		return null;
	}
	static String	URN_SOAPCLUSTER = "urn:Soap4Cluster";
	static String	GET_CLUSTER_GROUP_ADDR = "getClusterGroupAddr";
}
