import CoreData
import Foundation
import UIKit.UIDiffableDataSource

final class PostsCoreDataRepository: NSObject {
	// MARK: - Private
	private(set) lazy var fetchedResultsController: NSFetchedResultsController<PostCoreData> = {
		let descendingSortDescriptor = NSSortDescriptor(key: "pubDate", ascending: false)
		let fetchRequest = NSFetchRequest<PostCoreData>(entityName: "PostCoreData")
		fetchRequest.sortDescriptors = [descendingSortDescriptor]

		let controller = NSFetchedResultsController(
			fetchRequest: fetchRequest,
			managedObjectContext: viewContext,
			sectionNameKeyPath: nil,
			cacheName: nil
		)

		controller.delegate = self

		return controller
	}()

	private let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss ZZZZ"
		formatter.locale = Locale(identifier: "en_US")
		return formatter
	}()

	private let coreDataContainer: CoreDataContainer

	private var viewContext: NSManagedObjectContext {
		coreDataContainer.persistentContainer.viewContext
	}

	// MARK: - Public
	var didChangeContentWithSnapshot: ((NSDiffableDataSourceSnapshot<String, Post.ID>) -> Void)?

	// MARK: - 
	init(coreDataContainer: CoreDataContainer) {
		self.coreDataContainer = coreDataContainer
		super.init()
	}
}

// MARK: - IPostsRepository
extension PostsCoreDataRepository: IPostsRepository {
	func add(_ elements: [XMLPost]) {
		let idSet = savedPostIds()
		let backgroundContext = coreDataContainer.persistentContainer.newBackgroundContext()
		for element in elements where !idSet.contains(element.id) {
			insert(xmlPost: element, context: backgroundContext)
		}

		do {
			try backgroundContext.save()
		} catch {
			assertionFailure("Cannot save content \(error)")
		}
	}
	
	func fetchPost(at indexPath: IndexPath) -> Post? {
		let post = fetchedResultsController.object(at: indexPath)
		return Post.make(fromCoreData: post, dateFormatter: dateFormatter)
	}

	func fetchPost(withPostId postId: Post.ID) -> Post? {
		let backgroundContext = coreDataContainer.persistentContainer.newBackgroundContext()

		let fetchRequest = NSFetchRequest<PostCoreData>(entityName: "PostCoreData")
		fetchRequest.predicate = NSPredicate(format: "id == %@", postId)
		fetchRequest.fetchBatchSize = 1
		do {
			guard let postCoreData = try backgroundContext.fetch(fetchRequest).first else { return nil }
			return Post.make(fromCoreData: postCoreData, dateFormatter: dateFormatter)
		} catch {
			assertionFailure("Fetching post with postId \(postId) failed with error \(error)")
			return nil
		}
	}

	func fetchAllPosts() {
		do {
			try fetchedResultsController.performFetch()
		} catch {
			assertionFailure("Fetching FRC error \(error)")
		}
	}
}

// MARK: - Private
private extension PostsCoreDataRepository {
	func savedPostIds() -> Set<String> {
		let fetchRequest = NSFetchRequest<PostCoreData>(entityName: "PostCoreData")
		fetchRequest.propertiesToFetch = ["id"]

		let backgroundContext = coreDataContainer.persistentContainer.newBackgroundContext()

		guard let result = try? backgroundContext.fetch(fetchRequest) else {
			return Set()
		}

		return Set(result.compactMap(\.id))
	}

	func insert(
		xmlPost: XMLPost,
		context: NSManagedObjectContext
	) {
		guard let date = dateFormatter.date(from: xmlPost.pubDate) else { return }
		guard let entity = NSEntityDescription.entity(
			forEntityName: "PostCoreData",
			in: context
		) else { return }
		let post = PostCoreData(entity: entity, insertInto: context)
		post.id = xmlPost.id
		post.summary = xmlPost.description
		post.pubDate = date
		post.link = xmlPost.link
		post.title = xmlPost.title
		post.source = "Lenta.ru"
		post.imageURL = xmlPost.imageURL
	}
}

// MARK: - NSFetchedResultsController
extension PostsCoreDataRepository: NSFetchedResultsControllerDelegate {
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
		let snapshot = snapshot as NSDiffableDataSourceSnapshot<String, NSManagedObjectID>
		var convertedSnapshot = NSDiffableDataSourceSnapshot<String, Post.ID>()

		convertedSnapshot.appendSections(snapshot.sectionIdentifiers)
		for section in snapshot.sectionIdentifiers {
			let items: [Post.ID] = snapshot.itemIdentifiers(inSection: section).compactMap {
				guard
					let postCoreData = viewContext.object(with: $0) as? PostCoreData,
					let post = Post.make(fromCoreData: postCoreData, dateFormatter: dateFormatter)
				else { return nil }

				return post.id
			}
			convertedSnapshot.appendItems(items, toSection: section)
		}

		didChangeContentWithSnapshot?(convertedSnapshot)
	}
}
