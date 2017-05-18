//
//  RepoService.swift
//  Repo List
//
//  Created by Linus Nyberg on 2017-05-13.
//  Copyright © 2017 Linus Nyberg. All rights reserved.
//

import Foundation
import Alamofire

/// Responsible for fetching remote Repos data from Github.
class RepoService {
	var authenticator: Authenticator
	var store: RepoStore

	init(authenticator: Authenticator, store: RepoStore) {
		self.authenticator = authenticator
		self.store = store
	}

	func fetchRepos(completion: @escaping ([Repo]?) -> Void) {
		authenticator.ensureAuthenticated() { authenticated in
			if !authenticated {
				print("Authentication failed - abort fetching repos.")
				return
			}

			print("fetching repos!")
			Alamofire.request(
				URL(string: "https://api.github.com/user/repos")!,
				method: .get,
				parameters: nil
				)
				.validate()
				.responseJSON { [weak self] (response) -> Void in
					guard let strongSelf = self else {
						return
					}

					guard response.result.isSuccess else {
						print("Error while fetching remote repos: \(String(describing: response.result.error))")
						completion(nil)
						return
					}

					guard let jsonDicts = response.result.value as? NSArray else {
						print("UNKNOWN RESPONSE: \(String(describing: response.result.value))")
						return
					}
					//print("RESPONSE: \(jsonDicts)")

					// Parse repos and add them to the store:
					//---------------------------------------
					strongSelf.store.clearRepos()
					for jsonDict in jsonDicts {
						guard let jsonData = jsonDict as? NSDictionary else {
							continue
						}
						_ = strongSelf.store.addRepo(populateValues: { (repo: Repo) in
							repo.populateFromJSON(jsonData: jsonData)
						})
					}

					completion(strongSelf.store.loadRepos())
			}
		}
	}

}
