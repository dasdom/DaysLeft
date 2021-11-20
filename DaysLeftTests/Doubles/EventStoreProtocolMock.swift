//  Created by Dominik Hauser on 19.08.21.
//  
//

import Foundation
@testable import fourtytwodays
import Combine

// MARK: - EventStoreProtocolMock -

final class EventStoreProtocolMock: EventStoreProtocol {

  init() {
    ageOfReturnValue = 3
    remainingDaysUntilReturnValue = 42
    underlyingEventsPublisher = CurrentValueSubject<[Event], Never>([])
  }

   // MARK: - eventsPublisher

    var eventsPublisher: CurrentValueSubject<[Event], Never> {
        get { underlyingEventsPublisher }
        set(value) { underlyingEventsPublisher = value }
    }
    private var underlyingEventsPublisher: CurrentValueSubject<[Event], Never>!

   // MARK: - add

    var addCallsCount = 0
    var addCalled: Bool {
        addCallsCount > 0
    }
    var addReceivedEvent: Event?
    var addReceivedInvocations: [Event] = []
    var addClosure: ((Event) -> Void)?

    func add(_ event: Event) {
        addCallsCount += 1
        addReceivedEvent = event
        addReceivedInvocations.append(event)
        addClosure?(event)
    }

   // MARK: - remainingDaysUntil

    var remainingDaysUntilCallsCount = 0
    var remainingDaysUntilCalled: Bool {
        remainingDaysUntilCallsCount > 0
    }
    var remainingDaysUntilReceivedEvent: Event?
    var remainingDaysUntilReceivedInvocations: [Event] = []
    var remainingDaysUntilReturnValue: Int!
    var remainingDaysUntilClosure: ((Event) -> Int)?

    func remainingDaysUntil(_ event: Event) -> Int {
        remainingDaysUntilCallsCount += 1
        remainingDaysUntilReceivedEvent = event
        remainingDaysUntilReceivedInvocations.append(event)
        return remainingDaysUntilClosure.map({ $0(event) }) ?? remainingDaysUntilReturnValue
    }

   // MARK: - nextOccurrence

    var nextOccurrenceOfCallsCount = 0
    var nextOccurrenceOfCalled: Bool {
        nextOccurrenceOfCallsCount > 0
    }
    var nextOccurrenceOfReceivedDate: Date?
    var nextOccurrenceOfReceivedInvocations: [Date] = []
    var nextOccurrenceOfReturnValue: Date?
    var nextOccurrenceOfClosure: ((Date) -> Date?)?

    func nextOccurrence(of date: Date) -> Date? {
        nextOccurrenceOfCallsCount += 1
        nextOccurrenceOfReceivedDate = date
        nextOccurrenceOfReceivedInvocations.append(date)
        return nextOccurrenceOfClosure.map({ $0(date) }) ?? nextOccurrenceOfReturnValue
    }

   // MARK: - age

    var ageOfCallsCount = 0
    var ageOfCalled: Bool {
        ageOfCallsCount > 0
    }
    var ageOfReceivedEvent: Event?
    var ageOfReceivedInvocations: [Event] = []
    var ageOfReturnValue: Int!
    var ageOfClosure: ((Event) -> Int)?

    func age(of event: Event) -> Int {
        ageOfCallsCount += 1
        ageOfReceivedEvent = event
        ageOfReceivedInvocations.append(event)
        return ageOfClosure.map({ $0(event) }) ?? ageOfReturnValue
    }

   // MARK: - numberOfEvents

    var numberOfEventsCallsCount = 0
    var numberOfEventsCalled: Bool {
        numberOfEventsCallsCount > 0
    }
    var numberOfEventsReturnValue: Int!
    var numberOfEventsClosure: (() -> Int)?

    func numberOfEvents() -> Int {
        numberOfEventsCallsCount += 1
        return numberOfEventsClosure.map({ $0() }) ?? numberOfEventsReturnValue
    }

   // MARK: - eventAt

    var eventAtIndexCallsCount = 0
    var eventAtIndexCalled: Bool {
        eventAtIndexCallsCount > 0
    }
    var eventAtIndexReceivedIndex: Int?
    var eventAtIndexReceivedInvocations: [Int] = []
    var eventAtIndexReturnValue: Event?
    var eventAtIndexClosure: ((Int) -> Event?)?

    func eventAt(index: Int) -> Event? {
        eventAtIndexCallsCount += 1
        eventAtIndexReceivedIndex = index
        eventAtIndexReceivedInvocations.append(index)
      return (eventAtIndexClosure.map({ $0(index) }) ?? eventAtIndexReturnValue) ?? underlyingEventsPublisher.value.last
    }

   // MARK: - update

    var updateCallsCount = 0
    var updateCalled: Bool {
        updateCallsCount > 0
    }
    var updateClosure: (() -> Void)?

    func update() {
        updateCallsCount += 1
        updateClosure?()
    }
}
