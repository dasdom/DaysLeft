//  Created by Dominik Hauser on 18.08.21.
//  
//

import XCTest
import Combine
@testable import fourtytwodays

class EventsListViewControllerTests: XCTestCase {

  var sut: EventsListViewController!

  override func setUpWithError() throws {
    sut = EventsListViewController()
  }

  override func tearDownWithError() throws {
    sut = nil
  }

  func test_loading_shouldAddTableView() {
    // arrange
    sut.loadViewIfNeeded()

    // act
    let tableViewIsSubview = sut.tableView.isDescendant(of: sut.view)

    // assert
    XCTAssertEqual(tableViewIsSubview, true, "tableView should be subview")
  }

  func test_appearance_shouldAskEventStoreToUpdate() {
    let eventStoreMock = EventStoreProtocolMock()
    sut.eventStore = eventStoreMock

    sut.beginAppearanceTransition(true, animated: false)
    sut.endAppearanceTransition()

    XCTAssertEqual(eventStoreMock.updateCallsCount, 1)
  }

  func test_numberOfRows_shouldCallEventStore() {
    // arrange
    let eventStoreMock = EventStoreProtocolMock()
    let events = ["Foo", "Bar"].map({ Event(name: $0, date: Date()) })
    let eventsPublisher = CurrentValueSubject<[Event], Never>([])
    eventStoreMock.eventsPublisher = eventsPublisher
    eventsPublisher.send(events)
    sut.eventStore = eventStoreMock
    sut.loadViewIfNeeded()

    // act
    let result = sut.tableView.dataSource?.tableView(sut.tableView, numberOfRowsInSection: 0)

    // assert
    XCTAssertEqual(result, 2)
  }

  func test_cellForRow_shouldSetName() throws {
    // arrange
    let eventStoreMock = EventStoreProtocolMock()
    let eventsPublisher = CurrentValueSubject<[Event], Never>([])
    eventStoreMock.eventsPublisher = eventsPublisher
    eventsPublisher.send([Event(name: "Dummy", date: Date())])
    eventStoreMock.ageOfReturnValue = 42
    eventStoreMock.remainingDaysUntilReturnValue = 200
    sut.eventStore = eventStoreMock
    sut.loadViewIfNeeded()

    // act
    let indexPath = IndexPath(row: 0, section: 0)
    let cell = try XCTUnwrap(sut.tableView.dataSource?.tableView(sut.tableView, cellForRowAt: indexPath) as? EventCell)

    // assert
    XCTAssertEqual(cell.nameLabel.text, "Dummy")
  }

  func test_cellForRow_shouldSetRemainingDays() throws {
    // arrange
    let eventStoreMock = EventStoreProtocolMock()
    let notUsedDate = Date()
    eventStoreMock.ageOfReturnValue = 200
    eventStoreMock.remainingDaysUntilReturnValue = 42
    let eventsPublisher = CurrentValueSubject<[Event], Never>([])
    eventStoreMock.eventsPublisher = eventsPublisher
    eventsPublisher.send([Event(name: "Dummy", date: notUsedDate)])
    sut.eventStore = eventStoreMock
    sut.loadViewIfNeeded()

    // act
    let indexPath = IndexPath(row: 0, section: 0)
    let cell = try XCTUnwrap(sut.tableView.dataSource?.tableView(sut.tableView, cellForRowAt: indexPath) as? EventCell)

    // assert
    XCTAssertEqual(cell.remainingDaysLabel.text, "42")
  }

  func test_cellForRow_shouldSetDate() throws {
    // arrange
    let eventStoreMock = EventStoreProtocolMock()
    let dateFormatter = DateFormatter()
    dateFormatter.setLocalizedDateFormatFromTemplate("dd MM")
    let date = Date()
    let next = try next(for: date)
    eventStoreMock.nextOccurrenceOfReturnValue = next
    let eventsPublisher = CurrentValueSubject<[Event], Never>([])
    eventStoreMock.eventsPublisher = eventsPublisher
    eventsPublisher.send([Event(name: "Dummy", date: date)])
    eventStoreMock.ageOfReturnValue = 3
    eventStoreMock.remainingDaysUntilReturnValue = 200
    sut.eventStore = eventStoreMock
    sut.loadViewIfNeeded()

    // act
    let indexPath = IndexPath(row: 0, section: 0)
    let cell = try XCTUnwrap(sut.tableView.dataSource?.tableView(sut.tableView, cellForRowAt: indexPath) as? EventCell)

    // assert
    XCTAssertEqual(cell.dateLabel.text, "turns 3 on \(dateFormatter.string(from: next))")
  }

  func test_publishingEvents_shouldTriggerReload() {
    // arrange
    let eventStore = EventStoreProtocolMock()
    let eventsPublisher = CurrentValueSubject<[Event], Never>([])
    eventStore.eventsPublisher = eventsPublisher
    eventsPublisher.send([Event(name: "Dummy One", date: Date())])
    sut.eventStore = eventStore
    sut.loadViewIfNeeded()
    XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 1)

    // act
    eventsPublisher.send([Event(name: "Dummy One", date: Date()), Event(name: "Dummy Two", date: Date())])

    // assert
    XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 2)
  }

  func test_rightNavigationItem_shouldCallAddSelectedOfDelegate() throws {
    // arrange
    sut.loadViewIfNeeded()
    let delegateMock = EventsListViewControllerDelegateMock()
    sut.delegate = delegateMock
    let addButton = try XCTUnwrap(sut.navigationItem.rightBarButtonItem)
    let target = try XCTUnwrap(addButton.target as? EventsListViewController)
    let action = try XCTUnwrap(addButton.action)

    // act
    target.perform(action, with: addButton)

    // assert
    XCTAssertEqual(delegateMock.addSelectedCallCount, 1)
  }
}

extension EventsListViewControllerTests {
  func next(for date: Date) throws -> Date {
    let calendar = Calendar.current
    let startOfToday = calendar.startOfDay(for: Date())
    let eventDateComponents = calendar.dateComponents([.day, .month], from: date)
    return try XCTUnwrap(calendar.nextDate(after: startOfToday, matching: eventDateComponents, matchingPolicy: .nextTime))
  }

  func date(yearsInPast: Int = 0, daysInFuture: Int = 0) -> Date {
    let calendar = Calendar(identifier: .gregorian)
    let dateYearsInPast = calendar.date(byAdding: .year, value: -yearsInPast, to: Date())!
    return calendar.date(byAdding: .day, value: daysInFuture, to: dateYearsInPast)!
  }
}
