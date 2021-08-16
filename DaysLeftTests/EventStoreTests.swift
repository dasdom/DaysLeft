//  Created by Dominik Hauser on 16.08.21.
//  
//

import XCTest
@testable import DaysLeft

class EventStoreTests: XCTestCase {

  func test_add_shouldAddEventToEvents() {
    // arrange
    let store = EventStore()

    // act
    let event = Event(name: "Dummy", date: Date())
    store.add(event)

    // assert
    XCTAssertEqual(store.events.first, event)
  }
}
