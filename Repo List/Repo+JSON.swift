//
//  Repo+JSON.swift
//  Repo List
//
//  Created by Linus Nyberg on 2017-05-13.
//  Copyright © 2017 Linus Nyberg. All rights reserved.
//

import Foundation

/// Adds support for parsing Repos from JSON data from Github.
extension Repo {
	func populateFromJSON(jsonData: NSDictionary) {
		repoName = jsonData["name"] as! String

		if let description = jsonData["description"] as? String {
			repoDescription = description
		} else {
			repoDescription = ""
		}

		/// TODO: Expose URL version of this String? URL(string: jsonData["html_url"] as! String)!
		repoHtmlURL = jsonData["html_url"] as! String

		if let language = jsonData["language"] as? String {
			repoLanguage = language
		} else {
			repoLanguage = ""
		}
	}
}
