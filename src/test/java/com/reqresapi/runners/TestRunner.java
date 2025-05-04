package com.reqresapi.runners;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import com.intuit.karate.junit5.Karate;
import org.junit.jupiter.api.Test;
import net.masterthought.cucumber.Configuration;
import net.masterthought.cucumber.ReportBuilder;
import org.apache.commons.io.FileUtils;
import org.junit.jupiter.api.Assertions;

import java.io.File;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

class TestRunner {

    @Test
    void testParallel() {
        Results results = Runner.path("classpath:com/reqresapi/features")
                .outputCucumberJson(true)
                .parallel(5);
        generateReport(results.getReportDir());
        Assertions.assertEquals(0, results.getFailCount(),
                "Hay fallos en las pruebas. Consulta el informe para más detalles.");
    }

    @Karate.Test
    Karate testAll() {
        return Karate.run("classpath:com/reqresapi/features");
    }

    private static void generateReport(String karateOutputPath) {
        Collection<File> jsonFiles = FileUtils.listFiles(new File(karateOutputPath), new String[]{"json"}, true);
        List<String> jsonPaths = new ArrayList<>(jsonFiles.size());
        jsonFiles.forEach(file -> jsonPaths.add(file.getAbsolutePath()));

        Configuration config = new Configuration(new File("target"), "reqres-api-testing");
        config.addClassifications("Environment", "QA");
        config.addClassifications("Platform", "API");
        config.addClassifications("API", "ReqRes");
        config.addClassifications("Version", "1.0");

        ReportBuilder reportBuilder = new ReportBuilder(jsonPaths, config);
        reportBuilder.generateReports();
    }
}
