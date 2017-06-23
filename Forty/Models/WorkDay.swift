import Foundation

class WorkDay: Codable {
    var id: Int
    var date: Date

    var adjustHours: String
    var inTime: String
    var outTime: String
    var ptoHours: String

    var asObject: [String: String] {
        return [
            "adjust_hours": adjustHours,
            "in_time": inTime,
            "out_time": outTime,
            "pto_hours": ptoHours
        ]
    }

    enum CodingKeys : String, CodingKey {
        case id
        case date
        case adjustHours = "adjust_hours"
        case inTime = "in_time"
        case outTime = "out_time"
        case ptoHours = "pto_hours"
    }

    init(id: Int, date: Date, adjustHours: String, inTime: String, outTime: String, ptoHours: String) {
        self.id = id
        self.date = date
        self.adjustHours = adjustHours
        self.inTime = inTime
        self.outTime = outTime
        self.ptoHours = ptoHours
    }
}
