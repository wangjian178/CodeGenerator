

import com.sft360.ssc.lcxxh.framework.service.BaseService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;

/**
* @author wj
* @version 1.0
* @Desc ${desc}
*/
public interface ${className}Service extends BaseService<${className}> {

    Page<${className}> listPage(${className} queryDto, Pageable pageable);

    List<${className}> list(${className} queryDto);

    ${className} addOrUpdate(${className} form);

    void addBatch(List<${className}> data);

    void delete(Long id);

}