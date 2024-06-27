package com.wj;

import com.wj.model.ColumnModel;
import com.wj.model.TableModel;
import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;

import java.io.*;
import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/**
 * @author wj
 * @version 1.0
 * @Desc
 * @date 2024/6/26 10:24
 */
public class Generator {

    /**
     * 默认生成位置
     */
    private final static String DEFAULT_PATH = "D:\\codeGenerate";
    private final static String DEFAULT_FTL_PATH = "/ftl/";
    /**
     * xx要替换掉
     */
    private final static String BASE_PACKAGE = "com.sft360.ssc.lcxxh.biz.xx.model";

    /**
     * 文件类型
     */
    private final static String PATTERN_JAVA = ".java";
    private final static String PATTERN_HTML = ".html";
    private final static String PATTERN_JS = ".js";
    private final static String PATTERN_XML = ".xml";

    /**
     * 文件夹
     */
    private final static String DICTIONARY_MODEL = "model";
    private final static String DICTIONARY_REPOSITORY = "repository";
    private final static String DICTIONARY_SERVICE = "service";
    private final static String DICTIONARY_SERVICE_IMPL = "service" + File.separator + "impl";
    private final static String DICTIONARY_CONTROLLER = "controller";
    private final static String DICTIONARY_IMPORT_XML = "xml";

    //文件尾缀
    private final static String SUFFIX_DTO = "Dto";
    private final static String SUFFIX_REPOSITORY = "Repository";
    private final static String SUFFIX_SERVICE = "Service";
    private final static String SUFFIX_SERVICE_IMPL = "ServiceImpl";
    private final static String SUFFIX_CONTROLLER = "Controller";

    /**
     * 模板名称
     */
    private final static String FTL_MODEL = "Model.ftl";
    private final static String FTL_DTO = "entity_dto.ftl";
    private final static String FTL_REPOSITORY = "Repository.ftl";
    private final static String FTL_SERVICE = "Service.ftl";
    private final static String FTL_SERVICE_IMPL = "ServiceImpl.ftl";
    private final static String FTL_CONTROLLER = "Controller.ftl";
    private final static String FTL_IMPORT_XML = "ImportXml.ftl";

    /**
     * 解析数据
     *
     * @param tableModel
     * @return
     */
    public static Map<String, Object> getDataMap(TableModel tableModel) {
        Map<String, Object> dataMap = new HashMap<>();

        Field[] fields = TableModel.class.getDeclaredFields();
        for (Field field : fields) {
            field.setAccessible(true);
            try {
                dataMap.put(field.getName(), field.get(tableModel));
            } catch (IllegalAccessException e) {
                throw new RuntimeException(e);
            }
        }

        return dataMap;
    }

    /**
     * 写入文件
     *
     * @param dataMap  数据
     * @param dirPath  文件夹名称
     * @param fileName 文件名
     * @param ftlName  模板名
     */
    public static void writeFile(Map<String, Object> dataMap, String dirPath, String fileName, String ftlName) {
        Configuration configuration = new Configuration(Configuration.VERSION_2_3_23);
        try {
            //创建文件
            File dir = new File(DEFAULT_PATH + File.separator + dirPath);
            File file = new File(dir, fileName);
            if (!dir.exists()) {
                dir.mkdirs();
            }
            if (!file.exists()) {
                file.createNewFile();
            }
            //文件输出流
            BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file)));

            //查找模板
            ClassLoader classLoader = Generator.class.getClassLoader();
            configuration.setClassLoaderForTemplateLoading(classLoader, DEFAULT_FTL_PATH);
            Template template = configuration.getTemplate(ftlName);

            //写入文件
            template.process(dataMap, writer);

            writer.flush();
        } catch (IOException | TemplateException e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * 生成文件
     */
    public static void generate(TableModel tableModel, String path) {

        Map<String, Object> dataMap = getDataMap(tableModel);
        String fileNamePrefix = tableModel.getClassName();

        //1.生成实体
        writeFile(dataMap, DICTIONARY_MODEL, fileNamePrefix + PATTERN_JAVA, FTL_MODEL);

        //2.生成Repository
        writeFile(dataMap, DICTIONARY_REPOSITORY, fileNamePrefix + SUFFIX_REPOSITORY + PATTERN_JAVA, FTL_REPOSITORY);

        //3.生成Service
        writeFile(dataMap, DICTIONARY_SERVICE, fileNamePrefix + SUFFIX_SERVICE + PATTERN_JAVA, FTL_SERVICE);

        //4.生成ServiceImpl
        writeFile(dataMap, DICTIONARY_SERVICE_IMPL, fileNamePrefix + SUFFIX_SERVICE_IMPL + PATTERN_JAVA, FTL_SERVICE_IMPL);

        //5.生成Controller
        writeFile(dataMap, DICTIONARY_CONTROLLER, fileNamePrefix + SUFFIX_CONTROLLER + PATTERN_JAVA, FTL_CONTROLLER);
        if (tableModel.getFunctionList().contains(FunctionEnum.IMPORT)) {
            writeFile(dataMap, DICTIONARY_IMPORT_XML, fileNamePrefix + PATTERN_XML, FTL_IMPORT_XML);
        }

        //6.生成列表页 以及js 检索、重置、新增、导入等

        //7.生成新增修改页

        //8.生成导入页


    }


    public static void main(String[] args) {
        //todo 可以读取excel

        TableModel tableModel = new TableModel().setClassName("User").setDesc("用户").setColumnList(
                Stream.of(
                        new ColumnModel().setCode("company").setDesc("公司").setJavaType("Company").setAnnotation("@ManyToOne"),
                        new ColumnModel().setCode("name").setDesc("姓名").setJavaType("String").setIsSearch(true).setIsUpdate(true)
                ).collect(Collectors.toList())
        ).setDefaultFunction().setTableName().updateClassName();

        generate(tableModel, DEFAULT_PATH);


    }
}
