<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
<head>
    <title>${desc}添加</title>
    <meta th:replace="tpl_boss::head"/>
    <link rel="stylesheet" href="/sftadmin/plugins/layui/extend/formSelects-v4.css"/>
</head>
<#-- 获取首字母大写 -->
<#assign firstChar = className[0]?lower_case>
<#assign restOfString = className[1..]?default("")>
<#-- 拼接首字母大写和剩余的字符串 -->
<#assign lowerClassName = firstChar + restOfString>
<body>
<div class="layui-fluid">
    <form id="myform" class="layui-form layui-form-pane" lay-filter="myform">
        <input type="hidden" name="id">
<#list columnList as column>

<#if column.isSelect>
        <div class="layui-form-item">
            <label class="layui-form-label">${column.desc}</label>
            <div class="layui-input-block">
                <div id="xm_${column.code}" class="xm-select-demo"></div>
            </div>
        </div>
<#elseif column.isUpload>
        <div class="layui-form-item">
            <input type="hidden" name="${column.code}" id="${column.code}"/>
            <div class="layui-input-block" id="${column.code}Show"></div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" style="width:15%">${column.desc}</label>
            <div class="layui-input-inline">
                <button type="button" class="layui-btn" id="${column.code}Btn">
                    <i class="layui-icon">&#xe67c;</i>上传附件
                </button>
            </div>
        </div>
<#elseif column.javaType == "String">
        <div class="layui-form-item">
            <label class="layui-form-label" style="width:15%">${column.desc}</label>
            <div class="layui-input-inline" style="width:80%">
                <input type="text" name="${column.code}" autocomplete="off" lay-verify="required" placeholder="请输入${column.desc}" class="layui-input">
            </div>
        </div>
<#elseif column.javaType == "Date">
        <div class="layui-form-item">
            <label class="layui-form-label" style="width:15%">${column.desc}</label>
            <div class="layui-input-inline" style="width:80%">
                <input type="text" id="${column.code}" name="${column.code}" autocomplete="off" lay-verify="required" placeholder="请选择${column.desc}" class="layui-input">
            </div>
        </div>
</#if>
</#list>

        <div class="layui-form-item layui-hide">
            <div class="layui-input-block">
                <button id="form_submit" class="layui-btn" lay-submit lay-filter="form-submit">立即提交</button>
                <button id="form_reset" type="reset" class="layui-btn layui-btn-primary">重置</button>
            </div>
        </div>
    </form>
</div>
<script th:src="@{/sftadmin/plugins/xm-select.js}" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript" th:src="@{/sftadmin/js/const/dict.js}"></script>
<script th:inline="javascript">
<#assign entryStart = '[[$'>
<#assign entryEnd = '{entry}]]'>
    let entry = ${entryStart}${entryEnd};
    let form;

<#list columnList as column>
    <#if column.isSelect>
        <#assign entryItemStart = '[[$'>
        <#assign entryItemMiddle = 'entry?.'>
        <#assign entryItemEnd = '}]]'>
    let xm_${column.code};
    </#if>
</#list>

<#list columnList as column>
    <#if column.isSelect>
        let ${column.code} = ${entryItemStart}${entryItemMiddle}${column.code}${entryItemEnd};
    </#if>
