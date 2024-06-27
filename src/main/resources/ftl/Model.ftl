<#if classPath??>
    package ${classPath};
</#if>

import com.sft360.ssc.lcxxh.framework.model.BaseModel;

import javax.persistence.ManyToOne;
import javax.persistence.Entity;
import javax.persistence.Table;
<#list columnList as column>
    <#if column.javaType = "Date">
        import java.util.Date;
    </#if>
</#list>

/**
* @author wj
* @version 1.0
* @Desc ${desc}
*/
@Entity
@Table(name = "${tableName}")
public class ${className} extends BaseModel {

<#list columnList as column>
    /**
    * ${column.desc}
    */
    private ${column.javaType} ${column.code};
</#list>

<#list columnList as column>
    <#-- 假设 column.code 总是以小写字母开头 -->
    <#-- 获取首字母大写 -->
    <#assign firstChar = column.code[0]?upper_case>
    <#assign restOfString = column.code[1..]?default("")>
    <#-- 拼接首字母大写和剩余的字符串 -->
    <#assign capitalizedCode = firstChar + restOfString>

    <#if column.annotation??>
    ${column.annotation}
    </#if>
    public ${column.javaType} get${capitalizedCode?cap_first}() {
        return this.${column.code};
    }

    public void set${capitalizedCode?cap_first}(${column.javaType} ${column.code}) {
        this.${column.code} = ${column.code};
    }
</#list>

}