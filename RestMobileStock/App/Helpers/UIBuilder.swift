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
    
    func addStackView() -> UIStackView {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .leading
        stack.distribution = .fillEqually
        stack.spacing = 20
        return stack
    }
    
    func addSearchBar() -> PaddedTextField {
        let textField = PaddedTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Find company or ticker"
        textField.backgroundColor = .appWhite
        textField.layer.cornerRadius = 24
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.appBlack.cgColor
        textField.clipsToBounds = true
        return textField
    }
    
    func addButton(txt: String, fz: CGFloat = 18, color: UIColor = .appBlack) -> UIButton {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle(txt, for: .normal)
        btn.setTitleColor(color, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: fz, weight: .black)
        btn.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return btn
    }
    
    func addTableView() -> UITableView {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .appWhite
        table.contentInsetAdjustmentBehavior = .never
        table.separatorStyle = .none
        table.separatorInset = .zero
        table.layoutMargins = .zero
        table.frame = .zero
        table.style = .plain
        return table
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
