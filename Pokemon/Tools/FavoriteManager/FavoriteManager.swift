//
//  FavoriteManager.swift
//  Pokemon
//
//  Created by Lo on 2024/6/15.
//

import Foundation

/// Favorite service
class FavoriteManager {
    // MARK: - Property

    private let userDefaultKey: String = "FavoriteItems"
    private let userDefault = UserDefaults.standard
    private var favorites: Set<Pokemon> = []

    /// initialize and load persistent favorite datas
    init() {
        favorites = load()
    }

    /// Add favorite pokemon
    /// - Parameter item: pokemon
    func addFavorite(_ item: Pokemon) {
        favorites.insert(item)
        // Sync persistent
        save()
    }

    /// Add favorite pokemons
    /// - Parameter items: [Pokemon]
    func addFavorites(_ items: [Pokemon]) {
        items.forEach { favorites.insert($0) }
        // Sync persistent
        save()
    }

    /// Remove favorite pokemon
    /// - Parameter item: pokemon
    func removeFavorite(_ item: Pokemon) {
        favorites.remove(item)
        // Sync persistent
        save()
    }

    /// Remove all pokemons
    func removeAll() {
        favorites.removeAll()
        // Sync persistent
        delete()
    }

    /// Fetch favorite pokemons
    /// - Returns: Set<Pokemon>
    func fetchFavorites() -> Set<Pokemon> {
        return favorites
    }

    /// Is pokemon favorite ?
    /// - Parameter item: Pokemon
    /// - Returns: Bool
    func hasFavorite(_ item: Pokemon) -> Bool {
        return favorites.contains { $0 == item }
    }
}

/// Save load remove favorite datas in userdefault for persistent
private extension FavoriteManager {
    /// Save favorite datas
    func save() {
        do {
            let data = try JSONEncoder().encode(favorites)
            userDefault.set(data, forKey: userDefaultKey)
            debugPrint("Save favorite \(favorites)")
        } catch {
            debugPrint("Favorite save error = \(error.localizedDescription)")
        }
    }

    /// Load favorite datas
    func load() -> Set<Pokemon> {
        do {
            guard let data = userDefault.value(forKey: userDefaultKey) as? Data else { return [] }
            let savedFavorites = try JSONDecoder().decode([Pokemon].self, from: data)
            debugPrint("Load favorite \(savedFavorites)")
            return Set(savedFavorites)
        } catch {
            debugPrint("Favorite save error = \(error.localizedDescription)")
            return []
        }
    }

    /// Delete favorite datas
    func delete() {
        debugPrint("Remove all favorites")
        userDefault.set(nil, forKey: userDefaultKey)
    }
}
