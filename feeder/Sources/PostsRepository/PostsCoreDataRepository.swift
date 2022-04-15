import CoreData

final class PostsCoreDataRepository: IPostsRepository {
	private let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss ZZZZ"
		formatter.locale = Locale(identifier: "en_US")
		return formatter
	}()

	private let coreDataContainer: CoreDataContainer

	init(coreDataContainer: CoreDataContainer) {
		self.coreDataContainer = coreDataContainer
	}

	func add(_ elements: [XMLPost]) {
		let idSet = self.savedPostIds()
		let backgroundContext = self.coreDataContainer.persistentContainer.newBackgroundContext()
		for element in elements where !idSet.contains(element.id) {
			self.insert(xmlPost: element, context: backgroundContext)
		}

		do {
			try backgroundContext.save()
		} catch {
			assertionFailure("Cannot save content \(error)")
		}
	}

	func fetchAll(completion: @escaping ([Post]) -> Void) {
		let descendingSortDescriptor = NSSortDescriptor(key: "pubDate", ascending: false)
		let fetchRequest = NSFetchRequest<PostCoreData>(entityName: "PostCoreData")
		fetchRequest.sortDescriptors = [descendingSortDescriptor]
		do {
			let allPosts = try self.coreDataContainer.persistentContainer.viewContext.fetch(fetchRequest)
			let posts = allPosts.compactMap { Post.make(fromCoreData: $0, dateFormatter: self.dateFormatter) }
			completion(posts)
		} catch {
			assertionFailure("Cannot save content \(error)")
			completion([])
		}
	}

	func fetchPost(postId: String, completion: @escaping (Post?) -> Void) {
		let fetchRequest = NSFetchRequest<PostCoreData>(entityName: "PostCoreData")
		fetchRequest.predicate = NSPredicate(format: "id == %@", postId)

		let backgroundContext = self.coreDataContainer.persistentContainer.newBackgroundContext()

		do {
			guard let post = try backgroundContext.fetch(fetchRequest).first else {
				completion(nil)
				return
			}
			completion(Post.make(fromCoreData: post, dateFormatter: self.dateFormatter))
		} catch {
			assertionFailure("Cannot save content \(error)")
			completion(nil)
		}
	}
}

// MARK: - Private
private extension PostsCoreDataRepository {
	func savedPostIds() -> Set<String> {
		let fetchRequest = NSFetchRequest<PostCoreData>(entityName: "PostCoreData")
		fetchRequest.propertiesToFetch = ["id"]

		let backgroundContext = self.coreDataContainer.persistentContainer.newBackgroundContext()

		guard let result = try? backgroundContext.fetch(fetchRequest) else {
			return Set()
		}

		return Set(result.compactMap(\.id))
	}

	func insert(
		xmlPost: XMLPost,
		context: NSManagedObjectContext
	) {
		guard let date = self.dateFormatter.date(from: xmlPost.pubDate) else { return }
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
