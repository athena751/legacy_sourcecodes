/*
 *	Copyright (c) 2001-2005 NEC Corporation
 *
 *	NEC SOURCE CODE	PROPRIETARY
 *
 *	Use, duplication and disclosure	subject	to a source code
 *	license	agreement with NEC Corporation.
 */

package	com.nec.sydney.beans. fcsan.componentdisp;
import java.util.*;
import java.io.*;
import com.nec.sydney.framework.*;
import com.nec.sydney.beans.fcsan.common.*;
public class DiskArrayPDDetailBean extends FcsanAbstractBean implements	FCSANConstants 
{

    private static final String	    cvsid = "@(#) $Id: DiskArrayPDDetailBean.java,v 1.2305 2005/12/23 12:47:46 wangli Exp $";


    private DiskArrayPDInfo PDInfo;    
    private List LDList;
    private boolean success;
    public DiskArrayPDDetailBean()
    {
	LDList=new ArrayList();
	PDInfo=new DiskArrayPDInfo();
	success=true;
    }
    public List	getLDList()
    {
	return LDList;
    }
    public DiskArrayPDInfo getPDInfo()
    {
	return PDInfo;
    }
    public boolean getSuccess()
    {
	return success;
    }
    public void	beanProcess() throws Exception
    {
	String diskarrayid=request.getParameter("diskid");
	String pdid=request.getParameter("pdid");
	if (diskarrayid==null||diskarrayid.equals("")||pdid==null||pdid.equals(""))
	{
	    NSException	ex=new NSException(NSMessageDriver.getInstance().getMessage(session,"fcsan_common/exception/invalid_param"));
	    throw ex;
	}
	
	String cmd=CMD_DISKLIST_PD+" "+diskarrayid+" "+"-npd"+"	"+pdid;
	BufferedReader readbuf=execCmd(cmd);
	if (readbuf==null)
	{
	    success=false;
	    return;
	}
	String line=readbuf.readLine();
	while (!line.startsWith(SEPARATED_LINE)&&line!=null)
	{
	    line=readbuf.readLine();
	}
	line=readbuf.readLine();
	if (line != null && line.startsWith(DISKLIST_CMD_NAME)){
	    return;
	}
	if (line!=null)
	{
	    StringTokenizer st=new StringTokenizer(line, "\t");
	    //int	stLength=st.countTokens();
	    PDInfo.setPdNo(st.nextToken().trim());
	    String state=st.nextToken().trim();
        /*
	    if (stLength==13)
	    {
		//PDInfo.setState((String)valueDisplayHash.get(state+" "+st.nextToken()));
		PDInfo.setState(state+" "+st.nextToken());//caoyh 4.15
	    }
	    else*/
		//PDInfo.setState((String)valueDisplayHash.get(state));
		PDInfo.setState(state);//caoyh 4.15
	    PDInfo.setCapacity(st.nextToken().trim());
	    PDInfo.setPoolNo(st.nextToken().trim());
        PDInfo.setPoolName(st.nextToken().trim());
	    
//	      PDInfo.setPdDivision((String)valueDisplayHash.get(st.nextToken()));
	    String keyDivision = "fcsan_hashvalue/hashvalue/"+st.nextToken().trim();
	    PDInfo.setPdDivision(NSMessageDriver.getInstance().getMessage(session,keyDivision));//caoyh	4.15
	    
	    PDInfo.setProductID(st.nextToken().trim());
	    PDInfo.setProductRevision(st.nextToken().trim());
	    PDInfo.setSerialNo(st.nextToken().trim());
	    PDInfo.setSpinNumber(st.nextToken().trim());
        //for [nsgui-necas-sv4:12155] by wangli 2005.12.10
        String progression=st.nextToken().trim();
        if (progression.equals(FCSAN_NOMEAN_VALUE)){
            progression="&nbsp;&nbsp;";
        }else {
            progression += "%";
        }
        PDInfo.setProgression(progression);
        PDInfo.setType(st.nextToken().trim());
        
	    line=readbuf.readLine();
	}
	cmd=CMD_DISKLIST_PL+" "+diskarrayid+" "+"-npd"+" "+pdid;
	readbuf=execCmd(cmd);	 
	if (readbuf==null)
	{
	    success=false;
	    return;
	}

	line=readbuf.readLine();
	while (!line.startsWith(SEPARATED_LINE)&&line!=null)
	{
	    line=readbuf.readLine();
	}
	line=readbuf.readLine();
	while (line!=null)
	{
	    StringTokenizer st=new StringTokenizer(line);
	    int	number=st.countTokens();

	    if (number == 10 || number == 11)
	    {
		DiskArrayLDInfo	ld=new DiskArrayLDInfo();
		ld.setLdNo(st.nextToken());
		String type=st.nextToken();
		if (type.equals(FCSAN_NOMEAN_VALUE)){
		    type="&nbsp;&nbsp;";
		}
		ld.setType(type);
		ld.setName(st.nextToken());
		String state=st.nextToken();
		if (state.equals(FCSAN_NOMEAN_VALUE)){
		    ld.setState("&nbsp;&nbsp;");    //Changed by Yang AH
		}
		else
		{
		    /*if (FCSAN_STATE_PREVENTIVE_COPY.indexOf(state)!=-1
			    ||FCSAN_STATE_COPY_BACK.indexOf(state)!=-1
			    ||FCSAN_STATE_FORMAT_FAIL.indexOf(state)!=-1
			    ||FCSAN_STATE_EXPAND_FAIL.indexOf(state)!=-1
			    ||FCSAN_STATE_MEDIA_ERROR.indexOf(state)!=-1
			    ||FCSAN_STATE_POWERING_UP.indexOf(state)!=-1){*/
		    if (number == 11){
			ld.setState(state+" "+st.nextToken());//caoyh 4.15
		    }else {
			ld.setState(state);//caoyh 4.15
		    }
		}
		ld.setRAID(st.nextToken());
		ld.setCapacity(st.nextToken());
		
		//if there is no Cache Resident, display noting in the jsp page; 
		String cacheflag = st.nextToken();
		if (cacheflag.equals("no")){
		    ld.setCacheFlag("&nbsp;&nbsp;");	
		} else {
		    ld.setCacheFlag(cacheflag);
		}
		String progression=st.nextToken();
		if (progression.equals(FCSAN_NOMEAN_VALUE)){
		    progression="&nbsp;&nbsp;";
		}

		ld.setProgression(progression);
        ld.setBasePd(st.nextToken());
		String LdSetName=st.nextToken();
		if (LdSetName.equals(FCSAN_NOMEAN_VALUE)){
		    LdSetName="&nbsp;&nbsp;";	 //added by Yang AH
		}
		ld.setLdSet(LdSetName);
		LDList.add(ld);
	    }
	    
	    line=readbuf.readLine();
	    
	}
    }
}
