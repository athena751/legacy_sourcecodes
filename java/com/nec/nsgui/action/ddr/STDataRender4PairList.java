/*
 *      Copyright (c) 2008 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */
package com.nec.nsgui.action.ddr;

import com.nec.nsgui.taglib.nssorttab.ListSTModel;
import com.nec.nsgui.taglib.nssorttab.STAbstractRender;
import com.nec.nsgui.action.base.NSActionUtil;
import com.nec.nsgui.model.entity.ddr.DdrPairInfoBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.PageContext;
import java.util.AbstractList;

import org.apache.struts.Globals;
import org.apache.struts.taglib.TagUtils;

public class STDataRender4PairList extends STAbstractRender implements DdrActionConst {
	private static final String cvsid = "@(#) $Id: STDataRender4PairList.java,v 1.3 2008/05/04 05:31:28 pizb Exp $";

	private static final String SEPARATOR_CELL_INFO = "<==>";
	private static final String ddrBundle = Globals.MESSAGES_KEY + "/ddr";
    
    public String getCellRender(int rowIndex, String colName) throws Exception {
    	String cellInfoStr = getCellInfo(rowIndex, colName);
		
    	if ( cellInfoStr.equals("") ){
    		return "";
    	}
    	String[] cellInfoAry = cellInfoStr.split(SEPARATOR_CELL_INFO);
    	
    	String rowSpan = cellInfoAry[0];
    	String mvName = cellInfoAry[1];
    	String cellContent = cellInfoAry[2];
    	
    	if (PAIR_LIST_COL_RADIO.equals(colName)
    			|| PAIR_LIST_COL_CLEARBUTTON.equals(colName)) {
    		return "<td valign=top nowrap rowspan=" + rowSpan + ">" + cellContent + "</td>";
    	}
    	        
    	if (PAIR_LIST_COL_USAGE.equals(colName)
    			|| PAIR_LIST_COL_MVNAME.equals(colName)
    			|| PAIR_LIST_COL_RVNAME.equals(colName)
    			|| PAIR_LIST_COL_SYNCSTATE.equals(colName)
    			|| PAIR_LIST_COL_SYNCSTARTTIME.equals(colName)
    			|| PAIR_LIST_COL_SCHEDULE.equals(colName)
    			|| PAIR_LIST_COL_STATUS.equals(colName)
    			|| PAIR_LIST_COL_ERRORCODE.equals(colName)){ 
    		return "<td valign=top nowrap rowspan=" + rowSpan + "><label for=\"pairRadio"+mvName+ "\">&nbsp;" + cellContent + "&nbsp;</label></td>";
    	}
    	
    	if (PAIR_LIST_COL_PROGRESSRATE.equals(colName)){
    		return "<td valign=top align=right nowrap rowspan=" + rowSpan + "><label for=\"pairRadio"+mvName+ "\">&nbsp;" + cellContent + "&nbsp;</label></td>";
    	}
    	
		return "";
	}

