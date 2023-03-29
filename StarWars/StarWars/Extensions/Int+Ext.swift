import Foundation

extension Int {
    func getHeightString() -> String {
        let feet = self / 12
        let inch = self % 12
        if feet == 0 {
            return "\(inch) Inch"
        } else if inch == 0 {
            return "\(feet) Feet"
        } else {
            return "\(feet)ft\(inch)in"
        }
    }
}
