/*
 *      Copyright (c) 2001-2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.snapshot;

import com.nec.sydney.framework.*;
import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.atom.admin.mapd.*;
import com.nec.sydney.beans.base.*;
import com.nec.sydney.atom.admin.base.api.*;
import com.nec.sydney.beans.mapdcommon.*;
import com.nec.sydney.beans.mapd.MAPDSOAPClient;
import com.nec.sydney.net.soap.*;
import java.util.*;
import com.nec.nsgui.action.base.NSActionUtil;

/****************************************************************

 * here is a JavaBean class used by mountpoint.jsp               *

 ****************************************************************/
public class MountPointBean extends AbstractJSPBean implements NasConstants, NSExceptionMsg {
    private static final String     cvsid = "@(#) $Id: MountPointBean.java,v 1.2314 2008/05/28 03:34:20 liy Exp $";

    private Vector curMountPointVec; // The all mount point under the selected ExportRoot
    private String selectedExportRoot; // The selected exportRoot
    private String selectedCodePage; // The selected code Page
    private String selectedHexMP; // The selected hex mountpoint
    private String destURL; // The dest URL
    private Hashtable oldLimit;
    private Hashtable cowUsed;
    private String mountPointOptionHtml;
    private boolean isSelectedEgExist;
    private Hashtable type;
    
    private String ldapServer = "";
    public String getLdapServer() throws Exception {
        if (ldapServer == null || ldapServer.equals("")) {
            AuthInfo authInfo = MapdCommon.getLDAPInfo(target);

            if (authInfo != null) {
                ldapServer = authInfo.getServerName();
            } else {
                ldapServer = "";
            }
        }
        return ldapServer;
    }

    /* none properties here*/
    // the constructor of this class
    public MountPointBean() {
        this.selectedCodePage = "";
        this.selectedExportRoot = "";
        this.selectedHexMP = "";
    }

