package com.hoily.service.jellyfish.application;

import com.hoily.service.jellyfish.infrastructure.InfrastructureContext;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;

@Slf4j
@Configuration
@ComponentScan("com.hoily.service.jellyfish.application")
@Import(InfrastructureContext.class)
public class ApplicationContext {
}
