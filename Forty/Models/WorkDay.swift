import Foundation

struct WorkDay: Codable {
    let id: Int
    let date: Date

    var adjustHours: String?
    var inTime: String?
    var outTime: String?
    var ptoHours: String?

    enum CodingKeys: String, CodingKey {
        case id
        case date
        case adjustHours = "adjust_hours"
        case inTime = "in_time"
        case outTime = "out_time"
        case ptoHours = "pto_hours"
    }
}

extension Dictionary where Key: ExpressibleByStringLiteral {
    subscript(codingKey: WorkDay.CodingKeys) -> Value? {
        get {
            return self[codingKey.rawValue as! Key]
        }
        set {
            self[codingKey.rawValue as! Key] = newValue
        }
    }
}
