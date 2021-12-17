//  Created by Dominik Hauser on 18.08.21.
//  
//

import UIKit
import Combine

enum Section: Hashable {
  case main
}

protocol EventsListViewControllerDelegate {
  func addSelected(_ viewController: UIViewController)
}

class EventsListViewController: UIViewController {

  private var dataSource: UITableViewDiffableDataSource<Section, UUID>?
  var delegate: EventsListViewControllerDelegate?
  var eventStore: EventStoreProtocol?
  var token: AnyCancellable?
  var notificationToken: AnyCancellable?
  let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.setLocalizedDateFormatFromTemplate("dd MM")
    return formatter
  }()
  var tableView: UITableView {
    return contentView.tableView
  }
  var contentView: EventsListView {
    return view as! EventsListView
  }

  override func loadView() {
    let contentView = EventsListView()
    contentView.tableView.register(EventCell.self, forCellReuseIdentifier: "EventCell")
    view = contentView
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    dataSource = UITableViewDiffableDataSource<Section, UUID>(tableView: contentView.tableView, cellProvider: { [weak self] tableView, indexPath, uuid in

      let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell

      guard let self = self else {
        return cell
      }

      if let eventStore = self.eventStore, let event = eventStore.eventAt(index: indexPath.row) {
        cell.update(with: event, eventStore: eventStore, dateFormatter: self.dateFormatter)
      }
      return cell
    })

    token = eventStore?.eventsPublisher
      .sink(receiveValue: { [weak self] events in
        self?.newSnapshot(events)
      })

    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addEvent(_:)))
    navigationItem.rightBarButtonItem = addButton

    notificationToken = NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification).sink { [weak self] _ in
      self?.tableView.reloadData()
    }

    title = "Events"
  }

  func newSnapshot(_ events: [Event]) {
    var snapshot = NSDiffableDataSourceSnapshot<Section , UUID>()
    snapshot.appendSections([.main])
    snapshot.appendItems(events.map({ $0.id }))
    dataSource?.apply(snapshot)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    eventStore?.update()
    tableView.reloadData()
  }
}

// MARK: - Actions
extension EventsListViewController {
  @objc func addEvent(_ sender: UIBarButtonItem) {
    delegate?.addSelected(self)
  }
}
