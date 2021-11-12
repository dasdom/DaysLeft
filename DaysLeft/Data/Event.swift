//  Created by Dominik Hauser on 15.08.21.
//  
//

import Foundation

struct Event: Codable, Equatable, Identifiable {
  let id: UUID
  let name: String
  let date: Date
  let thumbnailData: Data?

  init(id: UUID = UUID(), name: String, date: Date, thumbnailData: Data? = nil) {
    self.id = id
    self.name = name
    self.date = date
    self.thumbnailData = thumbnailData
  }
}
