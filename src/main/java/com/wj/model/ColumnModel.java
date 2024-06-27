package com.wj.model;

import lombok.Data;
import lombok.experimental.Accessors;

/**
 * @author wj
 * @version 1.0
 * @Desc 列
 * @date 2024/6/26 10:44
 */
@Data
@Accessors(chain = true)
public class ColumnModel {

    /**
     * 字段名
     */
    private String code;

    /**
     * 描述
     */
    private String desc;

    /**
     * 类型
     */
    private String javaType;

    /**
     * 注解
     */
    private String annotation;

    /**
     * 是否新增字段
     */
    private Boolean isAdd = true;

    /**
     * 是否修改字段
     */
    private Boolean isUpdate = false;

    /**
     * 是否搜索条件
     */
    private Boolean isSearch = false;

    /**
     * 是否上传
     */
    private Boolean isUpload = false;

    /**
     * 是否下拉
     */
    private Boolean isSelect = false;
}
