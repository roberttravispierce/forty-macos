import Foundation

struct WorkDayList: Codable {
    private static let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()

    private static let decoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(WorkDayList.formatter)
        return jsonDecoder
    }()

    static func decode(from data: Data?) -> WorkDayList? {
        guard let data = data,
            let workDayList = try? WorkDayList.decoder.decode(WorkDayList.self, from: data)
            else { return nil }

        return workDayList
    }

    let workDays: [WorkDay]

    enum CodingKeys : String, CodingKey {
        case workDays = "work_days"
    }
}
