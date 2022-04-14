import CoreData

final class PostsCoreDataRepository: IPostsRepository {
	private let dateFormatter = ISO8601DateFormatter()
	private let coreDataContainer: CoreDataContainer

	init(coreDataContainer: CoreDataContainer) {
		self.coreDataContainer = coreDataContainer
	}

	func add(_ elements: [XMLPost]) {
		let fetchRequest = NSFetchRequest<PostCoreData>(entityName: "PostCoreData")
		fetchRequest.propertiesToFetch = ["id"]
		var idSet = Set<String>()
		if let result = try? self.coreDataContainer.persistentContainer.newBackgroundContext().fetch(fetchRequest) {
			idSet = Set(result.compactMap(\.id))
		}
		let createBackgroundContext = self.coreDataContainer.persistentContainer.newBackgroundContext()
		for element in elements where !idSet.contains(element.id) {
			guard let entity = NSEntityDescription.entity(
				forEntityName: "PostCoreData",
				in: createBackgroundContext)
			else { break }
			let post = PostCoreData(entity: entity, insertInto: createBackgroundContext)
			post.id = element.id
			post.summary = element.description
			post.pubDate = self.dateFormatter.date(from: element.pubDate)
			post.link = element.link
			post.title = element.title
		}

		do {
			try createBackgroundContext.save()
		} catch {
			assertionFailure("Cannot save content \(error)")
		}
	}

	func update(elementWithId id: String, isRead: Bool) {
		// TODO: implement
	}

	func getAll(completion: @escaping ([Post]) -> Void) {
		let fetchRequest = NSFetchRequest<PostCoreData>(entityName: "PostCoreData")
		do {
			let posts = try self.coreDataContainer.persistentContainer.viewContext.fetch(fetchRequest)
			var newPosts: [Post] = []
			for post in posts {
				newPosts.append(
					Post(
						id: post.id ?? "",
						imageURL: nil,
						title: post.title ?? "",
						content: URL(string: post.link!)!,
						summary: post.summary ?? "",
						date: post.pubDate ?? Date(),
						source: PostSource.lenta,
						isRead: false
					)
				)
			}
			completion(newPosts)
		} catch {
			assertionFailure("Cannot save content \(error)")
			completion([])
		}
	}

	func fetchPost(postId: String, completion: @escaping (Post?) -> Void) {
		completion(Post.dummy.first(where: { $0.id == postId }))
	}
}
