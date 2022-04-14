import CoreData

final class CoreDataContainer {
	let persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "Model")
		container.loadPersistentStores { store, error in
			if let error = error {
				assertionFailure("Cannot create persistence container for \(error)")
			}
		}
		return container
	}()
}
