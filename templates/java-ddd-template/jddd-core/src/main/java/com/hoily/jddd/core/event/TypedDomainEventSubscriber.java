package com.hoily.jddd.core.event;

/**
 * A {@link DomainEventSubscriber} Implementation
 *
 * @author vyckey
 * 2022/6/24 13:07
 */
public abstract class TypedDomainEventSubscriber<E extends DomainEvent> implements DomainEventSubscriber {
    protected final Class<E> subscribedType;

    public TypedDomainEventSubscriber(Class<E> subscribedType) {
        this.subscribedType = subscribedType;
    }

    @Override
    public final boolean subscribedToEvent(DomainEvent domainEvent) {
        return subscribedType.equals(domainEvent.getClass()) || subscribedType.equals(DomainEvent.class);
    }

    @SuppressWarnings("unchecked")
    @Override
    public final void handleEvent(DomainEvent domainEvent) {
        onEvent((E) domainEvent);
    }

    public abstract void onEvent(E domainEvent);
}
