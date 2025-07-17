//
//  AddFavoriteStockUseCase.swift
//  RestMobileStock
//
//  Created by Олег Дмитриев on 17.07.2025.
//

import Foundation

protocol AddFavoriteStockUseCase {
    func execute(stock: Stock) throws
}

class AddFavoriteStockUseCaseImpl: AddFavoriteStockUseCase {
    private let repository: FavoriteStockRepository

    init(repository: FavoriteStockRepository) {
        self.repository = repository
    }

    func execute(stock: Stock) throws {
        try repository.save(stock)
    }
}

