//
//  MovieEntityTable+CoreDataProperties.swift
//  
//
//  Created by Sourabh Modi on 19/10/24.
//
//

import Foundation
import CoreData


extension MovieEntityTable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieEntityTable> {
        return NSFetchRequest<MovieEntityTable>(entityName: "MovieEntityTable")
    }

    @NSManaged public var movieTitle: String?
    @NSManaged public var movieYear: Int64
    @NSManaged public var movieId: Int64
    @NSManaged public var moviePoster: String?
    @NSManaged public var movieMediaType: String?

}
