//
//  Collection+.swift
//  Pokemon
//
//  Created by Lo on 2024/6/17.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
