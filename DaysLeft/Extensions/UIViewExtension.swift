//  Created by Dominik Hauser on 12.11.21.
//  Copyright © 2021 dasdom. All rights reserved.
//

import UIKit

extension UIView {
  func forAutoLayout() -> Self {
    self.translatesAutoresizingMaskIntoConstraints = false
    return self
  }
}
