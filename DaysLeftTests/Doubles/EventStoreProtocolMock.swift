//  Created by Dominik Hauser on 19.08.21.
//  
//

import Foundation
@testable import fourtytwodays
import Combine

class EventStoreProtocolMock: EventStoreProtocol {
  var eventsPublisher = CurrentValueSubject<[Event], Never>([])
  var events: [Event] = [] {
    didSet {
      eventsPublisher.send(events)
    }
  }
  var addEventReceivedValue: Event?
  var remainingDaysReturnValue: Int = 0
  var numberOfEventsCallCount = 0
  var numberOfEventsReturnValue = 0
  var eventAtReturnValue: Event?

  func add(_ event: Event) {
    addEventReceivedValue = event
    events.append(event)
  }

  func remainingDaysUntil(_ event: Event) -> Int {
    return remainingDaysReturnValue
  }

  func numberOfEvents() -> Int {
    numberOfEventsCallCount += 1
    return numberOfEventsReturnValue
  }

  func eventAt(index: Int) -> Event? {
    return eventAtReturnValue ?? events.last
  }
}
