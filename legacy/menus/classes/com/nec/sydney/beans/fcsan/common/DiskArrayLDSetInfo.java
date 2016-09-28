/*
 *      Copyright (c) 2001 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 *      Revision History:
 *      FCSAN-Phase 3   2002/6/20   caoyh   add the attribute pathCount 
 *                                  and pathState and the set and get method.
 *
 *
 */

package com.nec.sydney.beans.fcsan.common;
import java.util.*;


public class DiskArrayLDSetInfo {


    private static final String     cvsid = "@(#) $Id: DiskArrayLDSetInfo.java,v 1.2300 2003/11/24 00:54:47 nsadmin Exp $";


    private String ID;

    private String name;
    private String type;
    private String pathInfo;
    private String pattern;
    private String owner_id;
    private int pathCount;
    private String pathState;
    public DiskArrayLDSetInfo()
    {
        ID="";
        name="";
        type="";
        pathInfo="";
    }
    public String getID()
    {
        return ID;
    }
    public int getPathCount() {
        return pathCount;
    }
    public String getPathState() {
        return pathState;
    }
    public String getName()
    {
        return name;
    }
    public String getType()
    {
        return type;
    }
    public String getPathInfo()
    {
        return pathInfo;
    }
    public String getOwner_id()
    {
        return owner_id;
    }
    public String getPattern()
    {
        return pattern;
    }

    public void setID(String IDValue)
    {
        ID=IDValue;
    }
    public void setName(String nameValue)
    {
        name=nameValue;
    }
    public void setType(String typeValue)
    {
        type=typeValue;
    }
    public void setPathInfo(String pathInfoValue)
    {
        pathInfo=pathInfoValue;
    }
    public void setPathCount(int count) {
        pathCount = count;
    }
    public void setPathState(String state) {
        pathState = state;
    }
    public void setOwner_id(String id) {
        owner_id = id;
    }
    public void setPattern(String pat) {
        pattern = pat;
    }
    
    public String getPathInfoSummary()
    {
        StringTokenizer token=new StringTokenizer(pathInfo,",");
                if(token.countTokens()<=2){
            return pathInfo;
        }
        StringBuffer summary=new StringBuffer();
         
        summary.append(token.nextToken());
        summary.append(",");
        summary.append(token.nextToken());
        summary.append("...");

              return summary.toString();
    }
}
