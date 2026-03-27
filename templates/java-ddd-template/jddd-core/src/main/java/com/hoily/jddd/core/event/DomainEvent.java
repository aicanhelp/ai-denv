package com.hoily.jddd.core.event;

import java.util.Date;

/**
 * Domain Event Interface
 *
 * @author vyckey
 * 2022/6/24 12:45
 */
public interface DomainEvent {
    Date occurredOn();
}
