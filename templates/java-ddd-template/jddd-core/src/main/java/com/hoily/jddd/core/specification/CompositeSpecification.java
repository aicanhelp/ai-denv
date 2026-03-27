package com.hoily.jddd.core.specification;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * description is here
 *
 * @author vyckey
 * 2022/11/16 12:21
 */
public abstract class CompositeSpecification<T> implements Specification<T> {
    protected final List<Specification<T>> specifications;

    public CompositeSpecification(List<Specification<T>> specifications) {
        this.specifications = new ArrayList<>(specifications);
    }

    public CompositeSpecification(Specification<T>... specifications) {
        this(Arrays.asList(specifications));
    }

    public void addSpecification(Specification<T> specification) {
        this.specifications.add(specification);
    }

    @Override
    public abstract boolean isSatisfiedBy(T t);


    /**
     * Create a new specification that is the AND operation of all specifications.
     *
     * @param specifications Specifications to AND.
     * @return A new specification.
     */
    public static <T> CompositeSpecification<T> and(Specification<T>... specifications) {
        return new CompositeSpecification<T>(specifications) {
            @Override
            public boolean isSatisfiedBy(T t) {
                for (Specification<T> specification : this.specifications) {
                    if (!specification.isSatisfiedBy(t)) {
                        return false;
                    }
                }
                return true;
            }
        };
    }

    /**
     * Create a new specification that is the OR operation of all specifications.
     *
     * @param specifications Specifications to OR.
     * @return A new specification.
     */
    public static <T> CompositeSpecification<T> or(Specification<T>... specifications) {
        return new CompositeSpecification<T>(specifications) {
            @Override
            public boolean isSatisfiedBy(T t) {
                for (Specification<T> specification : this.specifications) {
                    if (specification.isSatisfiedBy(t)) {
                        return true;
                    }
                }
                return false;
            }
        };
    }
}
