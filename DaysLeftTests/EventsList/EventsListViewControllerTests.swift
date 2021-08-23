//  Created by Dominik Hauser on 18.08.21.
//  
//

import XCTest
@testable import DaysLeft

class EventsListViewControllerTests: XCTestCase {

  var sut: EventsListViewController!

  override func setUpWithError() throws {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    sut = (storyboard.instantiateViewController(withIdentifier: "EventsListViewController") as! EventsListViewController)
  }

  override func tearDownWithError() throws {
    sut = nil
  }

  func test_shouldBeLoadedFromStoryboard() {
    XCTAssertNotNil(sut)
  }

  func test_loading_shouldAddTableView() {
    // arrange
    sut.loadViewIfNeeded()

    // act
    let tableViewIsSubview = sut.tableView?.isDescendant(of: sut.view)

    // assert
    XCTAssertEqual(tableViewIsSubview, true, "tableView should be subview")
  }

  func test_numberOfRows_shouldCallEventStore() {
    // arrange
    let eventStoreMock = EventStoreProtocolMock()
    let events = ["Foo", "Bar"].map({ Event(name: $0, date: Date()) })
    eventStoreMock.eventsPublisher.send(events)
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
    eventStoreMock.events = [Event(name: "Dummy", date: Date())]
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
    eventStoreMock.events = [Event(name: "Dummy", date: notUsedDate)]
    eventStoreMock.remainingDaysReturnValue = 42
    sut.eventStore = eventStoreMock
    sut.loadViewIfNeeded()

    // act
    let indexPath = IndexPath(row: 0, section: 0)
    let cell = try XCTUnwrap(sut.tableView.dataSource?.tableView(sut.tableView, cellForRowAt: indexPath) as? EventCell)

    // assert
    XCTAssertEqual(cell.remainingDaysLabel.text, "42")
  }

  func test_addEvent_shouldTriggerReload() {
    // arrange
    let eventStore = EventStoreProtocolMock()
    sut.eventStore = eventStore
    sut.eventStore?.add(Event(name: "Dummy One", date: Date()))
    sut.loadViewIfNeeded()
    XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 1)

    // act
    sut.eventStore?.add(Event(name: "Dummy Two", date: Date()))

    // assert
    XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 2)
  }
}
