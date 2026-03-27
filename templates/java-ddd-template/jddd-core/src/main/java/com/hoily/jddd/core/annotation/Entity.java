package com.hoily.jddd.core.annotation;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Identifies an {@link Entity}. Entities represent a thread of continuity and identity, going through a lifecycle,
 * though their attributes may change. Means of identification may come from the outside, or it may be an arbitrary
 * identifier created by and for the system, but it must correspond to the identity distinctions in the model. The model
 * must define what it means to be the same thing.
 *
 * @author vyckey
 */
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.TYPE)
@Documented
public @interface Entity {

}
