//
//  PersistenceManager.swift
//  GHFollowers
//
//  Created by Taijaun Pitt on 10/02/2025.
//

import Foundation

enum PersistenceActionType {
    case add, remove
}

enum PersistenceManager {
    
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let favourites = "favourites"
    }
    
    static func updateWith(favourite: Follower, actionType: PersistenceActionType, completed: @escaping (GFError?) -> Void) {
        
        retrieveFavourites { result in
            switch result {
            case .success(let favourites):
                var retrievedFavourites = favourites
                
                switch actionType {
                case .add:
                    guard !retrievedFavourites.contains(favourite) else {
                        completed(.alreadyInFavourites)
                        return
                    }
                    
                    retrievedFavourites.append(favourite)
                    
                case .remove:
                    // anywhere the login is equal to a login in the favourite list, remove it
                    retrievedFavourites.removeAll { $0.login == favourite.login }
                    
                }
                
                completed(save(favourites: retrievedFavourites))
                
                
            case .failure(let error):
                completed(error)
            }
        }
        
    }
    
    static func retrieveFavourites(completed: @escaping (Result<[Follower], GFError>) -> Void) {
        
        guard let favouritesData = defaults.object(forKey: Keys.favourites) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            // array of followers, created from the data in the api call
            let favourites = try decoder.decode([Follower].self, from: favouritesData)
            completed(.success(favourites))
        } catch {
            completed(.failure(.unableToFavourite))
        }
        
    }
    
    static func save(favourites: [Follower]) -> GFError? {
        
        do {
            let encoder = JSONEncoder()
            let encodedFavourites = try encoder.encode(favourites)
            defaults.set(encodedFavourites, forKey: Keys.favourites)
            return nil
        } catch {
            return .unableToFavourite
        }
        
    }
}
