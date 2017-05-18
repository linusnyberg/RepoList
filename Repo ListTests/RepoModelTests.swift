//
//  RepoModelTests.swift
//  Repo List
//
//  Created by Linus Nyberg on 2017-05-13.
//  Copyright © 2017 Linus Nyberg. All rights reserved.
//

import XCTest
import CoreData

class RepoModelTests: XCTestCase {

	var managedObjectContext: NSManagedObjectContext?

	override func setUp() {
		managedObjectContext = NSManagedObjectContext.createInMemoryManagedObjectContext()
		super.setUp()
	}

	// MARK: - Tests

	func testPopulatingFromJSON() {
		let jsonData = exampleRepoJSONDictionary()
		//print("\(jsonData)")
		XCTAssertNotNil(jsonData)

		let repo = createRepo()
		XCTAssertNotNil(repo)

		repo?.populateFromJSON(jsonData: jsonData!)

		XCTAssertEqual(repo?.repoName, "SomeRepo", "Name should be parsed from JSON data")
		XCTAssertEqual(repo?.repoDescription, "iOS app that lets you save the current map location for later reference.", "Description should be parsed from JSON data")
		XCTAssertEqual(repo?.repoHtmlURL, "https://github.com/someuser/SomeRepo", "HTML URL should be parsed from JSON data")
		XCTAssertEqual(repo?.repoLanguage, "Swift", "Language should be parsed from JSON data")
	}

	// MARK: - Creation methods

	func exampleRepoJSONString() -> String {
		let path = Bundle.main.path(forResource: "TestData", ofType: "plist")
		let dict = NSDictionary(contentsOfFile: path!) as? [String: AnyObject]
		return dict!["exampleJsonForRepo"] as! String
	}

	func exampleRepoJSONDictionary() ->NSDictionary? {
		let jsonString = exampleRepoJSONString()
		if let data = jsonString.data(using: .utf8) {
			do {
				return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] as NSDictionary?
			} catch {
				print(error.localizedDescription)
			}
		}
		return nil
	}

	func createRepo() -> Repo? {
		guard let entity = NSEntityDescription.entity(forEntityName: "Repo", in: managedObjectContext!) else {
			return nil
		}
		let repo = Repo(entity: entity, insertInto: managedObjectContext)
		return repo
	}

}
