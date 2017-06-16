import Cocoa

class TimeEntryTextField: NSTextField {}
class InTextField: TimeEntryTextField {}
class OutTextField: TimeEntryTextField {}
class PtoTextField: TimeEntryTextField {}
class AdjustTextField: TimeEntryTextField {}
class TotalTextField: NSTextField {}

class DayStack: NSStackView {
    var timeEntryTextFields: [TimeEntryTextField] {
        return subviews.flatMap { $0 as? TimeEntryTextField }
    }

    var inTextField: InTextField? {
        return subviews.flatMap({ $0 as? InTextField }).first
    }

    var outTextField: OutTextField? {
        return subviews.flatMap({ $0 as? OutTextField }).first
    }

    var ptoTextField: PtoTextField? {
        return subviews.flatMap({ $0 as? PtoTextField }).first
    }

    var adjustTextField: AdjustTextField? {
        return subviews.flatMap({ $0 as? AdjustTextField }).first
    }

    var totalTextField: TotalTextField? {
        return subviews.flatMap({ $0 as? TotalTextField }).first
    }
}
