//
//  FavoriteStockRepository.swift
//  RestMobileStock
//
//  Created by Олег Дмитриев on 17.07.2025.
//

import Foundation

protocol FavoriteStockRepository {
    func save(_ stock: Stock) throws
    func getAll() throws -> [Stock]
    func delete(stock: Stock) throws
    func contains(symbol: String) -> Bool
}
