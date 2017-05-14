//
//  ReposDataLoader.swift
//  Repo List
//
//  Created by Linus Nyberg on 2017-05-13.
//  Copyright © 2017 Linus Nyberg. All rights reserved.
//

import Foundation
import CoreData
import UIKit

/// Loads data for the "Repos" view (ReposViewController).
class ReposDataLoader {
	var delegate: DataLoaderDelegate?
	var loadingState: LoadingState = .neverLoaded

	/// For loading cached data
	var repoStore: RepoStore

	/// For fetching data from Github
	var repoService: RepoService

	/// The last loaded Repos
	var repos: [Repo] = []

	init(delegate: DataLoaderDelegate, viewController: UIViewController, persistentContainer: NSPersistentContainer) {
		self.delegate = delegate
		repoStore = RepoStore(withContainer: persistentContainer)
		let authenticator = Authenticator(viewController: viewController)
		repoService = RepoService(authenticator: authenticator, store: repoStore)
	}

}

// MARK: - DataLoader
extension ReposDataLoader: DataLoader {
	func startLoadingData(allowCache: Bool) {
		guard let delegate = delegate else {
			return
		}
		loadingState = .isLoading

		// Load from cache
		//----------------
		if (allowCache) {
			repos = repoStore.loadRepos()
			delegate.dataLoaderDidLoadData(dataLoader: self)
		}

		// Fetch from Github
		//------------------
		repoService.fetchRepos() { [weak self] (repos: [Repo]?) in
			guard let strongSelf = self, let repos = repos else {
				return
			}
			strongSelf.repos = repos
			delegate.dataLoaderDidLoadData(dataLoader: strongSelf)
			strongSelf.loadingState = .doneLoading
		}
	}
}
