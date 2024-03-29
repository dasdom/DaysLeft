//  Created by Dominik Hauser on 19.08.21.
//  
//

import UIKit

class EventCell: UITableViewCell {
  let thumbnailImageView: UIImageView
  let nameLabel: UILabel
  let dateLabel: UILabel
  let remainingDaysLabel: UILabel
  let processMarker: UIView
  var processMarkerWidthConstraint: NSLayoutConstraint?

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

    thumbnailImageView = UIImageView()
    thumbnailImageView.clipsToBounds = true

    nameLabel = UILabel()
    nameLabel.font = .preferredFont(forTextStyle: .headline)
    nameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)

    dateLabel = UILabel()
    dateLabel.font = .preferredFont(forTextStyle: .footnote)
    dateLabel.textColor = .secondaryLabel

    let nameAndDateStackView = UIStackView(arrangedSubviews: [nameLabel, dateLabel])
    nameAndDateStackView.axis = .vertical
    nameAndDateStackView.distribution = .fillEqually

    remainingDaysLabel = UILabel()
    remainingDaysLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    remainingDaysLabel.font = .preferredFont(forTextStyle: .headline)

    let daysLabel = UILabel()
    daysLabel.text = "days"
    daysLabel.font = .preferredFont(forTextStyle: .footnote)
    daysLabel.textColor = .secondaryLabel

    let remainingDaysStackView = UIStackView(arrangedSubviews: [remainingDaysLabel, daysLabel])
    remainingDaysStackView.axis = .vertical
    remainingDaysStackView.alignment = .trailing

    processMarker = UIView()
    processMarker.translatesAutoresizingMaskIntoConstraints = false

    super.init(style: style, reuseIdentifier: reuseIdentifier)

    let stackView = UIStackView(arrangedSubviews: [thumbnailImageView, nameAndDateStackView, remainingDaysStackView]).forAutoLayout()
    stackView.spacing = 10
    stackView.alignment = .center

    addSubview(processMarker)
    contentView.addSubview(stackView)

    let thumbnailHeightConstraint = thumbnailImageView.heightAnchor.constraint(equalTo: thumbnailImageView.widthAnchor)
    thumbnailHeightConstraint.priority = UILayoutPriority(999)

    let thumbnailWidth: CGFloat = 60

    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
      stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
      stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

      thumbnailImageView.widthAnchor.constraint(equalToConstant: thumbnailWidth),
      thumbnailHeightConstraint,

      processMarker.leadingAnchor.constraint(equalTo: leadingAnchor),
//      processMarker.bottomAnchor.constraint(equalTo: bottomAnchor),
      processMarker.centerYAnchor.constraint(equalTo: centerYAnchor),
      processMarker.heightAnchor.constraint(equalToConstant: 2),
    ])

    thumbnailImageView.layer.cornerRadius = floor(thumbnailWidth / 2)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension EventCell {
  func update(with event: Event, eventStore: EventStoreProtocol, dateFormatter: DateFormatter) {
    if let data = event.thumbnailData {
      let image = UIImage(data: data)
      thumbnailImageView.image = image
    } else {
      thumbnailImageView.image = imageDataFrom(firstName: event.name, lastName: event.lastName)
    }
    let name = [event.name, event.lastName].compactMap({ $0 }).joined(separator: " ")
    nameLabel.text = name
    var dateString = "turns \(eventStore.age(of: event))"
    if let next = eventStore.nextOccurrence(of: event.date) {
      dateString.append(contentsOf: " on \(dateFormatter.string(from: next))")
    } else {
      dateString.append(contentsOf: " today")
    }
    dateLabel.text = dateString
    let remainingDays = eventStore.remainingDaysUntil(event)
    remainingDaysLabel.text = "\(remainingDays)"

    let color: UIColor?
    if remainingDays <= 14 {
      color = UIColor(named: "red")
      processMarker.backgroundColor = color
    } else {
      color = UIColor(named: "green")
      processMarker.backgroundColor = color
    }
    
    thumbnailImageView.layer.borderColor = color?.cgColor
    thumbnailImageView.layer.borderWidth = 2

    processMarkerWidthConstraint?.isActive = false
    processMarkerWidthConstraint = processMarker.widthAnchor.constraint(equalTo: widthAnchor, multiplier: (1 - CGFloat(remainingDays) / 365.0))
    processMarkerWidthConstraint?.isActive = true
  }

  func imageDataFrom(firstName: String, lastName: String?) -> UIImage {
    var initials = ""
    if let character = firstName.first {
      initials.append(contentsOf: character.uppercased())
    }
    if let character = lastName?.first {
      initials.append(contentsOf: character.uppercased())
    }

    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    label.textColor = .white
    label.backgroundColor = .gray
    label.textAlignment = .center
    label.font = .boldSystemFont(ofSize: 40)
    label.text = initials

    UIGraphicsBeginImageContext(label.frame.size)
    label.layer.render(in: UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
  }
}
