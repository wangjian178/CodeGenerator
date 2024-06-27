<?xml version="1.0" encoding="UTF-8"?>
<xls-config>
	<xlss>
		<!-- ${desc} -->
		<xls name="${className}" className="com.sft360.ssc.lcxxh.biz..model.${className}" type="Simple" indexRow="1">
		<#assign index = 0>
		<#list columnList as column>
			<column name="${column.code}"  		indexCol="${index}" 	type="${column.javaType}"/>
			<#assign index = index+1>
		</#list>
		</xls>
	</xlss>
</xls-config>