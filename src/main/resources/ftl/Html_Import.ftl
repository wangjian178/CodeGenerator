<html xmlns:th="http://www.thymeleaf.org">
<head>
    <title>${desc}导入</title>
    <meta th:replace="tpl_boss::head"/>
</head>
<body>
<#-- 获取首字母大写 -->
<#assign firstChar = className[0]?lower_case>
<#assign restOfString = className[1..]?default("")>
<#-- 拼接首字母大写和剩余的字符串 -->
<#assign lowerClassName = firstChar + restOfString>
<div class="layui-fluid">
    <form id="myform" class="layui-form layui-form-pane" action="/sft/${lowerClassName}/import" method="post"
        enctype="multipart/form-data" lay-filter="myform">
        <div class="layui-form-item">
            <label class="layui-form-label">附件</label>
            <div class="layui-input-inline">
                <input name="file"type="file"/>
            </div>
        </div>
        <div class="layui-form-item layui-hide">
            <div class="layui-input-block">
                <button id="form_submit"class="layui-btn"lay-submit lay-filter="form-submit">立即提交</button>
                <button id="form_reset"type="reset"class="layui-btn layui-btn-primary">重置</button>
            </div>
        </div>
    </form>
    <script type="text/javascript"th:src="@{/sftadmin/js/jquery.form.js}"></script>
    <script th:src="@{/sftadmin/plugins/xm-select.js}"type="text/javascript"charset="utf-8"></script>
    <script th:inline="javascript">

        layui.use(['form'],function(){
            let form=layui.form;

            //监听提交
            form.on('submit(form-submit)',function(data){
                let index=parent.layer.getFrameIndex(window.name);
                layer.load(2);
                $('#myform').ajaxSubmit({
                    type:$(this).attr('method'),
                    url: $(this).attr('action'),
                    data: $(this).serialize(),
                    dataType:'json',
                    success:function(data){
                        if(data.success){
                            //重载表格
                            parent.layui.table.reload('mytable');
                            //再执行关闭
                            parent.layer.close(index);
                        }else{
                            layer.msg(data.message);
                        }
                    },
                    error:function(data){
                        layer.msg(data.message);
                    }
                });
                return false;
            });

        });
    </script>
</div>
</body>
</html>