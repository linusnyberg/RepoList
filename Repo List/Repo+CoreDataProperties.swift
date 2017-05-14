//
//  Repo+CoreDataProperties.swift
//  Repo List
//
//  Created by Linus Nyberg on 2017-05-13.
//  Copyright © 2017 Linus Nyberg. All rights reserved.
//

import Foundation
import CoreData


extension Repo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Repo> {
        return NSFetchRequest<Repo>(entityName: "Repo")
    }

    @NSManaged public var repoName: String
    @NSManaged public var repoDescription: String
    @NSManaged public var repoHtmlURL: String

}
