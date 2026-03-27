package com.hoily.jddd.core.event;

import java.util.ArrayList;
import java.util.List;

/**
 * {@link DomainEvent} Publisher
 *
 * @author vyckey
 * 2022/6/24 12:45
 */
public class DomainEventPublisher {
    private static final ThreadLocal<List<DomainEventSubscriber>> subscribers = new ThreadLocal<>();
    private static final ThreadLocal<Boolean> publishing = new ThreadLocal<>();

    protected DomainEventPublisher() {
    }

    public static DomainEventPublisher instance() {
        return new DomainEventPublisher();
    }

    public <E extends DomainEvent> void publish(E domainEvent) {
        if (Boolean.TRUE.equals(publishing.get())) {
            return;
        }
        try {
            publishing.set(true);
            List<DomainEventSubscriber> subscribers = DomainEventPublisher.subscribers.get();
            if (subscribers !=null) {
                for (DomainEventSubscriber subscriber : subscribers) {
                    if (subscriber.subscribedToEvent(domainEvent)) {
                        subscriber.handleEvent(domainEvent);
                    }
                }
            }
        } finally {
            publishing.set(false);
        }
    }

    public <E extends DomainEvent> void subscribe(DomainEventSubscriber subscriber) {
        if (Boolean.TRUE.equals(publishing.get())) {
            return;
        }
        List<DomainEventSubscriber> subscribers = DomainEventPublisher.subscribers.get();
        if (subscribers == null) {
            subscribers = new ArrayList<>();
            DomainEventPublisher.subscribers.set(subscribers);
        }
        subscribers.add(subscriber);
    }

    public void resetSubscribers() {
        DomainEventPublisher.subscribers.remove();
    }
}
