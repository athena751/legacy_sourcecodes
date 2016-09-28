/*
 *      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.atom.admin.snapshot;

import java.util.*;

public class SnapSummaryInfo{

    private static final String     cvsid = "@(#) $Id: SnapSummaryInfo.java,v 1.2301 2007/05/30 09:57:15 liy Exp $";


    //the number of the snapshot which can be create successfully
    private int     snapAvailableNumber;
    
    //the vector contains the objects of SnapInfo or SnapSchedule
    private Vector  snapshotVector;
    private Vector  deleteSnapshotVector;
    
    private Hashtable scheduleOutCrontab2Time;
    
    
    //constructor
    public SnapSummaryInfo(){
    }
    
    // the GET methods
    public int getSnapAvailableNumber(){
        return snapAvailableNumber;
    }
    public Vector getSnapshotVector(){
        return snapshotVector;
    }
    public Vector getDeleteSnapshotVector(){
        return deleteSnapshotVector;
    }
    public Hashtable getScheduleOutCrontab2Time() {
        return scheduleOutCrontab2Time;
    }
    
    //the SET methods
    public void setSnapAvailableNumber(int i_number){
        snapAvailableNumber = i_number;
    }
    public void setSnapshotVector(Vector i_vector){
        snapshotVector = i_vector;
    }
    public void setDeleteSnapshotVector(Vector i_vector){
        deleteSnapshotVector = i_vector;
    }
    public void setScheduleOutCrontab2Time(Hashtable i_hash) {
        this.scheduleOutCrontab2Time = i_hash;
    }
}