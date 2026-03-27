package com.hoily.jddd.core.annotation;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Identifies a value object. Domain concepts that are modeled as value objects have no conceptual identity or
 * lifecycle. Implementations should be immutable, operations on it are side-effect free.
 *
 * @author vyckey
 */
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.TYPE)
@Documented
public @interface ValueObject {

}
