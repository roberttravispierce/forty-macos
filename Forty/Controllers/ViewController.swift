import Cocoa

class ViewController: NSViewController {
    private var workWeek: WorkWeek! {
        didSet {
            workWeek.fetch()
        }
    }

    private var dayStacks: [DayStack] {
        return horizontalStackView.subviews.flatMap { $0 as? DayStack }
    }

    private var timeEntryTextFields: [TimeEntryTextField] {
        return dayStacks.flatMap { $0.timeEntryTextFields }
    }

    @IBOutlet weak var grandTotalTextField: NSTextField!
    @IBOutlet weak var weekRangeTextField: NSTextField!
    @IBOutlet weak var horizontalStackView: NSStackView!

    @IBAction func lastWeekButtonPressed(sender: AnyObject) {
        workWeek = workWeek.lastWeek
    }

    @IBAction func nextWeekButtonPressed(sender: AnyObject) {
        workWeek = workWeek.nextWeek
    }

    @IBAction func thisWeekButtonPressed(sender: AnyObject) {
        // might be nice if this was something like workWeek.currentWeek so that it matches the other IBActions?
        workWeek = WorkWeek.thisWeek(delegate: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        workWeek = WorkWeek.thisWeek(delegate: self)
        timeEntryTextFields.forEach { $0.delegate = self }
    }

    private func fillDayStack() {
        for (index, workDay) in workWeek.workDays.enumerated() {
            let dayStack = dayStacks[index]
            dayStack.inTextField.stringValue = workDay.inTime
            dayStack.outTextField.stringValue = workDay.outTime
            dayStack.ptoTextField.stringValue = workDay.ptoHours
            dayStack.adjustTextField.stringValue = workDay.adjustHours
        }
    }

    private func recompute(control: NSControl) {
        guard let dayStack = control.superview as? DayStack
            else { fatalError() }

        let dailyTotal = TotalHours.daily(
            inTimeString: dayStack.inTextField.stringValue,
            outTimeString: dayStack.outTextField.stringValue,
            ptoHoursString: dayStack.ptoTextField.stringValue,
            adjustHoursString: dayStack.adjustTextField.stringValue
        )
        dayStack.totalTextField.stringValue = dailyTotal

        let totalStrings: [String] = dayStacks.flatMap { $0.totalTextField.stringValue }
        let grandTotal = TotalHours.weekly(totalStrings: totalStrings)
        grandTotalTextField.stringValue = grandTotal
    }

    private func updateWorkDay(control: NSControl) {
        guard let dayStack = control.superview as? DayStack,
            let index = dayStacks.index(of: dayStack)
            else { fatalError() }

        let workDay = workWeek.workDays[index]
        workDay.inTime = dayStack.inTextField.stringValue
        workDay.outTime = dayStack.outTextField.stringValue
        workDay.ptoHours = dayStack.ptoTextField.stringValue
        workDay.adjustHours = dayStack.adjustTextField.stringValue

        workDay.save()
    }
}

extension ViewController: WorkWeekDelegate {
    func didFetch() {
        DispatchQueue.main.async {
            // maybe this should be extracted to a function that is called here so that i don't have to have all these selfs...
            self.weekRangeTextField.stringValue = self.workWeek.asString
            self.fillDayStack()
            for dayStack in self.dayStacks {
                self.recompute(control: dayStack.inTextField)
            }
        }
    }
}

extension ViewController: NSTextFieldDelegate {
    func control(_ control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
        updateWorkDay(control: control)
        recompute(control: control)
        return true
    }
}
