package com.hoily.jddd.core.specification;

/**
 * {@link Specification} unsatisfied exception
 *
 * @author vyckey
 * 2022/11/16 11:58
 */
public class SpecificationUnSatisfiedException extends RuntimeException {
    public SpecificationUnSatisfiedException() {
    }

    public SpecificationUnSatisfiedException(String message) {
        super(message);
    }

    public SpecificationUnSatisfiedException(String message, Throwable cause) {
        super(message, cause);
    }
}
