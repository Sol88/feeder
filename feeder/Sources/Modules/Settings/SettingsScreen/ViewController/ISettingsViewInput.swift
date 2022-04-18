protocol ISettingsViewInput: AnyObject {
	var props: SettingsViewController.Props? { get set }
	func setupViews()
	func configureDataSource()
}
