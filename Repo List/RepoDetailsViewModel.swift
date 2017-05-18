//
//  RepoDetailsViewModel.swift
//  Repo List
//
//  Created by Linus Nyberg on 2017-05-16.
//  Copyright © 2017 Linus Nyberg. All rights reserved.
//

import Foundation

/// View model for the Repo Details view. Can be used to add additional state.
class RepoDetailsViewModel {

	var repo: Repo

	var repoName: String {
		get {
			return repo.repoName
		}
	}

	var repoDescription: String {
		get {
			return repo.repoDescription
		}
	}

	var repoHtmlURL: String {
		get {
			return repo.repoHtmlURL
		}
	}

	var repoLanguage: String {
		get {
			return repo.repoLanguage
		}
	}

	init(repo: Repo) {
		self.repo = repo
	}
}
