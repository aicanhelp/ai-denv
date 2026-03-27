package com.hoily.jddd.core.types;

/**
 * Association
 *
 * @author vyckey
 */
public interface Association<T extends AggregateRoot<T, ID>, ID extends Identifier> extends Identifiable<ID> {
}
