import Foundation
import SwiftUI

enum AppImage: String {
    case starWars = "star_wars"
}

extension Image {
    init(app: AppImage) {
        self.init(app.rawValue)
    }
}
