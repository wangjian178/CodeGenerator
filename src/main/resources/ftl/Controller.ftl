
<#-- 获取首字母大写 -->
<#assign firstChar = className[0]?lower_case>
<#assign restOfString = className[1..]?default("")>
<#-- 拼接首字母大写和剩余的字符串 -->
<#assign lowerClassName = firstChar + restOfString>
import com.sft360.ssc.lcxxh.framework.controller.BaseController;
import com.sft360.ssc.lcxxh.framework.model.Result;
import com.sft360.ssc.lcxxh.framework.utils.ExcelUtils;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import java.io.IOException;
import java.util.List;

/**
* @author wj
* @version 1.0
* @Desc ${desc}
*/
@Controller
@RequestMapping("/sft/${lowerClassName}")
public class ${className}Controller extends BaseController {

    @Resource
    private ${className}Service ${lowerClassName}Service;

    /**
     * 跳转-项目信息页面
     */
    @GetMapping("/index")
    public ModelAndView index() {
        ModelAndView modelAndView = new ModelAndView("${lowerClassName}/index");
        return modelAndView;
    }

    /**
     * 跳转-添加页面
     */
    @GetMapping("/addPage")
    public ModelAndView addPage() {
        ModelAndView modelAndView = new ModelAndView("${lowerClassName}/add");
        return modelAndView;
    }

    /**
     * 跳转-编辑页面
     */
    @GetMapping("/editPage/{id}")
    public ModelAndView editPage(@PathVariable Long id) {
        ModelAndView modelAndView = new ModelAndView("${lowerClassName}/add");
        modelAndView.addObject("entry", ${lowerClassName}Service.findById(id));
        return modelAndView;
    }

    /**
     * 列表
     */
    @GetMapping("/list")
    @ResponseBody
    public Result<?> list(${className} queryDto, Pageable pageable) {
        return Result.getSucess(${lowerClassName}Service.listPage(queryDto, pageable));
    }

    /**
     * 添加或修改
     *
     */
    @GetMapping("/addOrUpdate")
    @ResponseBody
    public Result<?> addOrUpdate(${className} form) {
        ${lowerClassName}Service.addOrUpdate(form);
        return Result.SUCCESS;
    }

    /**
     * 删除
     *
     * @param id id
     */
    @GetMapping("/del/{id}")
    @ResponseBody
    public Result<String> delete(@PathVariable Long id) {
        ${lowerClassName}Service.delete(id);
        return Result.SUCCESS;
    }

    <#assign import = false>
    <#assign other = false>
    <#assign export = false>
    <#list functionList as function>
        <#if function.code == "import">
            <#assign import = true>
        <#elseif function.code == "other">
            <#assign other = true>
        <#elseif function.code == "export">
            <#assign export = true>
        </#if>
    </#list>

    <#if import>
     /**
     * 导入Excel
     *
     * @param file
     * @return
     */
    @PostMapping("/import")
    @ResponseBody
    public Result<?> importExcel(MultipartFile file) {
        try {
            List<${className}> data = ExcelUtils.obtainT("${className}", file.getInputStream());
            if (CollectionUtils.isEmpty(data)) {
                return Result.getFailure("上传数据为空");
            }
                ${lowerClassName}Service.addBatch(data);
        } catch (IOException e) {
            return Result.getFailure("上传失败");
        }
        return Result.SUCCESS;
    }
    </#if>
    <#if export>
    /**
     * 导出
     *
     * @param queryDto
     * @param response
     */
    @RequestMapping(method = RequestMethod.GET, value = "/export", produces = "application/json;charset=UTF-8")
    public void export(${className} queryDto, HttpServletResponse response) {
        ${lowerClassName}Service.export(queryDto, response);
    }
    </#if>
    <#if other>
    /**
     * 其他
     */
    @GetMapping("/other")
    @ResponseBody
    public Result<?> other() {
        return Result.SUCCESS;
    }
    </#if>
}