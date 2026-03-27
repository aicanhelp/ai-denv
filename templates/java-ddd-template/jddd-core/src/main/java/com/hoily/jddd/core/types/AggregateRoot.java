package com.hoily.jddd.core.types;

/**
 * Identifies an aggregate root, i.e. the root entity of an aggregate. An aggregate forms a cluster of consistent rules
 * usually formed around a set of entities by defining invariants based on the properties of the aggregate that have to
 * be met before and after operations on it. Aggregates usually refer to other aggregates by their identifier.
 * References to aggregate internals should be avoided and at least not considered strongly consistent (i.e. a reference
 * held could possibly have been gone or become invalid at any point in time). They also act as scope of consistency,
 * i.e. changes on a single aggregate are expected to be strongly consistent while changes across multiple ones should
 * only expect eventual consistency.
 *
 * @author vyckey
 */
public interface AggregateRoot<T extends AggregateRoot<T, ID>, ID extends Identifier> extends Entity<T, ID> {
}
