package com.ync365.oa.service.performanceevaluation;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;

import com.ync365.oa.entity.PerformanceEvaluation;
import com.ync365.oa.query.PerformanceEvaluationQuery;
import com.ync365.oa.repository.BaseTest;

public class PerformanceEvaluationServiceTest extends BaseTest {
    @Autowired
    private PerformanceEvaluationService performanceEvaluationService;

    @Test
    public void test() {
        PerformanceEvaluationQuery q = new PerformanceEvaluationQuery();
//        q.setPageIndex(0);
//        q.setPageSize(10);
//        q.setSort("createTime");
//        q.setId(2l);
        Page<PerformanceEvaluation> pages = performanceEvaluationService.find(q);

        System.out.println("getTotalElements >>>> " + pages.getTotalElements());
        for (PerformanceEvaluation performanceEvaluation : pages) {
            System.out.println("id >>>> " + performanceEvaluation.getId());
        }
    }

}
