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

    dataSource = UITableViewDiffableDataSource<Section, UUID>(tableView: contentView.tableView, cellProvider: { tableView, indexPath, uuid in
      let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell
      if let eventStore = self.eventStore, let event = eventStore.eventAt(index: indexPath.row) {
        if let data = event.thumbnailData {
          let image = UIImage(data: data)
          cell.thumbnailImageView.image = image
        }
        let name = [event.name, event.lastName].compactMap({ $0 }).joined(separator: " ")
        cell.nameLabel.text = name
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
