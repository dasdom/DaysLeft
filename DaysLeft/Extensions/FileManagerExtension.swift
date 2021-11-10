//  Created by Dominik Hauser on 20/07/2021.
//  Copyright © 2021 dasdom. All rights reserved.
//

import Foundation

extension FileManager {
  func documentsURL(name: String) -> URL {
    guard let documentsURL = urls(for: .documentDirectory,
                                     in: .userDomainMask).first else {
      fatalError()
    }
    return documentsURL.appendingPathComponent(name)
  }
}
