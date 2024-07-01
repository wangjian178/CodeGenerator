

import com.sft360.ssc.lcxxh.biz.sys.model.Company;
import com.sft360.ssc.lcxxh.biz.sys.service.SysUserService;
import com.sft360.ssc.lcxxh.framework.config.ConstantConfig;
import com.sft360.ssc.lcxxh.framework.service.BaseServiceImpl;
import com.sft360.ssc.lcxxh.framework.spec.MySpecification;
import com.sft360.ssc.lcxxh.framework.spec.Restrictions;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.List;
import java.util.stream.Collectors;

/**
* @author wj
* @version 1.0
* @Desc ${desc}
*/
@Service
public class ${className}ServiceImpl extends BaseServiceImpl<${className}> implements ${className}Service {

    @Resource
    private SysUserService sysUserService;

    @Resource
    private ${className}Service contProjectService;


    @Override
    public Page<${className}> listPage(${className} queryDto, Pageable pageable) {
        Company company = sysUserService.currentUser().getCompany();

        MySpecification<${className}> spec = new MySpecification<>();
        spec.add(Restrictions.eq("company.id", company.getId()));
        <#list columnList as column>
        <#-- 假设 column.code 总是以小写字母开头 -->
        <#-- 获取首字母大写 -->
            <#assign firstChar = column.code[0]?upper_case>
            <#assign restOfString = column.code[1..]?default("")>
        <#-- 拼接首字母大写和剩余的字符串 -->
            <#assign capitalizedCode = firstChar + restOfString>

            <#if column.isSearch && column.javaType == "String">
        if (StringUtils.isNotEmpty(queryDto.get${capitalizedCode}())) {
            spec.add(Restrictions.like("${column.code}", queryDto.get${capitalizedCode}()));
        }
            <#elseif column.isSearch>
        if (queryDto.get${capitalizedCode}()!=null) {
            spec.add(Restrictions.eq("${column.code}", queryDto.get${capitalizedCode}()));
        }
            </#if>
        </#list>
        //排序
        Sort sort = new Sort(Sort.Direction.DESC, "id");
        return findPage(spec, pageable, sort);
    }

    @Override
    public List<${className}> list(${className} queryDto) {
        Company company = sysUserService.currentUser().getCompany();

        MySpecification<${className}> spec = new MySpecification<>();
        spec.add(Restrictions.eq("company.id", company.getId()));
        <#list columnList as column>
        <#-- 假设 column.code 总是以小写字母开头 -->
        <#-- 获取首字母大写 -->
            <#assign firstChar = column.code[0]?upper_case>
            <#assign restOfString = column.code[1..]?default("")>
        <#-- 拼接首字母大写和剩余的字符串 -->
            <#assign capitalizedCode = firstChar + restOfString>

            <#if column.isSearch && column.javaType == "String">
        if (StringUtils.isNotEmpty(queryDto.get${capitalizedCode}())) {
            spec.add(Restrictions.like("${column.code}", queryDto.get${capitalizedCode}()));
        }
            <#elseif column.isSearch>
        if (queryDto.get${capitalizedCode}()!=null) {
            spec.add(Restrictions.eq("${column.code}", queryDto.get${capitalizedCode}()));
        }
            </#if>
        </#list>
        //排序
        Sort sort = new Sort(Sort.Direction.DESC, "id");
        return findAll(spec, sort);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public ${className} addOrUpdate(${className} form) {

    ${className} saveData = form.getId() == null ? new ${className}() : findById(form.getId());

        if (form.getId() == null) {
            BeanUtils.copyProperties(form,saveData);
            //公司
            Company company = sysUserService.currentUser().getCompany();
            saveData.setCompany(company);
        } else {
        <#list columnList as column>
        <#-- 假设 column.code 总是以小写字母开头 -->
        <#-- 获取首字母大写 -->
            <#assign firstChar = column.code[0]?upper_case>
            <#assign restOfString = column.code[1..]?default("")>
        <#-- 拼接首字母大写和剩余的字符串 -->
            <#assign capitalizedCode = firstChar + restOfString>
            <#if column.isUpdate>
            saveData.set${capitalizedCode}(form.get${capitalizedCode}());
            </#if>
        </#list>
        }

        save(saveData);

        return saveData;
    }

    @Override
    public void addBatch(List<${className}> data) {
        //公司
        Company company = sysUserService.currentUser().getCompany();
        data.forEach(x->x.setCompany(company));
        saveAll(data);
    }

    @Override
    public void delete(Long id) {
        //删除
        del(id);
    }

    @Override
    public void export(${className} queryDto, HttpServletResponse response) {
        SysUser sysUser = sysUserService.findById(SystemContext.currentBossUser().getId());
        String titles[] = new String[] {
<#assign index = 0>
<#list columnList as column>
    <#if column.isExport>
            "${column.desc}"<#if index < columnList?size - 1>,</#if>
    </#if>
    <#assign index = index+1>
</#list>
        };

        // 查询数据
        List<${className}> list = list(queryDto);

        List<String[]> values = list.stream().map(x->{
            return new String[]{
<#assign index = 0>
<#list columnList as column>
<#-- 假设 column.code 总是以小写字母开头 -->
<#-- 获取首字母大写 -->
    <#assign firstChar = column.code[0]?upper_case>
    <#assign restOfString = column.code[1..]?default("")>
<#-- 拼接首字母大写和剩余的字符串 -->
    <#assign upperColumnCode = firstChar + restOfString>
    <#if column.isExport>
        <#if column.javaType == "Date">
                DateTimeUtils.SimpleDate2String(t.get${upperColumnCode}())<#if index < columnList?size - 1>,</#if>
        <#else>
                t.get${upperColumnCode}()<#if index < columnList?size - 1>,</#if>
        </#if>
    </#if>
    <#assign index = index+1>
</#list>
            };
        }).collect(Collectors.toList());

        // 设置编码
        response.setCharacterEncoding("UTF-8");
        response.setContentType("Application/application/vnd.ms-excel");
        try {
            response.setHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode("${desc}.xls", "UTF-8"));
            ExcelUtils.createExcel(response.getOutputStream(), "${desc}", titles, values);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
