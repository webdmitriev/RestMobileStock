//
//  UIView.ext.swift
//  RestMobileStock
//
//  Created by Олег Дмитриев on 16.07.2025.
//

import UIKit

extension UIView {
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach { addSubview($0) }
    }
}
