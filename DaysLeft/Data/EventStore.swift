//  Created by Dominik Hauser on 15.08.21.
//  
//

import Foundation

protocol EventStoreProtocol {
  func add(_ event: Event)
}

class EventStore: EventStoreProtocol {

  var events: [Event] = []

  init() {
    events = load()
  }

  func add(_ event: Event) {
    events.append(event)
    save(events)
  }

  func remove(event: Event) {
    events.removeAll(where: { $0 == event })
    save(events)
  }

  func save(_ events: [Event]) {
    do {
      let data = try JSONEncoder().encode(events)
      try data.write(to: FileManager.default.eventsURL())
    } catch {
      print("\(#file) \(#line), #Error: \(error)")
    }
  }

  func load() -> [Event] {
    do {
      let data = try Data(contentsOf: FileManager.default.eventsURL())
      return try JSONDecoder().decode([Event].self, from: data)
    } catch {
      print("\(#file) \(#line), #Error: \(error)")
      return []
    }
  }
}
