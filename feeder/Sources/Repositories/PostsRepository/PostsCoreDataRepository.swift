import CoreData
import Foundation
import UIKit.UIDiffableDataSource

final class PostsCoreDataRepository: NSObject {
	// MARK: - Public
	var didChangeContentWithSnapshot: ((NSDiffableDataSourceSnapshot<String, Post.ID>) -> Void)?

	// MARK: - Private
	private var fetchedResultsController: NSFetchedResultsController<PostCoreData>?

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

	// MARK: - 
	init(coreDataContainer: CoreDataContainer) {
		self.coreDataContainer = coreDataContainer
		super.init()
	}
}

// MARK: - IPostsRepository
extension PostsCoreDataRepository: IPostsRepository {
	func add(_ elements: [XMLPost], forSource source: PostSource) {
		let idSet = savedPostIds()
		let backgroundContext = coreDataContainer.persistentContainer.newBackgroundContext()
		for element in elements where !idSet.contains(element.id) {
			insert(xmlPost: element, source: source, context: backgroundContext)
		}

		do {
			try backgroundContext.save()
		} catch {
			assertionFailure("Cannot save content \(error)")
		}
	}
	
	func fetchPost(at indexPath: IndexPath) -> Post? {
		guard indexPath.item < fetchedResultsController?.sections?[indexPath.section].numberOfObjects ?? 0 else { return nil }
		guard let post = fetchedResultsController?.object(at: indexPath) else { return nil }
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

	func fetchAllPosts(forSources sources: [PostSource]) {
		do {
			fetchedResultsController = makeFetchedResultsController(withSourcesFilter: sources)
			try fetchedResultsController?.performFetch()
		} catch {
			assertionFailure("Fetching FRC error \(error)")
		}
	}

	func markReadPost(withPostId postId: Post.ID) {
		let backgroundContext = coreDataContainer.persistentContainer.newBackgroundContext()

		let fetchRequest = NSFetchRequest<PostCoreData>(entityName: "PostCoreData")
		fetchRequest.predicate = NSPredicate(format: "id == %@", postId)
		fetchRequest.fetchBatchSize = 1

		do {
			guard let postCoreData = try backgroundContext.fetch(fetchRequest).first else { return }
			postCoreData.isRead = true

			try backgroundContext.save()
		} catch {
			assertionFailure("Fetching post with postId \(postId) failed with error \(error)")
		}
	}
}

// MARK: - Private
private extension PostsCoreDataRepository {
	func makeFetchedResultsController(withSourcesFilter sources: [PostSource]) -> NSFetchedResultsController<PostCoreData> {
		let descendingPubDateSortDescriptor = NSSortDescriptor(key: "pubDate", ascending: false)
		let ascendingIDSortDescriptor = NSSortDescriptor(key: "id", ascending: true)
		let fetchRequest = NSFetchRequest<PostCoreData>(entityName: "PostCoreData")
		fetchRequest.sortDescriptors = [descendingPubDateSortDescriptor, ascendingIDSortDescriptor]
		var predicates: [NSPredicate] = []
		for source in sources {
			predicates.append(NSPredicate(format: "source == %@", source.rawValue))
		}
		fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)

		let fetchedResultsController = NSFetchedResultsController(
			fetchRequest: fetchRequest,
			managedObjectContext: viewContext,
			sectionNameKeyPath: nil,
			cacheName: nil
		)

		fetchedResultsController.delegate = self

		return fetchedResultsController
	}
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
		source: PostSource,
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
		post.source = source.rawValue
		post.imageURL = xmlPost.imageURL
		post.isRead = false
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
