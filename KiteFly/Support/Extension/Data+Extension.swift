import UIKit

public extension Data {
    var sizeKB: CGFloat {
        get {
            return CGFloat(self.count) / 1024.0
        }
    }
    
    var sizeMB: CGFloat {
        get {
            return CGFloat(self.sizeKB) / 1024.0
        }
    }
}
