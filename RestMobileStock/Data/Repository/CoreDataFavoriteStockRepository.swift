//
//  CoreDataFavoriteStockRepository.swift
//  RestMobileStock
//
//  Created by Олег Дмитриев on 17.07.2025.
//

import UIKit
import CoreData

class CoreDataFavoriteStockRepository: FavoriteStockRepository {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext) {
        self.context = context
    }

    func save(_ stock: Stock) throws {
        guard !contains(symbol: stock.symbol) else { return }

        let entity = FavoriteStock(context: context)
        entity.id = Int64(stock.id)
        entity.logo = stock.logo
        entity.name = stock.name
        entity.symbol = stock.symbol
        entity.price = stock.price
        entity.change = stock.change
        entity.changePercent = stock.changePercent
        try context.save()
    }

    func getAll() throws -> [Stock] {
        let request = FavoriteStock.fetchRequest()
        let result = try context.fetch(request)
        return result.map {
            Stock(
                id: Int($0.id),
                logo: $0.logo ?? "",
                name: $0.name ?? "",
                symbol: $0.symbol ?? "",
                price: $0.price,
                change: $0.change,
                changePercent: $0.changePercent
            )
        }
    }

    func remove(by symbol: String) throws {
        let request = FavoriteStock.fetchRequest()
        request.predicate = NSPredicate(format: "symbol == %@", symbol)
        let result = try context.fetch(request)
        result.forEach { context.delete($0) }
        try context.save()
    }

    func contains(symbol: String) -> Bool {
        let request = FavoriteStock.fetchRequest()
        request.predicate = NSPredicate(format: "symbol == %@", symbol)
        let result = try? context.fetch(request)
        return !(result?.isEmpty ?? true)
    }
    
    func delete(stock: Stock) throws {
        let request = FavoriteStock.fetchRequest()
        request.predicate = NSPredicate(format: "symbol == %@", stock.symbol)
        let result = try context.fetch(request)
        result.forEach { context.delete($0) }
        try context.save()
    }

}