    // process the HTTP request
    public void beanProcess() throws Exception {
        // get the destURL
        // request.setCharacterEncoding( NasConstants.BROWSER_ENCODE );
        this.destURL = request.getParameter(MP_NEXT_ACTION_PARAM);
        if (destURL == null) {
            NSException ex = new NSException(this.getClass(),
                    NSMessageDriver.getInstance().getMessage(session, 
                    "exception/snapshot/invalid_action"));

            ex.setDetail(MP_NEXT_ACTION_PARAM + "=" + destURL);
            ex.setReportLevel(NSReporter.ERROR);
            ex.setErrorCode(NAS_EXCEP_NO_MOUNTPOINT_BEAN_NEXTACTION);
            NSReporter.getInstance().report(ex);
            throw ex;
        }

        String actionStr = super.request.getParameter("act");

        NSReporter.getInstance().report(NSReporter.DEBUG, "act = " + actionStr);
        if (actionStr != null) {
            String exportRoot = request.getParameter(MP_SELECT_EXPORTROOT_NAME);
            String mountPoint = request.getParameter(MP_SELECT_MOUNTPOINT_NAME);
            String hexMountPoint = request.getParameter(
                    MP_SELECT_HEX_MOUNTPOINT_NAME);

            exportRoot = NSUtil.reqStr2EncodeStr(exportRoot,
                    NasConstants.BROWSER_ENCODE);
            mountPoint = NSUtil.reqStr2EncodeStr(mountPoint,
                    NasConstants.BROWSER_ENCODE);

            NSReporter.getInstance().report(NSReporter.DEBUG,
                    "ExportRoot = " + exportRoot + "MountPoint = " + mountPoint);

            if (hexMountPoint != null) {
                hexMountPoint = hexMountPoint.trim();
            }
            if (exportRoot != null) {
                exportRoot = exportRoot.trim();
            }
            if (mountPoint != null) {
                mountPoint = mountPoint.trim();
            }

            session.setAttribute(MP_SESSION_HEX_MOUNTPOINT, hexMountPoint);
            session.setAttribute(MP_SESSION_EXPORTROOT, exportRoot);
            session.setAttribute(MP_SESSION_MOUNTPOINT, mountPoint);

            if (actionStr.equalsIgnoreCase("SELECT")) { // Click the select button
                // forward for snapshot
                if (destURL.equalsIgnoreCase(MP_NEXT_ACTION_SNAPSHOT)) {
                    String typeStr = request.getParameter(NasConstants.REQUEST_PARAMETER_TYPE);
                    boolean isNsview = NSActionUtil.isNsview(request);
                    if ("rw".equals(typeStr)) {
                        // to original nsadmin list page
                        super.response.sendRedirect(
                                super.response.encodeRedirectURL(
                                        MP_REDIRECT_ADDR_SNAPSHOT));                            
                    } else if ("syncro".equals(typeStr)) {
                        if (isNsview) {
                            // if nsview, call replicaSnapshotList.do
                            super.response.sendRedirect(
                                    super.response.encodeRedirectURL(
                                            MP_REDIRECT_ADDR_SNAPSHOT_REPLICA_LIST_NSVIEW));
                        } else {
                            // if nsadmin, call replicaSnapshotListTop.do
                            super.response.sendRedirect(
                                    super.response.encodeRedirectURL(
                                            MP_REDIRECT_ADDR_SNAPSHOT_REPLICA_LIST));                            
                        }
                    }

                } else if (destURL.equalsIgnoreCase(MP_NEXT_ACTION_MAPD)) {
                    super.response.sendRedirect(
                            super.response.encodeRedirectURL(
                                    "../mapd/mapdauth.jsp?Previous=mountList"));
                } else if (destURL.equalsIgnoreCase(MP_NEXT_ACTION_QUOTA)
                        || destURL.equalsIgnoreCase("dirquota")) {
                    if (hexMountPoint.equals("")) {
                        super.response.sendRedirect(
                                super.response.encodeRedirectURL(
                                        "alertmessage.jsp?alertType=dirquota_nomp"));
                    } else {
                        processQuota(exportRoot, hexMountPoint, destURL);
                    }
                }
            } else if (actionStr.equalsIgnoreCase(FORM_ACTION_SET_LIMIT)) {
                String str_cowLimit = request.getParameter(
                        NasConstants.REQUEST_PARAMETER_COW_LIMIT);
                int cowLimit = Integer.valueOf(str_cowLimit).intValue();
                try{
                	SnapSOAPClient.setCOWLimit(cowLimit, hexMountPoint, super.target);
                	super.setMsg(
                        NSMessageDriver.getInstance().getMessage(session,
                                "common/alert/done"));}
                catch (NSException e){
                	if(e.getErrorCode()==1){
                		throw e;
                	}else{
                		super.setMsg(SnapshotErrorMsg.getErrorMsg(session,e));
                	}
                }
                super.response.sendRedirect(
                        super.response.encodeRedirectURL(
                                "mountpoint.jsp?" + MP_NEXT_ACTION_PARAM + "="
                                + MP_NEXT_ACTION_SNAPSHOT));
            }
        } else { // First load or refresh
            String selectedRoot = null;
            String actionParam = request.getParameter("action");

            if (actionParam == null) {
                session.setAttribute(MP_SESSION_HEX_MOUNTPOINT, null);
                session.setAttribute(MP_SESSION_EXPORTROOT, null);
                session.setAttribute(MP_SESSION_MOUNTPOINT, null);
                session.setAttribute(NasSession.SESSION_QUOTA_FSTYPE, null);
            }

            if (actionParam != null && actionParam.equals("selected")) { // First load or refresh
                selectedRoot = (String) session.getAttribute(
                        MP_SESSION_EXPORTROOT);
                this.selectedHexMP = (String) session.getAttribute(
                        MP_SESSION_HEX_MOUNTPOINT);
                if (this.selectedHexMP == null) {
                    this.selectedHexMP = "";
                }
            } else {
                selectedRoot = request.getParameter(MP_SELECT_EXPORTROOT_NAME);
                if (selectedRoot == null) {
                    selectedRoot = (String) session.getAttribute(
                            MP_SESSION_EXPORTROOT);
                }
            }

            NSReporter.getInstance().report(NSReporter.DEBUG,
                    "selectedRoot = " + selectedRoot);
            if (selectedRoot == null) { // The first load
                selectedRoot = NSActionUtil.getExportGroupPath(request);
            }

            genExportRootData(selectedRoot);
            mountPointOptionHtml = makeMountPointOptionHtml();
            return;
        }
    }

