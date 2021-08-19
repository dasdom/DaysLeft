//  Created by Dominik Hauser on 15.08.21.
//  
//

import Foundation
import Combine

protocol EventStoreProtocol {
  var eventsPublisher: Published<[Event]>.Publisher { get }
  func add(_ event: Event)
  func remainingDaysUntil(_ event: Event) -> Int
  func numberOfEvents() -> Int
  func eventAt(index: Int) -> Event?
}

class EventStore: EventStoreProtocol {

  var eventsPublisher: Published<[Event]>.Publisher { $events }
  @Published private var events: [Event] = []
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

  func eventAt(index: Int) -> Event? {
    guard index < events.count else {
      return nil
    }
    return events[index]
  }

  func numberOfEvents() -> Int {
    return events.count
  }

  func remainingDaysUntil(_ event: Event) -> Int {
    let calendar = Calendar.current
    let eventDateComponents = calendar.dateComponents([.day, .month], from: event.date)
    let now = Date()
    let nowComponents = calendar.dateComponents([.day, .month], from: now)
    if eventDateComponents == nowComponents {
      return 0
    }

    let startOfToday = calendar.startOfDay(for: now)
    guard let next = calendar.nextDate(after: startOfToday, matching: eventDateComponents, matchingPolicy: .nextTime) else {
      return 0
    }

    guard let remainingDays = calendar.dateComponents([.day], from: startOfToday, to: next).day else {
      return 0
    }

    return remainingDays
  }
}
