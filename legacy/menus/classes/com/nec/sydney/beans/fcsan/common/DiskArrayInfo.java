/*
 *      Copyright (c) 2001-2005 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.fcsan.common;
import java.util.*;

public class DiskArrayInfo{
    private static final String     cvsid = "@(#) $Id: DiskArrayInfo.java,v 1.2301 2005/09/21 05:00:38 wangli Exp $";

    private String ID;
    private String  name;
    private String type;
    private String  state;
    private Vector componentStates;
    private String observation;
    private String SAA;
    private String  productID;
    private Vector productNames;
    private Vector productStates;
    private String productRev;
    private String SerialNo;
    private String capacity;
    private String controlPass1;
    private String controlPass2;
    private String pathState1;
    private String pathState2; //Add by maojb on 4.22
    private String crossCallMode;
    private String accessControlFlag;
    private Vector entryCounts;
    private Vector componentTypes;
    private String assignMode;
    private String userSystemCode;
    
    private String WWNN; //Add by wangli on 2005.9.12 

    public String getWWNN() {
        return WWNN;
    }
    public void setWWNN(String wwnn) {
        WWNN = wwnn;
    }
    public String getID(){
        return ID;
    }
    public void setID(String ID){
        this.ID=ID;
    }
    public String  getName(){
        return name;
    }
    public void setName(String  name){
        this.name=name;
    }
    public String getType(){
        return type;
    }
    public void setType(String type){
        this.type=type;
    }
    public String  getState(){
        return state;
    }
    public void setState(String  state){
        this.state=state;
    }
    public Vector getComponentStates(){
        return componentStates;
    }
    public void setComponentStates(Vector componentStates){
        this.componentStates=componentStates;
    }
    public String getObservation(){
        return observation;
    }
    public void setObservation(String observation){
        this.observation=observation;
    }
    public String getSAA(){
        return SAA;
    }
    public void setSAA(String SAA){
        this.SAA=SAA;
    }
    public String  getProductID(){
        return productID;
    }
    public void setProductID(String  productID){
        this.productID=productID;
    }
    public Vector getProductNames(){
        return productNames;
    }
    public void setProductNames(Vector productNames){
        this.productNames=productNames;
    }
    public Vector getProductStates(){
        return productStates;
    }
    public void setProductStates(Vector productStates){
        this.productStates=productStates;
    }
    public String getProductRev(){
        return productRev;
    }
    public void setProductRev(String productRev){
        this.productRev=productRev;
    }
    public String getSerialNo(){
        return SerialNo;
    }
    public void setSerialNo(String SerialNo){
        this.SerialNo=SerialNo;
    }
    public String getCapacity(){
        return capacity;
    }
    public void setCapacity(String capacity){
        this.capacity=capacity;
    }
    public String getControlPass1(){
        return controlPass1;
    }
    public void setControlPass1(String controlPass1){
        this.controlPass1=controlPass1;
    }
//Add by maojb on 4.22
    public String getPathState1(){
        return pathState1;
    }
    public void setPathState1(String pathState1){
        this.pathState1=pathState1;
    }

    public String getControlPass2(){
        return controlPass2;
    }
    public void setControlPass2(String controlPass2){
        this.controlPass2=controlPass2;
    }

//Add by maojb on 4.22

    public String getPathState2(){
        return pathState2;
    }
    public void setPathState2(String pathState2){
        this.pathState2=pathState2;
    }

    public String getCrossCallMode(){
        return crossCallMode;
    }
    public void setCrossCallMode(String crossCallMode){
        this.crossCallMode=crossCallMode;
    }
    public String getAccessControlFlag(){
        return accessControlFlag;
    }
    public void setAccessControlFlag(String accessControlFlag){
        this.accessControlFlag=accessControlFlag;
    }
    public Vector getEntryCounts(){
        return entryCounts;
    }
    public void setEntryCounts(Vector entryCounts){
        this.entryCounts=entryCounts;
    }
    public Vector getComponentTypes()
    {
        return componentTypes;
    }
    public void setComponentTypes(Vector componentTypes)
    {
        this.componentTypes=componentTypes;
    }
    
    public String getAssignMode(){
        return assignMode;
    }
    public void setAssignMode(String mode){
        this.assignMode=mode;
    }

    //add by maojb on 5.22
    public String getUserSystemCode()
    {
        return userSystemCode;
    }
    public void setUserSystemCode(String userSystemCode)
    {
        this.userSystemCode = userSystemCode;
    }
}
