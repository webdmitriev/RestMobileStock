//
//  Stock.swift
//  RestMobileStock
//
//  Created by Олег Дмитриев on 16.07.2025.
//

import Foundation

struct Stock: Codable {
    let id: Int
    let logo: String
    let name: String
    let symbol: String
    let price: Double
    let change: Double
    let changePercent: Double
}
