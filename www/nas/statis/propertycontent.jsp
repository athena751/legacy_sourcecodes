<!--
        Copyright (c) 2005 NEC Corporation

        NEC SOURCE CODE PROPRIETARY

        Use, duplication and disclosure subject to a source code
        license agreement with NEC Corporation.
-->

<!-- "@(#) $Id: propertycontent.jsp,v 1.1 2005/10/19 05:08:17 zhangj Exp $" -->

<th rowspan="2">
            <bean:message key="statis.properties.th_from"/>
        </th>
        <td align="center">
            <nested:radio property="fromTimeInfo.flag" value="absolute" onclick="enableFromAbs()"/>
        </td>
        <td>

            <nested:select property="fromTimeInfo.year"  size="1"  onchange="onChangeFromYear(document.forms[0].elements['optionInfo.fromTimeInfo.year'].options[selectedIndex].value)" >
                <html:optionsCollection name="yearSet" />
            </nested:select>/
            <nested:select property="fromTimeInfo.month"  size="1"  onchange="swapFromDaySet(document.forms[0].elements['optionInfo.fromTimeInfo.month'].options[selectedIndex].value)" >
                <html:optionsCollection name="monthSet" />
            </nested:select>/
            <nested:select property="fromTimeInfo.day" >
                <html:optionsCollection name="daySet" />
            </nested:select>
            <nested:select property="fromTimeInfo.hour" >
                <html:optionsCollection name="hourSet" />
            </nested:select>:
            <nested:select property="fromTimeInfo.minute" >
                <html:optionsCollection name="minuteSet" />
            </nested:select>:
            <nested:select property="fromTimeInfo.second" >
                <html:optionsCollection name="secondSet" />
            </nested:select>
        </td>
    </tr>
    
    <tr>
        <td align="center">
            <nested:radio property="fromTimeInfo.flag" value="relative" onclick="enableFromRelative()"/>
        </td>
        <td>
            <nested:select property="fromTimeInfo.time">
                <html:optionsCollection name="fromTimeSet" />
            </nested:select>
            
            <nested:select property="fromTimeInfo.timeUnit" onchange="fromTimeSelection();" size="1" >
                <html:option value="Hours">
                    <bean:message key="statis.properties.option.hours"/>
                </html:option>
                <html:option value="Days">
                    <bean:message key="statis.properties.option.days"/>
                </html:option>
                <html:option value="Weeks">
                    <bean:message key="statis.properties.option.weeks"/>
                </html:option>
                <logic:notEqual name="is4Survey" value="true">
	                <html:option value="Months">
	                    <bean:message key="statis.properties.option.months"/>
	                </html:option>
	                <html:option value="Years">
	                    <bean:message key="statis.properties.option.years"/>
	                </html:option>
	            </logic:notEqual>
            </nested:select>
            <bean:message key="statis.properties.ago"/>
        </td>
    </tr>
    
    <tr>
        <th rowspan="3">
            <bean:message key="statis.properties.th_to"/>
        </th>
        <td align="center">
            <nested:radio property="toTimeInfo.flag" value="absolute" onclick="enableToAbs();"/>
        </td>
        <td>
            <nested:select property="toTimeInfo.year" size="1" onchange="onChangeToYear(document.forms[0].elements['optionInfo.toTimeInfo.year'].options[selectedIndex].value)" >
                <html:optionsCollection name="yearSet" />
            </nested:select>/
            <nested:select property="toTimeInfo.month" size="1" onchange="swapToDaySet(document.forms[0].elements['optionInfo.toTimeInfo.month'].options[selectedIndex].value)" >
                <html:optionsCollection name="monthSet" />
            </nested:select>/
            <nested:select property="toTimeInfo.day" >
                <html:optionsCollection name="daySet" />
            </nested:select>
            <nested:select property="toTimeInfo.hour" >
                <html:optionsCollection name="hourSet" />
            </nested:select>:
            <nested:select property="toTimeInfo.minute" >
                <html:optionsCollection name="minuteSet" />
            </nested:select>:
            <nested:select property="toTimeInfo.second" >
                <html:optionsCollection name="secondSet" />
            </nested:select>
        </td>
    </tr>
    
    <tr>
        <td align="center">
            <nested:radio property="toTimeInfo.flag" value="relative" onclick="enableToRelative();"/>
        </td>
        <td>
            <nested:select property="toTimeInfo.time">
                <html:optionsCollection name="toTimeSet" />
            </nested:select>

            <nested:select property="toTimeInfo.timeUnit" onchange="toTimeSelection();" size="1">
                <html:option value="Hours">
                    <bean:message key="statis.properties.option.hours"/>
                </html:option>
                <html:option value="Days">
                    <bean:message key="statis.properties.option.days"/>
                </html:option>
                <html:option value="Weeks">
                    <bean:message key="statis.properties.option.weeks"/>
                </html:option>
                <logic:notEqual name="is4Survey" value="true">
	                <html:option value="Months">
	                    <bean:message key="statis.properties.option.months"/>
	                </html:option>
	                <html:option value="Years">
	                    <bean:message key="statis.properties.option.years"/>
	                </html:option>
	            </logic:notEqual>
            </nested:select>
            <bean:message key="statis.properties.ago"/>
        </td>
    </tr>
    
    <tr>
        <td align="center">
            <nested:radio property="toTimeInfo.flag" value="now" styleId="now" onclick="enableToNow();"/>
        </td>
        <td>
            <label for="now">
                <bean:message key="statis.properties.radio_now"/>
            </label>
        </td>
    </tr>