    /**
     * Process the quota selected. save the sxfw to session.
     * When the selected mountpoint is sxfsfw, check the auth.
     * If the auth isn't set or Share, alert and back to the mountpoint.jsp
     * Otherwise ,goto quota setting.
     * @param exportRoot  selected export root
     * @param hexMountPoint  selected mount point hex value
     */
    private void processQuota(String exportRoot, String hexMountPoint, String destURL) throws Exception {

        String fstype = MAPDSOAPClient.getFsType(target, hexMountPoint);
        String authDomainStr = "sxfs";

        if (fstype.equals(NasConstants.FILETYPE_NT)) {
            authDomainStr = "sxfsfw";

            // sxfsfw Type, check auth
            
            // modified by caoy begins 2003/12/22
            // Get the auth from API
            hexMountPoint = getDirectMountPoint(hexMountPoint); // get the direct mountpoint.
            AuthDomain authDomain = APISOAPClient.getAuthDomain(target,
                    hexMountPoint);

            // modified by caoy ends 2003/12/22

            // auth isn't set or the auth is shr.
            if ((authDomain == null) || (authDomain instanceof AuthSHRDomain)) {
                authDomainStr = "NullorShare";
                // dirquota has no guard on auth(modified by zhangx)
                if (!destURL.equalsIgnoreCase("dirquota")) {
                    super.setMsg(
                            NSMessageDriver.getInstance().getMessage(session, 
                                    "nas_common/alert/quota_nopdc"));
                    super.response.sendRedirect(
                            super.response.encodeRedirectURL(
                                    "mountpoint.jsp?" + MP_NEXT_ACTION_PARAM
                                    + "=" + MP_NEXT_ACTION_QUOTA
                                    + "&action=selected"));      
                    return;            
                }                
            }            
        }

        // save the fstype and authInfo to session
        session.setAttribute(NasSession.SESSION_DIRQUOTA_AUTH, authDomainStr); 
        session.setAttribute(NasSession.SESSION_QUOTA_FSTYPE, fstype);
        String nextDirQuotaAction = request.getParameter("nextDirQuotaAction");

        if (nextDirQuotaAction == null || nextDirQuotaAction.equals("")) {
            super.response.sendRedirect(
                    super.response.encodeRedirectURL(MP_REDIRECT_ADDR_QUOTA));
        } else if (nextDirQuotaAction.equalsIgnoreCase("datasetlist")) {
            super.response.sendRedirect(
                    super.response.encodeRedirectURL(
                            "datasetlist.jsp?reverse=true"));
        } else if (nextDirQuotaAction.equalsIgnoreCase("datasetadd")) {
            super.response.sendRedirect(
                    super.response.encodeRedirectURL("dirquotaadd.jsp"));
        } else if (nextDirQuotaAction.equalsIgnoreCase("datasetdel")) {
            super.response.sendRedirect(
                    super.response.encodeRedirectURL("datasetdestroy.jsp"));
        }
    }

    private String getDirectMountPoint(String mountPoint) throws Exception {
        String tokenStr = "0x2f"; // 0x2f
        String lowStr = mountPoint.toLowerCase();
        String[] temp = lowStr.split(tokenStr);

        if (temp.length > 4) {
            return "0x2f" + temp[1] + "0x2f" + temp[2] + "0x2f" + temp[3];
        } else {
            return mountPoint;
        }
    }

