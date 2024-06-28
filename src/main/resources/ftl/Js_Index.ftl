<#-- 获取首字母大写 -->
<#assign firstChar = className[0]?lower_case>
    <#assign restOfString = className[1..]?default("")>
<#-- 拼接首字母大写和剩余的字符串 -->
<#assign lowerClassName = firstChar + restOfString>
<#--下拉字典-->
<#list columnList as column>
    <#if column.isSearch && column.isSelect>
        <#assign entryItemStart = '[[$'>
        <#assign entryItemMiddle = 'entry?.'>
        <#assign entryItemEnd = '}]]'>
let xm_${column.code};
    </#if>
    <#if column.isSelect>
let data_${column.code} = [];
    </#if>
</#list>
let SFT_DEFAULT_INDEX = {
    // 初始化控件
    init: function () {

<#list columnList as column>
    <#if column.isSelect>
        //加载下拉框 ${column.desc}
        <#if column.selectUrl != null>
        $.ajax({
            type:'GET',
            url:'${column.url}',
            dataType:'json',
            async:false,
            success:function(data){
                if(data.success){
                    data_${column.code} = data.t
                }
            },
            error:function(data){
                layer.msg(data.message);
            }
        });
        <#else>
        let data_${column.code} = [
            <#list column.selectData as option>
            {
                name: "${option.name}",
                value: "${option.value}"
            },
            </#list>
        ];
        </#if>
        xm_${column.code}=xmSelect.render({
            el:'#xm_${column.code}',
            name:'${column.code}',
            filterable:true,
            autoRow:true,
            prop:{
                name:'name',
        <#if column.selectUrl != null>
                value:'id'
        <#else>
                value:'value'
        </#if>
            },
            //单选模式
            radio:true,
            //选中关闭
            clickClose:true,
            toolbar:{
            show:true,
                list:['CLEAR']
            },
            //树
            tree:{
                show:true,
                //非严格模式
                strict:true,
                //默认展开节点
                expandedKeys:[-1],
            },
            theme:{
                color:'#2957A5',
            },
            data:data_${column.code}
        });
    </#if>
</#list>

        layui.use(['table', 'form'], function () {
            let table = layui.table;
            let form = layui.form;

            //加载表格数据
            table.render({
                elem: '#mytable',
                page: true,
                url: '/sft/${lowerClassName}/list',
                request: {
                    pageName: 'page',
                    limitName: 'size'
                },
                where: {
<#list columnList as column>
    <#if column.isSearch>
        <#if column.isSelect>
                    ${column.code}: xm_${column.code}.getValue('valueStr'),
        <#else>
                    ${column.code}: $('#${column.code}').val(),
        </#if>
    </#if>
</#list>
                },
                parseData: function (res) {
                    return {
                        "code": res.success ? 0 : 500,
                        "msg": res.message,
                        "count": res.t.totalElements,
                        "data": res.t.content
                    };
                },
                cols: [[
                    {field: 'numbers', width: '4%', title: '序号', type: 'numbers'},
<#list columnList as column>
    <#if column.isSelect && column.selectData != null>
                    {
                        field: '', width: '5%', title: '${column.desc}', templet: function (d) {
                            for (let item of data_${column.code}) {
                                if (item.value == d.${column.code}) {
                                    return item.name;
                                }
                            }
                            return d.${column.code};
                        }
                    },
    <#elseif column.isUpload>
                    {
                        field: '', width: '5%', title: '${column.desc}', templet: function (d) {
                            return getFiles(d.${column.code});
                        }
                    },
    <#elseif column.javaType == "String">
                    {field: '${column.code}', width: '7%', title: '${column.desc}'},
    <#elseif column.javaType == "Date">
                    {
                        field: '', width: '5%', title: '${column.desc}', templet: function (d) {
                            return d.${column.code} ? new Date(d.${column.code}).fmt('yyyy-MM-dd hh:mm:ss') : "";
                        }
                    },
    </#if>
</#list>
                    {fixed: 'right', field: '', width: '6%', title: '操作', toolbar: '#barOperate'}
                ]]
            });

            //重置
            $('#clear').on('click', function () {
<#list columnList as column>
    <#if column.isSearch>
        <#if column.isSelect>
                xm_${column.code}.setValue([]);
        <#else>
                $('#${column.code}').val('');
        </#if>
    </#if>
</#list>
                form.render();
                SFT_DEFAULT_INDEX.reload(table);
            });

            //检索
            $('#search').on('click', function () {
                SFT_DEFAULT_INDEX.reload(table);
            });

<#list functionList as function>
    <#if function.code == "add">
            // 添加
            $('#${function.code}').on('click', function () {
                layer.open({
                    type: 2
                    , title: '${desc}添加'
                    , content: '/sft/${lowerClassName}/addPage'
                    , maxmin: true
                    , area: ['60%', '90%']
                    , btn: ['确定', '取消']
                    , yes: function (index, layero) {
                        let submit = layero.find('iframe').contents().find("#form_submit");
                        submit.click();
                    }
                });
            });
    </#if>
</#list>

            //监听行工具事件
            table.on('tool(table)', function (obj) {
                let data = obj.data;
<#list functionList as function>
    <#if function.code == "delete">
                if (obj.event === '${function.code}') {
                    layer.confirm('确认删除${desc}？', function (index) {
                        $.ajax({
                            type: 'GET',
                            url: '/sft/${lowerClassName}/del/' + data.id,
                            dataType: 'json',
                            success: function (data) {
                                if (data.success) {
                                    table.reload('mytable');
                                    layer.close(index);
                                    layer.msg("删除成功!");
                                } else {
                                    layer.msg(data.message);
                                }
                            },
                            error: function (data) {
                                layer.msg(data.message);
                            }
                        });
                    });
                }
    <#elseif function.code == "edit">
                if (obj.event === '${function.code}') {
                    layer.open({
                        type: 2,
                        title: '${desc}编辑',
                        content: '/sft/${lowerClassName}/addPage?id=' + data.id,
                        maxmin: true,
                        area: ['60%', '90%'],
                        btn: ['确定', '取消'],
                        yes: function (index, layero) {
                            let submit = layero.find('iframe').contents().find("#form_submit");
                            submit.click();
                        }
                    });
                }
    <#elseif function.code == "other">
                if (obj.event === '${function.code}') {
                    layer.open({
                        type: 2,
                        title: '${desc}${function.desc}',
                        content: '/sft/${lowerClassName}/other?id=' + data.id,
                        maxmin: true,
                        area: ['60%', '90%'],
                        btn: ['确定', '取消'],
                        yes: function (index, layero) {
                            let submit = layero.find('iframe').contents().find("#form_submit");
                            submit.click();
                        }
                    });
                }
    </#if>
</#list>
            });
        });
    },
    reload: function (table) {
        table.reload('mytable', {
            where: {
<#list columnList as column>
    <#if column.isSearch>
        <#if column.isSelect>
                ${column.code}: xm_${column.code}.getValue('valueStr'),
        <#else>
                ${column.code}: $('#${column.code}').val(),
        </#if>
    </#if>
</#list>
            },
            page: {
                //重新从第 1 页开始
                curr: 1
            }
        });
    }
}
$(function () {
    SFT_DEFAULT_INDEX.init();
    //进度条结束
    NProgress.done();
});