import Foundation

/// A context which periodically updates the caller with the time until the target date.
protocol CountdownContext {

    func start(countdownTo targetDate: Date, update: @escaping (String) -> Void)
    func stop()
}

/// A concrete implementation of ``CountdownContext`` which counts down to a specific date in time.
class Countdown: CountdownContext {

    public let updateInterval: TimeInterval

    private var timer: Timer?

    private var countdownTargetDate: Date?

    init(updateInterval: TimeInterval = 1.0) {
        self.updateInterval = updateInterval
    }

    deinit {
        stop()
    }

    func start(countdownTo targetDate: Date, update: @escaping (String) -> Void) {

        self.timer = Timer.scheduledTimer(
            withTimeInterval: updateInterval,
            repeats: true,
            block: { _ in

                let components = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: Date(), to: targetDate)

                let formatter = DateComponentsFormatter()
                formatter.allowedUnits = [.day, .hour, .minute, .second]
                formatter.unitsStyle = .full
                formatter.includesTimeRemainingPhrase = true

                update(formatter.string(from: components) ?? "invalid")
            }
        )
        self.timer?.fire()
    }

    func stop() {

        timer?.invalidate()
        timer = nil
        countdownTargetDate = nil
    }
}
