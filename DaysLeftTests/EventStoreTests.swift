//  Created by Dominik Hauser on 16.08.21.
//  
//

import XCTest
@testable import DaysLeft

class EventStoreTests: XCTestCase {

  var sut: EventStore!

  override func setUpWithError() throws {
    sut = EventStore(eventsSerialiser: EventsPersistenceHandlerProtocolDummy())
  }

  override func tearDownWithError() throws {
    sut = nil
  }

  func test_add_shouldAddEventToEvents() {
    // arrange

    // act
    let event = Event(name: "Dummy", date: Date())
    sut.add(event)

    // assert
    XCTAssertEqual(sut.events.first, event)
  }

  func test_remove_shouldRemoveEventFromEvents() {
    // arrange
    let event = Event(name: "Dummy", date: Date())
    sut.add(event)
    XCTAssertEqual(sut.events.count, 1)

    // act
    sut.remove(event: event)

    // assert
    XCTAssertEqual(sut.events.count, 0)
  }
}
