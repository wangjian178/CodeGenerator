package com.wj.model;

import com.wj.FunctionEnum;
import lombok.Data;
import lombok.experimental.Accessors;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @author wj
 * @version 1.0
 * @Desc 表格
 * @date 2024/6/26 10:43
 */
@Data
@Accessors(chain = true)
public class TableModel {

    /**
     * 前缀
     */
    private String prefix = "t_";

    /**
     * 表名
     */
    private String tableName;

    /**
     * 类名
     */
    private String className;

    /**
     * 描述
     */
    private String desc;

    /**
     * 字段
     */
    private List<ColumnModel> columnList = new ArrayList<>();

    /**
     * 功能
     */
    private List<FunctionEnum> functionList = new ArrayList<>();

    /**
     * 默认全都有
     */
    public TableModel setDefaultFunction() {
        this.functionList = Arrays.stream(FunctionEnum.values()).collect(Collectors.toList());
        return this;
    }

    /**
     * 驼峰转_
     * 设置表名
     */
    public TableModel setTableName() {
        char[] chars = this.className.toCharArray();
        String tableName = this.prefix;
        for (int i = 0; i < chars.length; i++) {
            char c = chars[i];
            tableName += i == 0 ? Character.toLowerCase(c) : Character.isUpperCase(c) ? "_" + Character.toLowerCase(c) : c;
        }
        this.tableName = tableName;
        return this;
    }

    /**
     * 首字母大写
     * 设置类名
     */
    public TableModel updateClassName() {
        this.className = Character.toUpperCase(this.className.charAt(0)) + this.className.substring(1);
        return this;
    }

}
