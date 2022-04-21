import CoreData

final class CoreDataContainer {
	let updatingContext: NSManagedObjectContext
	let persistentContainer: NSPersistentContainer

	init() {
		let container = NSPersistentContainer(name: "Model")
		container.loadPersistentStores { store, error in
			if let error = error {
				assertionFailure("Cannot create persistence container for \(error)")
			}
		}
		container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
		container.viewContext.automaticallyMergesChangesFromParent = true

		self.persistentContainer = container
		self.updatingContext = container.newBackgroundContext()
	}
}
