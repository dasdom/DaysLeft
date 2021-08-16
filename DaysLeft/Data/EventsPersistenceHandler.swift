//  Created by Dominik Hauser on 16.08.21.
//  
//

import Foundation

protocol EventsPersistenceHandlerProtocol {
  func save(_ events: [Event])
  func load() -> [Event]
}

struct EventsPersistenceHandler: EventsPersistenceHandlerProtocol {
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
