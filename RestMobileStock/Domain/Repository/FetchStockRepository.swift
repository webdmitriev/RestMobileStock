//
//  FetchStockRepository.swift
//  RestMobileStock
//
//  Created by Олег Дмитриев on 16.07.2025.
//

import Foundation
import Combine

protocol FetchStockRepository {
    func fetchStocks() -> AnyPublisher<[Stock], Error>
}
