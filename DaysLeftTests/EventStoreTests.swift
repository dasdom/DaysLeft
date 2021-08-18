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

  func test_remainingDays_whenEventIsToday_shouldBe0() {
    // arrange
    let event = event(name: "Dummy", yearsInPast: 1, daysInFuture: 0)

    // act
    let result = sut.remainingDaysUntil(event)

    // assert
    XCTAssertEqual(result, 0)
  }

  func test_remainingDays_whenEventIsIn42Days_shouldBe42() {
    // arrange
    let event = event(name: "Dummy", yearsInPast: 1, daysInFuture: 42)

    // act
    let result = sut.remainingDaysUntil(event)

    // assert
    XCTAssertEqual(result, 42)
  }
}

extension EventStoreTests {
  func event(name: String, yearsInPast: Int = 0, daysInFuture: Int = 0) -> Event {
    return Event(name: name, date: date(yearsInPast: yearsInPast, daysInFuture: daysInFuture))
  }

  func date(yearsInPast: Int = 0, daysInFuture: Int = 0) -> Date {
    let calendar = Calendar(identifier: .gregorian)
    let dateYearsInPast = calendar.date(byAdding: .year, value: -yearsInPast, to: Date())!
    return calendar.date(byAdding: .day, value: daysInFuture, to: dateYearsInPast)!
  }
}
