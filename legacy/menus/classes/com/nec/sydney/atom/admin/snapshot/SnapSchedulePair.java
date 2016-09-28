/*
 *      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.atom.admin.snapshot;

import java.util.Vector;

public class SnapSchedulePair implements Comparable

{

	private static final String cvsid = "@(#) $Id: SnapSchedulePair.java,v 1.5 2007/05/30 09:57:15 liy Exp $";

	// subitems of SnapSchedule

	// The member variable mountPoint and deviceName are the actual mountpoint
	// or devicename . Their values
	// can't be trusted .
	private String mountPoint, deviceName, scheduleName, generation, day, hour,
			minute, directEditInfo, deleteGeneration, deleteDay, deleteHour,
			deleteMinute, deleteDirectEditInfo;

	private int period, deletePeriod;

	// constructor
	public SnapSchedulePair() {

		mountPoint = "";
		deviceName = "";
		scheduleName = "";
		generation = "";
		day = "";
		hour = "";
		minute = "";
		period = 0;
		directEditInfo = "";
		deleteGeneration = "";
		deleteDay = "";
		deleteHour = "";
		deleteMinute = "";
		deletePeriod = 0;
		deleteDirectEditInfo = "";
	}

	public SnapSchedulePair(SnapSchedule schedule) {
		mountPoint = schedule.getMountPoint();
		deviceName = schedule.getDeviceName();
		scheduleName = schedule.getScheduleName();
		generation = schedule.getGeneration();
		day = schedule.getDay();
		hour = schedule.getHour();
		minute = schedule.getMinute();
		period = schedule.getPeriod();
		directEditInfo = schedule.getDirectEditInfo();
		deleteGeneration = "";
		deleteDay = "";
		deleteHour = "";
		deleteMinute = "";
		deletePeriod = 0;
		deleteDirectEditInfo = "";
	}

	// some GET methods
	public String getMountPoint() {
		return mountPoint;
	}

	public String getDeviceName() {
		return deviceName;
	}

	public String getScheduleName() {
		return scheduleName;
	}

	public String getGeneration() {
		return generation;
	}

	public int getPeriod() {
		return period;
	}

	public String getDay() {
		return day;
	}

	public String getHour() {
		return hour;
	}

	public String getMinute() {
		return minute;
	}

	public String getDirectEditInfo() {
		return directEditInfo;
	}

	public String getDeleteGeneration() {
		return deleteGeneration;
	}

	public int getDeletePeriod() {
		return deletePeriod;
	}

	public String getDeleteDay() {
		return deleteDay;
	}

	public String getDeleteHour() {
		return deleteHour;
	}

	public String getDeleteMinute() {
		return deleteMinute;
	}

	public String getDeleteDirectEditInfo() {
		return deleteDirectEditInfo;
	}

	// some SET
	public void setMountPoint(String paramMP) {
		mountPoint = paramMP;
	}

	public void setDeviceName(String paramDN) {
		deviceName = paramDN;
	}

	public void setScheduleName(String paramSN) {
		scheduleName = paramSN;
	}

	public void setGeneration(String paramGen) {
		generation = Integer.toString(Integer.parseInt(paramGen));
	}

	public void setPeriod(int paramPeriod) {
		period = paramPeriod;
	}

	public void setDay(String paramDay) {
		day = paramDay;
	}

	public void setMinute(String paramMinute) {
		minute = paramMinute;
	}

	public void setHour(String paramHour) {
		hour = paramHour;
	}

	public void setDirectEditInfo(String paramDirectEditInfo) {
		directEditInfo = paramDirectEditInfo;
	}

	public void setDeleteGeneration(String paramGen) {
		deleteGeneration = Integer.toString(Integer.parseInt(paramGen));
	}

	public void setDeletePeriod(int paramPeriod) {
		deletePeriod = paramPeriod;
	}

	public void setDeleteDay(String paramDay) {
		deleteDay = paramDay;
	}

	public void setDeleteMinute(String paramMinute) {
		deleteMinute = paramMinute;
	}

	public void setDeleteHour(String paramHour) {
		deleteHour = paramHour;
	}

	public void setDeleteDirectEditInfo(String paramDirectEditInfo) {
		deleteDirectEditInfo = paramDirectEditInfo;
	}

	// make SnapSchedulePair 's List
	static public Vector makeSchedulePair(Vector snapshotVector,
			Vector deleteSnapshotVector) {
		Vector snapSchedulePairVector = new Vector();
		for (int i = 0, j = 0; i < snapshotVector.size(); i++) {
			SnapSchedule schedule = ((SnapSchedule) snapshotVector.get(i));
			SnapSchedulePair snapSchedulePair = new SnapSchedulePair(schedule);
			if (deleteSnapshotVector != null && j < deleteSnapshotVector.size()
					&& schedule.compareTo(deleteSnapshotVector.get(j)) == 0) {

				// The two schedule has the same schedule name,so they are of a
				// pair
				// 's SnapSchedulePair
				SnapSchedule deleteSchedule = ((SnapSchedule) deleteSnapshotVector
						.get(j));
				snapSchedulePair.deleteGeneration = deleteSchedule
						.getGeneration();
				snapSchedulePair.deleteDay = deleteSchedule.getDay();
				snapSchedulePair.deleteHour = deleteSchedule.getHour();
				snapSchedulePair.deleteMinute = deleteSchedule.getMinute();
				snapSchedulePair.deletePeriod = deleteSchedule.getPeriod();
				snapSchedulePair.deleteDirectEditInfo = deleteSchedule
						.getDirectEditInfo();
				j++;
			}

			snapSchedulePairVector.add(i, snapSchedulePair);
		}
		return snapSchedulePairVector;

	}

	// compare the double objects of SnapSchedule
	public int compareTo(Object i_ss) {
		String i_sn = ((SnapSchedule) i_ss).getScheduleName();
		return (scheduleName.compareTo(i_sn) < 0 ? -1 : (scheduleName
				.compareTo(i_sn) == 0 ? 0 : 1));
	}
}