</#list>

    layui.use(['form', 'element', 'upload', 'laydate'], function () {
        form = layui.form;
        let upload = layui.upload;
        let element = layui.element;
        let laydate = layui.laydate;

<#list columnList as column>
    <#if column.javaType == "Date">
        //${column.desc}
        laydate.render({elem:'#${column.code}',type:'datetime',trigger:'click'});
        if (entry && entry.${column.code}) {
            entry.${column.code} = new Date(entry.${column.code}).fmt('yyyy-MM-dd hh:mm:ss');
        }
    </#if>
</#list>

<#list columnList as column>
    <#if column.isUpload>
        //上传 ${column.desc}
        upload.render({
            //绑定元素
            elem: '#${column.code}Btn',
            field: 'file',
            accept: 'file',
            //上传接口
            url: '/sft/sys/file/add',
            done: function (res) {
                //上传完毕回调
                if (res.success) {
                    let fileNames = $("#${column.code}").val();
                    if (fileNames == null || fileNames.length == 0) {
                        fileNames = res.message;
                    } else {
                        fileNames = fileNames + ',' + res.message;
                    }
                    $("#${column.code}").val(fileNames);
                    showFiles(fileNames, "${column.code}Show", "${column.code}");
                }
            },
            error: function () {
                lay.msg('请求异常');
            }
        });
        if(entry && entry.${column.code}){
            showFiles(entry.${column.code},"${column.code}Show","${column.code}");
        }
    </#if>
</#list>

<#list columnList as column>
    <#if column.isSelect>
        //加载下拉框 ${column.desc}
        <#if column.selectUrl != null>
        let data_${column.code} = [];
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

        //监听提交
        form.on('submit(form-submit)', function (data) {
            let field = data.field;
            let index = parent.layer.getFrameIndex(window.name);
            $.ajax({
                type: 'POST',
                url: '/sft/${lowerClassName}/addOrUpdate',
                dataType: 'json',
                data: $('#myform').serialize(),
                success: function (data) {
                    if (data.success) {
                        //重载表格
                        parent.layui.table.reload('mytable');
                        //再执行关闭
                        parent.layer.close(index);
                    } else {
                        layer.msg(data.message);
                    }
                },
                error: function (data) {
                    layer.msg(data.message);
                }
            });
            return false;
        });

        //表单赋值
        form.val("myform", entry);
    })

    function showFiles(paths, showEle, valueEle) {
        var html = [];
        if (paths != null && paths != '') {
            let imgs = paths.split(',');
            $.each(imgs, function (index, path) {
                //获取最后一个.的位置
                var index = path.lastIndexOf(".");
                //获取后缀
                var str = path.substr(index + 1);
                if (str == 'pdf') {
                    html.push('<img src="/sftadmin/img2/PDF.png" width="200px" height="200px" alt="' + path + '" ondblclick="del(this,\'' + showEle + '\',\'' + valueEle + '\')"/>');
                } else if (str == 'doc' || str == 'docx') {
                    html.push('<img src="/sftadmin/img2/word.png" width="200px" height="200px" alt="' + path + '" ondblclick="del(this,\'' + showEle + '\',\'' + valueEle + '\')"/>');
                } else if (str == 'mp4') {
                    html.push('<img src="/sftadmin/img2/mp4.png" width="200px" height="200px" alt="' + path + '" ondblclick="del(this,\'' + showEle + '\',\'' + valueEle + '\')"/>');
                } else if (str == 'ppt') {
                    html.push('<img src="/sftadmin/img2/ppt.png" width="200px" height="200px" alt="' + path + '" ondblclick="del(this,\'' + showEle + '\',\'' + valueEle + '\')"/>');
                } else if (str == 'xls') {
                    html.push('<img src="/sftadmin/img2/excel.png" width="200px" height="200px" alt="' + path + '" ondblclick="del(this,\'' + showEle + ',' + valueEle + '\')"/>');
                } else if (str == 'jpg' || str == 'jpeg' || str == 'png') {
                    html.push('<img src="' + getImg(path) + '" width="200px" height="200px" alt="' + path + '" ondblclick="del(this,\'' + showEle + '\',\'' + valueEle + '\')"/>');
                } else {
                    html.push('<img src="/sftadmin/img2/file.png" width="200px" height="200px" alt="' + path + '" ondblclick="del(this,\'' + showEle + '\',\'' + valueEle + '\')"/>');
                }
            })
            form.render();
        } else {
            html.push('');
        }
        $("#" + showEle).html(html.join(''));
    };

    function del(img, showEle, valueEle) {
        //询问框
        layer.confirm('确认删除文件操作？', {
            btn: ['确认', '取消'] //按钮
        }, function () {
            var imgPath = getImgPath(img.alt);
            var imgs = $("#" + valueEle).val();
            var arrays = imgs.split(',');
            arrays.remove(imgPath);
            var newImgs = arrays.join(',');
            $("#" + valueEle).val(newImgs);
            showFiles(newImgs, showEle, valueEle);
            layer.close(layer.index);
        });
    };

</script>
</body>
</html>