//
//  StockCell.swift
//  RestMobileStock
//
//  Created by Олег Дмитриев on 17.07.2025.
//

import UIKit

class StockCell: UITableViewCell {
    static let reuseID: String = "StockCell"
    
    private let uiBuilder = UIBuilder()
    
    private lazy var cellView = uiBuilder.addView(brs: 16)
    private lazy var cellImage = uiBuilder.addImage(named: "default", brs: 12)
    private lazy var cellSymbol = uiBuilder.addLabel(text: "", fz: 18, fw: .bold)
    private lazy var cellName = uiBuilder.addLabel(text: "", fz: 12, fw: .bold)
    private lazy var cellPrice = uiBuilder.addLabel(text: "", fz: 18, fw: .bold, alignment: .right)
    private lazy var cellChange = uiBuilder.addLabel(text: "", fz: 12, fw: .bold, alignment: .right, color: .appGreen)
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .appWhite
        contentView.backgroundColor = .appWhite
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(stock: Stock, bgc: UIColor, isFavorite: Bool = false) {
        self.cellView.backgroundColor = bgc
        
        self.cellSymbol.text = stock.symbol
        
        let starColor: UIColor = isFavorite ? .appYellow : .appGray
        self.cellSymbol.addTrailingIcon(image: UIImage(systemName: "star.fill")!, tintColor: starColor)

        self.cellName.text = stock.name
        self.cellPrice.text = "$\(stock.price)"
        
        if stock.change < 0 {
            self.cellChange.textColor = .appRed
            self.cellChange.text = "-$\(stock.change.description.dropFirst()) (\(stock.changePercent.description.dropFirst()))"
        } else {
            self.cellChange.text = "+$\(stock.change.description) (\(stock.changePercent.description))"
        }
        
        if let url = URL(string: stock.logo) {
            self.cellImage.load(url: url)
        }
    }
    
    private func setupUI() {
        contentView.addSubviews(cellView, cellImage, cellSymbol, cellName, cellPrice, cellChange)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            cellView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            cellView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            cellView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            cellImage.widthAnchor.constraint(equalToConstant: 52),
            cellImage.heightAnchor.constraint(equalToConstant: 52),
            cellImage.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 8),
            cellImage.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 8),
            
            cellSymbol.topAnchor.constraint(equalTo: cellImage.topAnchor, constant: 7),
            cellSymbol.leadingAnchor.constraint(equalTo: cellImage.trailingAnchor, constant: 12),
            cellSymbol.trailingAnchor.constraint(equalTo: cellPrice.leadingAnchor, constant: -8),
            
            cellName.bottomAnchor.constraint(equalTo: cellImage.bottomAnchor, constant: -7),
            cellName.leadingAnchor.constraint(equalTo: cellImage.trailingAnchor, constant: 12),
            cellName.trailingAnchor.constraint(equalTo: cellPrice.leadingAnchor, constant: -8),
            
            cellPrice.widthAnchor.constraint(equalToConstant: 100),
            cellPrice.topAnchor.constraint(equalTo: cellImage.topAnchor, constant: 4),
            cellPrice.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -14),
            
            cellChange.widthAnchor.constraint(equalToConstant: 100),
            cellChange.bottomAnchor.constraint(equalTo: cellImage.bottomAnchor, constant: -4),
            cellChange.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -14),
        ])
    }
}
