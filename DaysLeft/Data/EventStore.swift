//  Created by Dominik Hauser on 15.08.21.
//
//

import Foundation
import Combine

protocol EventStoreProtocol: AnyObject {
  var eventsPublisher: CurrentValueSubject<[Event], Never> { get }
  func add(_ event: Event)
  func remainingDaysUntil(_ event: Event) -> Int
  func nextOccurrence(of date: Date) -> Date?
  func age(of event: Event) -> Int
  func numberOfEvents() -> Int
  func eventAt(index: Int) -> Event?
  func update()
  func remove(event: Event)
}

class EventStore: EventStoreProtocol {

  let fileName: String
  var eventsPublisher = CurrentValueSubject<[Event], Never>([])
  private(set) var events: [Event] = [] {
    didSet {
      save(events)
      eventsPublisher.send(events)
    }
  }

  init(fileName: String = "events.json") {
    self.fileName = fileName
    load()
  }

  func add(_ event: Event) {
    var tempEvents = events
    if let index = tempEvents.firstIndex(where: {
      $0.name == event.name
      && $0.lastName == $0.lastName
      && $0.date == event.date
    }) {
      tempEvents.remove(at: index)
    }
    tempEvents.append(event)
    events = tempEvents.sorted(by: { remainingDaysUntil($0) < remainingDaysUntil($1) })
  }

  func remove(event: Event) {
    events.removeAll(where: { $0 == event })
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
//    let eventDateComponents = calendar.dateComponents([.day, .month], from: event.date)
    let now = Date()
//    let nowComponents = calendar.dateComponents([.day, .month], from: now)
//    if eventDateComponents == nowComponents {
//      return 0
//    }

    let startOfToday = calendar.startOfDay(for: now)
    guard let next = nextOccurrence(of: event.date) else {
      return 0
    }

    guard let remainingDays = calendar.dateComponents([.day], from: startOfToday, to: next).day else {
      return 0
    }

    return remainingDays
  }

  func nextOccurrence(of date: Date) -> Date? {
    let calendar = Calendar.current
    let eventDateComponents = calendar.dateComponents([.day, .month], from: date)
    let now = Date()
    let nowComponents = calendar.dateComponents([.day, .month], from: now)
    if eventDateComponents == nowComponents {
      return nil
    }

    let startOfToday = calendar.startOfDay(for: now)
    guard let next = calendar.nextDate(after: startOfToday, matching: eventDateComponents, matchingPolicy: .nextTime) else {
      return nil
    }
    return next
  }

  func age(of event: Event) -> Int {
    let calendar = Calendar.current

    let startOfToday = calendar.startOfDay(for: Date())
    guard let age = calendar.dateComponents([.year], from: event.date, to: startOfToday).year else {
      return 0
    }
    return age + 1
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

  func update() {
    events = events.sorted(by: { remainingDaysUntil($0) < remainingDaysUntil($1) })
  }
}
