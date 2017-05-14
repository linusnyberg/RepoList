//
//  RepoListDefaults.swift
//  Repo List
//
//  Created by Linus Nyberg on 2017-05-14.
//  Copyright © 2017 Linus Nyberg. All rights reserved.
//

import Foundation

class RepoListDefaults {
	static let hasLoggedInKey = "RepoListHasLoggedIn"

	static var hasLoggedIn: Bool {
		get {
			let defaults = UserDefaults.standard
			return defaults.bool(forKey: hasLoggedInKey)
		}
		set(newValue) {
			let defaults = UserDefaults.standard
			if newValue {
				let defaults = UserDefaults.standard
				defaults.set(true, forKey: hasLoggedInKey)
			} else {
				defaults.removeObject(forKey: hasLoggedInKey)
			}
		}
	}
}