	private String getCellInfo(int rowIndex, String colName) throws Exception {
		PageContext context = getSortTagInfo().getPageContext();
		HttpServletRequest request = (HttpServletRequest) context.getRequest();

		AbstractList <DdrPairInfoBean> ddrPairInfoList = ((ListSTModel) getTableModel()).getDataList();
		if ( ddrPairInfoList == null ){
			return "";
		}
		DdrPairInfoBean currentDdrPairInfo = ddrPairInfoList.get(rowIndex);
		
		String mvName = currentDdrPairInfo.getMvName();
		
		// judge whether the current pair's MV is the same as the previous pair's.
		// if current pair has the same MV with previous pair, then sift this cell in order
		// to combine the cells whose MV are the same.
		boolean isMvSameAsPrePair = isMvSameAsPrePair(mvName, rowIndex, ddrPairInfoList);
		
		int rowSpan = 1;
		StringBuffer cellStr = new StringBuffer();
		// display 'radio' cell.
		if (PAIR_LIST_COL_RADIO.equals(colName)) {
			if ( isMvSameAsPrePair ) {
				return "";
			}
			
			int rvNumber = getRvNumByMv(rowIndex, ddrPairInfoList);
			rowSpan = rvNumber;
			
			// store the all rvName list of the MV.
			StringBuffer rvListBuffer = new StringBuffer(currentDdrPairInfo.getRvName());
			// store the all syncStates list of the MV.
			StringBuffer syncStateListBuffer = new StringBuffer(currentDdrPairInfo.getSyncState());
			// store the all progessRate list of the MV.
			StringBuffer progressRateListBuffer = new StringBuffer(currentDdrPairInfo.getProgressRate());
			// store the all syncStartTime list of the MV.
			StringBuffer syncStartTimeListBuffer = new StringBuffer(currentDdrPairInfo.getSyncStartTime());
			// store the all RV LD name list of the MV.
			StringBuffer rvLdNameListBuffer = new StringBuffer(currentDdrPairInfo.getRvLdNameList());
			// store the all copyControlState list of the MV.
			StringBuffer copyControlStateListBuffer = new StringBuffer(currentDdrPairInfo.getCopyControlState());
			// store the all RV result code list of the MV.
			StringBuffer rvResultCodeListBuffer = new StringBuffer(currentDdrPairInfo.getRvResultCode());
			
			for (int i = 1; i < rvNumber; i++){
				DdrPairInfoBean ddrPairInfoTmp = ddrPairInfoList.get(rowIndex+i);
				
				rvListBuffer.append(SEPARATOR_BETWEEN_RVINFO).append(ddrPairInfoTmp.getRvName());
				syncStateListBuffer.append(SEPARATOR_BETWEEN_RVINFO).append(ddrPairInfoTmp.getSyncState());
				progressRateListBuffer.append(SEPARATOR_BETWEEN_RVINFO).append(ddrPairInfoTmp.getProgressRate());
				syncStartTimeListBuffer.append(SEPARATOR_BETWEEN_RVINFO).append(ddrPairInfoTmp.getSyncStartTime());
				rvLdNameListBuffer.append(SEPARATOR_BETWEEN_RVINFO).append(ddrPairInfoTmp.getRvLdNameList());
				copyControlStateListBuffer.append(SEPARATOR_BETWEEN_RVINFO).append(ddrPairInfoTmp.getCopyControlState());
				rvResultCodeListBuffer.append(SEPARATOR_BETWEEN_RVINFO).append(ddrPairInfoTmp.getRvResultCode());
			}
			
			String holisticStatus = getMvStatus(rowIndex, rvNumber, ddrPairInfoList);
			
			cellStr.append("<input name=\"pairRadio\" type=\"radio\" onclick=\"onRadioClick(this.value);\" value=\"");
			cellStr.append(currentDdrPairInfo.getUsage()).append(SEPARATOR_BETWEEN_MVINFO);
			cellStr.append(mvName).append(SEPARATOR_BETWEEN_MVINFO);
			cellStr.append(rvListBuffer).append(SEPARATOR_BETWEEN_MVINFO);
			cellStr.append(syncStateListBuffer).append(SEPARATOR_BETWEEN_MVINFO);
			cellStr.append(progressRateListBuffer).append(SEPARATOR_BETWEEN_MVINFO);
			cellStr.append(syncStartTimeListBuffer).append(SEPARATOR_BETWEEN_MVINFO);
			cellStr.append(currentDdrPairInfo.getSchedule()).append(SEPARATOR_BETWEEN_MVINFO);
			cellStr.append(currentDdrPairInfo.getMvLdNameList()).append(SEPARATOR_BETWEEN_MVINFO);
			cellStr.append(rvLdNameListBuffer).append(SEPARATOR_BETWEEN_MVINFO);
			cellStr.append(copyControlStateListBuffer).append(SEPARATOR_BETWEEN_MVINFO);
			cellStr.append(holisticStatus).append(SEPARATOR_BETWEEN_MVINFO);
			cellStr.append(rvResultCodeListBuffer).append(SEPARATOR_BETWEEN_MVINFO);
			cellStr.append(currentDdrPairInfo.getMvResultCode()).append(SEPARATOR_BETWEEN_MVINFO);
			cellStr.append(currentDdrPairInfo.getSchedResultCode()).append("\" ");
			
			String selectedMv = (String)NSActionUtil.getSessionAttribute(request, SESSION_MV_NAME);
            if ( selectedMv != null ) {
                if ( selectedMv.equals(mvName) ) {
                    cellStr.append("checked");
                }
                
                if ( selectedMv.equals(mvName) || rowIndex == ddrPairInfoList.size() - 1 ) {
                    NSActionUtil.removeSessionAttribute(request, SESSION_MV_NAME);
                }
            }
            
            if ((selectedMv == null) && (rowIndex == 0)) {
                cellStr.append("checked");
            }
            
			cellStr.append(" id=\"pairRadio").append(mvName);
			cellStr.append("\">");
		} 
		
		// display 'error code' cell.
		if ( PAIR_LIST_COL_ERRORCODE.equals(colName) ){
			int firstPairIndex = getFirstPairIndex(rowIndex, ddrPairInfoList);
			int rvNumber = getRvNumByMv(firstPairIndex, ddrPairInfoList);
			String holisticStatus = getMvStatus(firstPairIndex, rvNumber, ddrPairInfoList);
			
			// if it is not 'MV extend failure' and not 'schedule create failure', 
			// display 'error code' cell by pair unit.
			if ( !INFO_NODATA.equals(holisticStatus) 
					&& !PAIRINFO_STATUS_CREATE_SCHED_FAIL.equals(holisticStatus) 
					&& !PAIRINFO_STATUS_EXTEND_MV_FAIL.equals(holisticStatus) ){
				// in order to do not display the code which is not error, sift it.
				String rvResultCode = currentDdrPairInfo.getRvResultCode();
				cellStr.append(rvResultCode.replaceAll(DDR_OPERATING_CODE + "|" + DDR_OPERATED_CODE + "|" + INFO_NODATA, ""));
			} 
			// if it is 'MV extend failure' or 'schedule create failure', 
			// display 'error code' cell by MV unit.
			else {
				if ( isMvSameAsPrePair ) {
					return "";
				}
				
				rowSpan = rvNumber;
				
				if ( PAIRINFO_STATUS_EXTEND_MV_FAIL.equals(holisticStatus) ) {
					cellStr.append(currentDdrPairInfo.getMvResultCode());
				}
				if ( PAIRINFO_STATUS_CREATE_SCHED_FAIL.equals(holisticStatus) ) {
					cellStr.append(currentDdrPairInfo.getSchedResultCode());
				}
			}
		}
		// display 'status' cell.
		else if ( PAIR_LIST_COL_STATUS.equals(colName) ){
			// get the whole status of the MV.
			int firstPairIndex = getFirstPairIndex(rowIndex, ddrPairInfoList);
			int rvNumber = getRvNumByMv(firstPairIndex, ddrPairInfoList);
			String holisticStatus = getMvStatus(firstPairIndex, rvNumber, ddrPairInfoList);
			
			// if it is 'abnormal composition', display 'status' cell by pair unit.
			if ( PAIRINFO_STATUS_ABNORMALITYCOMPOSITION.equals(holisticStatus)) {
				String status = currentDdrPairInfo.getStatus();
				if (!INFO_NODATA.equals(status)){
					String msgKey = "pair.info.status." + status;
					cellStr.append(TagUtils.getInstance().message(context, ddrBundle, null, msgKey));
				}
			}
			// if it is not 'abnormal composition' or no data, display 'status' cell by MV unit.
			else {
				if ( isMvSameAsPrePair ) {
					return "";
				}
				
				rowSpan = rvNumber;
				
				if (!INFO_NODATA.equals(holisticStatus)){
					String msgKey = "pair.info.status." + holisticStatus;
					cellStr.append(TagUtils.getInstance().message(context, ddrBundle, null, msgKey));
				}
			}
		}
		// display 'clear button' cell.
		else if (PAIR_LIST_COL_CLEARBUTTON.equals(colName)) {
			if ( isMvSameAsPrePair ) {
				return "";
			}
			
			int rvNumber = getRvNumByMv(rowIndex, ddrPairInfoList);
			rowSpan = rvNumber;
			// get the whole status of the MV.
			String holisticStatus = getMvStatus(rowIndex, rvNumber, ddrPairInfoList);
			if (DdrActionConst.PAIRINFO_STATUS_CREATE_FAIL.equals(holisticStatus) 
					|| DdrActionConst.PAIRINFO_STATUS_EXTEND_FAIL.equals(holisticStatus) 
					|| DdrActionConst.PAIRINFO_STATUS_EXTEND_MV_FAIL.equals(holisticStatus) 
					|| DdrActionConst.PAIRINFO_STATUS_CREATE_SCHED_FAIL.equals(holisticStatus) ){
				cellStr.append("<input name=\"delete\" type=\"button\" onclick=\'onDelAsyncPair(\""+mvName+"\");\' value=\"");
				cellStr.append(TagUtils.getInstance().message(context, ddrBundle, null, "pair.info.clearbutton"));
				cellStr.append("\" />");
			}
			else {
				cellStr.append("&nbsp;");
			}
		} 
		// display 'usage' cell.
		else if (PAIR_LIST_COL_USAGE.equals(colName)) {
			if ( isMvSameAsPrePair ) {
				return "";
			}
			rowSpan = getRvNumByMv(rowIndex, ddrPairInfoList);
			String usage = currentDdrPairInfo.getUsage();
			String msgKey = "pair.info.usage." + usage;
			cellStr.append(TagUtils.getInstance().message(context, ddrBundle, null, msgKey));
		} 
		// display 'mvname' cell.
		else if (PAIR_LIST_COL_MVNAME.equals(colName)) {
			if ( isMvSameAsPrePair ) {
				return "";
			}
			rowSpan = getRvNumByMv(rowIndex, ddrPairInfoList);
			String mvNameTmp = mvName.replaceFirst("NV_LVM_", "");
			cellStr.append(mvNameTmp);
		} 
		// display 'schedule' cell.
		else if (PAIR_LIST_COL_SCHEDULE.equals(colName)) {
			if ( isMvSameAsPrePair ) {
				return "";
			}
			rowSpan = getRvNumByMv(rowIndex, ddrPairInfoList);
			String scheduleListStr = currentDdrPairInfo.getSchedule();
			String[] scheduleListAry = scheduleListStr.split(SEPARATOR_BETWEEN_SCHEDULE);
			for (int i = 0; i < scheduleListAry.length; i++) {
				cellStr.append(ScheduleUtil.getSchedule(scheduleListAry[i], request));
				if (i < scheduleListAry.length - 1) {
					cellStr.append("&nbsp;"+SEPARATOR_NEWLINE+"&nbsp;");
				}
			}
		} 
		// display 'progress' cell.
		else if (PAIR_LIST_COL_PROGRESSRATE.equals(colName)) {
			String progressRate = currentDdrPairInfo.getProgressRate();
			cellStr.append(progressRate);
			if (!progressRate.equals(SYNCSTATE_ALWAYSREPL_MARK) && !progressRate.equals(INFO_NODATA)) {
				cellStr.append("%");
			}
		} 
		// display 'RV Name' cell.
		else if (PAIR_LIST_COL_RVNAME.equals(colName)) {
			cellStr.append(currentDdrPairInfo.getRvName());
		} 
		// display 'Sync state' cell.
		else if (PAIR_LIST_COL_SYNCSTATE.equals(colName)) {
			String state = currentDdrPairInfo.getSyncState();
			if (state.equals(SYNCSTATE_ALWAYSREPL_MARK) || state.equals(SYNCSTATE_SYNC_NOTHING_MARK)){
				cellStr.append(state);
			} else {
				String msgKey = "pair.info.syncstate." + state;
				cellStr.append(TagUtils.getInstance().message(context, ddrBundle, null, msgKey));
			}
		} 
		// display 'Sync Start Time' cell.
		else if (PAIR_LIST_COL_SYNCSTARTTIME.equals(colName)) {
			String src_date_time = currentDdrPairInfo.getSyncStartTime().trim();
			String localDate_Time = NSActionUtil.getLocalDateTimeStr(src_date_time, request);
			cellStr.append(localDate_Time);
		} 
		
		String content = cellStr.toString();
		if (content.equals("")) {
			content = "&nbsp;";
		}
		return rowSpan + SEPARATOR_CELL_INFO + mvName + SEPARATOR_CELL_INFO + content;
	}

