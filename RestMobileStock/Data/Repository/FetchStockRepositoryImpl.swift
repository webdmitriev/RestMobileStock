//
//  FetchStockRepositoryImpl.swift
//  RestMobileStock
//
//  Created by Олег Дмитриев on 16.07.2025.
//

import Foundation
import Combine

class FetchStockRepositoryImpl: FetchStockRepository {
    private let dataSource: FetchStockDataSource
    init(dataSource: FetchStockDataSource) {
        self.dataSource = dataSource
    }

    func fetchStocks() -> AnyPublisher<[Stock], any Error> {
        self.dataSource.fetchStocks()
    }
}
