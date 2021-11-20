//  Created by Dominik Hauser on 16.08.21.
//  
//

import XCTest
@testable import fourtytwodays

class EventStoreTests: XCTestCase {

  var sut: EventStore!

  override func setUpWithError() throws {
    sut = EventStore(fileName: "dummy.json")
  }

  override func tearDownWithError() throws {
    sut = nil

    let url = FileManager.default
      .documentsURL(name: "dummy.json")

    try? FileManager.default.removeItem(at: url)
  }

  func test_add_shouldAddEventToEvents() {
    // arrange

    // act
    let event = Event(name: "Dummy", date: Date())
    sut.add(event)

    // assert
    XCTAssertEqual(sut.eventAt(index: 0), event)
  }

  func test_add_whenEventIsAlreadyAdded_shouldNotAddEventAgain() {
    let name = "Dummy"
    let date = Date()
    let event1 = Event(name: name, date: date)
    sut.add(event1)

    let event2 = Event(name: name, date: date)
    sut.add(event2)

    XCTAssertEqual(sut.eventAt(index: 0), event2)
  }

  func test_remove_shouldRemoveEventFromEvents() {
    // arrange
    let event = Event(name: "Dummy", date: Date())
    sut.add(event)
    XCTAssertEqual(sut.numberOfEvents(), 1)

    // act
    sut.remove(event: event)

    // assert
    XCTAssertEqual(sut.numberOfEvents(), 0)
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

  func test_age_whenDateIsThreeYearsInThePastAndTwoDaysInFuture_shouldBeThree() {
    let event = event(name: "Dummy", yearsInPast: 3, daysInFuture: 2)

    let result = sut.age(of: event)

    XCTAssertEqual(result, 3)
  }

  func test_addingEvent_shouldPublishChange() {
    // arrange
    let publisherExpectation = expectation(description: "Wait for publisher in \(#file)")
    var receivedEvents: [Event] = []
    let token = sut.eventsPublisher
      .dropFirst()
      .sink { events in
      receivedEvents = events
      publisherExpectation.fulfill()
    }

    // act
    let event = Event(name: "Dummy", date: Date())
    sut.add(event)

    // assert
    wait(for: [publisherExpectation], timeout: 1)
    token.cancel()
    XCTAssertEqual(receivedEvents, [event])
  }

  func test_init_shouldLoadPreviousEvents() {
    var sut1: EventStore? = EventStore(fileName: "dummy.json")
    let event = Event(name: "Dummy", date: Date())
    sut1?.add(event)
    sut1 = nil

    let publisherExpectation = expectation(description: "Wait for publisher in \(#file)")
    let sut2 = EventStore(fileName: "dummy.json")
    var receivedEvents: [Event] = []
    let token = sut2.eventsPublisher
      .sink { events in
        receivedEvents = events
        publisherExpectation.fulfill()
      }

    // assert
    wait(for: [publisherExpectation], timeout: 1)
    token.cancel()
    XCTAssertEqual(receivedEvents, [event])
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