    private void genExportRootData(String selectedRoot) throws Exception {

        this.selectedExportRoot = selectedRoot;
        // modified by caoy begins 2003/12/22
        // Get the exportRoot from API
        isSelectedEgExist = true; 
        if (this.selectedExportRoot!=null && !this.selectedExportRoot.equals("")) {
            this.selectedCodePage = NSActionUtil.getExportGroupEncoding(request);
            if (this.selectedCodePage == null || this.selectedCodePage.equals("")) { // The export root is not existed
                isSelectedEgExist = false;
                return; 
            }
        }else{
            isSelectedEgExist = false;
            return; 
        }// End of this
             
        // Get the mountpoint list from /ect/mtab
        String mountType = null;
        String exportRootStr = null;

        if (destURL.equalsIgnoreCase(MP_NEXT_ACTION_MAPD)) { // For Mapd ,only get the directory mount point
            mountType = MapdCommon.DIRECT_MOUNT;
            exportRootStr = this.selectedExportRoot;
        } else { // For submount ,should change the string to hex string
            if (destURL.equalsIgnoreCase(MP_NEXT_ACTION_QUOTA)) {
                mountType = MapdCommon.QUOTA_MOUNT;
            } else if (destURL.equalsIgnoreCase("dirquota")) {
                mountType = MapdCommon.DIR_QUOTA_MOUNT;
            } else if (destURL.equalsIgnoreCase(MP_NEXT_ACTION_SNAPSHOT)) {
                mountType = MapdCommon.SNAP_MOUNT;
            }
            exportRootStr = NSUtil.ascii2hStr(this.selectedExportRoot);
        }

        try{
        	this.curMountPointVec = MapdCommon.getMountList(exportRootStr, mountType,
                    super.target);
        } catch (NSException e){
        	if(e.getErrorCode()==2){
                request.setAttribute("SNAPSHOT_ALERT_MSG",NSMessageDriver.getInstance().getMessage(session, 
            		"exception/snapshot/getVolumeInfoErr"));
        		this.curMountPointVec = new Vector();
        	}else{
        		throw e;
        	}
        }
        
        Collections.sort(this.curMountPointVec);

    }

    /**
     *judge to need shown Cowlimit or not
     */
    public boolean needShowLimit() {
        if ((destURL != null)
                && (destURL.equalsIgnoreCase(MP_NEXT_ACTION_SNAPSHOT))
                && (this.curMountPointVec != null)
                && (this.curMountPointVec.size() != 0)) {
            return true;
        } else {
            return false;
        }
    }

    // get the export root count

    public String getMountPointOptionHtml() throws Exception {
        return mountPointOptionHtml;
    }

