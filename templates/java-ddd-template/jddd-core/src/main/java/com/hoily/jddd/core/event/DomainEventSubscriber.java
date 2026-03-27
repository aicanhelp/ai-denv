package com.hoily.jddd.core.event;

import java.util.function.Consumer;

/**
 * {@link DomainEvent} Subscriber
 *
 * @author vyckey
 * 2022/6/24 12:49
 */
public interface DomainEventSubscriber {
    boolean subscribedToEvent(DomainEvent domainEvent);

    void handleEvent(DomainEvent domainEvent);

    static <E extends DomainEvent> DomainEventSubscriber create(Class<E> eventType, Consumer<E> handler) {
        return new TypedDomainEventSubscriber<E>(eventType) {
            @Override
            public void onEvent(E domainEvent) {
                handler.accept(domainEvent);
            }
        };
    }
}
