//
//  CoreDataManager.swift
//  MovieApp
//
//  Created by Sourabh Modi on 19/10/24.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager: UIViewController {
    static let shared = CoreDataManager()
    let persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "CoreDataModel")
            container.loadPersistentStores { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            }
            return container
        }()
        
        func saveContext() {
            let context = persistentContainer.viewContext
                    if context.hasChanges {
                        do {
                            try context.save()
                        } catch let error as NSError {
                            print("Unresolved error \(error), \(error.userInfo)")
                        }
                    }
        }

        // Save movie data to Core Data
        func saveMovies(_ movies: [GetMovieListModel]) {
            let context = persistentContainer.viewContext
            for movie in movies {
                let movieEntityTable = MovieEntityTable(context: context)
                movieEntityTable.movieTitle = movie.Title
                movieEntityTable.moviePoster = movie.Poster
                movieEntityTable.movieId = Int64(movie.imdbID) ?? 0
            }
            saveContext()
        }

        // Fetch paginated movies from Core Data
    func fetchMovies(offset: Int, limit: Int) -> [MovieEntityTable] {
            let fetchRequest: NSFetchRequest<MovieEntityTable> = MovieEntityTable.fetchRequest()
            fetchRequest.fetchOffset = offset
            fetchRequest.fetchLimit = limit
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "movieTitle", ascending: true)]
            
            do {
                let movies = try persistentContainer.viewContext.fetch(fetchRequest)
                print("Fetched \(movies.count) movies from Core Data (offset: \(offset), limit: \(limit))")
                return movies
            } catch {
                print("Error fetching movies from Core Data: \(error)")
                return []
            }
        }
    func getTotalMoviesCount() -> Int {
            let fetchRequest: NSFetchRequest<MovieEntityTable> = MovieEntityTable.fetchRequest()
            
            do {
                let count = try persistentContainer.viewContext.count(for: fetchRequest)
                print("Total movies in Core Data: \(count)")
                return count
            } catch {
                print("Error getting total movies count from Core Data: \(error)")
                return 0
            }
        }
}
