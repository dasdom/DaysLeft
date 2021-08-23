//  Created by Dominik Hauser on 15.08.21.
//  
//

import Foundation

struct Event: Codable, Equatable, Identifiable {
  let id: UUID
  let name: String
  let date: Date

  init(id: UUID = UUID(), name: String, date: Date) {
    self.id = id
    self.name = name
    self.date = date
  }
}
