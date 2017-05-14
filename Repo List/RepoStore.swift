//
//  RepoStore.swift
//  Repo List
//
//  Created by Linus Nyberg on 2017-05-13.
//  Copyright © 2017 Linus Nyberg. All rights reserved.
//

import Foundation
import CoreData

/// Responsible for storing and loading local (cached) Repos.
class RepoStore {
	var persistentContainer: NSPersistentContainer

	init(withContainer persistentContainer: NSPersistentContainer) {
		self.persistentContainer = persistentContainer
	}

	func loadRepos() -> [Repo] {
		let managedContext = persistentContainer.viewContext

		let fetchRequest:NSFetchRequest<Repo> = Repo.fetchRequest()

		do {
			let repos = try managedContext.fetch(fetchRequest)
			// TODO: Sort?
			return repos
		} catch let error as NSError {
			print("Failed fetching repos: \(error), \(error.userInfo)")
		}

		return []
	}

	func addRepo(populateValues: (_ repo: Repo) -> Void) -> Repo? {
		let managedContext = persistentContainer.viewContext

		guard let entity = NSEntityDescription.entity(forEntityName: "Repo", in: managedContext) else {
			return nil
		}

		let repo = Repo(entity: entity, insertInto: managedContext)
		populateValues(repo)

		do {
			try managedContext.save()
		} catch let error as NSError {
			print("Failed when creating repo: \(error), \(error.userInfo)")
		}
		return repo
	}

	func updateRepo(repo: Repo) {
		let managedContext = persistentContainer.viewContext
		do {
			try managedContext.save()
		} catch let error as NSError {
			print("Failed when updating repo: \(error), \(error.userInfo)")
		}
	}

	func clearRepos() {
		let repos = loadRepos()
		deleteRepos(repos: repos)
	}

	func deleteRepos(repos: [Repo]) {
		let managedContext = persistentContainer.viewContext
		for repo in repos {
			managedContext.delete(repo)
		}
		do {
			try managedContext.save()
		} catch let error as NSError {
			print("Failed when deleting repos: \(error), \(error.userInfo)")
		}
	}

}
