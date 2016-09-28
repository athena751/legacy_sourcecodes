/*
 *      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.snapshot;

import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.atom.admin.snapshot.*;
import com.nec.sydney.beans.base.*;
import java.util.*; 

public class SnapSOAPClient implements NasConstants,NSExceptionMsg
{
    private static final String     cvsid = "@(#) $Id: SnapSOAPClient.java,v 1.2304 2007/05/30 10:03:37 liy Exp $";
    private static final String     URN_SNAPSHOT_SERVICE                 = "urn:SnapshotConf";
    /*none properties here*/
    //constructor
    public SnapSOAPClient()
    {}
    
    //Call SnapSOAPServer service "getSnapSchedule"
    public static SnapSummaryInfo getSnapSchedule(String mountPoint,String deviceName, String account, String routerUrl)throws Exception
    {
        Vector paramVec = new Vector();
        paramVec.add(mountPoint);
        paramVec.add(deviceName);
        paramVec.add(account);
        SoapRpsSnapSummaryInfo rtValue = (SoapRpsSnapSummaryInfo)SoapClientBase.execSoapServerFunc(paramVec,"getSnapSchedule",URN_SNAPSHOT_SERVICE,routerUrl);
        return rtValue.getInfo();
    }
     
    //Call SnapSOAPServer service "addSnapSchedule"
    public static String addSnapSchedule(SnapSchedule schedule,SnapSchedule delSnapSche,String account,String routerUrl)throws Exception
    {
        Vector paramVec = new Vector();
        paramVec.add(schedule);
        paramVec.add(delSnapSche);
        paramVec.add(account);
        SoapRpsString rtValue = (SoapRpsString)SoapClientBase.execSoapServerFunc(paramVec,"addSnapSchedule",URN_SNAPSHOT_SERVICE,routerUrl);
        return rtValue.getString();
    }  
    
    //Call SnapSOAPServer service "deleteSnapSchedule"
    public static void deleteSnapSchedule(String schedule,String mountPoint,String deviceName,String account,String routerUrl)throws Exception
    {
        Vector paramVec = new Vector();
        paramVec.add(schedule);
        paramVec.add(mountPoint);
        paramVec.add(deviceName);
        paramVec.add(account);
        SoapClientBase.execSoapServerFunc(paramVec,"deleteSnapSchedule",URN_SNAPSHOT_SERVICE,routerUrl);
    }
    
    //Call SnapSOAPServer service "setCOWLimit"
    public static void setCOWLimit(int limit,String mountPoint,String routerUrl) throws Exception
    {
        Vector paramVec = new Vector();
        paramVec.add(new Integer(limit));
        paramVec.add(mountPoint);
        SoapClientBase.execSoapServerFunc(paramVec,"setCOWLimit",URN_SNAPSHOT_SERVICE,routerUrl);
    }
    
    //Call SnapSOAPServer service "createSnap"
    public static void createSnap(String name,String mountPoint,String routerUrl)throws Exception 
    {
        Vector paramVec = new Vector();
        paramVec.add(name);
        paramVec.add(mountPoint);
        SoapClientBase.execSoapServerFunc(paramVec,"createSnap",URN_SNAPSHOT_SERVICE,routerUrl);
    }
    
    //Call SnapSOAPServer service "deleteSnap"
    public static void deleteSnap(String name,String mountPoint,String routerUrl)throws Exception
    {
        Vector paramVec = new Vector();
        paramVec.add(name);
        paramVec.add(mountPoint);
        SoapClientBase.execSoapServerFunc(paramVec,"deleteSnap",URN_SNAPSHOT_SERVICE,routerUrl);
    }
    
    //Call SnapSOAPServer service "getSnapList"
    public static SnapSummaryInfo getSnapList(String mountPoint,String deviceName, String routerUrl)throws Exception
    {
        Vector paramVec = new Vector();
        paramVec.add(mountPoint);
        paramVec.add(deviceName);
        SoapRpsSnapSummaryInfo rtValue = (SoapRpsSnapSummaryInfo)SoapClientBase.execSoapServerFunc(paramVec,"getSnapList",URN_SNAPSHOT_SERVICE,routerUrl);
        return rtValue.getInfo();
    }

    //added by wangw at 2003/1/14
    public static void checkOutSnapshot(String routerUrl)throws Exception
    {
        SoapClientBase.execSoapServerFunc("checkOutSnapshot",URN_SNAPSHOT_SERVICE,routerUrl);
    }

    public static void checkInSnapshot(String routerUrl)throws Exception
    {
        SoapClientBase.execSoapServerFunc("checkInSnapshot",URN_SNAPSHOT_SERVICE,routerUrl);

    }

    public static void rollBackSnapshot(String routerUrl)throws Exception
    {
        SoapClientBase.execSoapServerFunc("rollBackSnapshot",URN_SNAPSHOT_SERVICE,routerUrl);
    }
    
    public static String hexMP2DevName(String mountPoint , String routerUrl)throws Exception {
		Vector paramVec = new Vector();
        paramVec.add(mountPoint);
        SoapRpsString rtValue = (SoapRpsString)SoapClientBase.execSoapServerFunc(paramVec,"hexMP2DevName",URN_SNAPSHOT_SERVICE,routerUrl);
        return rtValue.getString();
	}
}