	/*
	 * judge whether the current pair's MV is the same as previous pair's.
	 * if it's the same, return true, or return false.
	 */
	private boolean isMvSameAsPrePair(String mvName, int rowIndex, AbstractList<DdrPairInfoBean> ddrPairInfoList) {
		boolean isMvSameAsPrePair = false;
		if (rowIndex > 0) {
			DdrPairInfoBean preDdrPairInfo = ddrPairInfoList.get( rowIndex - 1);
			// judge whether the current pair's MV is the same as previous pair's.
			if (mvName.equals(preDdrPairInfo.getMvName())) {
				isMvSameAsPrePair = true;
			}
		}
		return isMvSameAsPrePair;
	}
	
	/*
	 * get the first pair's index of the appointed MV in ddrPairInfoList.
	 */
	private int getFirstPairIndex(int rowIndex, AbstractList<DdrPairInfoBean> ddrPairInfoList) {
		String mvName = ddrPairInfoList.get(rowIndex).getMvName();
		
		// find the pair whose mvName is the same as the appointed mvName before
		// rowIndex, if there is N pairs, the first index will be rowIndex - N.
		int firstPairIndex = rowIndex;
		while ( --rowIndex >= 0 && mvName.equals(ddrPairInfoList.get(rowIndex).getMvName())){
			firstPairIndex--;
		}
		
		return firstPairIndex;
	}
	