    public String makeMountPointOptionHtml() throws Exception {

        if (this.curMountPointVec == null) {
            return "";
        }

        // The mountPoint is null
        if (this.curMountPointVec.size() == 0) {
            StringBuffer buffer = new StringBuffer(50);

            buffer.append("<option value=\"").append(NasConstants.MP_NULL_OPTION).append(
                    "\">");
            buffer.append(NasConstants.MP_NULL_OPTION).append("</option>\n");
            return buffer.toString();
        }

        StringBuffer buffer = new StringBuffer(this.curMountPointVec.size() * 30);
        String mountpoint = "";
        String encodeStr = "";
        int pos = 0;
        char ch = '/';
        boolean bSelected = false;

        cowUsed = new Hashtable();
        oldLimit = new Hashtable();
        type = new Hashtable();
        for (int i = 0; i < this.curMountPointVec.size(); i++) {
            encodeStr = mountpoint = (String) this.curMountPointVec.elementAt(i);

            if (destURL.equalsIgnoreCase(MP_NEXT_ACTION_SNAPSHOT)) {
                String cowStr = null;
                int cowPos = mountpoint.indexOf("0x20"); // Find the space

                if (cowPos > 0) {
                    cowStr = mountpoint.substring(cowPos + 4);
                    encodeStr = mountpoint.substring(0, cowPos);

                    // get the cowUsed and cowLimit
                    cowStr = NSUtil.hStr2EncodeStr(cowStr, this.selectedCodePage,
                            NasConstants.BROWSER_ENCODE);
                    StringTokenizer st = new StringTokenizer(cowStr, " ");
                    
                    // get type "rw" or "ro"
                    if (st.hasMoreTokens()) {
                        type.put(Integer.toString(i), st.nextToken());
                    }

                    if (st.hasMoreTokens()) {
                        cowUsed.put(Integer.toString(i), st.nextToken());
                        if (st.hasMoreTokens()) {
                            int i_limit = Integer.parseInt(st.nextToken());

                            if (i_limit <= 0 || i_limit >= 100) {
                                i_limit = 9;
                            } else {

                                /* For example:
                                 1. 0<limit<=10, the value in page show 10;
                                 2. 60<limit<=70, the value in page show 70;
                                 3. limit=0 or limit=100, the value in page show 100
                                 4. limit can not be this kind of number: 60.1
                                 */
                            	/*
                            	 (i_limit + 9) / 10 ------>to get the least integer which is >= i_limit
                            	 i_limit= XXXX -1   ------>to get the index 
                            	 */
                                i_limit = (i_limit + 9) / 10 - 1;
                            }
                            // i_limit:  index of selectbox.
                            oldLimit.put(Integer.toString(i),
                                    Integer.toString(i_limit));
                        }
                    } else {
                        // syncro
                        cowUsed.put(Integer.toString(i), "0");
                        oldLimit.put(Integer.toString(i),
                                Integer.toString(9));                        
                    }

                }//
            }

            mountpoint = encodeStr; // save the split hex moint point
            encodeStr = NSUtil.hStr2EncodeStr(encodeStr, this.selectedCodePage, NasConstants.BROWSER_ENCODE).trim();
            String option_text_encodeStr = encodeStr;
            if (!destURL.equalsIgnoreCase("dirquota") && encodeStr.length() > 0) {
                // erase the export strin
                pos = encodeStr.indexOf(ch, 1); // Skip the first '/'
                if (pos >= 0) {
                    if (pos + 1 < encodeStr.length()) {
                        pos = encodeStr.indexOf(ch, pos + 1); // Skip the sencode '/'
                        if (pos >= 0) {
                            encodeStr = encodeStr.substring(pos);
                        }
                    } // end of pos+1
                } // end of pos >= 0
            }// End of encodeStr.length()

            if (mountpoint.equals(this.selectedHexMP)) { // The selected mp
                buffer.append("<option selected value = \"").append(encodeStr).append(
                        "\" >");
                bSelected = true;
            } else {
                buffer.append("<option value = \"").append(encodeStr).append(
                        "\" >");
            }

            buffer.append(option_text_encodeStr).append(" </option> \n");

        } // End of for

        if (!bSelected) {
            this.selectedHexMP = (String) this.curMountPointVec.elementAt(0);
        }

        return buffer.toString();
    } // End of makeMountPointOptionHtml

    private String genArrayFromHash(String arrayName, Hashtable baseHash)throws Exception {
        StringBuffer buffer = new StringBuffer(baseHash.size() * 30);

        buffer.append(arrayName).append(" = new Array(").append(
                Integer.toString(baseHash.size()));
        buffer.append(");\n");
        String the_valule = "";

        for (int i = 0; i < baseHash.size(); i++) {
            the_valule = (String) baseHash.get(Integer.toString(i));
            buffer.append(arrayName).append("[").append(Integer.toString(i)).append(
                    "]");
            buffer.append(" = \"").append(the_valule).append("\";\n");
        } // End of for

        return buffer.toString();
    }

    public String genCowUsedArray() throws Exception {
        return genArrayFromHash("cowUsedArray", cowUsed);
    }

    public String genOldLimit() throws Exception {
        return genArrayFromHash("oldLimitArray", oldLimit);
    }
    
    public String genType() throws Exception {
        return genArrayFromHash("typeArray", type);
    }

    public String genMountPointArray() throws Exception {
        if (this.curMountPointVec == null) {
            return "";
        }

        // The mountPoint is null
        StringBuffer buffer = new StringBuffer(this.curMountPointVec.size() * 30);

        buffer.append(" hexMountPointArray = new Array(").append(
                Integer.toString(this.curMountPointVec.size()));
        buffer.append(");\n");
        String mountpoint = "";

        for (int i = 0; i < this.curMountPointVec.size(); i++) {
            mountpoint = (String) this.curMountPointVec.elementAt(i);
            if (destURL.equalsIgnoreCase(MP_NEXT_ACTION_SNAPSHOT)) {
                int position = mountpoint.indexOf("0x20");

                mountpoint = mountpoint.substring(0, position);
                ;
            }
            buffer.append(" hexMountPointArray[").append(Integer.toString(i)).append(
                    "]");
            buffer.append(" = \"").append(mountpoint).append("\";\n");
        } // End of for

        return buffer.toString();
    } // End of genMountPointArray

