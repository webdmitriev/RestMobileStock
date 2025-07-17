//
//  FetchStockUseCase.swift
//  RestMobileStock
//
//  Created by Олег Дмитриев on 16.07.2025.
//

import Foundation
import Combine

protocol FetchStockUseCase {
    func execute() -> AnyPublisher<[Stock], Error>
}

class FetchStockUseCaseImpl: FetchStockUseCase {
    let repository: FetchStockRepository
    init(repository: FetchStockRepository) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<[Stock], any Error> {
        self.repository.fetchStocks()
    }
}