	/*
	 * calculate the number of RV of the appointed MV.
	 * @firstPairIndex	the mv's first pair index in the ddrPairInfoList.
	 * @ddrPairInfoList all pair info.
	 */
	private int getRvNumByMv(int firstPairIndex, AbstractList<DdrPairInfoBean> ddrPairInfoList) {
		int rvNumber = 1;
		int pairNumber = ddrPairInfoList.size();
		int nextDdrPairIndex = firstPairIndex;
		String mvName = ddrPairInfoList.get(firstPairIndex).getMvName();
		
		// calculate the number of RV of the appointed MV. 
		while ( ++nextDdrPairIndex < pairNumber 
				&& mvName.equals(ddrPairInfoList.get(nextDdrPairIndex).getMvName())) {
			rvNumber++;
		}
		
		return rvNumber;
	}
	
	/*
	 * get the holistic status of the appointed MV.
	 */
	private String getMvStatus(int firstPairIndex, int rvNumber, AbstractList<DdrPairInfoBean> ddrPairInfoList) {
		String holisticStatus = INFO_NODATA;
		
		for (int i = 0; i < rvNumber; i++){
			DdrPairInfoBean ddrPairInfoTmp = ddrPairInfoList.get(firstPairIndex+i);
			String statusTmp = ddrPairInfoTmp.getStatus();
			// if one of the pair's status is '****fail' or '****ing' or 'abnormal', then we make the 
			// mv's final status be '****fail' or '****ing' or 'abnormal'.
			if ( statusTmp.endsWith("fail") 
					|| statusTmp.endsWith("ing") 
					|| PAIRINFO_STATUS_ABNORMALITYCOMPOSITION.equals(statusTmp)) {
				holisticStatus = statusTmp;
				break;
			}
		}
		
		return holisticStatus;
	}
}