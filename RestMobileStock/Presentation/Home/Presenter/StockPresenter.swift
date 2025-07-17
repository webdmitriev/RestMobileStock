//
//  StockPresenter.swift
//  RestMobileStock
//
//  Created by Олег Дмитриев on 17.07.2025.
//

import Foundation
import Combine

protocol StockPresenterProtocol: AnyObject {
    func fetchStocks()
    func fetchFavorites() -> [Stock]
    func addToFavorites(stock: Stock)
    func removeFromFavorites(stock: Stock)

    var stocksPublisher: AnyPublisher<[Stock], Error> { get }
}

class StockPresenter: StockPresenterProtocol {
    private let dataSource: FetchStockDataSource
    private var cancellables = Set<AnyCancellable>()
    
    private let stocksSubject = PassthroughSubject<[Stock], Error>()
    var stocksPublisher: AnyPublisher<[Stock], Error> {
        stocksSubject.eraseToAnyPublisher()
    }
    
    private let favoriteRepository: FavoriteStockRepository
    private let addFavoriteUseCase: AddFavoriteStockUseCase
    
    init(dataSource: FetchStockDataSource, favoriteRepository: FavoriteStockRepository, addFavoriteUseCase: AddFavoriteStockUseCase
    ) {
        self.dataSource = dataSource
        self.favoriteRepository = favoriteRepository
        self.addFavoriteUseCase = addFavoriteUseCase
    }
    
    func fetchStocks() {
        dataSource.fetchStocks()
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.stocksSubject.send(completion: .failure(error))
                    }
                },
                receiveValue: { [weak self] stocks in
                    self?.stocksSubject.send(stocks)
                }
            )
            .store(in: &cancellables)
    }
    
    func fetchFavorites() -> [Stock] {
        return (try? favoriteRepository.getAll()) ?? []
    }
    
    func addToFavorites(stock: Stock) {
        let favorite = Stock(
            id: stock.id,
            logo: stock.logo,
            name: stock.name,
            symbol: stock.symbol,
            price: stock.price,
            change: stock.change,
            changePercent: stock.changePercent
        )

        do {
            try addFavoriteUseCase.execute(stock: favorite)
            print("✅ Добавлено в избранное: \(favorite.symbol)")
        } catch {
            print("❌ Ошибка при добавлении: \(error)")
        }
    }
    
    func removeFromFavorites(stock: Stock) {
        do {
            try favoriteRepository.delete(stock: stock)
            print("🗑 Удалено из избранного: \(stock.symbol)")
        } catch {
            print("❌ Ошибка при удалении из избранного: \(error)")
        }
    }


}
