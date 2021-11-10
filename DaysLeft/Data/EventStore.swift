//  Created by Dominik Hauser on 15.08.21.
//  
//

import Foundation
import Combine

protocol EventStoreProtocol: AnyObject {
  var eventsPublisher: CurrentValueSubject<[Event], Never> { get }
  func add(_ event: Event)
  func remainingDaysUntil(_ event: Event) -> Int
  func numberOfEvents() -> Int
  func eventAt(index: Int) -> Event?
}

class EventStore: EventStoreProtocol {

  let fileName: String
  var eventsPublisher = CurrentValueSubject<[Event], Never>([])
  private var events: [Event] = [] {
    didSet {
      eventsPublisher.send(events)
    }
  }

  init(fileName: String = "events.json") {
    self.fileName = fileName
    load()
  }

  func add(_ event: Event) {
    events.append(event)
    save(events)
  }

  func remove(event: Event) {
    events.removeAll(where: { $0 == event })
    save(events)
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

  func save(_ events: [Event]) {
    do {
      let data = try JSONEncoder().encode(events)
      try data.write(to: FileManager.default.documentsURL(name: fileName))
    } catch {
      print("\(#file) \(#line), #Error: \(error)")
    }
  }

  func load() {
    do {
      let data = try Data(contentsOf: FileManager.default.documentsURL(name: fileName))
      events = try JSONDecoder().decode([Event].self, from: data)
    } catch {
      print("\(#file) \(#line), #Error: \(error)")
      return
    }
  }
}
