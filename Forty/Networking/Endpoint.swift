import Foundation

enum Endpoint {
    case showWorkWeek(year: Int, number: Int)
    case updateWorkDay(workDay: WorkDay)

    private var payload: Any? {
        switch self {
        case .updateWorkDay(let workDay):
            return ["work_day": workDay.asObject]
        default:
            return nil
        }
    }

    var data: Data? {
        guard let payload = payload else { return nil }
        return try! JSONSerialization.data(withJSONObject: payload)
    }

    var method: String {
        switch self {
        case .showWorkWeek:
            return "GET"
        case .updateWorkDay:
            return "PATCH"
        }
    }

    var path: String {
        switch self {
        case .showWorkWeek(let year, let number):
            return "/work_weeks/\(year)/\(number)"
        case .updateWorkDay(let workDay):
            return "/work_days/\(workDay.id)"
        }
    }
}
