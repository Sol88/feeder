protocol ISettingsViewInput: AnyObject {
	var props: SettingsViewController.Props? { get set }
	func setupViews()
	func configureDataSource()
	func showTimeUpdatePicker()
	func hideTimeUpdatePicker()
	func configureTimeUpdatePicker(defaultRow row: Int)
	func updateTableView()
}
