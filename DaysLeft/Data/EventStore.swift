//  Created by Dominik Hauser on 15.08.21.
//  
//

import Foundation

protocol EventStoreProtocol {
  func add(_ event: Event)
  func remainingDaysUntil(_ event: Event) -> Int
}

class EventStore: EventStoreProtocol {

  var events: [Event] = []
  private let eventsSerialiser: EventsPersistenceHandlerProtocol

  init(eventsSerialiser: EventsPersistenceHandlerProtocol = EventsPersistenceHandler()) {
    self.eventsSerialiser = eventsSerialiser
    events = eventsSerialiser.load()
  }

  func add(_ event: Event) {
    events.append(event)
    eventsSerialiser.save(events)
  }

  func remove(event: Event) {
    events.removeAll(where: { $0 == event })
    eventsSerialiser.save(events)
  }

  func remainingDaysUntil(_ event: Event) -> Int {
    return 42
  }
}
