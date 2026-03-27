package com.hoily.service.domain.model.event;

import com.google.common.collect.Lists;
import com.hoily.jddd.core.event.DomainEvent;
import com.hoily.jddd.core.event.DomainEventPublisher;
import com.hoily.jddd.core.event.DomainEventSubscriber;
import org.junit.Assert;
import org.junit.Test;

import java.util.Date;
import java.util.List;

/**
 * description is here
 *
 * @author vyckey
 * 2022/6/24 13:23
 */
public class DomainEventPublisherTest {
    @Test
    public void publishTest() {
        List<TestEvent> receiveEvents = Lists.newArrayList();
        DomainEventPublisher.instance().subscribe(DomainEventSubscriber.create(TestEvent.class, receiveEvents::add));
        DomainEventPublisher.instance().publish(new TestEvent());
        Assert.assertEquals(1, receiveEvents.size());
    }

    static class TestEvent implements DomainEvent {
        @Override
        public Date occurredOn() {
            return new Date();
        }
    }
}