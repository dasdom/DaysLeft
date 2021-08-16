//  Created by Dominik Hauser on 16.08.21.
//  
//

import Foundation
@testable import DaysLeft

struct EventsPersistenceHandlerProtocolDummy: EventsPersistenceHandlerProtocol {
  func save(_ events: [Event]) {
    
  }

  func load() -> [Event] {
    return []
  }
}
