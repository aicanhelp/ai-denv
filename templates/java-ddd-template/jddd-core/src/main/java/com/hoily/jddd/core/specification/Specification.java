package com.hoily.jddd.core.specification;

/**
 * An implementation of Specification-Pattern
 *
 * @author vyckey
 * 2022/11/16 11:57
 */
@FunctionalInterface
public interface Specification<T> {

    /**
     * Check if {@code t} is satisfied by the specification.
     *
     * @param t Object to test.
     * @return {@code true} if {@code t} satisfies the specification.
     */
    boolean isSatisfiedBy(T t);

    /**
     * Check if {@code t} is satisfied by the specification.
     *
     * @param t Object to test.
     * @throws SpecificationUnSatisfiedException if {@code t} not satisfies the specification.
     */
    default void assertSatisfiedBy(T t) throws SpecificationUnSatisfiedException {
        if (!isSatisfiedBy(t)) {
            throw new SpecificationUnSatisfiedException();
        }
    }

    /**
     * Create a new specification that is the AND operation of {@code this} specification and another specification.
     *
     * @param specification Specification to AND.
     * @return A new specification.
     */
    default Specification<T> and(Specification<T> specification) {
        return t -> isSatisfiedBy(t) && specification.isSatisfiedBy(t);
    }

    /**
     * Create a new specification that is the OR operation of {@code this} specification and another specification.
     *
     * @param specification Specification to OR.
     * @return A new specification.
     */
    default Specification<T> or(Specification<T> specification) {
        return t -> isSatisfiedBy(t) || specification.isSatisfiedBy(t);
    }

    /**
     * Create a new specification that is the NOT operation of {@code this} specification.
     *
     * @return A new specification.
     */
    default Specification<T> not() {
        return t -> !isSatisfiedBy(t);
    }

    static <T> Specification<T> any() {
        return t -> true;
    }

    static <T> Specification<T> none() {
        return t -> false;
    }
}
