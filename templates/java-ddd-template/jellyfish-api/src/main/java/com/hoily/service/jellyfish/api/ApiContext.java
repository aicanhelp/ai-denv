package com.hoily.service.jellyfish.api;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.hoily.service.jellyfish.application.ApplicationContext;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.WebApplicationType;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.embedded.tomcat.TomcatServletWebServerFactory;
import org.springframework.boot.web.server.WebServerFactoryCustomizer;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.context.annotation.Import;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.web.servlet.mvc.method.annotation.ExceptionHandlerExceptionResolver;

import java.util.concurrent.TimeUnit;

@Slf4j
@EnableAsync
@SpringBootApplication
@EnableAspectJAutoProxy(proxyTargetClass = true)
@Import(ApplicationContext.class)
public class ApiContext {

    @Value("${jellyfish-api.server.port}")
    private int serverPort;

    public static void main(String[] args) {
        SpringApplication application = new SpringApplication(ApiContext.class);
        application.setWebApplicationType(WebApplicationType.SERVLET);
        application.setRegisterShutdownHook(false);
        ConfigurableApplicationContext ctx = application.run(args);
        Runtime.getRuntime().addShutdownHook(new Thread(() -> {
            try {
                // gracefully shutdown
                TimeUnit.MILLISECONDS.sleep(10000L);
            } catch (InterruptedException e) {
                log.error("gracefully shutdown ex", e);
                Thread.currentThread().interrupt();
            }
            ctx.close();
        }));
    }


    @Bean
    public ObjectMapper objectMapper() {
        return new ObjectMapper()
                .disable(SerializationFeature.FAIL_ON_EMPTY_BEANS)
                .configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
    }

    @Bean
    public ExceptionHandlerExceptionResolver exceptionHandlerExceptionResolver() {
        return new ExceptionHandlerExceptionResolver();
    }

    @Bean
    public WebServerFactoryCustomizer customizer(/*ServletRegistrationBean servletRegistrationBean*/) {
        return factory -> {
//            servletRegistrationBean.setLoadOnStartup(1);
            if (factory instanceof TomcatServletWebServerFactory) {
                TomcatServletWebServerFactory tomcatFactory = (TomcatServletWebServerFactory) factory;
                tomcatFactory.addConnectorCustomizers(connector -> {
                    connector.setPort(serverPort);
                });
            }
        };
    }
}
