//
//  RemoteStockDataSourceImpl.swift
//  RestMobileStock
//
//  Created by Олег Дмитриев on 16.07.2025.
//

import Foundation
import Combine

class RemoteStockDataSourceImpl: FetchStockDataSource {
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func fetchStocks() -> AnyPublisher<[Stock], any Error> {
        guard let url = URL(string: "https://api.webdmitriev.com/wp-json/wp/v2/stock-posts") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: [Stock].self, decoder: JSONDecoder())
            .map { posts in
                posts.map { $0 }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
