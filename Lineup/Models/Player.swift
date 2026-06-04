import Foundation
import SwiftData

@Model
final class Player {
    var name: String
    var number: Int

    init(name: String, number: Int) {
        self.name = name
        self.number = number
    }
}
