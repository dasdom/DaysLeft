//  Created by Dominik Hauser on 20/07/2021.
//  Copyright © 2021 dasdom. All rights reserved.
//

import Foundation

protocol FileManagerProtocol {
  func eventsURL() -> URL
}

extension FileManager: FileManagerProtocol {
  func eventsURL() -> URL {
    guard let documentsURL = urls(for: .documentDirectory, in: .userDomainMask).first else {
      fatalError()
    }
    return documentsURL.appendingPathComponent("events.json")
  }
}
