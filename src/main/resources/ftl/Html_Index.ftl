<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
<head>
    <title>${desc}</title>
    <meta th:replace="tpl_boss::head"/>
</head>
<body>
<#-- 获取首字母大写 -->
<#assign firstChar = className[0]?lower_case>
<#assign restOfString = className[1..]?default("")>
<#-- 拼接首字母大写和剩余的字符串 -->
<#assign lowerClassName = firstChar + restOfString>
<div class="layui-fluid">
    <div class="layui-card">
        <fieldset class="layui-elem-field">
            <div class="layui-field-box">
                <form class="layui-form" action="">

<#list columnList as column>
    <#if column.isSearch>
        <#if column.isSelect>
                    <div class="layui-input-inline">
                        <label class="layui-form-label">${column.desc}</label>
                        <div class="layui-input-block">
                            <div id="xm_${column.code}" class="xm-select-demo"></div>
                        </div>
                    </div>
        <#elseif column.javaType == "String">
                    <div class="layui-input-inline">
                        <label class="layui-form-label">${column.desc}</label>
                        <div class="layui-input-inline">
                            <input type="text" id="${column.code}" name="${column.code}" placeholder="请输入${column.desc}" autocomplete="off"
                                   class="layui-input"/>
                        </div>
                    </div>
        <#elseif column.javaType == "Date">
                    <div class="layui-input-inline">
                        <label class="layui-form-label" style="width:15%">${column.desc}</label>
                        <div class="layui-input-inline" style="width:80%">
                            <input type="text" id="${column.code}" name="${column.code}" autocomplete="off" lay-verify="required" placeholder="请选择${column.desc}" class="layui-input">
                        </div>
                    </div>
        </#if>

    </#if>
</#list>
                    <div class="sftadmin-btn-group layui-inline">
                        <a href="javascript:" class="layui-btn layui-btn-sm" id="search">
                            <i class="layui-icon">&#xe615;</i> 查询
                        </a>
                        <a href="javascript:" class="layui-btn layui-btn-sm" id="clear">
                            <i class="layui-icon">&#xe64d;</i> 重置
                        </a>
<#list functionList as function>
    <#if function.code == "add">
                        <a href="javascript:" class="layui-btn layui-btn-sm" id="${function.code}">
                            <i class="layui-icon">&#xe624;</i> ${function.desc}
                        </a>
    <#elseif function.code == "import">
                        <a href="javascript:;" class="layui-btn layui-btn-sm" id="${function.code}">
                            <i class="layui-icon">&#xe629;</i> ${function.desc}
                        </a>
    <#elseif function.code == "export">
                        <a href="javascript:;" class="layui-btn layui-btn-sm" id="${function.code}">
                            <i class="layui-icon">&#xe62f;</i> ${function.desc}
                        </a>
    <#elseif function.code == "download">
                        <a class="layui-btn layui-btn-sm layui-btn-warm" href="/pub/xls/${template}">
                            <i class="layui-icon">&#xe601;</i> ${function.desc}
                        </a>
    </#if>
</#list>
                    </div>
                </form>
            </div>
        </fieldset>
    </div>
    <div class="layui-card-body">
        <div class="layui-field-box">
            <table id="mytable" class="layui-hide" lay-filter="table"></table>
        </div>
    </div>
</div>
<script type="text/html" id="barOperate">
    <div class="sftadmin-btn-group">
<#list functionList as function>
    <#if function.code == "edit">
        <a class="layui-btn layui-btn-xs" lay-event="${function.code}">${function.desc}</a>
    <#elseif function.code == "other">
        <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="${function.code}">${function.desc}</a>
    <#elseif function.code == "delete">
        <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="${function.code}">${function.desc}</a>
    </#if>
</#list>
    </div>
</script>
<script th:src="@{/sftadmin/plugins/xm-select.js}" type="text/javascript" charset="utf-8"></script>
<script th:src="@{/sftadmin/plugins/layui/extend/formSelects-v4.js}" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript" th:src="@{/sftadmin/js/const/dict.js}"></script>
<script type="text/javascript" th:src="@{/sftadmin/biz/${lowerClassName}/index.js}"></script>
</body>
</html>