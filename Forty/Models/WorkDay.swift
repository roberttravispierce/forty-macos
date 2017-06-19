import Foundation

class WorkDay {
    private static let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()

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

    init?(_ attrs: [String: Any]) {
        guard let id = attrs["id"] as? Int,
            let dateString = attrs["date"] as? String,
            let date = WorkDay.formatter.date(from: dateString)
            else { return nil }

        self.id = id
        self.date = date

        self.adjustHours = attrs["adjust_hours"] as? String ?? ""
        self.inTime = attrs["in_time"] as? String ?? ""
        self.outTime = attrs["out_time"] as? String ?? ""
        self.ptoHours = attrs["pto_hours"] as? String ?? ""
    }
}
