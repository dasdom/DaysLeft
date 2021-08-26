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

  @IBOutlet var tableView: UITableView!
  private var dataSource: UITableViewDiffableDataSource<Section, UUID>?
  var delegate: EventsListViewControllerDelegate?
  var eventStore: EventStoreProtocol?
  var token: AnyCancellable?

  override func viewDidLoad() {
    super.viewDidLoad()

   tableView.register(EventCell.self, forCellReuseIdentifier: "EventCell")

    dataSource = UITableViewDiffableDataSource<Section, UUID>(tableView: tableView, cellProvider: { tableView, indexPath, uuid in
      let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell
      if let eventStore = self.eventStore, let event = eventStore.eventAt(index: indexPath.row) {
        cell.nameLabel.text = event.name
        cell.remainingDaysLabel.text = "\(eventStore.remainingDaysUntil(event))"
      }
      return cell
    })

    token = eventStore?.eventsPublisher
      .sink(receiveValue: { [weak self] events in
        self?.newSnapshot(events)
      })

    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addEvent(_:)))
    navigationItem.rightBarButtonItem = addButton
  }

  func newSnapshot(_ events: [Event]) {
    var snapshot = NSDiffableDataSourceSnapshot<Section , UUID>()
    snapshot.appendSections([.main])
    snapshot.appendItems(events.map({ $0.id }))
    dataSource?.apply(snapshot)
  }
}

// MARK: - Actions
extension EventsListViewController {
  @objc func addEvent(_ sender: UIBarButtonItem) {
    delegate?.addSelected(self)
  }
}
