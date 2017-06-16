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

    var inTextField: InTextField {
        guard let field = subviews.flatMap({ $0 as? InTextField }).first
            else { fatalError() }
        return field
    }

    var outTextField: OutTextField {
        guard let field = subviews.flatMap({ $0 as? OutTextField }).first
            else { fatalError() }
        return field
    }

    var ptoTextField: PtoTextField {
        guard let field = subviews.flatMap({ $0 as? PtoTextField }).first
            else { fatalError() }
        return field
    }

    var adjustTextField: AdjustTextField {
        guard let field = subviews.flatMap({ $0 as? AdjustTextField }).first
            else { fatalError() }
        return field
    }

    var totalTextField: TotalTextField {
        guard let field = subviews.flatMap({ $0 as? TotalTextField }).first
            else { fatalError() }
        return field
    }
}