    public String getSelectedJsp() {
        return response.encodeRedirectURL(
                "mountpoint.jsp?" + MP_NEXT_ACTION_PARAM + "=" + this.destURL
                + "&" + NasConstants.MP_SELECT_EXPORTROOT_NAME + "=");
    }

    public String getSelectedJspNew() {
        return response.encodeRedirectURL(
                "mapdlist.jsp?" + MP_NEXT_ACTION_PARAM + "=" + this.destURL
                + "&" + NasConstants.MP_SELECT_EXPORTROOT_NAME + "=");
    }

    public String getSelectedHexMP() {
        if (this.selectedHexMP != null) {
            return  this.selectedHexMP;
        }

        return "";
    }

    public String getDestURL() {
        if (destURL == null) {
            return "";
        }

        return destURL;
    }

    public String getSelectedExportRoot(){
        return selectedExportRoot;
    }

    public boolean getIsSelectedEgExist() {
        return isSelectedEgExist;
    }
    /**
     get mp and auth info;
     */
    public Vector getMPAuth() throws Exception {
        if (this.curMountPointVec == null || this.curMountPointVec.size() == 0) {
            return (new Vector());
        }
        
        Map authMap = APISOAPClient.getAuthDomain(target, curMountPointVec);

        Vector mpList = new Vector();
        String ludbRoot = "";

        for (int i = 0; i < this.curMountPointVec.size(); i++) {
            String single = (String) this.curMountPointVec.get(i);
            String hexPath = single;
            String encodeStr = NSUtil.hStr2EncodeStr(single, this.selectedCodePage, NasConstants.BROWSER_ENCODE).trim();

            int pos = 0;
            char ch = '/';

            // erase the export string
            if (encodeStr.length() > 0) {
                pos = encodeStr.indexOf(ch, 1); // Skip the first '/'
                if (pos >= 0) {
                    if (pos + 1 < encodeStr.length()) {
                        pos = encodeStr.indexOf(ch, pos + 1); // Skip the second '/'
                        if (pos >= 0) {
                            encodeStr = encodeStr.substring(pos);
                        }
                    }
                }
            }

            MPAndAuth mp = new MPAndAuth();

            mp.setMp(encodeStr);
            mp.setHexMountPoint(single);

            AuthDomain auth = (AuthDomain) authMap.get(single);

            if (auth != null) {

                if (auth instanceof AuthNISDomain) {
                    AuthNISDomain nisDomain = (AuthNISDomain) auth;

                    mp.setDomainType(
                            NSMessageDriver.getInstance().getMessage(session,
                                    "nas_mapd/unix/radio_nis"));
                    String servers = nisDomain.getDomainServer();

                    mp.setResource(
                            NSMessageDriver.getInstance().getMessage(session,
                                    "nas_mapd/nt/nis_domain")
                                            + " : "
                                            + nisDomain.getDomainName()
                                            + "<br>"
                                            + NSMessageDriver.getInstance().getMessage(session,
                                                    "nas_mapd/nt/nis_server")
                                                    + " : <br>&nbsp;&nbsp;"
                                                    + servers.replaceAll("\\s+",
                                                    "<br>&nbsp;&nbsp;"));
                }

                if (auth instanceof AuthPWDDomain) {
                    AuthPWDDomain pwdDomain = (AuthPWDDomain) auth;
                    String pass = NSUtil.bytes2hStr(pwdDomain.getPasswd());

                    pass = NSUtil.hStr2EncodeStr(pass, NSUtil.EUC_JP,
                            BROWSER_ENCODE);
                    String group = NSUtil.bytes2hStr(pwdDomain.getGroup());

                    group = NSUtil.hStr2EncodeStr(group, NSUtil.EUC_JP,
                            BROWSER_ENCODE);

                    String fsType = MAPDSOAPClient.getFsType(super.target,
                            hexPath);

                    if (ludbRoot == null || ludbRoot.equals("")) {
                        ludbRoot = MAPDSOAPClient.getLudbRoot(target);
                    }
                    String exportForPwd = NSUtil.trimExport(selectedExportRoot);

                    if (!MapdCommon.checkPwd(pass, exportForPwd, fsType,
                            "/passwd", target, ludbRoot)) {
                        throw new Exception(
                                NSMessageDriver.getInstance().getMessage
                                (session, "nas_mapd/alert/old_pass"));
                    }
                    pass = MapdCommon.trimPwd(pass, exportForPwd, fsType, target,
                            ludbRoot);

                    mp.setDomainType(
                            NSMessageDriver.getInstance().getMessage(session,
                                    "nas_mapd/unix/radio_pwd"));

                    mp.setResource(
                            NSMessageDriver.getInstance().getMessage(session,
                                    "nas_mapd/nt/ludb_name")
                                            + " : <br>&nbsp;&nbsp;"
                                            + pass);
                }

                if (auth instanceof AuthSHRDomain) {
                    String domain = MapdCommon.getLocalDomain(session,target,
                            this.selectedExportRoot);

                    mp.setDomainType(
                            NSMessageDriver.getInstance().getMessage(session,
                                    "nas_mapd/nt/h3_shr"));

                    mp.setResource(
                            NSMessageDriver.getInstance().getMessage(session,
                                    "nas_mapd/nt/nt_domain")
                                            + " : "
                                            + domain);
                }

                if (auth instanceof AuthDMCDomain) {
                    String domain = MapdCommon.getLocalDomain(session,target,
                            this.selectedExportRoot);

                    mp.setDomainType(
                            NSMessageDriver.getInstance().getMessage(session,
                                    "nas_mapd/nt/h3_auth"));

                    mp.setResource(
                            NSMessageDriver.getInstance().getMessage(session,
                                    "nas_mapd/nt/nt_domain")
                                            + " : "
                                            + domain);
                }
                if (auth instanceof AuthADSDomain) {
                    String domain = MapdCommon.getLocalDomain(session,target,
                            this.selectedExportRoot);

                    mp.setDomainType(
                            NSMessageDriver.getInstance().getMessage(session,
                                    "nas_mapd/nt/h3_ads"));

                    String dnsDomain = ((AuthADSDomain) auth).getDNSDomain();
                    String kdcServer = ((AuthADSDomain) auth).getKDCServer();

                    if (kdcServer == null || kdcServer.equals("")) {
                        String friend = Soap4Cluster.whoIsMyFriend(target);

                        if (friend != null) {
                            Vector vec = MapdCommonSOAPClient.getADSConf(friend,
                                    domain);

                            if (vec != null) {
                                dnsDomain = (String) vec.get(0);
                                kdcServer = (String) vec.get(1);
                            }
                        }
                    }
                    if (kdcServer != null && !kdcServer.equals("")) {
                        kdcServer = kdcServer.replaceAll(" ", "<br>&nbsp;&nbsp;");
                        mp.setResource(
                                NSMessageDriver.getInstance().getMessage(session,
                                        "nas_mapd/nt/nt_domain")
                                                + " : "
                                                + domain
                                                + "<br>"
                                                + NSMessageDriver.getInstance().getMessage(session,
                                                        "nas_mapd/nt/text_dnsdomain")
                                                        + " : <br>&nbsp;&nbsp;"
                                                        + dnsDomain
                                                        + "<br>"
                                                        + NSMessageDriver.getInstance().getMessage(session,
                                                                "nas_mapd/nt/text_kdcserver")
                                                                + " : <br>&nbsp;&nbsp;" 
                                                                + kdcServer);
                    }
                }

                if (auth instanceof AuthLDAPDomain) {
                    AuthLDAPDomain ldapDomain = (AuthLDAPDomain) auth;
                    String server = getLdapServer();

                    mp.setDomainType(
                            NSMessageDriver.getInstance().getMessage(session,
                                    "nas_mapd/nt/h3_ldap"));

                    mp.setResource(
                            NSMessageDriver.getInstance().getMessage(session,
                                    "nas_mapd/nt/ldap_server")
                                            + " : <br>&nbsp;&nbsp;"
                                            + server.replaceAll("\\s+",
                                            "<br>&nbsp;&nbsp;"));
                }
            }

            mpList.add(mp);
        }
        return mpList;
    }
}
