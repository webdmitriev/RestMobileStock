//
//  UIBuilder.swift
//  RestMobileStock
//
//  Created by Олег Дмитриев on 17.07.2025.
//

import UIKit

class UIBuilder {
    func addLabel(text: String, fz: CGFloat = 14, fw: UIFont.Weight = .regular, alignment: NSTextAlignment = .left,
                  color: UIColor = .appBlack) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = UIFont.systemFont(ofSize: fz, weight: fw)
        label.textAlignment = alignment
        label.textColor = color
        return label
    }
    
    func addImage(named: String, brs: CGFloat = 0) -> UIImageView {
        let imageView = UIImageView(image: UIImage(named: named))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = brs
        imageView.clipsToBounds = true
        return imageView
    }
    
    func addView(bgc: UIColor = .white, brs: CGFloat = 0) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = bgc
        view.layer.cornerRadius = brs
        view.clipsToBounds = true
        return view
    }
}

class PaddedTextField: UITextField {
    var textPadding = UIEdgeInsets(top: 0, left: 44, bottom: 0, right: 8)

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
}
