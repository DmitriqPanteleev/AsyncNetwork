
import Foundation

extension StatusCodes {
    static var successCodes: Self {
        (200...299)
    }
    
    static var successAndRedirectCodes: Self {
        (200...399)
    }
}
