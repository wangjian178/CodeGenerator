package com.wj;

/**
 * @author wj
 * @version 1.0
 * @Desc
 * @date 2024/6/26 10:58
 */
public enum FunctionEnum {

    /**
     *
     */
    QUERY("query", "检索"),
    CLEAR("clear", "重置"),
    ADD("add", "添加"),
    EDIT("edit", "编辑"),
    DELETE("delete", "删除"),
    DOWNLOAD("download", "下载模板"),
    IMPORT("import", "导入"),
    EXPORT("export", "导出"),
    OTHER("other", "其他");

    private String code;

    private String name;

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    FunctionEnum(String code, String name) {
        this.code = code;
        this.name = name;
    }
}
