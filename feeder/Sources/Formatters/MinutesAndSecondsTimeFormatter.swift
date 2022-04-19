import Foundation

struct MinutesAndSecondsTimeFormatter: ITimeFormatter {
	func format(time: TimeInterval) -> String {
		let time = Int(time)
		let minutes = time / 60
		let seconds = time % 60

		var result = ""
		if minutes > 0 {
			result += "\(minutes) min"
		}
		if seconds > 0 {
			if !result.isEmpty { result += " " }
			result += "\(seconds) sec"
		}
		return result
	}
}
