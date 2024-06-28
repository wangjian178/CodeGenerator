package com.wj.model;

import lombok.Data;
import lombok.experimental.Accessors;

/**
 * @author wj
 * @version 1.0
 * @Desc 字典
 * @date 2024/6/28 14:52
 */
@Data
@Accessors(chain = true)
public class Dict {

    private String name;

    private String value;
}
