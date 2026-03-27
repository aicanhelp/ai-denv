package com.hoily.jddd.core.annotation;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Identifies a {@link Factory}. Factories encapsulate the responsibility of creating complex objects in general and
 * Aggregates in particular. Objects returned by the factory methods are guaranteed to be in valid state.
 *
 * @author vyckey
 * @see AggregateRoot
 */
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.TYPE)
@Documented
public @interface Factory {

}
