/*
 *      Copyright (c) 2001-2007 NEC Corporation
 *
 *      NEC SOURCE CODE PROPRIETARY
 *
 *      Use, duplication and disclosure subject to a source code
 *      license agreement with NEC Corporation.
 */

package com.nec.sydney.beans.taglib;

import com.nec.sydney.atom.admin.base.*;
import com.nec.sydney.framework.*;
import com.nec.sydney.net.soap.*;
import java.util.*; 

import java.lang.reflect.*;
import java.lang.*;
import java.beans.*;

public class ListSorter implements NasConstants,NSExceptionMsg{

    private static final String     cvsid = "@(#) $Id: ListSorter.java,v 1.2301 2007/04/26 05:45:20 liul Exp $";

    /**
     * the following method is used to sort the Vector's object according to the "fieldname" parameter.
     * the parameter "fieldname" must be the  member of the Vector's object, and there must be corresponding get method,
     * otherwise a exception will be throwed.
     * added by changhs,key 2002-8-21
    */
    public static void sortList(List toSortList, String fieldName , boolean reverse , String fieldType) throws Exception{
        if (!(toSortList.isEmpty())&&(fieldName != null)){
            ComparatorImpl mycomparator = new ComparatorImpl(fieldName,reverse,fieldType);
            Collections.sort(toSortList, mycomparator);         
        }
    }


    /**
     * the following method is used to sort the Vector's object, and the user must implement the  interface  Comparator
     *  himself, and pass a corresponding object as the parameter  selfDefineComparator;
     * added by changhs,key 2002-8-21
    */
    public static void sortList(List toSortList, Comparator selfDefineComparator, boolean reverse) throws Exception{
        if (selfDefineComparator == null){
            NSException ex = new NSException(NSMessageDriver.getInstance().getMessage("fcsan_common/exception/objectIsNull"));
            ex.setDetail(NSMessageDriver.getInstance().getMessage("fcsan_common/exception/objectIsNull"));
            ex.setReportLevel(NSReporter.ERROR);
            ex.setErrorCode(FCSAN_EXCEP_OBJECT_IS_NULL);
            NSReporter.getInstance().report(ex);
            throw ex;  
        }else{
            Collections.sort(toSortList , selfDefineComparator);        
            if (!reverse){ //descend
                Collections.reverse(toSortList);
            }
        }

    }
}


    /**
     * the following class implement the interface Comparator. this method Collections.sort() use it to
     * compare the Vector's objects, and sort the vectors' objects based on the result of comparation.
     * added by changhs,key 2002-8-21
    */
class ComparatorImpl implements Comparator {
    private String myFieldname;     //save the keyword which the sort is based on;
    private boolean myReverse;      //the sort is accending or verse;
    private String myFieldType;     //the type of fieldname;
    private String fieldMethodType;     
    ComparatorImpl(String fieldName , boolean reverse , String fieldType){
        myFieldname = fieldName;
        myReverse = reverse ;
        myFieldType = fieldType;
    }
    
     /**
     * the following method is used to wipe off "," in the string and return a Double value.
     */
    private Double myGetDoubleValue(String value){
        StringBuffer results = new StringBuffer();
        for (int i = 0; i < value.toString().length(); i++){
            char c = value.toString().charAt(i);
            if (c != ',') {
                results.append(String.valueOf(c));
            }
        }
        return Double.valueOf(results.toString());
    }
    
    /**
     * the following method is used to convert the value's type according to the parameter "type" , 
     * this is necessary because in Beans many type of classes' field are "String",but in fact their 
     * values denote  "double" or other types. 
     */
    private Object convertObj(Object value, String type){
        try {
            if (type.equals("Double")){
                return myGetDoubleValue(value.toString());
            }else if (type.equals("Float")){
                return Float.valueOf(value.toString());
            }else if (type.equals("Short")){
                return Short.valueOf(value.toString());
            }else if (type.equals("Long")){
                return Long.valueOf(value.toString());
            }else if (type.equals("Integer")){
                return Integer.valueOf(value.toString());
            }else if (type.equals("CapacityWithUnit")){
            	String capType,rawValue;
            	double doubleValue;
            	rawValue = value.toString().substring (0,value.toString().length() - 2);
            	doubleValue = myGetDoubleValue(rawValue.toString()).doubleValue();
            	capType = value.toString().substring(value.toString().length() - 2);
            	if (capType.equals("GB")){
            		return new Double(doubleValue * 1024 * 1024);
            	}else if (capType.equals("MB")){
            		return new Double(doubleValue * 1024);
            	}else if (capType.equals("KB")){
            		return new Double(doubleValue);
            	}else{
            		return new Double(doubleValue);
            	}
            }else{
                return value.toString();
            } 
        }catch (Exception e){
            if (type.equals("Double")){
                return new Double(-Double.MAX_VALUE);
            }else if (type.equals("Float")){
                return new Float(-Float.MAX_VALUE);
            }else if (type.equals("Short")){
                return new Short(Short.MIN_VALUE);
            }else if (type.equals("Long")){
                return new Long(Long.MIN_VALUE);
            }else if (type.equals("Integer")){
                return new Integer(Integer.MIN_VALUE);
            }else if (type.equals("CapacityWithUnit")){
            	return new Double(-Double.MAX_VALUE);
            }else{
                return value.toString();
            }
        }
    }
    
