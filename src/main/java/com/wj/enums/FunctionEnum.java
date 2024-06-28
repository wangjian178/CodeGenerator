package com.wj.enums;

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

    private String desc;

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getDesc() {
        return desc;
    }

    public void setDesc(String desc) {
        this.desc = desc;
    }

    FunctionEnum(String code, String desc) {
        this.code = code;
        this.desc = desc;
    }
}
