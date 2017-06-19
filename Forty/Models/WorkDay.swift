import Foundation

// not sure where a cooler place for this is - i wanted to put it on the class, but had trouble with that.
private let formatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter
}()

class WorkDay {
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
            let date = formatter.date(from: dateString)
            else { return nil }

        self.id = id
        self.date = date

        self.adjustHours = attrs["adjust_hours"] as? String ?? ""
        self.inTime = attrs["in_time"] as? String ?? ""
        self.outTime = attrs["out_time"] as? String ?? ""
        self.ptoHours = attrs["pto_hours"] as? String ?? ""
    }

    func save() {
        let url = URL(string: "https://forty-rails.herokuapp.com/api/v1/work_days/\(id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(ClientToken, forHTTPHeaderField: "X-CLIENT-TOKEN")
        let data = try? JSONSerialization.data(withJSONObject: ["work_day": asObject])
        request.httpBody = data
        let task = URLSession.shared.dataTask(with: request)
        task.resume()
    }
}
