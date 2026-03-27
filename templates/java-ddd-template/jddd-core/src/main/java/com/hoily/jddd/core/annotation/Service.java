package com.hoily.jddd.core.annotation;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Identifies a domain {@link Service}. A service is a significant process or transformation in the domain that is not a
 * natural responsibility of an entity or value object, add an operation to the model as a standalone interface declared
 * as a service. Define a service contract, a set of assertions about interactions with the service. (See assertions.)
 * State these assertions in the ubiquitous language of a specific bounded context. Give the service a name, which also
 * becomes part of the ubiquitous language.
 *
 * @author vyckey
 */
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.TYPE)
@Documented
public @interface Service {

}