     /**
     * the following method is used to override the method compare
     * 
     * @return  1: comp_obj1 > comp_obj2
     *          0: comp_obj1 = comp_obj2             
     *         -1: comp_obj1 < comp_obj2
     */
    public int compare(Object comp_obj1,Object comp_obj2) throws ClassCastException {
        try{
            Object value1;
            Object value2;
            String fieldMethodType; 
            value1 = getObjValue(comp_obj1);
            value2 = getObjValue(comp_obj2); 
			
			if(value1 == null){
				return myReverse ? -1 : 1;
			}else if (value2 == null){
				return myReverse ? 1:-1;
			}
            fieldMethodType = value1.getClass().getName();
         
            /**
             * deal with the type of specified member varible ; Such as : String,BigDecimal,BigInteger,Float,Integer,Long,
             * Byte,Double,Short
             */
            if (fieldMethodType.equals("java.lang.BigDecimal")||
                fieldMethodType.equals("java.lang.BigInteger")||
                fieldMethodType.equals("java.lang.Float")||
                fieldMethodType.equals("java.lang.Integer")||
                fieldMethodType.equals("java.lang.Long")||
                fieldMethodType.equals("java.lang.Byte")||
                fieldMethodType.equals("java.lang.Double")||
                fieldMethodType.equals("java.lang.Short")){
                    
                return myReverse ? (((Comparable)value1).compareTo((Comparable)value2))
                                  :(((Comparable)value2).compareTo((Comparable)value1));
            }else if (fieldMethodType.equals("java.lang.Boolean")){
                if (value1.toString().compareTo(value2.toString()) == 0){
                        return 0;
                }else if (value1.toString().equals("true")) {
                        return myReverse ? 1 : -1;
                }else{
                        return myReverse ? -1 : 1;
                }   
            }else if (fieldMethodType.equals("java.lang.String")) {
                if (myFieldType == null){
                	return myReverse ? (((Comparable)value1).compareTo((Comparable)value2))
                                      :(((Comparable)value2).compareTo((Comparable)value1));
            	}else if (myFieldType.equals("String")){
                    return myReverse ? (((Comparable)value1).compareTo((Comparable)value2))
                                      :(((Comparable)value2).compareTo((Comparable)value1));
                }else if(myFieldType.equals("Float")||
                        myFieldType.equals("Integer")||
                        myFieldType.equals("Long")||
                        myFieldType.equals("Double")||
                        myFieldType.equals("Short")||
                        myFieldType.equals("CapacityWithUnit")){
                    int result = ((Comparable)convertObj(value1,myFieldType)).compareTo(convertObj(value2,myFieldType));
                    return myReverse ? result:( -result);                   
                }else if (myFieldType.equals("String:String")){
                    String [] compObj1 = ((String)value1).split(":");
                    String [] compObj2 = ((String)value2).split(":");
                    if (compObj1[0].equals(compObj2[0])){
                        int result = ((Comparable) (convertObj(compObj1[1], "Integer"))).compareTo((Comparable)(convertObj(compObj2[1],"Integer"))); 
                        return myReverse ? result : -result;
                    }else{
                        int result = ((Comparable) (convertObj(compObj1[0], "Integer"))).compareTo((Comparable)(convertObj(compObj2[0],"Integer"))); 
                        return myReverse ? result : -result; 
                    }    
                }else{    
                    ClassCastException invalidParaEexp = new ClassCastException("the field type is invalid!");
                    throw invalidParaEexp;
                }
            }else{ /* deal with the other type of specified member varible ; */
                    return myReverse ? (value1.toString().compareTo(value2.toString())):(value2.toString().compareTo(value1.toString()));
            }
        }catch (Exception e){
            ClassCastException newEexp = new ClassCastException(e.getMessage());
            throw newEexp;
        }
          
    }
     /**
     * the following method is used to get the value which is used in method compare ;
    */
    
    private Object getObjValue(Object comp_obj) throws Exception{ 
        Object value;
        Class myClass , classForMethod;
        Field myField;
        Method myMethod;
        PropertyDescriptor propDesc;

        myClass = comp_obj.getClass();
        myField = myClass.getDeclaredField(myFieldname);
           
        /* The specified member varible  do not existed. */
        if (myField == null){
            throw (new Exception("No the specified field"));
        }
            
        /* get the  member variable (public) */
        if (myField.getModifiers() == java.lang.reflect.Modifier.PUBLIC){
            value = myField.get((Object)comp_obj);
        }else{
            /* get the  member variable (public) */
            propDesc = new java.beans.PropertyDescriptor(myFieldname, myClass);
            myMethod = propDesc.getReadMethod();
                    
            /* The specified method (corresponding the specified member) do not existed. */
            if (myMethod == null){
                throw (new Exception("Can't access the specified field"));
            }
                                    
            /* invoke the specified  method  */
            value = myMethod.invoke(comp_obj, new Object[0]);
        }
        return value;
    }   

}